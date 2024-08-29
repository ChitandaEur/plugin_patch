#!/bin/bash

#移除不必要的GTK警告
zen_nospam() {
  zenity 2> >(grep -v 'Gtk' >&2) "$@"
}

#检查是否为root权限
if [ "$(id -u)" -ne 0 ]; then
    zen_nospam --error --text="请使用root权限运行此脚本！进入root权限命令sudo su" --width=600 --height=30
    exit 666
fi

#选项主函数
function select_main()
{
    choice=$(zen_nospam --list --title="SteamOS工具箱" --text="脚本版本:2.5.7\n有bug请联系QQ群：945280107，有想加的功能请联系QQ群：945280107\n请选择一个选项:" \
        --column="编号" --column="功能" \
        1 "初始化国内软件源" \
        2 "安装UU加速插件" \
        3 "安装讯游加速插件" \
        4 "安装奇游加速插件" \
        5 "调整虚拟内存大小" \
        6 "steamcommunity302" \
        7 "安装国内源稳定版插件商店" \
        8 "安装官方源稳定版插件商店" \
        9 "安装官方源测试版插件商店" \
        10 "安装tomoon" \
        11 "插件汉化" \
        12 "安装todesk" \
        13 "安装Anydesk" \
        14 "安装rustdesk" \
        15 "安装QQ" \
        16 "安装微信" \
        17 "安装Edge浏览器" \
        18 "安装Google浏览器" \
        19 "安装百度网盘" \
        20 "安装QQ音乐" \
        21 "安装网易云音乐" \
        22 "安装wiliwili" \
        23 "安装OBS Stdio" \
        24 "安装ProtonUp-Qt" \
        25 "安装WPS-Office" \
        26 "安装Minecraft" \
        27 "安装yuzu模拟器" \
        28 "模拟器陀螺仪" \
        29 "安装宝葫芦" \
        30 "安装Waydroid安卓模拟器" \
        31 "安装steam++" \
        32 "安装最新社区兼容层" \
        s "卸载已安装..." \
        cl "更新日志" \
        ys "原神,启动!" \
        --width=600 --height=600)

    #检查zen_nospam的退出状态码
    if [ $? -ne 0 ]; then
        exit 0
    fi

    case $choice in
        1)
            zen_nospam --info --text="正在初始化系统环境..." --width=200 --height=100
            steamos-readonly disable
            echo 'Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/os/$arch' | sudo tee /etc/pacman.d/mirrorlist > /dev/null
            flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
            echo "#
[options]
DBPath = /usr/lib/holo/pacmandb/
HoldPkg     = pacman glibc
        Architecture = auto
Color
CheckSpace
ParallelDownloads = 10
SigLevel    = Never
LocalFileSigLevel = Optional

[jupiter-3.5]
Include = /etc/pacman.d/mirrorlist

[holo-3.5]
Include = /etc/pacman.d/mirrorlist

[core-3.5]
Include = /etc/pacman.d/mirrorlist

[extra-3.5]
Include = /etc/pacman.d/mirrorlist

[community-3.5]
Include = /etc/pacman.d/mirrorlist

[multilib-3.5]
Include = /etc/pacman.d/mirrorlist

[archlinuxcn]" | sudo tee /etc/pacman.conf > /dev/null
            echo 'Server = https://mirrors.aliyun.com/archlinuxcn/$arch'>>/etc/pacman.conf
            rm -rf /etc/pacman.d/gnupg
            pacman-key --init
            pacman-key --populate
            pacman -Syyu --noconfirm
            pacman -S archlinux-keyring --noconfirm
            pacman -S archlinuxcn-keyring --noconfirm
            pacman -Syyu --noconfirm
            echo -e "\e[34m安装必要软件包中...\e[0m"
            sed -i "s%#zh_CN.UTF-8 UTF-8%zh_CN.UTF-8 UTF-8%" /etc/locale.gen
            rm -rf ~/.cache/locale
            echo "LANG=zh_CN.UTF-8" | sudo tee /etc/locale.conf > /dev/null
            locale-gen
            zen_nospam --info --text="初始化完毕!建议立即重启系统" --width=300 --height=100
            select_main
            ;;
        2)
            zen_nospam --info --text="开始安装UU加速器插件..." --width=200 --height=100
            sudo curl -s uudeck.com | sudo sh
            if [ -e /home/deck/uu ] ; then
                zen_nospam --info --text="UU加速器插件安装完毕!" --width=200 --height=100
                select_main
            else
                zen_nospam --error --text="UU加速器插件安装失败!请检查网络后重试" --width=300 --height=100
                select_main
            fi
            ;;
        3)
            zen_nospam --info --text="开始安装讯游加速器插件..." --width=200 --height=100
            curl -s sd.xunyou.com | sudo sh
            if [ -e /home/deck/xunyou ] ; then
                zen_nospam --info --text="讯游加速器插件安装完毕!" --width=200 --height=100
                select_main
            else
                zen_nospam --error --text="加速器插件安装失败!请检查网络后重试" --width=200 --height=100
                select_main
            fi
            ;;
        4)
            zen_nospam --info --text="开始安装奇游加速器插件..." --width=200 --height=100
            curl -s sd.qiyou.cn | sudo sh
            if [ -e /home/deck/qy ] ; then
                zen_nospam --info --text="奇游加速器插件安装完毕!" --width=200 --height=100
                select_main
            else
                zen_nospam --error --text="加速器插件安装失败!请检查网络后重试" --width=200 --height=100
                select_main
            fi
            ;;
        5)
            current_swap_size=$(du -sh /home/swapfile | cut -b 1,2,3)
            swapchoice=$(zen_nospam --question --title="调整系统虚拟内存大小" --text="当前虚拟内存大小: $current_swap_size\n是否需要调整虚拟内存大小?" --ok-label="是" --cancel-label="否" --width=250 --height=120)
            if [ $? -eq 0 ] ; then
                swapfilesize=$(zen_nospam --entry --text="请输入虚拟内存大小(单位:G,只需要输入数字):")
                zen_nospam --info --text="正在将调整虚拟内存从 $current_swap_size 调整到 $swapfilesize G" --width=200 --height=100
                swapoff /home/swapfile
                dd if=/dev/zero of=/home/swapfile bs=1024M count=$swapfilesize
                mkswap /home/swapfile
                swapon /home/swapfile
                zen_nospam --info --text="调整完成!按键返回主菜单!" --width=200 --height=100
                select_main
            else
                select_main
            fi
            ;;
        6)
            steamcommunity302_choice=$(zen_nospam --list --title="一键安装steamcommunity302" --text="                                                  当前工具版本：                    12.1.40\n                                                  上次证书更新日期：             2024.06.26\n                                                  预计下次证书更新日期：     2024.10.01\n请选择一个选项:" \
                --column="编号" --column="选项" \
                1 "我是第一次安装" \
                2 "我想重新安装（更新证书)" \
                --width=600 --height=300)
            case $steamcommunity302_choice in
                1|2)
                    SCRIPT_ABSOLUTE_PATH__302=$(readlink -f "$0")
                    SCRIPT_DIRECTORY_plugin_patch=$(dirname "$SCRIPT_ABSOLUTE_PATH__302")
                    if [ $steamcommunity302_choice -eq 2 ]; then
                        echo -e "\e[34m重新安装steamcommunity302...\e[0m"
                        sleep 1
                        echo -e "\e[34m卸载旧版本...\e[0m"
                        sleep 1
                        cd /home/deck/.local/share/SteamDeck_302/
                        chmod +x /home/deck/.local/share/SteamDeck_302/uninstall.sh
                        sh /home/deck/.local/share/SteamDeck_302/uninstall.sh
                        cd "$SCRIPT_DIRECTORY_plugin_patch"
                    fi
                    echo -e "\e[34m开始安装steamcommunity302...\e[0m"
                    sleep 1
                    rm -rf /home/deck/.local/share/SteamDeck_302
                    wget -q https://vip.123pan.cn/1824872873/releases/steamcommunity302/302 -O /home/deck/Downloads/302.zip
                    unzip /home/deck/Downloads/302.zip -d /home/deck/.local/share/
                    rm -f /home/deck/Downloads/302.zip
                    chmod 777 /home/deck/.local/share/SteamDeck_302
                    cd /home/deck/.local/share/SteamDeck_302/
                    sh /home/deck/.local/share/SteamDeck_302/install.sh
                    cd "$SCRIPT_DIRECTORY_plugin_patch"
                    zen_nospam --info --text="安装完毕！按键返回主菜单" --width=200 --height=100
                    select_main
                    ;;
            esac
            ;;
        7)
            zen_nospam --info --text="开始安装国内源稳定版插件商店...\n安装前请先打开开发者模式和cef远程调试" --width=300 --height=100
            rm -rf /home/deck/homebrew
            curl -L dl.ohmydeck.net | sh
            if [ -e /etc/systemd/system/plugin_loader.service ] ; then
                zen_nospam --info --text="插件商店安装成功!" --width=200 --height=100
                select_main
            else
                zen_nospam --error --text="插件商店安装失败!请检查网络连接后重试" --width=300 --height=100
                select_main
            fi
            ;;
        8)
            zen_nospam --info --text="开始安装官方源稳定版插件商店...\n安装前请先打开开发者模式和cef远程调试" --width=300 --height=100
            install_plugin_loader "false"
            ;;
        9)
            zen_nospam --info --text="开始安装官方源测试版插件商店...\n安装前请先打开开发者模式和cef远程调试" --width=300 --height=100
            install_plugin_loader "true"
            ;;
        10)
            zen_nospam --info --text="开始安装tomoon插件..." --width=200 --height=100
            if test -e /home/deck/homebrew/plugins/tomoon; then
                echo -e "\e[34m检测到旧版本，开始删除...\e[0m"
                rm -rf /home/deck/homebrew/plugins/tomoon
                echo -e "\e[34m删除成功！开始安装新版本\e[0m"
            fi
            if test -e /tmp/tomoon.zip; then
                rm /tmp/tomoon.zip
            fi
            curl -L -o /home/deck/Downloads/tomoon.zip https://vip.123pan.cn/1824872873/releases/tomoon/tomoon-v0.2.5.zip
            if test ! -e /home/deck/homebrew/plugins; then
               sudo mkdir -p /home/deck/homebrew/plugins
            fi
            echo -e "\e[34m在开始前，先停止插件商店服务的运行，请耐心等待几秒...\e[0m"
            systemctl stop plugin_loader 2> /dev/null
            unzip -o -qq /home/deck/Downloads/tomoon.zip -d /home/deck/Downloads/
            sleep 3
            chmod -R 777 /home/deck/Downloads/tomoon
            mv -f /home/deck/Downloads/tomoon /home/deck/homebrew/plugins/tomoon
            rm -f /home/deck/Downloads/tomoon.zip
            echo -e "\e[34m重新开启插件商店服务...\e[0m"
            systemctl start plugin_loader
            sleep 3
            if [ -d /home/deck/homebrew/plugins/tomoon ] ; then
                zen_nospam --info --text="tomoon插件安装成功!" --width=200 --height=100
                select_main
            else
                zen_nospam --error --text="tomoon插件安装失败!请检查网络连接后重试" --width=300 --height=100
                select_main
            fi
            ;;
        11)
            zen_nospam --info --text="开始汉化插件...\n只会汉化已安装的插件" --width=250 --height=100
            echo -e "\e[34m在开始前，先停止插件商店服务的运行，请耐心等待几秒...\e[0m"
            sudo systemctl stop plugin_loader
            mkdir -p /home/deck/Downloads/decky-loader-chinese
            wget -O /home/deck/Downloads/decky-loader-chinese/homebrew.7z https://gitee.com/songy171/decky-chs/raw/master/homebrew.7z
            7z x /home/deck/Downloads/decky-loader-chinese/homebrew.7z -o/home/deck/Downloads/decky-loader-chinese/
            wget -P /home/deck/Downloads/decky-loader-chinese https://vip.123pan.cn/1824872873/releases/decky-loader/Chinese/plugins.tar.gz
            tar -xzf /home/deck/Downloads/decky-loader-chinese/plugins.tar.gz -C /home/deck/Downloads/decky-loader-chinese
            chmod -R 777 /home/deck/Downloads/decky-loader-chinese
            process_plugin() {
                local plugin_folder_name=$1
                local plugin_name=$2
                if [ -d /home/deck/homebrew/plugins/$plugin_folder_name ]; then
                    cp -rf /home/deck/Downloads/decky-loader-chinese/plugins/$plugin_folder_name /home/deck/homebrew/plugins
                    echo -e "\033[38;5;207m已汉化插件  $plugin_name\033[0m"
                    sleep 1
                fi
            }
            process_plugin "tomoon" "科学上网(tomoon)"
            process_plugin "SDH-PlayTime" "游戏时长统计(PlayTime)"
            process_plugin "protondb-decky" "游戏兼容性提示(ProtonDB Badges)"
            process_plugin "PowerTools" "电源工具箱(PowerTools)"
            process_plugin "decky-steamgriddb" "封面下载(SteamGridDB)"
            process_plugin "steam-deck-battery-tracker" "电量追踪器(Battery Tracker)"
            process_plugin "CheatDeck" "游戏修改器(CheatDeck)"
            process_plugin "decky-storage-cleaner" "系统空间清理(Storage Cleaner)"
            process_plugin "Fantastic" "风扇调节(Fantastic)"
            process_plugin "SDH-AnimationChanger" "开机动画(Animation Changer)"
            process_plugin "SDH-CssLoader" "系统主题(CSS Loader)"
            process_plugin "SDH-AudioLoader" "自定义音效(Audio Loader)"
            process_plugin "Decky-Undervolt" "APU降压(Decky-Undervolt)"
            process_plugin "Junk-Store" "垃圾商店(Junk-Store)"
            rm -rf /home/deck/Downloads/decky-loader-chinese
            echo -e "\e[34m重新开启插件商店服务...\e[0m"
            sudo systemctl start plugin_loader
            zen_nospam --info --text="汉化完毕！按任意键返回主菜单" --width=250 --height=100
            select_main
            ;;
        12)
            zen_nospam --info --text="开始安装todesk..." --width=200 --height=100
            PASSWD=$(zen_nospam --password --title="请输入终端密码:" --text="passwd")
            steamos-readonly disable
            pacman-key --init
            pacman-key --populate
            pacman -R todesk --noconfirm
            pacman -R todesk-bin --noconfirm
            rm -rf /etc/systemd/system/todeskd.service -v
            rm -rf  ~/.config/todesk/todesk.cfg -v
            rm -rf /opt/todesk/ -v
            rm -rf /usr/lib/holo/pacmandb/db.lck
            curl -L -o /home/deck/Downloads/todesk-bin-4.7.2.0-4-x86_64.pkg.tar.zst https://vip.123pan.cn/1824872873/releases/todesk/bing-any
            sudo pacman -U /home/deck/Downloads/todesk-bin-4.7.2.0-4-x86_64.pkg.tar.zst --noconfirm
            echo "#!/bin/bash
echo \"$PASSWD\" | sudo -S systemctl stop todeskd.service
sleep 1
echo \"$PASSWD\" | sudo -S systemctl start todeskd.service
sleep 1
/opt/todesk/bin/ToDesk" > /opt/todesk/ToDesk.sh
            chmod +x /opt/todesk/ToDesk.sh
            echo "[Desktop Entry]
GenericName=远程软件
Categories=Network;Internet;Application;
Exec=/opt/todesk/ToDesk.sh
Icon=todesk
Name=ToDesk
StartupNotify=true
Terminal=false
Type=Application
Version=4.7.2.0" > /home/deck/.local/share/applications/Todesk.desktop
            cp /home/deck/.local/share/applications/Todesk.desktop /home/deck/Desktop/
            rm -f /home/deck/Downloads/todesk-bin-4.7.2.0-4-x86_64.pkg.tar.zst
            rm -f /usr/share/applications/todesk.desktop
            chmod 777 /home/deck/Desktop/Todesk.desktop
            systemctl stop todeskd.service
            systemctl start todeskd.service
            zen_nospam --info --text="安装完毕！按任意键返回主菜单" --width=250 --height=100
            select_main
            ;;
        13)
            flathub_name="Anydesk"
            flatpak_name="com.anydesk.Anydesk"
            flatpak_install
            ;;
        14)
            install_rustdesk() {
                local version=$1
                echo -e "\e[34m开始安装rustdesk $version 版...\e[0m"
                mkdir -p /home/deck/.local/share/rustdesk
                wget https://vip.123pan.cn/1824872873/releases/rustdesk/r.png -O /home/deck/.local/share/rustdesk/r.png
                wget -O /home/deck/.local/share/rustdesk/rustdesk-$version-x86_64.AppImage https://vip.123pan.cn/1824872873/releases/rustdesk/rustdesk-$version-x86_64.AppImage
                wget https://vip.123pan.cn/1824872873/releases/rustdesk/%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E.txt -O /home/deck/.local/share/rustdesk/使用说明.txt
                echo "[Desktop Entry]
GenericName=远程软件
Categories=Network;Internet;Application;
Exec=/home/deck/.local/share/rustdesk/rustdesk-$version-x86_64.AppImage
Icon=/home/deck/.local/share/rustdesk/r.png
Name=rustdesk
StartupNotify=true
Terminal=false
Type=Application
Version=$version" > /home/deck/.local/share/applications/rustdesk.desktop
                chmod 777 /home/deck/.local/share/applications/rustdesk.desktop
                chmod a+x /home/deck/.local/share/rustdesk/rustdesk-$version-x86_64.AppImage
                cp /home/deck/.local/share/applications/rustdesk.desktop /home/deck/Desktop/
                sudo -u deck kate /home/deck/.local/share/rustdesk/使用说明.txt
                zen_nospam --info --text="安装完毕！按任意键返回主菜单" --width=250 --height=100
                select_main
            }
            rustdesk_choice=$(zen_nospam --list --title="一键安装rustdesk" --text="请选择要安装的版本：" \
                --column="编号" --column="选项" \
                1 "v 1.3.0（官方最新版）" \
                2 "v 1.2.6（兼容低版本系统）" \
                --width=600 --height=186)
            case $rustdesk_choice in
                1)
                    install_rustdesk "1.3.0"
                    ;;
                2)
                    install_rustdesk "1.2.6"
                    ;;
            esac
            ;;
        15)
            flathub_name="LinuxQQ"
            flatpak_name="com.qq.QQ"
            flatpak_install
            ;;
        16)
            flathub_name="Linux原生版微信"
            flatpak_name="com.tencent.WeChat"
            flatpak_install
            ;;
        17)
            flathub_name="Microsoft Edge"
            flatpak_name="com.microsoft.Edge"
            flatpak_install
            ;;
        18)
            flathub_name="谷歌浏览器"
            flatpak_name="com.google.Chrome"
            flatpak_install
            ;;
        19)
            flathub_name="百度网盘"
            flatpak_name="com.baidu.NetDisk"
            flatpak_install
            ;;
        20)
            flathub_name="QQ音乐"
            flatpak_name="com.qq.QQmusic"
            flatpak_install
            ;;
        21)
            flathub_name="网易云音乐"
            flatpak_name="com.netease.CloudMusic"
            flatpak_install
            ;;
        22)
            flathub_name="wiliwili"
            flatpak_name="cn.xfangfang.wiliwili"
            flatpak_install
            ;;
        23)
            flathub_name="OBS Studio"
            flatpak_name="com.obsproject.Studio"
            flatpak_install
            ;;
        24)
            flathub_name="ProtonUp-Qt(兼容层软件)"
            flatpak_name="net.davidotek.pupgui2"
            flatpak_install
            ;;
        25)
            flathub_name="WPS-Office"
            flatpak_name="com.wps.Office"
            flatpak_install
            ;;
        26)
            source_run=$(zen_nospam --question --text="是否已经初始化国内软件源？" --ok-label="是" --cancel-label="否")
            if [ $? -eq 0 ]; then
                echo -e "\e[34m正在开始安装基于HMCL启动器的Minecraft...\e[0m"
                steamos-readonly disable
                wget -O /home/deck/Downloads/Minecraft.tar.gz https://vip.123pan.cn/1824872873/releases/Minecraft/Minecraft.tar.gz
                tar -xzf /home/deck/Downloads/Minecraft.tar.gz -C /home/deck
                echo "[Desktop Entry]
GenericName=我的世界HMCL启动器
Categories=Game;
Exec=/home/deck/Minecraft/jdk-21.0.4+7/bin/java -jar /home/deck/Minecraft/HMCL-3.5.9.jar
Icon=/home/deck/Minecraft/Minecraft.ico
Name=Minecraft
StartupNotify=true
Terminal=false
Type=Application
Version=3.5.9" > /home/deck/.local/share/applications/Minecraft.desktop
                chmod 777 /home/deck/.local/share/applications/Minecraft.desktop
                cp /home/deck/.local/share/applications/Minecraft.desktop /home/deck/Desktop/
                pacman -S wqy-zenhei --noconfirm
                rm -f /home/deck/Downloads/Minecraft.tar.gz
                chmod -R 777 /home/deck/Minecraft
                zen_nospam --info --text="安装完毕！按任意键返回主菜单" --width=250 --height=100
                select_main
            else
                zen_nospam --error --text="请先选择初始化国内软件源后再选择安装Minecraft！" --width=200 --height=100
                select_main
            fi
            ;;
        27)
            zen_nospam --info --text="正在开始安装yuzu模拟器..." --width=200 --height=100
            wget -P /home/deck/Downloads https://vip.123pan.cn/1824872873/releases/yuzu/yz.7z.001
            wget -P /home/deck/Downloads https://vip.123pan.cn/1824872873/releases/yuzu/yz.7z.002
            wget -P /home/deck/Downloads https://vip.123pan.cn/1824872873/releases/yuzu/yz.7z.003
            wget -P /home/deck/Downloads https://vip.123pan.cn/1824872873/releases/yuzu/yz.7z.004
            wget -P /home/deck/Downloads https://vip.123pan.cn/1824872873/releases/yuzu/yz.ico
            wget -P /home/deck/Downloads https://vip.123pan.cn/1824872873/releases/yuzu/yz
            /usr/bin/7z x /home/deck/Downloads/yz.7z.001 -o/home/deck/Downloads/
            mv /home/deck/Downloads/yuzu /home/deck/.local/share/yuzu
            mkdir /home/deck/yuzu
            mv /home/deck/Downloads/yz /home/deck/yuzu/yuzu.AppImage
            mv /home/deck/Downloads/yz.ico /home/deck/yuzu/yuzu.ico
            chmod -R 777 /home/deck/yuzu
            chmod -R 777 /home/deck/.local/share/yuzu
            echo -e "\e[34m创建桌面快捷方\e[0m"
            echo "[Desktop Entry]
GenericName=任天堂Switch模拟器
Categories=Game;
Exec=/home/deck/yuzu/yuzu.AppImage
Icon=/home/deck/yuzu/yuzu.ico
Name=yuzu
StartupNotify=true
Terminal=false
Type=Application
Version=Early_Access_4176" > /home/deck/.local/share/applications/yuzu.desktop
            chmod -R 777 /home/deck/yuzu
            cp /home/deck/.local/share/applications/yuzu.desktop /home/deck/Desktop/
            rm -f /home/deck/Downloads/yz.7z.00*
            chmod +x /home/deck/yuzu/yuzu.AppImage
            zen_nospam --info --text="安装完毕！已自动配置好密钥(keys)和固件(firmware)18.0.0，打开即玩，不需要再手动安装" --width=500 --height=100
            select_main
            ;;
        28)
            zen_nospam --info --text="开始安装模拟器体感陀螺仪插件，版本 V2.2.1 ..." --width=300 --height=100
            sleep 1
            wget -O /home/deck/Downloads/SteamDeckGyroDSUSetup.zip https://vip.123pan.cn/1824872873/releases/GyroDSU/SDG
            unzip -o /home/deck/Downloads/SteamDeckGyroDSUSetup.zip -d /home/deck/Downloads/
            chmod -R 777 /home/deck/Downloads/SteamDeckGyroDSUSetup
            script -q -c "su - deck -c /home/deck/Downloads/SteamDeckGyroDSUSetup/install.sh" /dev/null
            mv /home/deck/Downloads/SteamDeckGyroDSUSetup/uninstall.sh /home/deck/.config/uninstall.sh
            rm -rf /home/deck/Downloads/SteamDeckGyroDSUSetup
            rm -f /home/deck/Downloads/SteamDeckGyroDSUSetup.zip
            echo -e "\e[31m启用服务失败.请打开一个新的终端，手动输入systemctl --user -q enable --now sdgyrodsu.service\e[0m"
            zen_nospam --info --text="启用服务失败.请打开一个新的终端，手动输入systemctl --user -q enable --now sdgyrodsu.service" --width=700 --height=100
            zen_nospam --info --text="安装完毕！手动启用服务即可" --width=200 --height=100
            exit 1
            ;;
        29)
            zen_nospam --info --text="开始安装宝葫芦..." --width=200 --height=100
            sleep 1
            curl -s -L https://i.hulu.deckz.fun | sudo sh -
            echo -e "[Desktop Entry]
GenericName=一个多功能的工具
Categories=Game;
Name=宝葫芦
Exec=/home/deck/.fun.deckz/hulu/app/pad/bin/pad
Path=/home/deck/.fun.deckz/hulu
Icon=/home/deck/.fun.deckz/hulu/app/icon.png
Type=Application
Encoding=UTF-8
Terminal=false
Keywords=hulu;宝葫芦;葫芦" > /home/deck/.local/share/applications/hulu.desktop
            chmod 777 /home/deck/.local/share/applications/hulu.desktop
            zen_nospam --info --text="安装完毕！按任意键返回主菜单" --width=250 --height=100
            select_main
            ;;
        30)
            proxy_choice=$(zen_nospam --question --text="是否已开启魔法？（下载源在国外，必须翻墙，UU加速器没用）" --ok-label="是" --cancel-label="否")
            if [ $? -eq 0 ]; then
                echo -e "\e[34m开始安装Waydroid...\e[0m"
                sleep 1
                rm -rf /home/deck/SteamOS-Waydroid-Installer
                SCRIPT_ABSOLUTE_PATH_Waydroid=$(readlink -f "$0")
                SCRIPT_DIRECTORY_plugin_patch=$(dirname "$SCRIPT_ABSOLUTE_PATH_Waydroid")
                cd /home/deck
                git clone https://github.com/ryanrudolfoba/SteamOS-Waydroid-Installer
                cd /home/deck/SteamOS-Waydroid-Installer
                wget -O /home/deck/SteamOS-Waydroid-Installer/steamos-waydroid-installer.sh https://vip.123pan.cn/1824872873/releases/SteamOS-Waydroid-Installer/steamos-waydroid-installer.sh
                chmod -R 777 /home/deck/SteamOS-Waydroid-Installer
                cd /home/deck/SteamOS-Waydroid-Installer/
                sh /home/deck/SteamOS-Waydroid-Installer/steamos-waydroid-installer.sh
                cd "$SCRIPT_DIRECTORY_plugin_patch"
                rm -rf /home/deck/SteamOS-Waydroid-Installer
                wget -O /home/deck/Android_Waydroid/Waydroid-Toolbox.sh https://vip.123pan.cn/1824872873/releases/SteamOS-Waydroid-Installer/Waydroid-Toolbox.sh
                chmod +x /home/deck/Android_Waydroid/Waydroid-Toolbox.sh
                echo "[Desktop Entry]
GenericName=安卓模拟器
Categories=Game;
Version=0.0.1
Exec=/home/deck/Android_Waydroid/Android_Waydroid_Cage.sh
Icon=waydroid
Name=Waydroid
StartupNotify=true
Terminal=false
Type=Application" > /home/deck/Desktop/Waydroid.desktop
                chmod +x /home/deck/Desktop/Waydroid.desktop
                zen_nospam --info --text="安装完毕！按任意键返回主菜单" --width=250 --height=100
                select_main
            else
                zen_nospam --error --text="请开启魔法后再选择安装Waydroid！" --width=300 --height=100
                select_main
            fi
            ;;
        31)
            zen_nospam --info --text="开始安装steam++..." --width=200 --height=100
            zen_nospam --info --text="建议安装路径与快捷方式位置全部默认位置\n否则无法使用一键卸载功能" --width=300 --height=100
            HOME=/home/deck
            curl -sSL https://steampp.net/Install/Linux.sh | bash
            chmod -R 777 /home/deck/WattToolkit
            rm -f /home/deck/.local/share/applications/Watt\ Toolkit.desktop
            echo "[Desktop Entry]
Categories=Utility;Application;
Exec=/home/deck/WattToolkit/Steam++.sh
Icon=/home/deck/WattToolkit/Icons/Watt-Toolkit.png
Name=Watt Toolkit
StartupNotify=false
Terminal=false
Type=Application
Version=3" > /home/deck/.local/share/applications/Watt\ Toolkit.desktop
            chmod 777 /home/deck/.local/share/applications/Watt\ Toolkit.desktop
            cp '/home/deck/.local/share/applications/Watt Toolkit.desktop' /home/deck/Desktop/
            HOME=/root
            sudo chmod a+w /etc/hosts
            zen_nospam --info --text="安装完毕！按任意键返回主菜单" --width=200 --height=100
            select_main
            ;;
        32)
            zen_nospam --info --text="开始安装最新社区兼容层..." --width=200 --height=100
            VERSION_URL="https://vip.123pan.cn/1824872873/releases/proton-ge-custom/version_proton.txt"
            VERSION_INFO=$(curl -s "$VERSION_URL")
            eval "$VERSION_INFO"
            echo -e "\e[34m正在下载安装包...\e[0m"
            wget https://down.npee.cn/\?https://github.com/GloriousEggroll/proton-ge-custom/releases/download/$Proton/$Proton.tar.gz -O /home/deck/Downloads/$Proton.tar.gz
            echo -e "\e[34m下载完成，正在解压...\e[0m"
            tar -xzf /home/deck/Downloads/$Proton.tar.gz -C /home/deck/Downloads/
            mkdir -p /home/deck/.local/share/Steam/compatibilitytools.d
            mv /home/deck/Downloads/$Proton /home/deck/.local/share/Steam/compatibilitytools.d/$Proton
            chmod -R 777 /home/deck/.local/share/Steam/compatibilitytools.d/$Proton
            rm -f /home/deck/Downloads/$Proton.tar.gz
            if [ -d "/home/deck/.local/share/Steam/compatibilitytools.d/$Proton" ]; then
                zen_nospam --info --text="安装完毕！重启steam生效" --width=200 --height=100
                select_main
            else
                zen_nospam --error --text="安装失败！出现了一些问题，请稍候再试" --width=200 --height=100
                select_main
            fi
            ;;
        s)
            uninstall
            ;;
        ys)
            clear
            colors=("30" "31" "32" "33" "34" "35" "36" "37" "90" "91" "92" "93" "94" "95" "96" "97" "100" "101" "102" "103")
            while true; do
                color=${colors[$RANDOM % ${#colors[@]}]}
                echo -e "\e[5;${color}m玩原神玩的         玩原神玩的         玩原神玩的\e[0m"
                sleep 0.2
                done
                ;;
        cl)
            zen_nospam --text-info --width=600 --height=600 --title="更新日志" --filename=<(echo -e "Change Log：\n\n2.0.0：新增安装各种软件，删除paur安装\n\n2.0.1：更新无法正常安装应用的bug，解决系统更新无法连接数据库的bug，删除自动重启程序\n\n2.1.0：更新了彩色字体\n\n2.1.1：修复了tomoon插件安装失败的bug\n\n2.2.0：增加了安装国外官方源的稳定版和测试版插件商店，增加了插件汉化\n\n2.2.1：增加Todesk旧版卸载，新版安装\n\n2.2.2：新增HMCL启动器和Minecraft\n\n2.2.3：新增yuzu模拟器（自动配置密钥和固件，打开即玩）\n\n2.2.4：新增自动更新程序，发现新版本自动更新。11改为Wps Office\n\n2.3.1：新增steamcommunity302一键安装\n\n2.3.3：修复已知BUG，新增自动更新程序超时机制，模拟器陀螺仪安装\n\n2.3.4：修复Steamcommunity302加速，修复移动脚本位置可能导致某些软件不能正常安装，添加超时验证\n\n2.3.6：紧急修复初始化时语言编码BUG\n\n2.4.0：新增rustdesk安装，新增安装文件的卸载程序，新增每个安装的软件/游戏都会自动创建桌面快捷方式(卸载时快捷方式也会自动删除)。脚本托管地址改为123云盘，必定更新成功。完全修复桌面一半中文一半英文\n\n2.4.2：修改所有下载源为123云盘，下载速度1000倍\n\n2.4.3：新增wiliwili，迅游加速器、奇游加速器插件，宝葫芦，Waydroid安装\n\n2.4.4：修复Waydroid安装\n\n2.4.5~2.4.9：新增steam++一键安装,优化部分安装程序\n\n2.5.0：新增最新社区兼容层一键安装\n\n2.5.1：更新Minecraft的HMCL启动器版本3.5.9\n\n2.5.2：修复todesk无法连接网络，安装插件商店无需魔法（测试功能）\n\n2.5.3：添加WPS office汉化，更新waydroid到最新版本。优化部分卸载程序，使卸载更彻底\n\n2.5.4：修复汉化插件后出现两个插件的bug；修复汉化后tomoon可能出现崩溃；新增插件PlayTime（游戏时长统计）的汉化；优化.desktop文件，现在安装的软件可以在主菜单中找到。移除多余的点击步骤，移除zenity版脚本中不必要的GTK警告。\n\n2.5.5：优化汉化插件程序，现在插件不会再奔溃；重新汉化所有插件，使汉化更加完善（99%）；增加了检测程序，只会汉化已安装的插件，不会再出现未安装的插件；新增插件“电量追踪器”(Battery Tracker)的汉化\n\n2.5.6：新增插件 自定义音频(Audio Loader)的汉化，rustdesk增加v1.2.6和最新版v1.3.0\n\n2.5.7：新增插件 APU降压(Decky-Undervolt) 和 垃圾商店(Junk-Store) 的汉化")
            select_main
            ;;
        *)
            zen_nospam --error --text="无效的选择，请重新输入" --width=200 --height=100
            select_main
            ;;
    esac
}

#插件商店安装函数
install_plugin_loader() {
    local prerelease=$1
    USER_DIR="$(getent passwd $SUDO_USER | cut -d: -f6)"
    HOMEBREW_FOLDER="${USER_DIR}/homebrew"
    rm -rf "${HOMEBREW_FOLDER}/services"
    sudo -u $SUDO_USER mkdir -p "${HOMEBREW_FOLDER}/services"
    sudo -u $SUDO_USER mkdir -p "${HOMEBREW_FOLDER}/plugins"
    touch "${USER_DIR}/.steam/steam/.cef-enable-remote-debugging"
    RELEASE=$(curl -s 'https://api.github.com/repos/SteamDeckHomebrew/decky-loader/releases' | jq -r "first(.[] | select(.prerelease == $prerelease))")
    VERSION=$(jq -r '.tag_name' <<< ${RELEASE} )
    DOWNLOADURL=$(jq -r '.assets[].browser_download_url | select(endswith("PluginLoader"))' <<< ${RELEASE})
    printf "\033[34m正在安装的版本： %s...\033[0m\n" "${VERSION}"
    curl -L https://down.npee.cn/\?$DOWNLOADURL --output ${HOMEBREW_FOLDER}/services/PluginLoader
    chmod +x ${HOMEBREW_FOLDER}/services/PluginLoader
    echo $VERSION > ${HOMEBREW_FOLDER}/services/.loader.version
    systemctl --user stop plugin_loader 2> /dev/null
    systemctl --user disable plugin_loader 2> /dev/null
    systemctl stop plugin_loader 2> /dev/null
    systemctl disable plugin_loader 2> /dev/null
    SERVICE_FILE="plugin_loader-release.service"
    if [ "$prerelease" == "true" ]; then
        SERVICE_FILE="plugin_loader-prerelease.service"
    fi
    curl -L https://down.npee.cn/\?https://raw.githubusercontent.com/SteamDeckHomebrew/decky-loader/main/dist/$SERVICE_FILE --output ${HOMEBREW_FOLDER}/services/$SERVICE_FILE
    cat > "${HOMEBREW_FOLDER}/services/plugin_loader-backup.service" <<- EOM
[Unit]
Description=SteamDeck Plugin Loader
After=network-online.target
Wants=network-online.target
[Service]
Type=simple
User=root
Restart=always
ExecStart=${HOMEBREW_FOLDER}/services/PluginLoader
WorkingDirectory=${HOMEBREW_FOLDER}/services
KillSignal=SIGKILL
Environment=PLUGIN_PATH=${HOMEBREW_FOLDER}/plugins
Environment=LOG_LEVEL=$(if [ "$prerelease" == "true" ]; then echo "DEBUG"; else echo "INFO"; fi)
[Install]
WantedBy=multi-user.target
EOM
    if [[ -f "${HOMEBREW_FOLDER}/services/$SERVICE_FILE" ]]; then
        printf "\e[34m已获取最新的$(if [ "$prerelease" == "true" ]; then echo "测试版"; else echo "稳定版"; fi)服务.\n\e[0m"
        sed -i -e "s|\${HOMEBREW_FOLDER}|${HOMEBREW_FOLDER}|" "${HOMEBREW_FOLDER}/services/$SERVICE_FILE"
        cp -f "${HOMEBREW_FOLDER}/services/$SERVICE_FILE" "/etc/systemd/system/plugin_loader.service"
    else
        printf "\e[34m无法获取最新发布的$(if [ "$prerelease" == "true" ]; then echo "测试版"; else echo "稳定版"; fi)systemd服务，使用内置服务作为备份!\n\e[0m"
        rm -f "/etc/systemd/system/plugin_loader.service"
        cp "${HOMEBREW_FOLDER}/services/plugin_loader-backup.service" "/etc/systemd/system/plugin_loader.service"
    fi
    mkdir -p ${HOMEBREW_FOLDER}/services/.systemd
    cp ${HOMEBREW_FOLDER}/services/$SERVICE_FILE ${HOMEBREW_FOLDER}/services/.systemd/$SERVICE_FILE
    cp ${HOMEBREW_FOLDER}/services/plugin_loader-backup.service ${HOMEBREW_FOLDER}/services/.systemd/plugin_loader-backup.service
    rm ${HOMEBREW_FOLDER}/services/plugin_loader-backup.service ${HOMEBREW_FOLDER}/services/$SERVICE_FILE
    systemctl daemon-reload
    systemctl start plugin_loader
    systemctl enable plugin_loader
    zen_nospam --info --text="安装完毕！按任意键返回主菜单" --width=250 --height=100
    select_main
}

#flatpak函数模板
function flatpak_install() {
    source_run=$(zen_nospam --question --text="是否已经初始化国内软件源？" --ok-label="是" --cancel-label="否")
    if [ $? -eq 0 ]; then
        echo -e "\e[34m正在开始安装$flathub_name...\e[0m"
        flatpak install -y flathub $flatpak_name
        # 如果是WPS-Office，那么执行汉化
        if [ "$flathub_name" = "WPS-Office" ]; then
            echo -e "\e[34m开始汉化！\e[0m"
            wget -P /home/deck/Downloads/ https://vip.123pan.cn/1824872873/releases/WPS2019/mui.tar.gz
            tar -xzf /home/deck/Downloads/mui.tar.gz -C /home/deck/Downloads/
            rm -rf /var/lib/flatpak/app/com.wps.Office/x86_64/stable/active/files/extra/wps-office/office6/mui
            mv /home/deck/Downloads/mui /var/lib/flatpak/app/com.wps.Office/x86_64/stable/active/files/extra/wps-office/office6/mui
            chmod -R 777 /var/lib/flatpak/app/com.wps.Office/x86_64/stable/active/files/extra/wps-office/office6/mui
            rm -f /home/deck/Downloads/mui.tar.gz
            echo -e "\e[34m汉化完成！\e[0m"
        fi
        # 创建桌面快捷方式
        desktop_file_path="/var/lib/flatpak/exports/share/applications/$flatpak_name.desktop"
        cp "$desktop_file_path" /home/deck/Desktop
        if [ -f "/home/deck/Desktop/$flatpak_name.desktop" ]; then
            echo -e "\e[34m桌面快捷方式创建成功！\e[0m"
            chmod +x /home/deck/Desktop/$(basename "$desktop_file_path")
            zen_nospam --info --text="安装完毕！\n按任意键返回主菜单" --width=200 --height=100
            select_main
        else
            zen_nospam --error --text="安装失败，请检查是否已切换国内源或检查网络连接\n按任意键返回主菜单" --width=200 --height=100
            select_main
        fi
    fi
}

function flatpak_uninstall()
{
    zen_nospam --info --text="正在开始卸载$flathub_name..." --width=200 --height=100
    flatpak uninstall --assumeyes $flatpak_name
    rm -f /home/deck/Desktop/$flatpak_name.desktop
    rm -rf /home/deck/.var/app/$flatpak_name
    zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
    uninstall
}

#卸载程序
function uninstall()
{
    uninstall_choice=$(zen_nospam --list --title="卸载程序" --text="请选择一个选项:" \
        --column="编号" --column="功能" \
        1 "卸载UU加速插件" \
        2 "卸载steamcommunity302" \
        3 "卸载插件商店" \
        4 "卸载todesk" \
        5 "卸载Anydesk" \
        6 "卸载rustdesk" \
        7 "卸载QQ" \
        8 "卸载微信" \
        9 "卸载Edge浏览器" \
        10 "卸载谷歌浏览器" \
        11 "卸载百度网盘" \
        12 "卸载QQ音乐" \
        13 "卸载网易云音乐" \
        14 "卸载OBS Studio" \
        15 "卸载ProtonUp-Qt" \
        16 "卸载WPS-Office" \
        17 "卸载Minecraft" \
        18 "卸载yuzu" \
        19 "卸载模拟器陀螺仪" \
        20 "卸载clash" \
        21 "卸载讯游加速插件" \
        22 "卸载奇游加速插件" \
        23 "卸载wiliwili" \
        24 "卸载Waydroid" \
        25 "卸载宝葫芦" \
        26 "卸载steam++" \
        s "回到安装菜单" \
        --width=600 --height=600)

    if [ $? -ne 0 ]; then
        exit 0
    fi

    case $uninstall_choice in
        1)
            zen_nospam --info --text="开始卸载UU加速插件..." --width=200 --height=100
            wget -O /home/deck/Downloads/UU_uninstall.sh https://gitee.com/soforeve/plugin_patch/raw/master/uninstall/UU_uninstall.sh
            chmod +x /home/deck/Downloads/UU_uninstall.sh
            sh /home/deck/Downloads/UU_uninstall.sh steam-deck-plugin
            rm -f /home/deck/Downloads/UU_uninstall.sh
            zen_nospam --info --text="卸载成功!" --width=200 --height=100
            uninstall
            ;;
        2)
            zen_nospam --info --text="开始卸载steamcommunity302..." --width=200 --height=100
            SCRIPT_ABSOLUTE_PATH__302=$(readlink -f "$0")
            SCRIPT_DIRECTORY_plugin_patch=$(dirname "$SCRIPT_ABSOLUTE_PATH__302")
            cd /home/deck/.local/share/SteamDeck_302/
            chmod +x /home/deck/.local/share/SteamDeck_302/uninstall.sh
            sh /home/deck/.local/share/SteamDeck_302/uninstall.sh
            cd "$SCRIPT_DIRECTORY_plugin_patch"
            rm -rf /home/deck/.local/share/SteamDeck_302
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        3)
            zen_nospam --info --text="开始卸载插件商店..." --width=200 --height=100
            curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/uninstall.sh | sh
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        4)
            zen_nospam --info --text="开始卸载todesk..." --width=200 --height=100
            steamos-readonly disable
            pacman -R todesk --noconfirm
            pacman -R todesk-bin --noconfirm
            rm -rf /etc/systemd/system/todeskd.service -v
            rm -rf  ~/.config/todesk/todesk.cfg -v
            rm -rf /opt/todesk/ -v
            rm -rf /usr/lib/holo/pacmandb/db.lck
            rm -f /home/deck/Desktop/Todesk.desktop
            rm -rf /home/deck/.local/share/todesk
            rm -f /home/deck/.local/share/applications/Todesk.desktop
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        5)
            flathub_name="Anydesk"
            flatpak_name="com.anydesk.Anydesk"
            flatpak_uninstall
            ;;
        6)
            zen_nospam --info --text="开始卸载rustdesk..." --width=200 --height=100
            rm -rf /home/deck/.local/share/rustdesk
            rm -f /home/deck/Desktop/rustdesk.desktop
            rm -f /home/deck/.local/share/applications/rustdesk.desktop
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        7)
            flathub_name="QQ"
            flatpak_name="com.qq.QQ"
            flatpak_uninstall
            ;;
        8)
            flathub_name="Linux原生版微信"
            flatpak_name="com.tencent.WeChat"
            flatpak_uninstall
            ;;
        9)
            flathub_name="Microsoft Edge"
            flatpak_name="com.microsoft.Edge"
            flatpak_uninstall
            ;;
        10)
            flathub_name="谷歌浏览器"
            flatpak_name="com.google.Chrome"
            flatpak_uninstall
            ;;
        11)
            flathub_name="百度网盘"
            flatpak_name="com.baidu.NetDisk"
            flatpak_uninstall
            ;;
        12)
            flathub_name="QQ音乐"
            flatpak_name="com.qq.QQmusic"
            flatpak_uninstall
            ;;
        13)
            flathub_name="网易云音乐"
            flatpak_name="com.netease.CloudMusic"
            flatpak_uninstall
            ;;
        14)
            flathub_name="OBS Studio"
            flatpak_name="com.obsproject.Studio"
            flatpak_uninstall
            ;;
        15)
            flathub_name="ProtonUp-Qt(兼容层软件)"
            flatpak_name="net.davidotek.pupgui2"
            flatpak_uninstall
            ;;
        16)
            flathub_name="WPS-Office"
            flatpak_name="com.wps.Office"
            flatpak_uninstall
            ;;
        17)
            zen_nospam --info --text="开始卸载Minecraft..." --width=200 --height=100
            rm -rf /home/deck/Minecraft
            rm -f /home/deck/Desktop/Minecraft.desktop
            rm -f /home/deck/.local/share/applications/Minecraft.desktop
            rm -rf /home/deck/.minecraft
            rm -rf /home/deck/.local/share/hmcl
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        18)
            zen_nospam --info --text="开始卸载yuzu..." --width=200 --height=100
            rm -rf /home/deck/yuzu
            rm -rf /home/deck/.local/share/yuzu
            rm -f /home/deck/Desktop/yuzu.desktop
            rm -f /home/deck/.local/share/applications/yuzu.desktop
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        19)
            zen_nospam --info --text="开始卸载模拟器陀螺仪..." --width=200 --height=100
            chmod +x /home/deck/.config/uninstall.sh
            script -q -c "su - deck -c /home/deck/.config/uninstall.sh" /dev/null
            rm -f /home/deck/.config/uninstall.sh
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        20)
            zen_nospam --info --text="开始卸载clash..." --width=200 --height=100
            rm -rf /home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux
            rm -f /home/deck/Desktop/clash.desktop
            rm -f /home/deck/.local/share/applications/clash.desktop
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        21)
            zen_nospam --info --text="开始卸载讯游加速插件..." --width=200 --height=100
            sh /home/deck/xunyou/xunyou_uninstall.sh
            rm -rf /tmp/xunyou
            rm -rf /home/deck/xunyou
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        22)
            zen_nospam --info --text="开始卸载奇游加速插件..." --width=200 --height=100
            wget -O /home/deck/qy/qy_uninstall.sh https://gitee.com/soforeve/plugin_patch/raw/master/uninstall/qy_uninstall.sh
            chmod +x /home/deck/qy/qy_uninstall.sh
            sh /home/deck/qy/qy_uninstall.sh
            rm -rf /home/deck/qy
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        23)
            flathub_name="wiliwili"
            flatpak_name="cn.xfangfang.wiliwili"
            flatpak_uninstall
            ;;
        24)
            zen_nospam --info --text="开始卸载Waydroid..." --width=200 --height=100
            steamos-readonly disable
            sleep 1
            kernel_version=$(uname -r)
            rm /lib/modules/$kernel_version/binder_linux.ko.zst
            pacman -R --noconfirm libglibutil libgbinder python-gbinder waydroid wlroots dnsmasq lxc
            rm -rf /home/deck/waydroid /var/lib/waydroid
            rm /etc/sudoers.d/zzzzzzzz-waydroid /etc/modules-load.d/waydroid.conf /usr/bin/waydroid*
            rm /usr/bin/cage /usr/bin/wlr-randr
            rm -rf /home/deck/Android_Waydroid
            rm -rf /home/deck/SteamOS-Waydroid-Installer
            rm /home/deck/Desktop/Waydroid-Toolbox
            rm -rf /home/deck/AUR
            rm -rf /home/root
            rm /home/deck/Desktop/Waydroid.desktop
            rm -rf /root/Android_Waydroid
            rm -rf /root/waydroid
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        25)
            zen_nospam --info --text="开始卸载宝葫芦..." --width=200 --height=100
            curl -L https://i.hulu.deckz.fun/u.sh | sudo sh -
            rm -f /home/deck/.local/share/applications/hulu.desktop
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        26)
            zen_nospam --info --text="开始卸载steam++..." --width=200 --height=100
            rm -f /home/deck/.local/share/applications/Watt\ Toolkit.desktop
            rm -rf /home/deck/.local/share/.local
            rm -rf /home/deck/.local/share/.cache
            rm -f /home/deck/Desktop/Watt\ Toolkit.desktop
            chmod 777 /home/deck/WattToolkit/script/uninstall.sh
            sh /home/deck/WattToolkit/script/uninstall.sh
            zen_nospam --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        s)
            select_main
            ;;
        *)
            zen_nospam --error --text="无效的选择，请重新输入" --width=200 --height=100
            uninstall
            ;;
    esac
}

steamos-readonly disable

#当前版本
current_version=257

#仓库地址
version_url="https://gitee.com/soforeve/plugin_patch/raw/master/version/version_zenity.txt"
download_url="https://vip.123pan.cn/1824872873/releases/plugin_patch_zenity.sh"

#自动更新程序
new_version=$(curl -s $version_url | grep 'version_zenity=' | cut -d'=' -f2)
if [ "$new_version" -gt "$current_version" ]; then
    echo -e "\e[34m发现新版本: $version_new，正在更新...\e[0m"
    # 获取当前脚本路径
    script_path=$(realpath "$0")
    # 下载最新版本脚本
    curl --max-time 30 -o "$script_path" $download_url
    if [ $? -eq 0 ]; then
        current_version=$new_version
        chmod 777 "$script_path"
        echo -e "\e[34m更新完成！当前版本: $current_version...请重启脚本\e[0m"
        exit 1
    else
        echo -e "\e[31m更新失败，请检查网络连接或重试。\e[0m"
        echo -e "\e[34m请前往QQ群945280107获取最新版\n旧版本可能功能不全或存在bug，但仍然可以使用\n按任意键进入脚本\e[0m"
        read -n 1
        select_main
    fi
else
    echo "当前已是最新版本: $current_version"
fi

mkdir -p /home/deck/.local/share/applications
select_main
