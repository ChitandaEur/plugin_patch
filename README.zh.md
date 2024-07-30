[English](README.md)
#  **_plugin_patch_**

有想加的功能或有bug请进QQ群：945280107反馈

#### 命令行版本介绍

整合了steamdeck安装各种软件的脚本，使用简单方便，无图形界面

![界面示例](image/plugin_patch/plugin_patch.sh.png)


#### 使用教程

1.  下载脚本到deck

```
cd /home/deck/Downloads
```
![1.1](image/plugin_patch/1.1.png)


```
curl -O https://vip.123pan.cn/1824872873/releases/plugin_patch.sh
```

![1](image/plugin_patch/1.png)

2.  给予脚本可执行权限

```
chmod +x plugin_patch.sh
```
![2](image/plugin_patch/2.png)

3.  进入管理员用户（输入密码）

```
sudo su
```
![3](image/plugin_patch/3.png)

4.  运行脚本

```
sh plugin_patch.sh
```
![4](image/plugin_patch/4.png)

#  **_plugin_patch_zenity_**

#### 图形版本介绍

整合了steamdeck安装各种软件的脚本，使用简单方便，有图形界面
![界面示例](image/plugin_patch_zenity/plugin_patch_zenity.sh.png)


#### 使用教程

1.  下载脚本到deck

```
cd /home/deck/Downloads
```
![1.1](image/plugin_patch_zenity/1.1.png)


```
curl -O https://vip.123pan.cn/1824872873/releases/plugin_patch_zenity.sh
```

![1](image/plugin_patch_zenity/1.png)

2.  给予脚本可执行权限

```
chmod +x plugin_patch_zenity.sh
```
![2](image/plugin_patch_zenity/2.png)

3.  进入管理员用户（输入密码）

```
sudo su
```
![3](image/plugin_patch_zenity/3.png)

4.  运行脚本

```
sh plugin_patch_zenity.sh
```
![4](image/plugin_patch_zenity/4.png)

#  **_功能介绍_**
1.  初始化国内软件源，更新系统
    打开脚本必须要选的选项，否则大部分功能无法使用
    时长大约5分钟
    强烈建议执行完之后立即重启系统

2.  安装UU加速插件
    加速steam商店免费，其他游戏要收费
     **_只加速steam，不加速其他软件的安装_** 
     **_只加速steam，不加速其他软件的安装_** 
     **_只加速steam，不加速其他软件的安装_** 

3.  安装讯游加速插件
    同上

4.  安装奇游加速插件
    同上

5.  调整虚拟内存大小
    对个别游戏有改善卡顿，闪退问题有作用，推荐大小30，不要超过50

6.  steamcommunity302
    加速steam的软件，安装成功以后开机自启，不用手动打开

7.  安装插件商店
    国内源插件商店，有时也会因网络问题安装失败。（不是你的网络问题，过两天再试一试）
     **_安装前在游戏模式开启开发者模式和cef远程调试_** 
     **_稳定版装稳定版插件商店，测试版装测试版插件商店_** 
    什么？你问怎么看自己是稳定版还是测试版？桌面模式在steam设置——界面里看，stable稳定版，beta测试版。游戏模式内在设置——系统

8.  官方源插件商店
    官方源稳定插件商店，在国外，必须开启魔法，UU，讯游，奇游，steamcommunity302都没用

9.  测试版插件商店
    测试版系统专用（steam家庭组测试版，beta测试版），在国外，必须开启魔法，UU，讯游，奇游，steamcommunity302都没用

10.  安装tomoon
     **_先安装插件商店再装tomoon，不要直接装tomoon_** 
    有时也会因网络问题安装失败。（不是你的网络问题，过两天再试一试）

11.  插件商店汉化
     **_先安装插件商店和tomoon再汉化，不要直接汉化_** 
    有8个常用插件的汉化，分别是
    由大佬steamdeck超人提供

12.  安装todesk
    远程软件，这是一个改版，安装时注意提示，如果有下载官网版本根据提示先卸载

13.  安装Anydesk
    远程软件，必须先执行初始化国内软件源才能安装

14.  安装rustdesk
    远程软件，todesk的替代品

15.  安装QQ
    linux原生版，必须先执行初始化国内软件源

16.  安装微信
    linux原生版，必须先执行初始化国内软件源

17.  安装Edge浏览器
    linux原生版，必须先执行初始化国内软件源

18.  安装Google浏览器
    linux原生版，必须先执行初始化国内软件源

19.  安装百度网盘
    linux原生版，必须先执行初始化国内软件源

20.  安装QQ音乐
    linux原生版，必须先执行初始化国内软件源

21.  安装网易云音乐
    linux原生版，必须先执行初始化国内软件源
    目前好像有点问题，用不了

22.  安装wiliwili
    linux原生版，必须先执行初始化国内软件源
    bilibili客户端

23.  安装WPS-Office
    linux原生版，必须先执行初始化国内软件源

24.  安装ProtonUp-Qt
    兼容层安装软件，必须先执行初始化国内软件源

25.  安装OBS Stdio
    直播和录屏软件，必须先执行初始化国内软件源

26.  安装Minecraft
    HMCL启动器，必须先执行初始化国内软件源
    进入之后中文要手动切换一下

27.  安装yuzu模拟器
    最后发行版

28.  模拟器陀螺仪
    适用于yuzu和cemu模拟器，比如可以用deck自带的陀螺仪过塞尔达神庙
    安装完需要在新的终端运行systemctl --user -q enable --now sdgyrodsu.service启动服务

29.  安装宝葫芦
    一个多功能的工具，有加速steam、着色器缓存清理、商店换源、社区兼容层下载、同局域网文件互传、内存性能优化、各种问题解决教程等，是一款功能十分强大的工具。

30.  安装Waydroid安卓模拟器
    能在deck上下载手机应用
     **_对网络有要求，必须开启魔法_** 

31.  安装steam++
    有点难用，不推荐，不如steamcommunity302(bushi)

32.  卸载已安装
    ![输入图片说明](image/uninstall.png)
