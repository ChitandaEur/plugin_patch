#!/bin/bash

# 检查是否为root权限
if [ "$(id -u)" -ne 0 ]; then
    zenity --error --text="请使用root权限运行此脚本！进入root权限命令sudo su" --width=600 --height=30
    exit 1
fi

#deck ALL=(ALL) NOPASSWD: /usr/bin/systemctl stop todeskd.service, /usr/bin/systemctl start todeskd.service

#选项主函数
function select_main()
{
    choice=$(zenity --list --title="SteamOS工具箱" --text="脚本版本:2.4.8\n有bug请联系QQ群：945280107，有想加的功能请联系QQ群：945280107\n请选择一个选项:" \
        --column="编号" --column="功能" \
        1 "初始化国内软件源" \
        2 "安装UU加速插件" \
        3 "安装讯游加速插件" \
        4 "安装奇游加速插件" \
        5 "调整虚拟内存大小" \
        6 "steamcommunity302" \
        7 "安装插件商店" \
        8 "官方源插件商店" \
        9 "测试版插件商店" \
        10 "安装tomoon" \
        11 "插件商店汉化" \
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
        23 "安装WPS-Office" \
        24 "安装ProtonUp-Qt" \
        25 "安装OBS Stdio" \
        26 "安装Minecraft" \
        27 "安装yuzu模拟器" \
        28 "模拟器陀螺仪" \
        29 "安装宝葫芦" \
        30 "安装Waydroid" \
        31 "安装steam++" \
        s "卸载已安装..." \
        cl "更新日志" \
        ys "原神,启动!" \
        --width=600 --height=600)

    # 检查zenity的退出状态码
    if [ $? -ne 0 ]; then
        exit 0
    fi

    case $choice in
        1)
            zenity --info --text="正在初始化系统环境..." --width=200 --height=100
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
            zenity --info --text="初始化完毕!建议立即重启系统" --width=200 --height=100
            select_main
            ;;
        2)
            zenity --info --text="开始安装UU加速器插件..." --width=200 --height=100
            sudo curl -s uudeck.com | sudo sh
            if [ -e /home/deck/uu ] ; then
                zenity --info --text="UU加速器插件安装完毕!" --width=200 --height=100
                select_main
            else
                zenity --error --text="UU加速器插件安装失败!请检查网络后重试" --width=200 --height=100
                select_main
            fi
            ;;
        3)
            zenity --info --text="开始安装讯游加速器插件..." --width=200 --height=100
            curl -s sd.xunyou.com | sudo sh
            if [ -e /home/deck/xunyou ] ; then
                zenity --info --text="讯游加速器插件安装完毕!" --width=200 --height=100
                select_main
            else
                zenity --error --text="加速器插件安装失败!请检查网络后重试" --width=200 --height=100
                select_main
            fi
            ;;
        4)
            zenity --info --text="开始安装奇游加速器插件..." --width=200 --height=100
            curl -s sd.qiyou.cn | sudo sh
            if [ -e /home/deck/qy ] ; then
                zenity --info --text="奇游加速器插件安装完毕!" --width=200 --height=100
                select_main
            else
                zenity --error --text="加速器插件安装失败!请检查网络后重试" --width=200 --height=100
                select_main
            fi
            ;;
        5)
            current_swap_size=$(du -sh /home/swapfile | cut -b 1,2,3)
            swapchoice=$(zenity --question --text="调整系统虚拟内存大小\n当前虚拟内存大小: $current_swap_size\n是否需要调整虚拟内存大小?" --ok-label="是" --cancel-label="否")
            if [ $? -eq 0 ] ; then
                swapfilesize=$(zenity --entry --text="请输入虚拟内存大小(单位:G,只需要输入数字):")
                zenity --info --text="正在将调整虚拟内存从 $current_swap_size 调整到 $swapfilesize G" --width=200 --height=100
                swapoff /home/swapfile
                dd if=/dev/zero of=/home/swapfile bs=1024M count=$swapfilesize
                mkswap /home/swapfile
                swapon /home/swapfile
                zenity --info --text="调整完成!按键返回主菜单!" --width=200 --height=100
                select_main
            else
                select_main
            fi
            ;;
        6)
            steamcommunity302_choice=$(zenity --list --title="一键安装steamcommunity302" --text="请选择一个选项:" \
                --column="编号" --column="选项" \
                1 "我是第一次安装" \
                2 "我想重新安装（更新证书)" \
                --width=600 --height=300)
            case $steamcommunity302_choice in
                1)
                    zenity --info --text="开始安装steamcommunity302..." --width=200 --height=100
                    SCRIPT_ABSOLUTE_PATH__302=$(readlink -f "\$0")
                    SCRIPT_DIRECTORY_plugin_patch=$(dirname "$SCRIPT_ABSOLUTE_PATH__302")
                    rm -rf /home/deck/.local/share/SteamDeck_302
                    wget -q https://vip.123pan.cn/1824872873/releases/steamcommunity302/302 -O /home/deck/Downloads/302.zip
                    unzip /home/deck/Downloads/302.zip -d /home/deck/.local/share/
                    rm -f /home/deck/Downloads/302.zip
                    chmod 777 /home/deck/.local/share/SteamDeck_302
                    cd /home/deck/.local/share/SteamDeck_302/
                    sh /home/deck/.local/share/SteamDeck_302/install.sh
                    cd "$SCRIPT_DIRECTORY_plugin_patch"
                    zenity --info --text="安装完毕！按任意键返回主菜单" --width=200 --height=100
                    select_main
                    ;;
                2)
                    SCRIPT_ABSOLUTE_PATH__302=$(readlink -f "\$0")
                    SCRIPT_DIRECTORY_plugin_patch=$(dirname "$SCRIPT_ABSOLUTE_PATH__302")
                    zenity --info --text="开始重新安装steamcommunity302...\n卸载旧版本..." --width=300 --height=100
                    sleep 1
                    cd /home/deck/.local/share/SteamDeck_302/
                    chmod +x /home/deck/.local/share/SteamDeck_302/uninstall.sh
                    sh /home/deck/.local/share/SteamDeck_302/uninstall.sh
                    cd "$SCRIPT_DIRECTORY_plugin_patch"
                    zenity --info --text="开始安装新版本..." --width=200 --height=100
                    sleep 1
                    rm -rf /home/deck/.local/share/SteamDeck_302
                    wget -q https://vip.123pan.cn/1824872873/releases/steamcommunity302/302 -O /home/deck/Downloads/302.zip
                    unzip /home/deck/Downloads/302.zip -d /home/deck/.local/share/
                    rm -f /home/deck/Downloads/302.zip
                    chmod 777 /home/deck/.local/share/SteamDeck_302
                    cd /home/deck/.local/share/SteamDeck_302/
                    sh /home/deck/.local/share/SteamDeck_302/install.sh
                    cd "$SCRIPT_DIRECTORY_plugin_patch"
                    zenity --info --text="安装完毕！按任意键返回主菜单" --width=200 --height=100
                    select_main
                    ;;
                *)
                    zenity --error --text="请选择正确的选项！" --width=200 --height=100
                    select_main
                    ;;
            esac
            ;;
        7)
            zenity --info --text="开始安装插件商店..." --width=200 --height=100
            rm -rf /home/deck/homebrew
            curl -L dl.ohmydeck.net | sh
            if [ -e /etc/systemd/system/plugin_loader.service ] ; then
                zenity --info --text="插件商店安装成功!" --width=200 --height=100
                select_main
            else
                zenity --error --text="插件商店安装失败!请检查网络连接后重试" --width=200 --height=100
                select_main
            fi
            ;;
        8)
            proxy_choice=$(zenity --question --text="是否已开启魔法？（官方源在国外，必须翻墙，UU加速器没用）" --ok-label="是" --cancel-label="否")
            if [ $? -eq 0 ]; then
                zenity --info --text="正在安装插件商店稳定版..."
                USER_DIR="$(getent passwd $SUDO_USER | cut -d: -f6)"
                HOMEBREW_FOLDER="${USER_DIR}/homebrew"
                rm -rf "${HOMEBREW_FOLDER}/services"
                sudo -u $SUDO_USER mkdir -p "${HOMEBREW_FOLDER}/services"
                sudo -u $SUDO_USER mkdir -p "${HOMEBREW_FOLDER}/plugins"
                touch "${USER_DIR}/.steam/steam/.cef-enable-remote-debugging"
                RELEASE=$(curl -s 'https://api.github.com/repos/SteamDeckHomebrew/decky-loader/releases' | jq -r "first(.[] | select(.prerelease == \"false\"))")
                VERSION=$(jq -r '.tag_name' <<< ${RELEASE} )
                DOWNLOADURL=$(jq -r '.assets[].browser_download_url | select(endswith("PluginLoader"))' <<< ${RELEASE})
                printf "\033[34m正在安装的版本： %s...\033[0m\n" "${VERSION}"
                curl -L $DOWNLOADURL --output ${HOMEBREW_FOLDER}/services/PluginLoader
                chmod +x ${HOMEBREW_FOLDER}/services/PluginLoader
                echo $VERSION > ${HOMEBREW_FOLDER}/services/.loader.version
                systemctl --user stop plugin_loader 2> /dev/null
                systemctl --user disable plugin_loader 2> /dev/null
                systemctl stop plugin_loader 2> /dev/null
                systemctl disable plugin_loader 2> /dev/null
                curl -L https://raw.githubusercontent.com/SteamDeckHomebrew/decky-loader/main/dist/plugin_loader-release.service  --output ${HOMEBREW_FOLDER}/services/plugin_loader-release.service
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
Environment=LOG_LEVEL=INFO
[Install]
WantedBy=multi-user.target
EOM
                if [[ -f "${HOMEBREW_FOLDER}/services/plugin_loader-release.service" ]]; then
                    printf "\e[34m已获取最新的稳定版服务.\n\e[0m"
                    sed -i -e "s|\${HOMEBREW_FOLDER}|${HOMEBREW_FOLDER}|" "${HOMEBREW_FOLDER}/services/plugin_loader-release.service"
                    cp -f "${HOMEBREW_FOLDER}/services/plugin_loader-release.service" "/etc/systemd/system/plugin_loader.service"
                else
                    printf "\e[34m无法获取最新发布的systemd服务，使用内置服务作为备份!\n\e[0m"
                    rm -f "/etc/systemd/system/plugin_loader.service"
                    cp "${HOMEBREW_FOLDER}/services/plugin_loader-backup.service" "/etc/systemd/system/plugin_loader.service"
                fi
                mkdir -p ${HOMEBREW_FOLDER}/services/.systemd
                cp ${HOMEBREW_FOLDER}/services/plugin_loader-release.service ${HOMEBREW_FOLDER}/services/.systemd/plugin_loader-release.service
                cp ${HOMEBREW_FOLDER}/services/plugin_loader-backup.service ${HOMEBREW_FOLDER}/services/.systemd/plugin_loader-backup.service
                rm ${HOMEBREW_FOLDER}/services/plugin_loader-backup.service ${HOMEBREW_FOLDER}/services/plugin_loader-release.service

                systemctl daemon-reload
                systemctl start plugin_loader
                systemctl enable plugin_loader
                zenity --info --text="安装完成！按任意键返回主菜单" --width=200 --height=100
                select_main
            else
                zenity --error --text="请开启魔法后再选择安装官方源插件商店！" --width=200 --height=100
                select_main
            fi
            ;;
        9)
            proxy_choice=$(zenity --question --text="是否已开启魔法？（官方源在国外，必须翻墙，UU加速器没用）" --ok-label="是" --cancel-label="否")
            if [ $? -eq 0 ]; then
                zenity --info --text="正在安装插件商店测试版..."
                USER_DIR="$(getent passwd $SUDO_USER | cut -d: -f6)"
                HOMEBREW_FOLDER="${USER_DIR}/homebrew"
                rm -rf "${HOMEBREW_FOLDER}/services"
                sudo -u $SUDO_USER mkdir -p "${HOMEBREW_FOLDER}/services"
                sudo -u $SUDO_USER mkdir -p "${HOMEBREW_FOLDER}/plugins"
                touch "${USER_DIR}/.steam/steam/.cef-enable-remote-debugging"
                RELEASE=$(curl -s 'https://api.github.com/repos/SteamDeckHomebrew/decky-loader/releases' | jq -r "first(.[] | select(.prerelease == \"true\"))")
                VERSION=$(jq -r '.tag_name' <<< ${RELEASE} )
                DOWNLOADURL=$(jq -r '.assets[].browser_download_url | select(endswith("PluginLoader"))' <<< ${RELEASE})
                printf "\033[34m正在安装的版本： %s...\033[0m\n" "${VERSION}"
                curl -L $DOWNLOADURL --output ${HOMEBREW_FOLDER}/services/PluginLoader
                chmod +x ${HOMEBREW_FOLDER}/services/PluginLoader
                echo $VERSION > ${HOMEBREW_FOLDER}/services/.loader.version
                systemctl --user stop plugin_loader 2> /dev/null
                systemctl --user disable plugin_loader 2> /dev/null
                systemctl stop plugin_loader 2> /dev/null
                systemctl disable plugin_loader 2> /dev/null
                curl -L https://raw.githubusercontent.com/SteamDeckHomebrew/decky-loader/main/dist/plugin_loader-prerelease.service  --output ${HOMEBREW_FOLDER}/services/plugin_loader-prerelease.service
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
Environment=LOG_LEVEL=DEBUG
[Install]
WantedBy=multi-user.target
EOM
                if [[ -f "${HOMEBREW_FOLDER}/services/plugin_loader-prerelease.service" ]]; then
                    printf "\e[34m已获取最新的测试版服务.\n\e[0m"
                    sed -i -e "s|\${HOMEBREW_FOLDER}|${HOMEBREW_FOLDER}|" "${HOMEBREW_FOLDER}/services/plugin_loader-prerelease.service"
                    cp -f "${HOMEBREW_FOLDER}/services/plugin_loader-prerelease.service" "/etc/systemd/system/plugin_loader.service"
                else
                    printf "\e[34m无法获取最新发布的测试版systemd服务，使用内置服务作为备份!\n\e[0m"
                    rm -f "/etc/systemd/system/plugin_loader.service"
                    cp "${HOMEBREW_FOLDER}/services/plugin_loader-backup.service" "/etc/systemd/system/plugin_loader.service"
                fi
                mkdir -p ${HOMEBREW_FOLDER}/services/.systemd
                cp ${HOMEBREW_FOLDER}/services/plugin_loader-prerelease.service ${HOMEBREW_FOLDER}/services/.systemd/plugin_loader-prerelease.service
                cp ${HOMEBREW_FOLDER}/services/plugin_loader-backup.service ${HOMEBREW_FOLDER}/services/.systemd/plugin_loader-backup.service
                rm ${HOMEBREW_FOLDER}/services/plugin_loader-backup.service ${HOMEBREW_FOLDER}/services/plugin_loader-prerelease.service

                systemctl daemon-reload
                systemctl start plugin_loader
                systemctl enable plugin_loader
                zenity --info --text="安装完成！按任意键返回主菜单"
                select_main
            else
                zenity --error --text="请开启魔法后再选择安装官方源测试版插件商店！"
                select_main
            fi
            ;;
        10)
            zenity --info --text="开始安装tomoon插件..."
            if test -e /home/deck/homebrew/plugins/tomoon; then
                zenity --info --text="检测到旧版本，开始删除..."
                rm -rf /home/deck/homebrew/plugins/tomoon
            fi
            if test -e /tmp/tomoon.zip; then
                rm /tmp/tomoon.zip
            fi
            zenity --info --text="删除成功！开始安装新版本"
            curl -L -o /home/deck/Downloads/tomoon.zip https://moon.ohmydeck.net
            if test ! -e /home/deck/homebrew/plugins; then
               sudo mkdir -p /home/deck/homebrew/plugins
            fi
            systemctl --user stop plugin_loader 2> /dev/null
            systemctl stop plugin_loader 2> /dev/null
            unzip -o -qq /home/deck/Downloads/tomoon.zip -d /home/deck/Downloads/
            sleep 3
            chmod -R 777 /home/deck/Downloads/tomoon
            mv -f /home/deck/Downloads/tomoon /home/deck/homebrew/plugins/tomoon
            rm -f /home/deck/Downloads/tomoon.zip
            systemctl start plugin_loader
            sleep 3
            if [ -d /home/deck/homebrew/plugins/tomoon ] ; then
                zenity --info --text="tomoon插件安装成功!"
                select_main
            else
                zenity --error --text="tomoon插件安装失败!请检查网络连接后重试"
                select_main
            fi
            ;;
        11)
            plugin_install_choice=$(zenity --question --text="是否已经安装插件商店？" --ok-label="是" --cancel-label="否")
            if [ $? -eq 0 ]; then
                zenity --info --text="正在开始汉化插件..." --width=200 --height=100
                rm -rf /home/deck/homebrew/plugins/CheatDeck/plugin.json
                rm -rf /home/deck/homebrew/plugins/CheatDeck/dist/index.js
                rm -rf /home/deck/homebrew/plugins/decky-steamgriddb/plugin.json
                rm -rf /home/deck/homebrew/plugins/decky-storage-cleaner/dist/index.js
                rm -rf /home/deck/homebrew/plugins/decky-storage-cleaner/plugin.json
                rm -rf /home/deck/homebrew/plugins/protondb-decky/plugin.json
                rm -rf /home/deck/homebrew/plugins/SDH-AnimationChanger/plugin.json
                rm -rf /home/deck/homebrew/plugins/SDH-AnimationChanger/dist/index.js
                rm -rf /home/deck/homebrew/plugins/SDH-CssLoader/plugin.json
                rm -rf /home/deck/homebrew/plugins/SDH-CssLoader/dist/index.js
                rm -rf /home/deck/homebrew/plugins/tomoon/plugin.json
                rm -rf /home/deck/homebrew/plugins/tomoon/dist/index.js
                rm -rf /home/deck/homebrew/plugins/PowerTools/plugin.json
                wget -O /home/deck/Downloads/homebrew.7z https://gitee.com/songy171/decky-chs/raw/master/homebrew.7z
                /usr/bin/7z x /home/deck/Downloads/homebrew.7z -o/home/deck/Downloads/
                chmod -R 777 /home/deck/Downloads/homebrew
                cp -rf /home/deck/Downloads/homebrew /home/deck
                rm -rf /home/deck/Downloads/homebrew.7z
                rm -rf /home/deck/Downloads/homebrew
                zenity --info --text="汉化完毕！按任意键返回主菜单" --width=200 --height=100
                select_main
            else
                zenity --error --text="请先安装插件商店后再选择汉化！" --width=200 --height=100
                select_main
            fi
            ;;
        12)
            todesk_choice=$(zenity --list --title="一键安装Todesk" --text="请选择一个选项:" \
                --column="编号" --column="选项" \
                1 "已安装官网版本，卸载并安装新版本" \
                2 "从未安装过todesk,安装新版本" \
                --width=600 --height=300)
            case $todesk_choice in
                1)
                    zenity --info --text="开始卸载官网版本..." --width=200 --height=100
                    sleep 1
                    rm -rf /etc/systemd/system/todeskd.service -v
                    rm -rf  ~/.config/todesk/todesk.cfg -v
                    rm -rf /opt/todesk/ -v
                    rm -rf /usr/lib/holo/pacmandb/db.lck
                    pacman -R todesk --noconfirm
                    zenity --info --text="todesk 卸载成功，开始安装新版本" --width=200 --height=100
                    steamos-readonly disable
                    sleep 1
                    pacman-key --init
                    pacman-key --populate
                    curl -L -o /home/deck/Downloads/todesk-bin-4.7.2.0-4-x86_64.pkg.tar.zst https://vip.123pan.cn/1824872873/releases/todesk/bing-any
                    sleep 2
                    pacman -U /home/deck/Downloads/todesk-bin-4.7.2.0-4-x86_64.pkg.tar.zst --noconfirm
                    sleep 2
                    echo "#!/bin/bash
sudo systemctl stop todeskd.service
sudo systemctl start todeskd.service
/opt/todesk/bin/ToDesk" > /home/deck/Downloads/ToDesk.sh
                    chmod +x /home/deck/Downloads/ToDesk.sh
                    mv /home/deck/Downloads/ToDesk.sh /opt/todesk/ToDesk.sh
                    sleep 2
                    echo "[Desktop Entry]
Comment[zh_CN]=
Comment=
Exec=/opt/todesk/ToDesk.sh
GenericName[zh_CN]=
GenericName=
Icon=todesk
MimeType=
Name[zh_CN]=ToDesk
Name=ToDesk
Path=
StartupNotify=true
Terminal=false
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=" > /home/deck/Desktop/ToDesk.txt
                    mv /home/deck/Desktop/ToDesk.txt /home/deck/Desktop/Todesk.desktop
                    systemctl stop todeskd.service
                    systemctl start todeskd.service
                    rm -f /home/deck/Downloads/todesk-bin-4.7.2.0-4-x86_64.pkg.tar.zst
                    zenity --info --text="安装完毕！按任意键返回主菜单" --width=200 --height=100
                    select_main
                    ;;
                2)
                    if [ -e /etc/systemd/system/todeskd.service ] ; then
                        zenity --error --text="检测到你已经安装官网版本，请先卸载！" --width=200 --height=100
                        select_main
                    else
                        zenity --info --text="开始安装todesk"
                        steamos-readonly disable
                        sleep 1
                        pacman-key --init
                        pacman-key --populate
                        curl -L -o /home/deck/Downloads/todesk-bin-4.7.2.0-4-x86_64.pkg.tar.zst https://vip.123pan.cn/1824872873/releases/todesk/bing-any
                        pacman -U /home/deck/Downloads/todesk-bin-4.7.2.0-4-x86_64.pkg.tar.zst --noconfirm
                        echo "#!/bin/bash
sudo systemctl stop todeskd.service
sudo systemctl start todeskd.service
/opt/todesk/bin/ToDesk" > /home/deck/Downloads/ToDesk.sh
                        chmod +x /home/deck/Downloads/ToDesk.sh
                        mv /home/deck/Downloads/ToDesk.sh /opt/todesk/ToDesk.sh
                        sleep 1
                        echo "[Desktop Entry]
Comment[zh_CN]=
Comment=
Exec=/opt/todesk/ToDesk.sh
GenericName[zh_CN]=
GenericName=
Icon=todesk
MimeType=
Name[zh_CN]=ToDesk
Name=ToDesk
Path=
StartupNotify=true
Terminal=false
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=" > /home/deck/Desktop/ToDesk.txt
                        mv /home/deck/Desktop/ToDesk.txt /home/deck/Desktop/Todesk.desktop
                        systemctl stop todeskd.service
                        systemctl start todeskd.service
                        rm -f /home/deck/Downloads/todesk-bin-4.7.2.0-4-x86_64.pkg.tar.zst
                        zenity --info --text="安装完毕！按任意键返回主菜单" --width=200 --height=100
                        select_main
                    fi
                    ;;
                *)
                    zenity --error --text="选择错误，请重新选择！" --width=200 --height=100
                    select_main
                    ;;
            esac
            ;;
        13)
            flathub_name="Anydesk"
            flatpak_name="com.anydesk.Anydesk"
            flatpak_install
            ;;
        14)
            zenity --info --text="开始安装rustdesk..."
            mkdir -p /home/deck/.local/share/rustdesk
            wget https://vip.123pan.cn/1824872873/releases/rustdesk/r.png -O /home/deck/.local/share/rustdesk/r.png
            wget -O /home/deck/.local/share/rustdesk/rustdesk-1.2.6-x86_64.AppImage https://vip.123pan.cn/1824872873/releases/rustdesk/rustdesk-1.2.6-x86_64.AppImage
            wget https://vip.123pan.cn/1824872873/releases/rustdesk/%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E.txt -O /home/deck/.local/share/rustdesk/使用说明.txt
            echo "[Desktop Entry]
Comment[zh_CN]=
Comment=
Exec=/home/deck/.local/share/rustdesk/rustdesk-1.2.6-x86_64.AppImage
GenericName[zh_CN]=
GenericName=
Icon=/home/deck/.local/share/rustdesk/r.png
MimeType=
Name[zh_CN]=rustdesk
Name=rustdesk
Path=
StartupNotify=true
Terminal=false
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=" > /home/deck/.local/share/rustdesk/rustdesk.txt
            chmod -R 777 /home/deck/.local/share/rustdesk
            mv /home/deck/.local/share/rustdesk/rustdesk.txt /home/deck/Desktop/rustdesk.desktop
            sudo -u deck kate /home/deck/.local/share/rustdesk/使用说明.txt
            zenity --info --text="安装完毕！按任意键返回主菜单" --width=200 --height=100
            select_main
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
            flathub_name="WPS-Office"
            flatpak_name="com.wps.Office"
            flatpak_install
            ;;
        24)
            flathub_name="ProtonUp-Qt(兼容层软件)"
            flatpak_name="net.davidotek.pupgui2"
            flatpak_install
            ;;
        25)
            flathub_name="OBS Studio"
            flatpak_name="com.obsproject.Studio"
            flatpak_install
            ;;
        26)
            source_run=$(zenity --question --text="是否已经初始化国内软件源？" --ok-label="是" --cancel-label="否")
            if [ $? -eq 0 ]; then
                zenity --info --text="正在开始安装基于HMCL启动器的Minecraft..." --width=200 --height=100
                steamos-readonly disable
                wget -P /home/deck/Downloads https://vip.123pan.cn/1824872873/releases/Minecraft/tfarcenim.7z.001
                wget -P /home/deck/Downloads https://vip.123pan.cn/1824872873/releases/Minecraft/tfarcenim.7z.002
                wget -P /home/deck/Downloads https://vip.123pan.cn/1824872873/releases/Minecraft/tfarcenim.7z.003
                /usr/bin/7z x /home/deck/Downloads/tfarcenim.7z.001 -o/home/deck/Downloads/
                mv /home/deck/Downloads/Minecraft /home/deck/Minecraft
                echo "[Desktop Entry]
Comment[zh_CN]=
Comment=
Exec=/home/deck/Minecraft/jdk-21.0.3/bin/java -jar /home/deck/Minecraft/HMCL-3.5.8.jar
GenericName[zh_CN]=
GenericName=
Icon=/home/deck/Minecraft/jdk-21.0.3/1.ico
MimeType=
Name[zh_CN]=Minecraft
Name=HMCL
Path=
StartupNotify=true
Terminal=false
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=" > /home/deck/Downloads/Minecraft.txt
                mv /home/deck/Downloads/Minecraft.txt /home/deck/Desktop/Minecraft.desktop
                chmod +x /home/deck/Desktop/Minecraft.desktop
                pacman -S wqy-zenhei --noconfirm
                rm -f /home/deck/Downloads/tfarcenim.7z.00*
                chmod -R 777 /home/deck/Minecraft
                zenity --info --text="安装完毕！按任意键返回主菜单" --width=200 --height=100
                select_main
            else
                zenity --error --text="请先选择初始化国内软件源后再选择安装Minecraft！" --width=200 --height=100
                select_main
            fi
            ;;
        27)
            zenity --info --text="正在开始安装yuzu模拟器..." --width=200 --height=100
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
            echo "[Desktop Entry]
Comment[zh_CN]=
Comment=
Exec=/home/deck/yuzu/yuzu.AppImage
GenericName[zh_CN]=
GenericName=
Icon=/home/deck/yuzu/yuzu.ico
MimeType=
Name[zh_CN]=yuzu
Name=yuzu
Path=
StartupNotify=true
Terminal=false
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=" > /home/deck/yuzu/yuzu.txt
            chmod -R 777 /home/deck/yuzu
            mv /home/deck/yuzu/yuzu.txt /home/deck/Desktop/yuzu.desktop
            rm -f /home/deck/Downloads/yz.7z.00*
            chmod +x /home/deck/yuzu/yuzu.AppImage
            zenity --info --text="安装完毕！已自动配置好密钥(keys)和固件(firmware)18.0.0，打开即玩，不需要再手动安装" --width=500 --height=100
            select_main
            ;;
        28)
            zenity --info --text="开始安装模拟器体感陀螺仪插件，版本 V2.2.1 ..." --width=200 --height=100
            sleep 1
            wget -O /home/deck/Downloads/SteamDeckGyroDSUSetup.zip https://vip.123pan.cn/1824872873/releases/GyroDSU/SDG
            unzip -o /home/deck/Downloads/SteamDeckGyroDSUSetup.zip -d /home/deck/Downloads/
            chmod -R 777 /home/deck/Downloads/SteamDeckGyroDSUSetup
            script -q -c "su - deck -c /home/deck/Downloads/SteamDeckGyroDSUSetup/install.sh" /dev/null
            mv /home/deck/Downloads/SteamDeckGyroDSUSetup/uninstall.sh /home/deck/.config/uninstall.sh
            rm -rf /home/deck/Downloads/SteamDeckGyroDSUSetup
            rm -f /home/deck/Downloads/SteamDeckGyroDSUSetup.zip
            zenity --info --text="启用服务失败.请打开一个新的终端，手动输入systemctl --user -q enable --now sdgyrodsu.service" --width=700 --height=100
            zenity --info --text="安装完毕！手动启用服务即可" --width=200 --height=100
            exit 1
            ;;
        29)
            zenity --info --text="开始安装宝葫芦..." --width=200 --height=100
            sleep 1
            curl -s -L https://i.hulu.deckz.fun | sudo sh -
            zenity --info --text="安装完毕！按任意键返回主菜单" --width=200 --height=100
            select_main
            ;;
        30)
            proxy_choice=$(zenity --question --text="是否已开启魔法？（下载源在国外，必须翻墙，UU加速器没用）" --ok-label="是" --cancel-label="否")
            if [ $? -eq 0 ]; then
                zenity --info --text="开始安装Waydroid..." --width=200 --height=100
                sleep 1
                rm -rf /home/deck/SteamOS-Waydroid-Installer
                SCRIPT_ABSOLUTE_PATH_Waydroid=$(readlink -f "\$0")
                SCRIPT_DIRECTORY_plugin_patch=$(dirname "$SCRIPT_ABSOLUTE_PATH_Waydroid")
                cd /home/deck
                git clone https://github.com/ryanrudolfoba/SteamOS-Waydroid-Installer
                cd /home/deck/SteamOS-Waydroid-Installer
                wget -O /home/deck/SteamOS-Waydroid-Installer/steamos-waydroid-installer.sh https://vip.123pan.cn/1824872873/releases/SteamOS-Waydroid-Installer/steamos-waydroid-installer.sh
                chmod +x /home/deck/SteamOS-Waydroid-Installer/steamos-waydroid-installer.sh
                chmod -R 777 /home/deck/SteamOS-Waydroid-Installer
                cd /home/deck/SteamOS-Waydroid-Installer/
                /home/deck/SteamOS-Waydroid-Installer/steamos-waydroid-installer.sh
                cd "$SCRIPT_DIRECTORY_plugin_patch"
                rm -rf /home/deck/SteamOS-Waydroid-Installer
                wget -O /home/deck/Android_Waydroid/Waydroid-Toolbox.sh https://vip.123pan.cn/1824872873/releases/SteamOS-Waydroid-Installer/Waydroid-Toolbox.sh
                chmod +x /home/deck/Android_Waydroid/Waydroid-Toolbox.sh
                echo "[Desktop Entry]
Comment[zh_CN]=
Comment=
Exec=/home/deck/Android_Waydroid/Android_Waydroid_Cage.sh
GenericName[zh_CN]=
GenericName=
Icon=waydroid
MimeType=
Name[zh_CN]=Waydroid
Name=Waydroid
Path=
StartupNotify=true
Terminal=false
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=" > /home/deck/Waydroid.txt
                chmod +x /home/deck/Waydroid.txt
                mv /home/deck/Waydroid.txt /home/deck/Desktop/Waydroid.desktop
                steamos-readonly disable
                zenity --info --text="安装完毕！按任意键返回主菜单" --width=200 --height=100
                select_main
            else
                zenity --error --text="请开启魔法后再选择安装Waydroid！" --width=200 --height=100
                select_main
            fi
            ;;
        31)
            zenity --info --text="开始安装steam++..." --width=200 --height=100
            zenity --info --text="建议安装路径与快捷方式位置全部默认位置\n否则无法使用一键卸载功能" --width=300 --height=100
            HOME=/home/deck
            curl -sSL https://steampp.net/Install/Linux.sh | bash
            chmod -R 777 /home/deck/WattToolkit
            cp '/home/deck/.local/share/applications/Watt Toolkit.desktop' /home/deck/Desktop/
            sudo chmod a+w /etc/hosts
            HOME=/root
            zenity --info --text="安装完毕！按任意键返回主菜单" --width=200 --height=100
            select_main
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
            zenity --text-info --width=600 --height=600 --title="更新日志" --filename=<(echo -e "Change Log：\n\n2.0.0：新增安装各种软件，删除paur安装\n\n2.0.1：更新无法正常安装应用的bug，解决系统更新无法连接数据库的bug，删除自动重启程序\n\n2.1.0：更新了彩色字体\n\n2.1.1：修复了tomoon插件安装失败的bug\n\n2.2.0：增加了安装国外官方源的稳定版和测试版插件商店，增加了插件汉化\n\n2.2.1：增加Todesk旧版卸载，新版安装\n\n2.2.2：新增HMCL启动器和Minecraft\n\n2.2.3：新增yuzu模拟器（自动配置密钥和固件，打开即玩）\n\n2.2.4：新增自动更新程序，发现新版本自动更新。11改为Wps Office\n\n2.3.1：新增steamcommunity302一键安装\n\n2.3.3：修复已知BUG，新增自动更新程序超时机制，模拟器陀螺仪安装\n\n2.3.4：修复Steamcommunity302加速，修复移动脚本位置可能导致某些软件不能正常安装，添加超时验证\n\n2.3.6：紧急修复初始化时语言编码BUG\n\n2.4.0：新增rustdesk安装，新增安装文件的卸载程序，新增每个安装的软件/游戏都会自动创建桌面快捷方式(卸载时快捷方式也会自动删除)。脚本托管地址改为123云盘，必定更新成功。完全修复桌面一半中文一半英文\n\n2.4.2：修改所有下载源为123云盘，下载速度1000倍\n\n2.4.3：新增wiliwili，迅游加速器、奇游加速器插件，宝葫芦，Waydroid安装\n\n2.4.4：修复Waydroid安装\n\n2.4.7：新增steam++一键安装,优化部分安装程序")
            select_main
            ;;
        *)
            zenity --error --text="无效的选择，请重新输入" --width=200 --height=100
            select_main
            ;;
    esac
}

#flatpak函数模板
function flatpak_install()
{
    source_run=$(zenity --question --text="是否已经初始化国内软件源？" --ok-label="是" --cancel-label="否")
    if [ $? -eq 0 ]; then
        zenity --info --text="正在开始安装$flathub_name..." --width=200 --height=100
        flatpak install -y flathub $flatpak_name
        zenity --info --text="安装完毕！" --width=200 --height=100

        # 查找 .desktop 文件路径
        desktop_file_path="/var/lib/flatpak/exports/share/applications/$flatpak_name.desktop"

        # 如果找到 .desktop 文件，复制到桌面并设置权限
        if [ -n "$desktop_file_path" ]; then
            cp "$desktop_file_path" /home/deck/Desktop
            chmod +x /home/deck/Desktop/$(basename "$desktop_file_path")
            zenity --info --text="桌面快捷方式创建成功！" --width=200 --height=100
        else
            zenity --error --text="未找到 .desktop 文件，无法创建桌面快捷方式。" --width=200 --height=100
        fi

        zenity --info --text="按任意键返回主菜单" --width=200 --height=100
        select_main
    else
        zenity --error --text="请先选择初始化国内软件源后再选择安装$flathub_name！" --width=200 --height=100
        select_main
    fi
}

function flatpak_uninstall()
{
    zenity --info --text="正在开始卸载$flathub_name..." --width=200 --height=100
    flatpak uninstall --assumeyes $flatpak_name
    rm -f /home/deck/Desktop/$flatpak_name.desktop
    zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
    uninstall
}

#卸载程序
function uninstall()
{
    uninstall_choice=$(zenity --list --title="卸载程序" --text="请选择一个选项:" \
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
        14 "卸载WPS-Office" \
        15 "卸载ProtonUp-Qt" \
        16 "卸载OBS Studio" \
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
            zenity --info --text="开始卸载UU加速插件..." --width=200 --height=100
            wget -O /home/deck/Downloads/UU_uninstall.sh https://gitee.com/soforeve/plugin_patch/raw/master/uninstall/UU_uninstall.sh
            chmod +x /home/deck/Downloads/UU_uninstall.sh
            sh /home/deck/Downloads/UU_uninstall.sh steam-deck-plugin
            rm -f /home/deck/Downloads/UU_uninstall.sh
            zenity --info --text="卸载成功!" --width=200 --height=100
            uninstall
            ;;
        2)
            zenity --info --text="开始卸载steamcommunity302..." --width=200 --height=100
            SCRIPT_ABSOLUTE_PATH__302=$(readlink -f "\$0")
            SCRIPT_DIRECTORY_plugin_patch=$(dirname "$SCRIPT_ABSOLUTE_PATH__302")
            cd /home/deck/.local/share/SteamDeck_302/
            chmod +x /home/deck/.local/share/SteamDeck_302/uninstall.sh
            sh /home/deck/.local/share/SteamDeck_302/uninstall.sh
            cd "$SCRIPT_DIRECTORY_plugin_patch"
            rm -rf /home/deck/.local/share/SteamDeck_302
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        3)
            zenity --info --text="开始卸载插件商店..." --width=200 --height=100
            curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/uninstall.sh | sh
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        4)
            zenity --info --text="开始卸载todesk..." --width=200 --height=100
            pacman -R todesk-bin --noconfirm
            rm -rf /etc/systemd/system/todeskd.service -v
            rm -rf  ~/.config/todesk/todesk.cfg -v
            rm -rf /opt/todesk/ -v
            rm -rf /usr/lib/holo/pacmandb/db.lck
            pacman -R todesk --noconfirm
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        5)
            flathub_name="Anydesk"
            flatpak_name="com.anydesk.Anydesk"
            flatpak_uninstall
            ;;
        6)
            zenity --info --text="开始卸载rustdesk..." --width=200 --height=100
            rm -rf /home/deck/.local/share/rustdesk
            rm -f /home/deck/Desktop/rustdesk.desktop
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
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
            flathub_name="WPS-Office"
            flatpak_name="com.wps.Office"
            flatpak_uninstall
            ;;
        15)
            flathub_name="ProtonUp-Qt(兼容层软件)"
            flatpak_name="net.davidotek.pupgui2"
            flatpak_uninstall
            ;;
        16)
            flathub_name="OBS Studio"
            flatpak_name="com.obsproject.Studio"
            flatpak_uninstall
            ;;
        17)
            zenity --info --text="开始卸载Minecraft..." --width=200 --height=100
            rm -rf /home/deck/Minecraft
            rm -f /home/deck/Desktop/Minecraft.desktop
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        18)
            zenity --info --text="开始卸载yuzu..." --width=200 --height=100
            rm -rf /home/deck/yuzu
            rm -rf /home/deck/.local/share/yuzu
            rm -f /home/deck/Desktop/yuzu.desktop
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        19)
            zenity --info --text="开始卸载模拟器陀螺仪..." --width=200 --height=100
            chmod +x /home/deck/.config/uninstall.sh
            script -q -c "su - deck -c /home/deck/.config/uninstall.sh" /dev/null
            rm -f /home/deck/.config/uninstall.sh
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        20)
            zenity --info --text="开始卸载clash..." --width=200 --height=100
            rm -rf /home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux
            rm -f /home/deck/Desktop/clash.desktop
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        21)
            zenity --info --text="开始卸载讯游加速插件..." --width=200 --height=100
            sh /home/deck/xunyou/xunyou_uninstall.sh
            rm -rf /tmp/xunyou
            rm -rf /home/deck/xunyou
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        22)
            zenity --info --text="开始卸载奇游加速插件..." --width=200 --height=100
            wget -O /home/deck/qy/qy_uninstall.sh https://gitee.com/soforeve/plugin_patch/raw/master/uninstall/qy_uninstall.sh
            chmod +x /home/deck/qy/qy_uninstall.sh
            sh /home/deck/qy/qy_uninstall.sh
            rm -rf /home/deck/qy
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        23)
            flathub_name="wiliwili"
            flatpak_name="cn.xfangfang.wiliwili"
            flatpak_uninstall
            ;;
        24)
            zenity --info --text="开始卸载Waydroid..." --width=200 --height=100
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
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        25)
            zenity --info --text="开始卸载宝葫芦..." --width=200 --height=100
            curl -L https://i.hulu.deckz.fun/u.sh | sudo sh -
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        26)
            zenity --info --text="开始卸载steam++..." --width=200 --height=100
            chmod 777 /home/deck/WattToolkit/script/uninstall.sh
            sh /home/deck/WattToolkit/script/uninstall.sh
            rm -f /home/deck/.local/share/applications/Watt\ Toolkit.desktop
            rm -f /home/deck/Desktop/Watt\ Toolkit.desktop
            rm -rf /home/deck/.local/share/.local
            zenity --info --text="卸载完毕！按任意键返回主菜单" --width=200 --height=100
            uninstall
            ;;
        s)
            select_main
            ;;
        *)
            zenity --error --text="无效的选择，请重新输入" --width=200 --height=100
            uninstall
            ;;
    esac
}

#当前版本
current_version=248

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
        echo -e "\e[34m请前往QQ群945280107获取最新版\e[0m"
        echo -e "\e[34m旧版本可能功能不全或存在bug，但仍然可以使用\e[0m"
        echo -e "\e[34m按任意键进入脚本\e[0m"
        read -n 1
        select_main
    fi
else
    echo "当前已是最新版本: $current_version"
fi

steamos-readonly disable

select_main
