#!/bin/bash
PASSWORD=$(zenity --password --title "sudo 密码认证")
echo $PASSWORD | sudo -S ls &> /dev/null
if [ $? -ne 0 ]
then
    echo sudo 密码错误！ | \
        zenity --text-info --title "Clover Toolbox" --width 400 --height 200
    exit
fi

while true
do
Choice=$(zenity --width 850 --height 350 --list --radiolist --multiple 	--title "Waydroid 工具箱 for SteamOS Waydroid 脚本  - https://github.com/ryanrudolfoba/steamos-waydroid-installer"\
	--column "选择一个" \
	--column "选项" \
	--column="描述 - 请仔细阅读！"\
	FALSE ADBLOCK "禁用或更新自定义广告拦截主机文件。"\
	FALSE AUDIO "启用或禁用自定义音频修复。"\
	FALSE SERVICE "启动或停止 Waydroid 容器服务。"\
	FALSE GPU "更改 GPU 配置 - GBM 或 MINIGBM。"\
	FALSE LAUNCHER "将 Android Waydroid Cage 启动器添加到游戏模式。"\
	FALSE UNINSTALL "选择此项以卸载 Waydroid 并恢复所有更改。"\
	TRUE EXIT "***** 退出 Waydroid 工具箱 *****")

if [ $? -eq 1 ] || [ "$Choice" == "EXIT" ]
then
    echo 用户按下了取消 / 退出。
    exit

elif [ "$Choice" == "ADBLOCK" ]
then
ADBLOCK_Choice=$(zenity --width 600 --height 220 --list --radiolist --multiple --title "Waydroid 工具箱" --column "选择一个" \
	--column "选项" --column="描述 - 请仔细阅读！"\
	FALSE DISABLE "禁用自定义广告拦截主机文件。"\
	FALSE UPDATE "更新并启用自定义广告拦截主机文件。"\
	TRUE MENU "***** 返回 Waydroid 工具箱主菜单 *****")

	if [ $? -eq 1 ] || [ "$ADBLOCK_Choice" == "MENU" ]
	then
		echo 用户按下了取消，返回主菜单。

	elif [ "$ADBLOCK_Choice" == "DISABLE" ]
	then
		# 禁用自定义广告拦截主机文件
		echo -e $PASSWORD\n | sudo -S mv /var/lib/waydroid/overlay/system/etc/hosts /var/lib/waydroid/overlay/system/etc/hosts.disable &> /dev/null

		zenity --warning --title "Waydroid 工具箱" --text "自定义广告拦截主机文件已被禁用！" --width 350 --height 75

	elif [ "$ADBLOCK_Choice" == "UPDATE" ]
	then
		# 从 Steven Black 的 GitHub 获取最新的自定义广告拦截主机文件
		echo -e $PASSWORD\n | sudo -S rm /var/lib/waydroid/overlay/system/etc/hosts.disable &> /dev/null
		echo -e $PASSWORD\n | sudo -S wget https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts \
		       -O /var/lib/waydroid/overlay/system/etc/hosts

		zenity --warning --title "Waydroid 工具箱" --text "自定义广告拦截主机文件已更新！" --width 350 --height 75
	fi

elif [ "$Choice" == "GPU" ]
then
GPU_Choice=$(zenity --width 600 --height 220 --list --radiolist --multiple 	--title "Waydroid 工具箱" --column "选择一个" --column "选项" --column="描述 - 请仔细阅读！"\
	FALSE GBM "使用 gbm 配置作为 GPU。"\
	FALSE MINIGBM "使用 minigbm_gbm_mesa 作为 GPU（默认）。"\
	TRUE MENU "***** 返回 Waydroid 工具箱主菜单 *****")
	if [ $? -eq 1 ] || [ "$GPU_Choice" == "MENU" ]
	then
		echo 用户按下了取消，返回主菜单。

	elif [ "$GPU_Choice" == "GBM" ]
	then
		# 编辑 waydroid 属性文件以使用 gbm
		echo -e $PASSWORD\n | sudo -S sed -i "s/ro.hardware.gralloc=.*/ro.hardware.gralloc=gbm/g" \
			/var/lib/waydroid/waydroid_base.prop

		zenity --warning --title "Waydroid 工具箱" --text "gbm 现在正在使用！" --width 350 --height 75

	elif [ "$GPU_Choice" == "MINIGBM" ]
	then
		# 编辑 waydroid 属性文件以使用 minigbm_gbm_mesa
		echo -e $PASSWORD\n | sudo -S sed -i "s/ro.hardware.gralloc=.*/ro.hardware.gralloc=minigbm_gbm_mesa/g" \
			/var/lib/waydroid/waydroid_base.prop

		zenity --warning --title "Waydroid 工具箱" --text "minigbm_gbm_mesa 现在正在使用！" --width 350 --height 75
	fi

elif [ "$Choice" == "AUDIO" ]
then
AUDIO_Choice=$(zenity --width 600 --height 220 --list --radiolist --multiple 	--title "Waydroid 工具箱" --column "选择一个" --column "选项" --column="描述 - 请仔细阅读！"\
	FALSE DISABLE "禁用自定义音频配置。"\
	FALSE ENABLE "启用自定义音频配置以降低音频延迟。"\
	TRUE MENU "***** 返回 Waydroid 工具箱主菜单 *****")
	if [ $? -eq 1 ] || [ "$AUDIO_Choice" == "MENU" ]
	then
		echo 用户按下了取消，返回主菜单。

	elif [ "$AUDIO_Choice" == "DISABLE" ]
	then
		# 禁用自定义音频配置
		echo -e $PASSWORD\n | sudo -S mv /var/lib/waydroid/overlay/system/etc/init/audio.rc \
		       	/var/lib/waydroid/overlay/system/etc/init/audio.rc.disable &> /dev/null

		zenity --warning --title "Waydroid 工具箱" --text "自定义音频配置已禁用！" --width 350 --height 75

	elif [ "$AUDIO_Choice" == "ENABLE" ]
	then
		# 启用自定义音频配置
		echo -e $PASSWORD\n | sudo -S mv /var/lib/waydroid/overlay/system/etc/init/audio.rc.disable \
		       	/var/lib/waydroid/overlay/system/etc/init/audio.rc &> /dev/null

		zenity --warning --title "Waydroid 工具箱" --text "自定义音频配置已启用！" --width 350 --height 75
	fi

elif [ "$Choice" == "SERVICE" ]
then
SERVICE_Choice=$(zenity --width 600 --height 220 --list --radiolist --multiple --title "Waydroid 工具箱" --column "选择一个" --column "选项" --column="描述 - 请仔细阅读！"\
	FALSE START "启动 Waydroid 容器服务。"\
	FALSE STOP "停止 Waydroid 容器服务。"\
	TRUE MENU "***** 返回 Waydroid 工具箱主菜单 *****")
	if [ $? -eq 1 ] || [ "$SERVICE_Choice" == "MENU" ]
	then
		echo 用户按下了取消，返回主菜单。

	elif [ "$SERVICE_Choice" == "START" ]
	then
		# 启动 Waydroid 容器服务
		echo -e $PASSWORD\n | sudo -S waydroid-container-start
		waydroid session start &
		sleep 5

		zenity --warning --title "Waydroid 工具箱" --text "Waydroid 容器服务已启动！" --width 350 --height 75

	elif [ "$SERVICE_Choice" == "STOP" ]
	then
		# 停止 Waydroid 容器服务
		waydroid session stop
		echo -e $PASSWORD\n | sudo -S waydroid-container-stop
		pkill kwallet

		zenity --warning --title "Waydroid 工具箱" --text "Waydroid 容器服务已停止！" --width 350 --height 75
	fi

elif [ "$Choice" == "LAUNCHER" ]
then
	steamos-add-to-steam /home/deck/Android_Waydroid/Android_Waydroid_Cage.sh
	sleep 5
	zenity --warning --title "Waydroid 工具箱" --text "Android Waydroid Cage 启动器已添加到游戏模式！" --width 450 --height 75

elif [ "$Choice" == "UNINSTALL" ]
then
	# 禁用 steamos 只读模式
	echo -e $PASSWORD\n | sudo -S steamos-readonly disable

	# 移除已安装的内核模块和软件包
	echo -e $PASSWORD\n | sudo -S systemctl stop waydroid-container
	echo -e $PASSWORD\n | sudo -S rm /lib/modules/$(uname -r)/binder_linux.ko.zst
	echo -e $PASSWORD\n | sudo -S pacman -R --noconfirm libglibutil libgbinder python-gbinder waydroid wlroots dnsmasq lxc

	# 删除 waydroid 目录和配置
	echo -e $PASSWORD\n | sudo -S rm -rf ~/waydroid /var/lib/waydroid ~/.local/share/waydroid ~/.local/share/applications/waydroid* ~/AUR

	# 删除 waydroid 配置和脚本
	echo -e $PASSWORD\n | sudo -S rm /etc/sudoers.d/zzzzzzzz-waydroid /etc/modules-load.d/waydroid.conf /usr/bin/waydroid-fix-controllers \
		/usr/bin/waydroid-container-stop /usr/bin/waydroid-container-start

	# 删除 cage 二进制文件
	echo -e $PASSWORD\n | sudo -S rm /usr/bin/cage /usr/bin/wlr-randr

	# 删除 Waydroid 工具箱符号链接
	rm ~/Desktop/Waydroid-Toolbox

	# 删除 ~/Android_Waydroid 的内容
	rm -rf ~/Android_Waydroid/

	# 重新启用 steamos 只读模式
	echo -e $PASSWORD\n | sudo -S steamos-readonly enable

	zenity --warning --title "Waydroid 工具箱" --text "Waydroid 已卸载！再见！" --width 600 --height 75
	exit
fi
done
echo -e $PASSWORD\n | sudo -S sed -i "s/ro.hardware.gralloc=.*/ro.hardware.gralloc=minigbm_gbm_mesa/g" /var/lib/waydroid/waydroid_base.prop
