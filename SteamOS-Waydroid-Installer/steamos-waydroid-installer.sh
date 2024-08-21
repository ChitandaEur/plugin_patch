#!/bin/bash

clear

echo "SteamOS Waydroid 安装脚本由 ryanrudolf 提供"
echo "https://github.com/ryanrudolfoba/SteamOS-Waydroid-Installer"
echo "YT - 10MinuteSteamDeckGamer"
sleep 2

# 定义变量
kernel_version=$(uname -r | cut -d "-" -f 1-5 )
kernel1=6.1.52-valve9-1-neptune-61
kernel2=6.1.52-valve14-1-neptune-61
kernel3=6.1.52-valve16-1-neptune-61
kernel4=6.5.0-valve5-1-neptune-65
kernel5=6.5.0-valve12-1-neptune-65
kernel6=6.5.0-valve16-1-neptune-65
kernel7=6.5.0-valve16-2-neptune-65
#kernel4=6.5.0-valve5-1-neptune-65-g6efe817cc486
#kernel5=6.5.0-valve12-1-neptune-65-g1889664e19fc
#kernel6=6.5.0-valve16-1-neptune-65-gc9ad4106624e
AUR_CASUALSNEK=https://github.com/casualsnek/waydroid_script.git
AUR_CASUALSNEK2=https://github.com/ryanrudolfoba/waydroid_script.git
DIR_CASUALSNEK=/home/deck/AUR/waydroid/waydroid_script
STEAMOS_VERSION=$(grep VERSION_ID /etc/os-release | cut -d "=" -f 2)


# 定义函数
cleanup_exit () {
    # 调用此函数在检查失败时进行清理
    # 移除 binder 内核模块
	echo "出现了问题！正在进行清理。请再次运行脚本以安装 waydroid。"
    echo -e "$current_password\n" | sudo -S rm /lib/modules/$kernel_version/binder_linux.ko.zst &> /dev/null
    # 移除已安装的软件包
    echo -e "$current_password\n" | sudo -S pacman -R --noconfirm libglibutil libgbinder python-gbinder waydroid wlroots dnsmasq lxc &> /dev/null
    # 删除 waydroid 目录
    echo -e "$current_password\n" | sudo -S rm -rf /home/deck/waydroid /var/lib/waydroid /home/deck/AUR &> /dev/null
    # 删除 waydroid 配置和脚本
    echo -e "$current_password\n" | sudo -S rm /etc/sudoers.d/zzzzzzzz-waydroid /etc/modules-load.d/waydroid.conf /usr/bin/waydroid* &> /dev/null
    # 删除 cage 二进制文件
    echo -e "$current_password\n" | sudo -S rm /usr/bin/cage /usr/bin/wlr-randr &> /dev/null
    echo -e "$current_password\n" | sudo -S rm -rf /home/deck/Android_Waydroid &> /dev/null
    echo -e "$current_password\n" | sudo -S steamos-readonly enable &> /dev/null
	echo "清理完成。请在 GitHub 仓库中提交问题或在 YT 频道上留言 - 10MinuteSteamDeckGamer。"
    exit
}

# 完整性检查 - 你是在桌面模式下运行吗？还是在 ssh / 虚拟 tty 会话中？
xdpyinfo &> /dev/null
if [ $? -eq 0 ]
then
	echo "脚本正在桌面模式下运行。"
else
	echo "脚本没有在桌面模式下运行。"
	echo "请按照 README 中的说明在桌面模式下运行脚本。再见！"
	exit
fi

# 检查内核版本是否受支持。如果不在受支持的内核上，立即退出
echo "检查内核是否受支持。"
if [ $kernel_version = $kernel1 ] || [ $kernel_version = $kernel2 ] || [ $kernel_version = $kernel3 ] || [ $kernel_version = $kernel4 ] || [ $kernel_version = $kernel5 ] || [ $kernel_version = $kernel6 ] || [ $kernel_version = $kernel7 ]
then
    echo "$kernel_version 受支持。继续下一步。"
else
    echo "$kernel_version 不受支持。立即退出。"
    exit
fi

# 检查 sudo 密码是否已设置
current_password=$(zenity --password --title="请输入终端密码:" --text="passwd")
echo "克隆 Casualsnek 仓库"

# 所有检查通过。开始安装！
# 创建用于保存 casualsnek 脚本的 AUR 目录
mkdir -p ~/AUR/waydroid &> /dev/null

# 执行 git clone 之前先进行清理，以防目录不为空
echo -e "$current_password\n" | sudo -S rm -rf ~/AUR/waydroid*  &> /dev/null && git clone $AUR_CASUALSNEK $DIR_CASUALSNEK &> /dev/null

if [ $? -eq 0 ]
then
	echo "Casualsnek 仓库已成功克隆！"
else
	echo "克隆 Casualsnek 仓库时出错！尝试使用备用仓库再次克隆。"
	echo -e "$current_password\n" | sudo -S rm -rf ~/AUR/waydroid*  &> /dev/null && git clone $AUR_CASUALSNEK2 $DIR_CASUALSNEK &> /dev/null

	if [ $? -eq 0 ]
	then
		echo "Casualsnek 仓库已成功克隆！"
	else
		echo "克隆 Casualsnek 仓库时出错！已经失败两次了！可能是你的互联网连接有问题？"
		cleanup_exit
	fi
fi

# 禁用 SteamOS 只读模式
echo -e "$current_password\n" | sudo -S steamos-readonly disable

# 初始化密钥环
echo -e "$current_password\n" | sudo -S pacman-key --init && echo -e "$current_password\n" | sudo -S pacman-key --populate

if [ $? -eq 0 ]
then
    echo "pacman 密钥环已初始化！"
else
    echo "初始化密钥环时出错！请再次运行脚本以安装 waydroid。"
    cleanup_exit
fi

# 安装并启用 binder 模块以便立即启动 waydroid
binder_loaded=$(lsmod | grep -q binder; echo $?)
binder_differs=$(cmp -s binder/$kernel_version/binder_linux.ko.zst /lib/modules/$(uname -r)/binder_linux.ko.zst; echo $?)
if [ "$binder_loaded" -ne 0 ] || [ "$binder_differs" -ne 0 ]
then
        echo "未找到 Binder 内核模块或未更新！正在安装 binder！"
        echo -e "$current_password\n" | sudo -S cp binder/$kernel_version/binder_linux.ko.zst /lib/modules/$(uname -r) && \
        echo -e "$current_password\n" | sudo -S depmod -a && \
        echo -e "$current_password\n" | sudo -S modprobe binder_linux

	if [ $? -eq 0 ]
	then
		echo "Binder 内核模块已安装！"
	else
		echo "安装 Binder 内核模块时出错。请再次运行脚本以安装 waydroid。"
		cleanup_exit
	fi
else
	echo "Binder 内核模块已加载并已更新！无需重新安装 binder！"
fi

# 安装 waydroid 和 cage
echo -e "$current_password\n" | sudo -S pacman -U cage/wlroots-0.16.2-1-x86_64.pkg.tar.zst waydroid/dnsmasq-2.89-1-x86_64.pkg.tar.zst \
    waydroid/lxc-1\:5.0.2-1-x86_64.pkg.tar.zst waydroid/libglibutil-1.0.74-1-x86_64.pkg.tar.zst waydroid/libgbinder-1.1.35-1-x86_64.pkg.tar.zst \
    waydroid/python-gbinder-1.1.2-1-x86_64.pkg.tar.zst waydroid/waydroid-1.4.2-1-any.pkg.tar.zst --noconfirm --overwrite "*" &> /dev/null

if [ $? -eq 0 ]
then
	echo "waydroid 和 cage 已安装！"
	echo -e "$current_password\n" | sudo -S systemctl disable waydroid-container.service
else
	echo "安装 waydroid 和 cage 时出错。请再次运行脚本以安装 waydroid。"
	cleanup_exit
fi

# firewall 配置，用于 waydroid0 接口转发数据包以使互联网工作
echo -e "$current_password\n" | sudo -S firewall-cmd --zone=trusted --add-interface=waydroid0 &> /dev/null
echo -e "$current_password\n" | sudo -S firewall-cmd --zone=trusted --add-port=53/udp &> /dev/null
echo -e "$current_password\n" | sudo -S firewall-cmd --zone=trusted --add-port=67/udp &> /dev/null
echo -e "$current_password\n" | sudo -S firewall-cmd --zone=trusted --add-forward &> /dev/null
echo -e "$current_password\n" | sudo -S firewall-cmd --runtime-to-permanent &> /dev/null

# 安装自定义配置文件
mkdir /home/deck/Android_Waydroid &> /dev/null

# waydroid 内核模块
echo -e "$current_password\n" | sudo -S tee /etc/modules-load.d/waydroid.conf > /dev/null <<'EOF'
binder_linux
EOF

# waydroid 启动服务
echo -e "$current_password\n" | sudo -S tee /usr/bin/waydroid-container-start > /dev/null <<'EOF'
#!/bin/bash
systemctl start waydroid-container.service
sleep 5
ln -s /dev/binderfs/binder /dev/anbox-binder &> /dev/null
chmod o=rw /dev/anbox-binder
EOF
echo -e "$current_password\n" | sudo -S chmod +x /usr/bin/waydroid-container-start

# waydroid 停止服务
echo -e "$current_password\n" | sudo -S tee /usr/bin/waydroid-container-stop > /dev/null <<'EOF'
#!/bin/bash
systemctl stop waydroid-container.service
EOF
echo -e "$current_password\n" | sudo -S chmod +x /usr/bin/waydroid-container-stop

# waydroid 修复控制器
echo -e "$current_password\n" | sudo -S tee /usr/bin/waydroid-fix-controllers > /dev/null <<'EOF'
#!/bin/bash
echo add > /sys/devices/virtual/input/input*/event*/uevent

# 修复作用域存储权限问题
waydroid shell sh /system/etc/nodataperm.sh
EOF
echo -e "$current_password\n" | sudo -S chmod +x /usr/bin/waydroid-fix-controllers

# 自定义 sudoers 文件，不要求自定义 waydroid 脚本的 sudo 密码
echo -e "$current_password\n" | sudo -S tee /etc/sudoers.d/zzzzzzzz-waydroid > /dev/null <<'EOF'
deck ALL=(ALL) NOPASSWD: /usr/bin/waydroid-container-stop
deck ALL=(ALL) NOPASSWD: /usr/bin/waydroid-container-start
deck ALL=(ALL) NOPASSWD: /usr/bin/waydroid-fix-controllers
EOF
echo -e "$current_password\n" | sudo -S chown root:root /etc/sudoers.d/zzzzzzzz-waydroid

# waydroid 启动器 - cage
cat > /home/deck/Android_Waydroid/Android_Waydroid_Cage.sh << EOF
#!/bin/bash

# 检查 waydroid 是否存在
if [ ! -f /usr/bin/waydroid ]
then
	kdialog --sorry "无法启动 Waydroid。Waydroid 不存在！ \\
	\\n如果您最近进行了 SteamOS 更新，那么您还需要重新安装 Waydroid！ \\
	\\n请再次启动 Waydroid 安装脚本以重新安装 Waydroid！ \\
	\\nSteamOS 版本: \$(cat /etc/os-release | grep -i VERSION_ID | cut -d "=" -f 2) \\
	\\n内核版本: \$(uname -r | cut -d "-" -f 1-5)"
	exit
fi

# 尝试使用 SIGTERM 优雅地终止 cage
timeout 5s killall -15 cage -w &> /dev/null
if [ \$? -eq 124 ]
then
	# 超时，进程仍在活动，使用 SIGINT 强制终止
	timeout 5s killall -2 cage -w &> /dev/null
	if [ \$? -eq 124 ]
	then
		# 再次超时，这将使用 SIGKILL 彻底关闭它
		timeout 5s killall -9 cage -w &> /dev/null
	fi
fi

# 停止并启动 waydroid 容器
sudo /usr/bin/waydroid-container-stop
sudo /usr/bin/waydroid-container-start
systemctl status waydroid-container.service | grep -i running
if [ \$? -eq 0 ]
then
	echo "一切正常，继续脚本。"
else
	kdialog --sorry "发生了错误。Waydroid 容器未正确初始化。"
	exit
fi

# 检查非 Steam 快捷方式是否将游戏 / 应用作为启动选项
if [ -z "\$1" ]
	then
		# 未提供启动选项。通过 cage 启动 Waydroid，并立即显示完整的用户界面
		cage -- bash -c 'wlr-randr --output X11-1 --custom-mode 1280x800@60Hz ;	\\
			/usr/bin/waydroid show-full-ui \$@ & \\

			sleep 15 ; \\
			sudo /usr/bin/waydroid-fix-controllers'
	else
		# 提供了启动选项。通过 cage 启动 Waydroid，但不显示完整的用户界面，启动参数中的应用，然后启动完整的用户界面，以便在退出所提供的应用时不会崩溃
		cage -- env PACKAGE="\$1" bash -c 'wlr-randr --output X11-1 --custom-mode 1280x800@60Hz ; \\
			/usr/bin/waydroid session start \$@ & \\

			sleep 15 ; \\
			sudo /usr/bin/waydroid-fix-controllers ; \\

			sleep 1 ; \\
			/usr/bin/waydroid app launch \$PACKAGE & \\

   			sleep 1 ; \\
      			/usr/bin/waydroid show-full-ui $@ &'
fi

# 重置 cage，以便它不会在退出时破坏显示环境变量
while [ -n "\$(pgrep cage)" ]
do
	sleep 1
done

cage -- bash -c 'wlr-randr'
EOF

# 自定义配置完成。将它们移动到正确的位置
cp $PWD/extras/Waydroid-Toolbox.sh /home/deck/Android_Waydroid
chmod +x /home/deck/Android_Waydroid/*.sh
ln -s /home/deck/Android_Waydroid/Waydroid-Toolbox.sh /home/deck/Desktop/Waydroid-Toolbox &> /dev/null

# 将 cage 和 wlr-randr 复制到正确的文件夹
echo -e "$current_password\n" | sudo -S cp cage/cage cage/wlr-randr /usr/bin
echo -e "$current_password\n" | sudo -S chmod +x /usr/bin/cage /usr/bin/wlr-randr

# 在此处放置自定义覆盖文件 - 键布局，hosts，audio.rc 等
# 复制 Steam 控制器的修正键布局
echo -e "$current_password\n" | sudo -S mkdir -p /var/lib/waydroid/overlay/system/usr/keylayout
echo -e "$current_password\n" | sudo -S cp extras/Vendor_28de_Product_11ff.kl /var/lib/waydroid/overlay/system/usr/keylayout/

# 复制自定义 audio.rc 补丁以降低音频延迟
echo -e "$current_password\n" | sudo -S mkdir -p /var/lib/waydroid/overlay/system/etc/init
echo -e "$current_password\n" | sudo -S cp extras/audio.rc /var/lib/waydroid/overlay/system/etc/init/

# 复制 StevenBlack 的自定义 hosts 文件以阻止广告（广告软件 + 恶意软件 + 假新闻 + 赌博 + 色情）
echo -e "$current_password\n" | sudo -S mkdir -p /var/lib/waydroid/overlay/system/etc
echo -e "$current_password\n" | sudo -S cp extras/hosts /var/lib/waydroid/overlay/system/etc

# 复制 nodataperm.sh - 这是修复 Android 11 中作用域存储问题的
chmod +x extras/nodataperm.sh
echo -e "$current_password\n" | sudo -S cp extras/nodataperm.sh /var/lib/waydroid/overlay/system/etc

# 检查是否为重新安装
grep redfin /var/lib/waydroid/waydroid_base.prop &> /dev/null
if [ $? -eq 0 ]
then
	echo "这似乎是重新安装。无需进一步配置。"

	# 完成所有操作，重新启用只读模式
	echo -e "$current_password\n" | sudo -S steamos-readonly enable
	echo "Waydroid 安装成功！"
else
	echo "配置文件丢失。让我们配置 waydroid。"

    # 初始化 waydroid
    mkdir -p /home/deck/waydroid/{images,cache_http}
    echo -e "$current_password\n" | sudo mkdir /var/lib/waydroid &> /dev/null
    echo -e "$current_password\n" | sudo -S ln -s /home/deck/waydroid/images /var/lib/waydroid/images &> /dev/null
    echo -e "$current_password\n" | sudo -S ln -s /home/deck/waydroid/cache_http /var/lib/waydroid/cache_http &> /dev/null
    echo -e "$current_password\n" | sudo -S waydroid init -s GAPPS

    # 检查 waydroid 初始化是否无错误完成
	if [ $? -eq 0 ]
	then
		echo "Waydroid 初始化无错误完成！"

	else
		echo "Waydroid 初始化不正确"
		echo "很可能是由于 Python 的问题。提交错误报告时附上此截图！"
		echo "whereis python 的输出 - $(whereis python)"
		echo "which python 的输出 - $(which python)"
		echo "python 版本的输出 - $(python -V)"
		cleanup_exit
	fi

    # casualsnek 脚本
    cd /home/deck/AUR/waydroid/waydroid_script
    python3 -m venv venv
    venv/bin/pip install -r requirements.txt &> /dev/null
    echo -e "$current_password\n" | sudo -S venv/bin/python3 main.py install {libndk,widevine}
    if [ $? -eq 0 ]
    then
        echo "Casualsnek 脚本完成。"
        echo -e "$current_password\n" | sudo -S rm -rf /home/deck/AUR
    else
        echo "Casualsnek 脚本出错。请再次运行脚本。"
        cleanup_exit
    fi

    # 修改指纹使 waydroid 显示为 Pixel 5 - Redfin
    echo -e "$current_password\n" | sudo -S tee -a /var/lib/waydroid/waydroid_base.prop > /dev/null <<'EOF'

##########################################################################
# udev 事件的控制器配置
persist.waydroid.udev=true
persist.waydroid.uevent=true

##########################################################################
### 自定义 build.prop 的开始 - 如果导致问题可以安全删除

ro.product.brand=google
ro.product.manufacturer=Google
ro.system.build.product=redfin
ro.product.name=redfin
ro.product.device=redfin
ro.product.model=Pixel 5
ro.system.build.flavor=redfin-user
ro.build.fingerprint=google/redfin/redfin:11/RQ3A.211001.001/eng.electr.20230318.111310:user/release-keys
ro.system.build.description=redfin-user 11 RQ3A.211001.001 eng.electr.20230318.111310 release-keys
ro.bootimage.build.fingerprint=google/redfin/redfin:11/RQ3A.211001.001/eng.electr.20230318.111310:user/release-keys
ro.build.display.id=google/redfin/redfin:11/RQ3A.211001.001/eng.electr.20230318.111310:user/release-keys
ro.build.tags=release-keys
ro.build.description=redfin-user 11 RQ3A.211001.001 eng.electr.20230318.111310 release-keys
ro.vendor.build.fingerprint=google/redfin/redfin:11/RQ3A.211001.001/eng.electr.20230318.111310:user/release-keys
ro.vendor.build.id=RQ3A.211001.001
ro.vendor.build.tags=release-keys
ro.vendor.build.type=user
ro.odm.build.tags=release-keys

### 自定义 build.prop 的结束 - 如果导致问题可以安全删除
##########################################################################
EOF
    echo "Waydroid 安装成功！"
fi

# 将 GPU 渲染更改为使用 minigbm_gbm_mesa
echo -e "$PASSWORD\n" | sudo -S sed -i "s/ro.hardware.gralloc=.*/ro.hardware.gralloc=minigbm_gbm_mesa/g" /var/lib/waydroid/waydroid_base.prop
