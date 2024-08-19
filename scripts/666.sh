


ldd /usr/bin/myapp | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' ~/AppDir/usr/bin/



#!/bin/bash
# 设置应用程序目录
APPDIR="$(dirname "$(readlink -f "$0")")"
# 设置环境变量
export LD_LIBRARY_PATH=$APPDIR/usr/lib:$LD_LIBRARY_PATH
# 启动应用程序
exec $APPDIR/usr/bin/obs "$@"



sudo chmod -R 777 /path/to/AppDir



/home/deck/AppImage/appimagetool-x86_64.AppImage /path/to/AppDir



/path/to/name.Appimage  --appimage-extract
