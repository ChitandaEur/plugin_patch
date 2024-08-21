#!/bin/bash

# 检查是否为root权限
if [ "$(id -u)" -ne 0 ]; then
    echo -e "\e[96m请使用root权限运行此脚本！进入root权限命令sudo su\e[0m"
    exit 1
fi

#deck ALL=(ALL) NOPASSWD: /usr/bin/systemctl stop todeskd.service, /usr/bin/systemctl start todeskd.service

#选项主函数
function select_main()
{
    clear
    echo -e "\e[34m                                       SteamOS工具箱\e[0m"
    echo -e "\e[34m                                      脚本版本:2.5.3\e[0m"
    echo -e "\e[34m     = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =\e[0m"
    echo -e "\e[34m     =   1.初始化国内软件源    =   15.安装QQ             =   29.安装宝葫芦         =\e[0m"
    echo -e "\e[34m     =   2.安装UU加速插件      =   16.安装微信           =   30.安装Waydroid       = \e[0m"
    echo -e "\e[34m     =   3.安装讯游加速插件    =   17.安装Edge浏览器     =   31.安装steam++        =\e[0m"
    echo -e "\e[34m     =   4.安装奇游加速插件    =   18.安装Google浏览器   =   32.安装最新社区兼容层 =\e[0m"
    echo -e "\e[34m     =   5.调整虚拟内存大小    =   19.安装百度网盘       =                         =\e[0m"
    echo -e "\e[34m     =   6.steamcommunity302   =   20.安装QQ音乐         =                         =\e[0m"
    echo -e "\e[34m     =   7.安装插件商店        =   21.安装网易云音乐     =                         =\e[0m"
    echo -e "\e[34m     =   8.官方源插件商店      =   22.安装wiliwili       =                         =\e[0m"
    echo -e "\e[34m     =   9.测试版插件商店      =   23.安装OBS Stdio      =                         =\e[0m"
    echo -e "\e[34m     =   10.安装tomoon         =   24.安装ProtonUp-Qt    =                         =\e[0m"
    echo -e "\e[34m     =   11.插件商店汉化       =   25.安装WPS-Office     =                         =\e[0m"
    echo -e "\e[34m     =   12.安装todesk         =   26.安装Minecraft      =   s.卸载已安装...       =\e[0m"
    echo -e "\e[34m     =   13.安装Anydesk        =   27.安装yuzu模拟器     =   cl.更新日志           =\e[0m"
    echo -e "\e[34m     =   14.安装rustdesk       =   28.模拟器陀螺仪       =   ys.原神,启动!         =\e[0m"
    echo -e "\e[34m     = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =\e[0m"
    echo -e "\e[34m有bug请联系QQ群：945280107，有想加的功能请联系QQ群：945280107\e[0m"
    read -p $'\e[34m请选择:\e[0m' main_choice

    case $main_choice in
        1)
            echo -e "\e[34m正在初始化系统环境...\e[0m"
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
            echo -e "\e[34m初始化完毕!建议立即重启系统\e[0m"
            echo -e "\e[34m按任意键返回主菜单\e[0m"
            read -n 1desktop:/Todesk.desktop
            select_main
            ;;
        2)
            echo -e "\e[34m开始安装UU加速器插件...\e[0m"
            sudo curl -s uudeck.com|sudo sh
            if [ -e /home/deck/uu ] ; then
                echo -e "\e[34mUU加速器插件安装完毕!\e[0m"
                sleep 3
                select_main
            else
                echo -e "\e[34mUU加速器插件安装失败!请检查网络后重试\e[0m"
                echo -e "\e[34m按任意键返回主菜单\e[0m"
                read -n 1
                select_main
            fi
            ;;
        3)
            echo -e "\e[34m开始安装讯游加速器插件...\e[0m"
            curl -s sd.xunyou.com|sudo sh
            if [ -e /home/deck/xunyou ] ; then
                echo -e "\e[34m讯游加速器插件安装完毕!\e[0m"
                sleep 3
                select_main
            else
                echo -e "\e[34m加速器插件安装失败!请检查网络后重试\e[0m"
                echo -e "\e[34m按任意键返回主菜单\e[0m"
                read -n 1
                select_main
            fi
            ;;
        4)
            echo -e "\e[34m开始安装奇游加速器插件...\e[0m"
            curl -s sd.qiyou.cn|sudo sh
            if [ -e /home/deck/qy ] ; then
                echo -e "\e[34m奇游加速器插件安装完毕!\e[0m"
                sleep 3
                select_main
            else
                echo -e "\e[34m加速器插件安装失败!请检查网络后重试\e[0m"
                echo -e "\e[34m按任意键返回主菜单\e[0m"
                read -n 1
                select_main
            fi
            ;;
        5)
            echo -e "\e[34m调整系统虚拟内存大小\e[0m"
            echo -e "\e[34m当前虚拟内存大小:"`du -sh /home/swapfile|cut -b 1,2,3`
            read -p $'\e[34m是否需要调整虚拟内存大小y/n:\e[0m' swapchoice
            if [ $swapchoice = y ] ; then
                read -p $'\e[34m请输入虚拟内存大小(单位:G,只需要输入数字):\e[0m' swapfilesize
                echo -e "\e[34m正在将调整虚拟内存从 \e[0m"`du -sh /home/swapfile | cut -b 1,2,3`"\e[34m 调整到 $swapfilesize G\e[0m"
                swapoff /home/swapfile
                dd if=/dev/zero of=/home/swapfile bs=1024M count=$swapfilesize
                mkswap /home/swapfile
                swapon /home/swapfile
                echo -e "\e[34m调整完成!3秒后返回主菜单!\e[0m"
                sleep 3
                select_main
            else
                select_main
            fi
            ;;
        6)
            clear
            echo -e "\e[34m                   一键安装steamcommunity302        \e[0m"
            echo -e "\e[34m         = = = = = = = = = = = = = = = = = = = = = =\e[0m"
            echo -e "\e[34m         =         1.我是第一次安装                =\e[0m"
            echo -e "\e[34m         =         2.我想重新安装（更新证书)       =\e[0m"
            echo -e "\e[34m         = = = = = = = = = = = = = = = = = = = = = =\e[0m"
            echo -e "\e[34m         =    当前工具版本：         12.1.40       =\e[0m"
            echo -e "\e[34m         =    上次证书更新日期：     2024.06.26    =\e[0m"
            echo -e "\e[34m         =    预计下次证书更新日期： 2024.10.01    =\e[0m"
            echo -e "\e[34m         = = = = = = = = = = = = = = = = = = = = = =\e[0m"
            read -p $'\e[34m请选择:\e[0m' steamcommunity302_choice
            case $steamcommunity302_choice in
                1)
                    echo -e "\e[34m开始安装steamcommunity302...\e[0m"
                    # 获取当前脚本的绝对路径并存储在特殊变量名中
                    SCRIPT_ABSOLUTE_PATH__302=$(readlink -f "$0")
                    SCRIPT_DIRECTORY_plugin_patch=$(dirname "$SCRIPT_ABSOLUTE_PATH__302")
                    rm -rf /home/deck/.local/share/SteamDeck_302
                    wget -q https://vip.123pan.cn/1824872873/releases/steamcommunity302/302 -O /home/deck/Downloads/302.zip
                    unzip /home/deck/Downloads/302.zip -d /home/deck/.local/share/
                    rm -f /home/deck/Downloads/302.zip
                    chmod 777 /home/deck/.local/share/SteamDeck_302
                    cd /home/deck/.local/share/SteamDeck_302/
                    sh /home/deck/.local/share/SteamDeck_302/install.sh
                    cd "$SCRIPT_DIRECTORY_plugin_patch"
                    echo -e "\e[34m安装完毕！按任意键返回主菜单\e[0m"
                    read -n 1
                    select_main
                    ;;
                2)
                    SCRIPT_ABSOLUTE_PATH__302=$(readlink -f "$0")
                    SCRIPT_DIRECTORY_plugin_patch=$(dirname "$SCRIPT_ABSOLUTE_PATH__302")
                    echo -e "\e[34m开始重新安装steamcommunity302...\e[0m"
                    echo -e "\e[34m卸载旧版本...\e[0m"
                    sleep 1
                    cd /home/deck/.local/share/SteamDeck_302/
                    chmod +x cd /home/deck/.local/share/SteamDeck_302/uninstall.sh
                    sh /home/deck/.local/share/SteamDeck_302/uninstall.sh
                    cd "$SCRIPT_DIRECTORY_plugin_patch"
                    echo -e "\e[34m开始安装新版本...\e[0m"
                    sleep 1
                    rm -rf /home/deck/.local/share/SteamDeck_302
                    wget -q https://vip.123pan.cn/1824872873/releases/steamcommunity302/302 -O /home/deck/Downloads/302.zip
                    unzip /home/deck/Downloads/302.zip -d /home/deck/.local/share/
                    rm -f /home/deck/Downloads/302.zip
                    chmod 777 /home/deck/.local/share/SteamDeck_302
                    cd /home/deck/.local/share/SteamDeck_302/
                    sh /home/deck/.local/share/SteamDeck_302/install.sh
                    cd "$SCRIPT_DIRECTORY_plugin_patch"
                    echo -e "\e[34m安装完毕！按任意键返回主菜单\e[0m"
                    read -n 1
                    select_main
                    ;;
                *)
                    echo -e "\e[34m请选择正确的选项！\e[0m"
                    sleep 2
                    select_main
                    ;;
            esac
            ;;
        7)
            echo -e "\e[34m开始安装插件商店...\e[0m"
            rm -rf /home/deck/homebrew
            curl -L dl.ohmydeck.net|sh
            if [ -e /etc/systemd/system/plugin_loader.service ] ; then
                echo -e "\e[34m插件商店安装成功!\e[0m"
                sleep 3
                select_main
            else
                echo -e "\e[31m插件商店安装失败!请检查网络连接后重试\e[0m"
                echo -e "\e[34m按任意键返回主菜单\e[0m"
                read -n 1
                select_main
            fi
            ;;
        8)
            echo -e "\033[41;37m正在安装插件商店稳定版\e[0m"
            USER_DIR="$(getent passwd $SUDO_USER | cut -d: -f6)"
            HOMEBREW_FOLDER="${USER_DIR}/homebrew"
            rm -rf "${HOMEBREW_FOLDER}/services"
            sudo -u $SUDO_USER mkdir -p "${HOMEBREW_FOLDER}/services"
            sudo -u $SUDO_USER mkdir -p "${HOMEBREW_FOLDER}/plugins"
            touch "${USER_DIR}/.steam/steam/.cef-enable-remote-debugging"
            RELEASE=$(curl -s 'https://api.github.com/repos/SteamDeckHomebrew/decky-loader/releases' | jq -r "first(.[] | select(.prerelease == "false"))")
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
            curl -L https://down.npee.cn/\?https://raw.githubusercontent.com/SteamDeckHomebrew/decky-loader/main/dist/plugin_loader-release.service  --output ${HOMEBREW_FOLDER}/services/plugin_loader-release.service
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
            echo -e "\e[34m安装完成！按任意键返回主菜单\e[0m"
            read -n 1
            select_main
            ;;
        9)
            echo -e "\033[41;37m正在安装插件商店测试版\e[0m"
            USER_DIR="$(getent passwd $SUDO_USER | cut -d: -f6)"
            HOMEBREW_FOLDER="${USER_DIR}/homebrew"
            rm -rf "${HOMEBREW_FOLDER}/services"
            sudo -u $SUDO_USER mkdir -p "${HOMEBREW_FOLDER}/services"
            sudo -u $SUDO_USER mkdir -p "${HOMEBREW_FOLDER}/plugins"
            touch "${USER_DIR}/.steam/steam/.cef-enable-remote-debugging"
            RELEASE=$(curl -s 'https://api.github.com/repos/SteamDeckHomebrew/decky-loader/releases' | jq -r "first(.[] | select(.prerelease == "true"))")
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
            curl -L https://down.npee.cn/\?https://raw.githubusercontent.com/SteamDeckHomebrew/decky-loader/main/dist/plugin_loader-prerelease.service  --output ${HOMEBREW_FOLDER}/services/plugin_loader-prerelease.service
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
                echo -e "\e[34m安装完成！按任意键返回主菜单\e[0m"
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
            echo -e "\e[34m安装完成！按任意键返回主菜单\e[0m"
            read -n 1
            select_main
            ;;
        10)
            echo -e "\e[34m开始安装tomoon插件...\e[0m"
            if test -e /home/deck/homebrew/plugins/tomoon; then
               echo -e "\e[34m检测到旧版本，开始删除...\e[0m"
               rm -rf /home/deck/homebrew/plugins/tomoon
            fi
            if test -e /tmp/tomoon.zip; then
               rm /tmp/tomoon.zip
            fi
            echo -e "\e[34m删除成功！开始安装新版本\e[0m"
            curl -L -o /home/deck/Downloads/tomoon.zip https://vip.123pan.cn/1824872873/releases/tomoon/tomoon-v0.2.5.zip
            if test ! -e /home/deck/homebrew/plugins; then
               mkdir -p /home/deck/homebrew/plugins
            fi
            systemctl --user stop plugin_loader 2> /dev/null
            systemctl stop plugin_loader 2> /dev/null
            unzip -o -qq /home/deck/Downloads/tomoon.zip -d /home/deck/Downloads/
            sleep 1
            chmod -R 777 /home/deck/Downloads/tomoon
            mv -f /home/deck/Downloads/tomoon /home/deck/homebrew/plugins/tomoon
            rm -f /home/deck/Downloads/tomoon.zip
            systemctl start plugin_loader
            sleep 1
            if [ -d /home/deck/homebrew/plugins/tomoon ] ; then
               echo -e "\e[34mtomoon插件安装成功!按任意键返回主菜单...\e[0m"
               read -n 1
               select_main
            else
               echo -e "\e[31mtomoon插件安装失败!请检查网络连接后重试\e[0m"
               echo -e "\e[34m按任意键返回主菜单\e[0m"
               read -n 1
               select_main
            fi
            ;;
        11)
            read -p $'\e[34m是否已经安装插件商店？y/n:\e[0m' plugin_install_choice
            case $plugin_install_choice in
                y)
                    echo -e "\e[34m正在开始汉化插件...\e[0m"
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
                    echo -e "\e[34m汉化完毕！按任意键返回主菜单\e[0m"
                    read -n 1
                    select_main
                    ;;
                n)
                    echo -e "\033[41;37m请先安装插件商店后再选择汉化！\033[0m"
                    echo -e "\e[34m按任意键返回主菜单\e[0m"
                    read -n 1
                    select_main
                    ;;
                *)
                    echo -e "\e[31m请选择正确的选项！\e[0m"
                    sleep 1
                    select_main
                    ;;
            esac
            ;;
        12)
            echo -e "\e[34m开始安装todesk\e[0m"
            PASSWD=$(zenity --password --title="请输入终端密码:" --text="passwd")
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
            echo -e "\e[34m安装完毕！按任意键返回主菜单\e[0m"
            read -n 1
            select_main
            ;;
        13)
            flathub_name=Anydesk
            flatpak_name=com.anydesk.Anydesk
            flatpak_install
            ;;
        14)
            echo -e "\e[96m开始安装rustdesk...\e[0m"
            mkdir -p /home/deck/.local/share/rustdesk
            wget https://vip.123pan.cn/1824872873/releases/rustdesk/r.png -O /home/deck/.local/share/rustdesk/r.png
            wget -O /home/deck/.local/share/rustdesk/rustdesk-1.2.7-x86_64.AppImage https://vip.123pan.cn/1824872873/releases/rustdesk/rustdesk-1.2.7-x86_64.AppImage
            wget https://vip.123pan.cn/1824872873/releases/rustdesk/%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E.txt -O /home/deck/.local/share/rustdesk/使用说明.txt
            echo "[Desktop Entry]
GenericName=远程软件
Categories=Network;Internet;Application;
Exec=/home/deck/.local/share/rustdesk/rustdesk-1.2.7-x86_64.AppImage
Icon=/home/deck/.local/share/rustdesk/r.png
Name=rustdesk
StartupNotify=true
Terminal=false
Type=Application
Version=1.2.7" > /home/deck/.local/share/applications/rustdesk.desktop
            chmod -R 777 /home/deck/.local/share/applications/rustdesk.desktop
            cp /home/deck/.local/share/applications/rustdesk.desktop /home/deck/Desktop/
            sudo -u deck kate /home/deck/.local/share/rustdesk/使用说明.txt
            echo -e "\e[34m安装完毕！按任意键返回主菜单\e[0m"
            read -n 1
            select_main
            ;;
        15)
            flathub_name=LinuxQQ
            flatpak_name=com.qq.QQ
            flatpak_install
            ;;
        16)
            flathub_name=Linux原生版微信
            flatpak_name=com.tencent.WeChat
            flatpak_install
            ;;
        17)
            flathub_name=Microsoft\ Edge
            flatpak_name=com.microsoft.Edge
            flatpak_install
            ;;
        18)
            flathub_name=谷歌浏览器
            flatpak_name=com.google.Chrome
            flatpak_install
            ;;
        19)
            flathub_name=百度网盘
            flatpak_name=com.baidu.NetDisk
            flatpak_install
            ;;
        20)
            flathub_name=QQ音乐
            flatpak_name=com.qq.QQmusic
            flatpak_install
            ;;
        21)
            flathub_name=网易云音乐
            flatpak_name=com.netease.CloudMusic
            flatpak_install
            ;;
        22)
            flathub_name=wiliwili
            flatpak_name=cn.xfangfang.wiliwili
            flatpak_install
            ;;
        23)
            flathub_name=OBS\ Studio
            flatpak_name=com.obsproject.Studio
            flatpak_install
            ;;
        24)
            flathub_name=ProtonUp-Qt\(兼容层软件\)
            flatpak_name=net.davidotek.pupgui2
            flatpak_install
            ;;
        25)
            flathub_name=WPS-Office
            flatpak_name=com.wps.Office
            read -p $'\e[34m是否已经初始化国内软件源？y/n:\e[0m' source_run
            case $source_run in
                y)
                    echo -e "\e[34m正在开始安装$flathub_name...\e[0m"
                    flatpak install -y flathub $flatpak_name
                    echo -e "\e[34m安装完毕，开始汉化！\e[0m"
                    wget -P /home/deck/Downloads/ https://vip.123pan.cn/1824872873/releases/WPS2019/mui.tar.gz
                    tar -xzf /home/deck/Downloads/mui.tar.gz -C /home/deck/Downloads/
                    rm -rf /var/lib/flatpak/app/com.wps.Office/x86_64/stable/active/files/extra/wps-office/office6/mui
                    mv /home/deck/Downloads/mui /var/lib/flatpak/app/com.wps.Office/x86_64/stable/active/files/extra/wps-office/office6/mui
                    chmod -R 777 /var/lib/flatpak/app/com.wps.Office/x86_64/stable/active/files/extra/wps-office/office6/mui
                    rm -f /home/deck/Downloads/mui.tar.gz
                    echo -e "\e[34m汉化完成！\e[0m"
                    # 查找 .desktop 文件路径
                    desktop_file_path="/var/lib/flatpak/exports/share/applications/$flatpak_name.desktop"
                    # 如果找到 .desktop 文件，复制到桌面并设置权限
                    if [ -n "$desktop_file_path" ]; then
                        cp "$desktop_file_path" /home/deck/Desktop
                        chmod +x /home/deck/Desktop/$(basename "$desktop_file_path")
                        echo -e "\e[34m桌面快捷方式创建成功！\e[0m"
                    else
                        echo -e "\e[31m未找到 .desktop 文件，无法创建桌面快捷方式。\033[0m"
                    fi
                    echo -e "\e[34m按任意键返回主菜单\e[0m"
                    read -n 1
                    select_main
                    ;;
                n)
                    echo -e "\033[41;37m请先选择初始化国内软件源后再选择安装$flathub_name！\033[0m"
                    echo -e "\e[34m按任意键返回主菜单\e[0m"
                    read -n 1
                    select_main
                    ;;
                *)
                    echo -e "\e[31m请选择正确的选项！\033[0m"
                    sleep 2
                    select_main
                    ;;
            esac
            ;;
        26)
            read -p $'\e[34m是否已经初始化国内软件源？y/n:\e[0m' source_run
            case $source_run in
                y)
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
                    echo -e "\e[34m安装完毕！按任意键返回主菜单\e[0m"
                    read -n 1
                    select_main
                    ;;
                n)
                    echo -e "\033[41;37m请先选择初始化国内软件源后再选择安装Minecraft！\033[0m"
                    echo -e "\e[34m按任意键返回主菜单\e[0m"
                    read -n 1
                    select_main
                    ;;
                *)
                    echo -e "\e[31m请选择正确的选项！\e[0m"
                    sleep 2
                    select_main
                    ;;
            esac
            ;;
        27)
            echo -e "\e[34m正在开始安装yuzu模拟器...\e[0m"
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
            echo -e "\e[34m安装完毕！已自动配置好密钥(keys)和固件(firmware)18.0.0，打开即玩，不需要再手动安装\e[0m"
            echo -e "\e[34m按任意键返回主菜单\e[0m"
            read -n 1
            select_main
            ;;
        28)
            echo -e "\e[34m开始安装模拟器体感陀螺仪插件，版本 V2.2.1 ...\e[0m"
            sleep 1
            wget -O /home/deck/Downloads/SteamDeckGyroDSUSetup.zip https://vip.123pan.cn/1824872873/releases/GyroDSU/SDG
            unzip -o /home/deck/Downloads/SteamDeckGyroDSUSetup.zip -d /home/deck/Downloads/
            chmod -R 777 /home/deck/Downloads/SteamDeckGyroDSUSetup
            script -q -c "su - deck -c /home/deck/Downloads/SteamDeckGyroDSUSetup/install.sh" /dev/null
            mv /home/deck/Downloads/SteamDeckGyroDSUSetup/uninstall.sh /home/deck/.config/uninstall.sh
            rm -rf /home/deck/Downloads/SteamDeckGyroDSUSetup
            rm -f /home/deck/Downloads/SteamDeckGyroDSUSetup.zip
            echo -e "\e[31m启用服务失败.请打开一个新的终端，手动输入systemctl --user -q enable --now sdgyrodsu.service\e[0m"
            echo -e "\e[34m安装完毕！手动启用服务即可\e[0m"
            exit 1
            ;;
        29)
            echo -e "\e[34m开始安装宝葫芦...\e[0m"
            sleep 1
            curl -s -L https://i.hulu.deckz.fun | sudo sh -
            echo -e "[Desktop Entry]
GenericName=一个多功能的工具
Categories=Game;
Name=宝葫芦
Version=0.0.1
Exec=/home/deck/.fun.deckz/hulu/app/pad/bin/pad
Path=/home/deck/.fun.deckz/hulu
Icon=/home/deck/.fun.deckz/hulu/app/icon.png
Type=Application
Encoding=UTF-8
Terminal=false
Keywords=hulu;宝葫芦;葫芦" > /home/deck/.local/share/applications/hulu.desktop
            chmod 777 /home/deck/.local/share/applications/hulu.desktop
            echo -e "\e[34m安装完毕！按任意键返回主菜单\e[0m"
            read -n 1
            select_main
            ;;
        30)
            read -p $'\e[34m是否已开启魔法？（下载源在国外，必须翻墙，UU加速器没用）y/n:\e[0m' proxy_choice
            case $proxy_choice in
                y)
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

                    echo -e "\e[34m安装完毕！按任意键返回主菜单\e[0m"
                    read -n 1
                    select_main
                    ;;
                n)
                    echo -e "\033[41;37m请开启魔法后再选择安装Waydroid！\033[0m"
                    echo -e "\e[34m按任意键返回主菜单\e[0m"
                    read -n 1
                    select_main
                    ;;
                *)
                    echo -e "\e[31m请选择正确的选项！\033[0m"
                    sleep 2
                    select_main
                    ;;
            esac
            ;;
        31)
            echo -e "\e[34m开始安装steam++...\e[0m"
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
            echo -e "\e[34m安装完毕！按任意键返回主菜单\e[0m"
            read -n 1
            select_main
            ;;
        32)
            echo -e "\e[34m开始安装最新社区兼容层...\e[0m"
            VERSION_URL="https://vip.123pan.cn/1824872873/releases/proton-ge-custom/version_proton.txt"
            VERSION_INFO=$(curl -s "$VERSION_URL")
            eval "$VERSION_INFO"
            echo -e "\e[34m正在下载安装包...\e[0m"
            wget https://down.npee.cn/\?https://github.com/GloriousEggroll/proton-ge-custom/releases/download/$Proton/$Proton.tar.gz -O /home/deck/Downloads/$Proton.tar.gz
            echo -e "\e[34m下载完成，正在解压...\e[0m"
            tar -xzf /home/deck/Downloads/$Proton.tar.gz -C /home/deck/Downloads/
            echo -e "\e[34m解压完成，正在应用设置...\e[0m"
            mkdir -p /home/deck/.local/share/Steam/compatibilitytools.d
            mv /home/deck/Downloads/$Proton /home/deck/.local/share/Steam/compatibilitytools.d/$Proton
            chmod -R 777 /home/deck/.local/share/Steam/compatibilitytools.d/$Proton
            rm -f /home/deck/Downloads/$Proton.tar.gz
            if [ -d "/home/deck/.local/share/Steam/compatibilitytools.d/$Proton" ]; then
                echo -e "\e[34m安装完毕！重启steam生效\e[0m"
                echo -e "\e[34m按任意键返回主菜单\e[0m"
                read -n 1
                select_main
            else
                echo -e "\e[31m安装失败！出现了一些问题，请稍候再试\e[0m"
                echo -e "\e[34m按任意键返回主菜单\e[0m"
                read -n 1
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
        c)
            echo -e "\e[34m正在开始安装clash...\e[0m"
            echo -e "\e[34m正在下载安装包...\e[0m"
            wget -O /home/deck/Downloads/Clash.for.Windows-0.20.39-x64-linux.tar.gz https://down.clashcn.com/soft/clashcn.com_Clash.for.Windows-0.20.39-x64-linux.tar.gz
            wget -O /home/deck/Downloads/clashcn.com_cfw-cn-app_0.20.39.zip https://down.clashcn.com/soft/clashcn.com_cfw-cn-app_0.20.39.zip
            tar -xzf /home/deck/Downloads/Clash.for.Windows-0.20.39-x64-linux.tar.gz -C /home/deck/.local/share/
            mv /home/deck/.local/share/Clash\ for\ Windows-0.20.39-x64-linux /home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux
            wget https://vip.123pan.cn/1824872873/releases/clash/c.png -O /home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux/c.png
            sleep 1
            unzip /home/deck/Downloads/clashcn.com_cfw-cn-app_0.20.39.zip -d /home/deck/Downloads/
            echo -e "\e[34m下载完毕！正在开始安装...\e[0m"
            mv -f /home/deck/Downloads/app.asar /home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux/resources
            cat << EOF > /home/deck/.local/share/applications/clash.desktop
[Desktop Entry]
GenericName=网络代理工具
Categories=Network;Internet;Application;
Exec=/home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux/clash.sh
Icon=/home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux/c.png
Name=clash
StartupNotify=true
Terminal=false
Type=Application
Version=0.20.39
EOF
            chmod 777 /home/deck/.local/share/applications/clash.desktop
            cp /home/deck/.local/share/applications/clash.desktop /home/deck/Desktop/
            cat <<EOL > /home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux/clash.sh
#!/bin/bash
export http_proxy=http://127.0.0.1:7890
export https_proxy=https://127.0.0.1:7890
'/home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux/cfw'
EOL
            rm -f /home/deck/Downloads/Clash.for.Windows-0.20.39-x64-linux.tar.gz /home/deck/Downloads/clashcn.com_cfw-cn-app_0.20.39.zip
            wget -O "/home/deck/Downloads/使用方法(必看）.zip" "https://vip.123pan.cn/1824872873/releases/clash/syff.zip"
            unzip "/home/deck/Downloads/使用方法(必看）.zip" -d "/home/deck/Downloads/"
            mv /home/deck/Downloads/使用方法（必看） /home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux/使用方法必看
            rm -f /home/deck/Downloads/使用方法\(必看）.zip
            chmod -R 777 /home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux
            sudo -u deck dolphin "/home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux/使用方法必看"
            echo -e "\e[34m安装完毕！按任意键返回主菜单\e[0m"
            read -n 1
            select_main
            ;;
        cl)
            echo -e "\e[35mChange Log：

2.0.0：新增安装各种软件，删除paur安装

2.0.1：更新无法正常安装应用的bug，解决系统更新无法连接数据库的bug，删除自动重启程序

2.1.0：更新了彩色字体

2.1.1：修复了tomoon插件安装失败的bug

2.2.0：增加了安装国外官方源的稳定版和测试版插件商店，增加了插件汉化

2.2.1：增加Todesk旧版卸载，新版安装

2.2.2：新增HMCL启动器和Minecraft

2.2.3：新增yuzu模拟器（自动配置密钥和固件，打开即玩）

2.2.4：新增自动更新程序，发现新版本自动更新。

2.3.1：新增steamcommunity302一键安装

2.3.3：修复已知BUG，新增自动更新程序超时机制，模拟器陀螺仪安装

2.3.4：修复Steamcommunity302加速，修复移动脚本位置可能导致某些软件不能正常安装，添加超时验证

2.3.6：紧急修复初始化时语言编码BUG

2.4.0：新增rustdesk安装，新增安装文件的卸载程序，新增每个安装的软件/游戏都会自动创建桌面快捷方式(卸载时快捷方式也会自动删除)。脚本托管地址改为123云盘，必定更新成功。完全修复桌面一半中文一半英文

2.4.2：修改所有下载源为123云盘，下载速度1000倍

2.4.3：新增wiliwili，迅游加速器、奇游加速器插件，宝葫芦，Waydroid安装

2.4.4：修复Waydroid安装

2.4.5~2.4.9：新增steam++一键安装,优化部分安装程序

2.5.0：新增最新社区兼容层一键安装

2.5.1：更新Minecraft的HMCL启动器版本3.5.9

2.5.2：修复todesk无法连接网络，安装插件商店无需魔法（测试功能）

2.5.3：添加WPS office汉化，更新waydroid到最新版本。优化部分卸载程序，使卸载更彻底
 \e[0m"
            echo -e "\e[34m按任意键返回主菜单\e[0m"
            read -n 1
            select_main
            ;;
        *)
            echo -e "\e[31m无效的选择，请重新输入\e[0m"
            sleep 1
            select_main
            ;;
    esac
}

#flatpak函数
function flatpak_install()
{
    read -p $'\e[34m是否已经初始化国内软件源？y/n:\e[0m' source_run
    case $source_run in
        y)
            echo -e "\e[34m正在开始安装$flathub_name...\e[0m"
            flatpak install -y flathub $flatpak_name
            echo -e "\e[34m安装完毕！\e[0m"
            # 查找 .desktop 文件路径
            desktop_file_path="/var/lib/flatpak/exports/share/applications/$flatpak_name.desktop"
            # 如果找到 .desktop 文件，复制到桌面并设置权限
            if [ -n "$desktop_file_path" ]; then
                cp "$desktop_file_path" /home/deck/Desktop
                chmod +x /home/deck/Desktop/$(basename "$desktop_file_path")
                echo -e "\e[34m桌面快捷方式创建成功！\e[0m"
            else
                echo -e "\e[31m未找到 .desktop 文件，无法创建桌面快捷方式。\033[0m"
            fi
            echo -e "\e[34m按任意键返回主菜单\e[0m"
            read -n 1
            select_main
            ;;
        n)
            echo -e "\033[41;37m请先选择初始化国内软件源后再选择安装$flathub_name！\033[0m"
            echo -e "\e[34m按任意键返回主菜单\e[0m"
            read -n 1
            select_main
            ;;
        *)
            echo -e "\e[31m请选择正确的选项！\033[0m"
            sleep 2
            select_main
            ;;
    esac
}

function flatpak_uninstall()
{
    echo -e "\e[34m正在开始卸载$flathub_name...\e[0m"
    flatpak uninstall --assumeyes $flatpak_name
    rm -f /home/deck/Desktop/$flatpak_name.desktop
    rm -rf /home/deck/.var/app/$flatpak_name
    echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
    read -n 1
    uninstall
}

#卸载程序
function uninstall()
{
        clear
    echo -e "\e[34m                               卸载程序\e[0m"
    echo -e "\e[34m        = = = = = = = = = = = = = = = = = = = = = = = = = = =\e[0m"
    echo -e "\e[34m        =   1.卸载UU加速插件      =   15.卸载ProtonUp-Qt    =\e[0m"
    echo -e "\e[34m        =   2.卸载steam302        =   16.卸载WPS-Office     =\e[0m"
    echo -e "\e[34m        =   3.卸载插件商店        =   17.卸载Minecraft      =\e[0m"
    echo -e "\e[34m        =   4.卸载todesk          =   18.卸载yuzu           =\e[0m"
    echo -e "\e[34m        =   5.卸载Anydesk         =   19.卸载模拟器陀螺仪   =\e[0m"
    echo -e "\e[34m        =   6.卸载rustdesk        =   20.卸载clash          =\e[0m"
    echo -e "\e[34m        =   7.卸载QQ              =   21.卸载讯游加速插件   =\e[0m"
    echo -e "\e[34m        =   8.卸载微信            =   22.卸载奇游加速插件   =\e[0m"
    echo -e "\e[34m        =   9.卸载Edge浏览器      =   23.卸载wiliwili       =\e[0m"
    echo -e "\e[34m        =   10.卸载谷歌浏览器     =   24.卸载Waydroid       =\e[0m"
    echo -e "\e[34m        =   11.卸载百度网盘       =   25.卸载宝葫芦         =\e[0m"
    echo -e "\e[34m        =   12.卸载QQ音乐         =   26.卸载steam++        =\e[0m"
    echo -e "\e[34m        =   13.卸载网易云音乐     =                         =\e[0m"
    echo -e "\e[34m        =   14.卸载OBS Studio     =   s.回到安装菜单        =\e[0m"
    echo -e "\e[34m        = = = = = = = = = = = = = = = = = = = = = = = = = = =\e[0m"
    read -p $'\e[34m请选择:\e[0m' uninstall_choice
    case $uninstall_choice in
        1)
            echo -e "\e[34m开始卸载UU加速插件...\e[0m"
            wget -O /home/deck/Downloads/UU_uninstall.sh https://gitee.com/soforeve/plugin_patch/raw/master/uninstall/UU_uninstall.sh
            chmod +x /home/deck/Downloads/UU_uninstall.sh
            sh /home/deck/Downloads/UU_uninstall.sh steam-deck-plugin
            rm -f /home/deck/Downloads/UU_uninstall.sh
            echo -e "\e[34m卸载成功!\e[0m"
            echo -e "\e[34m按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        2)
            echo -e "\e[34m开始卸载steamcommunity302...\e[0m"
            # 获取当前脚本的绝对路径并存储在特殊变量名中
            SCRIPT_ABSOLUTE_PATH__302=$(readlink -f "$0")
            SCRIPT_DIRECTORY_plugin_patch=$(dirname "$SCRIPT_ABSOLUTE_PATH__302")
            cd /home/deck/.local/share/SteamDeck_302/
            chmod +x /home/deck/.local/share/SteamDeck_302/uninstall.sh
            sh /home/deck/.local/share/SteamDeck_302/uninstall.sh
            cd "$SCRIPT_DIRECTORY_plugin_patch"
            rm -rf /home/deck/.local/share/SteamDeck_302
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        3)
            echo -e "\e[34m开始卸载插件商店...\e[0m"
            curl -L https://down.npee.cn/\?https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/uninstall.sh | sh
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        4)
            echo -e "\e[34m开始卸载todesk...\e[0m"
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
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        5)
            flathub_name=Anydesk
            flatpak_name=com.anydesk.Anydesk
            echo -e "\e[34m开始卸载$flathub_name...\e[0m"
            flatpak_uninstall
            ;;
        6)
            echo -e "\e[34m开始卸载rustdesk...\e[0m"
            rm -rf /home/deck/.local/share/rustdesk
            rm -f /home/deck/Desktop/rustdesk.desktop
            rm -f /home/deck/.local/share/applications/rustdesk.desktop
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        7)
            flathub_name=QQ
            flatpak_name=com.qq.QQ
            echo -e "\e[34m开始卸载$flathub_name...\e[0m"
            flatpak_uninstall
            ;;
        8)
            flathub_name=Linux原生版微信
            flatpak_name=com.tencent.WeChat
            echo -e "\e[34m开始卸载$flathub_name...\e[0m"
            flatpak_uninstall
            ;;
        9)
            flathub_name=Microsoft\ Edge
            flatpak_name=com.microsoft.Edge
            echo -e "\e[34m开始卸载$flathub_name...\e[0m"
            flatpak_uninstall
            ;;
        10)
            flathub_name=谷歌浏览器
            flatpak_name=com.google.Chrome
            echo -e "\e[34m开始卸载$flathub_name...\e[0m"
            flatpak_uninstall
            ;;
        11)
            flathub_name=百度网盘
            flatpak_name=com.baidu.NetDisk
            echo -e "\e[34m开始卸载$flathub_name...\e[0m"
            flatpak_uninstall
            ;;
        12)
            flathub_name=QQ音乐
            flatpak_name=com.qq.QQmusic
            echo -e "\e[34m开始卸载$flathub_name...\e[0m"
            flatpak_uninstall
            ;;
        13)
            flathub_name=网易云音乐
            flatpak_name=com.netease.CloudMusic
            echo -e "\e[34m开始卸载$flathub_name...\e[0m"
            flatpak_uninstall
            ;;
        14)
            flathub_name=OBS\ Studio
            flatpak_name=com.obsproject.Studio
            echo -e "\e[34m开始卸载$flathub_name...\e[0m"
            flatpak_uninstall
            ;;
        15)
            flathub_name=ProtonUp-Qt\(兼容层软件\)
            flatpak_name=net.davidotek.pupgui2
            echo -e "\e[34m开始卸载$flathub_name...\e[0m"
            flatpak_uninstall
            ;;
        16)
            flathub_name=WPS-Office
            flatpak_name=com.wps.Office
            echo -e "\e[34m开始卸载$flathub_name...\e[0m"
            flatpak_uninstall
            ;;
        17)
            echo -e "\e[34m开始卸载Minecraft...\e[0m"
            rm -rf /home/deck/Minecraft
            rm -f /home/deck/Desktop/Minecraft.desktop
            rm -f /home/deck/.local/share/applications/Minecraft.desktop
            rm -rf /home/deck/.minecraft
            rm -rf /home/deck/.local/share/hmcl
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        18)
            echo -e "\e[34m开始卸载yuzu...\e[0m"
            rm -rf /home/deck/yuzu
            rm -rf /home/deck/.local/share/yuzu
            rm -f /home/deck/Desktop/yuzu.desktop
            rm -f /home/deck/.local/share/applications/yuzu.desktop
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        19)
            echo -e "\e[34m开始卸载模拟器陀螺仪...\e[0m"
            chmod +x /home/deck/.config/uninstall.sh
            script -q -c "su - deck -c /home/deck/.config/uninstall.sh" /dev/null
            rm -f /home/deck/.config/uninstall.sh
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        20)
            echo -e "\e[34m开始卸载clash...\e[0m"
            rm -rf /home/deck/.local/share/Clash.for.Windows-0.20.39-x64-linux
            rm -f /home/deck/Desktop/clash.desktop
            rm -f /home/deck/.local/share/applications/clash.desktop
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        21)
            echo -e "\e[34m开始卸载讯游加速插件...\e[0m"
            sh home/deck/xunyou/xunyou_uninstall.sh
            rm -rf /tmp/xunyou
            rm -rf /home/deck/xunyou
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        22)
            echo -e "\e[34m开始卸载奇游加速插件...\e[0m"
            mkdir -p /home/deck/qy
            wget -O /home/deck/qy/qy_uninstall.sh https://gitee.com/soforeve/plugin_patch/raw/master/uninstall/qy_uninstall.sh
            chmod +x /home/deck/qy/qy_uninstall.sh
            sh /home/deck/qy/qy_uninstall.sh
            rm -rf /home/deck/qy
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        23)
            flathub_name=wiliwili
            flatpak_name=cn.xfangfang.wiliwili
            echo -e "\e[34m开始卸载$flathub_name...\e[0m"
            flatpak_uninstall
            ;;
        24)
            echo -e "\e[34m开始卸载Waydroid...\e[0m"
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
            steamos-readonly disable
            sleep 1
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        25)
            echo -e "\e[34m开始卸载宝葫芦...\e[0m"
            curl -L https://i.hulu.deckz.fun/u.sh | sudo sh -
            rm -f /home/deck/.local/share/applications/hulu.desktop
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        26)
            echo -e "\e[34m开始卸载steam++...\e[0m"
            rm -f /home/deck/.local/share/applications/Watt\ Toolkit.desktop
            rm -rf /home/deck/.local/share/.local
            rm -rf /home/deck/.local/share/.cache
            rm -f /home/deck/Desktop/Watt\ Toolkit.desktop
            chmod 777 /home/deck/WattToolkit/script/uninstall.sh
            sh /home/deck/WattToolkit/script/uninstall.sh
            echo -e "\e[34m卸载完毕！按任意键返回主菜单\e[0m"
            read -n 1
            uninstall
            ;;
        s)
            select_main
            ;;
        *)
            echo -e "\e[31m无效的选择，请重新输入\e[0m"
            sleep 1
            uninstall
            ;;
    esac
}

#当前版本
version=253

#仓库地址
REMOTE_VERSION_URL="https://gitee.com/soforeve/plugin_patch/raw/master/version/version.txt"
REMOTE_SCRIPT_URL="https://vip.123pan.cn/1824872873/releases/plugin_patch.sh"
LOCAL_SCRIPT_PATH="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/$(basename "${BASH_SOURCE[0]}")"
REMOTE_VERSION_INFO=$(curl -s "$REMOTE_VERSION_URL")
LOCAL_SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
eval "$REMOTE_VERSION_INFO"

#自动更新程序
if [ "$version_new" -gt "$version" ]; then
    echo -e "\e[34m发现新版本: $version_new，正在更新...\e[0m"
    if wget -q --timeout=20 -O "$LOCAL_SCRIPT_PATH" "$REMOTE_SCRIPT_URL"; then
        version=$version_new
        echo -e "\e[34m更新完成！当前版本: $version...请重启脚本\e[0m"
        chmod 777 "$LOCAL_SCRIPT_PATH"
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
    echo -e "\e[34m已经是最新版本: $version\e[0m"
fi

steamos-readonly disable

select_main
