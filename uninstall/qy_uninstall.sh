#!/bin/sh

ACTION="stop"
ROUTE_MODE=""
ROUTE_VERSION=""
ROUTE_FILE="/tmp/qyplug.tar.gz"
ROUTE_URL=""
SAVE_DIR=""
INIT_DIR="/tmp/qy"
INIT_FILE="init.sh"
PKG_URL=https://static.qiyou.cn/upgrade/ljb/plugin/QYPLUG
RET_FILE="/tmp/qyplug.ret"
PID_FILE="/tmp/qyplug.pid"

get_mode()
{
	#sd
	sd=`cat /etc/steamos-atomupd/manifest.json 2> /dev/null | grep steamdeck`
	if [ "${sd}" != "" ] && [ -e /etc/steamos-release ] && [ -d /usr/lib/steamos ]; then
		ROUTE_VERSION="1.0.3"
		ROUTE_MODE="SD_V1"
		return
	fi

	#glinet
	pa1=`cat /proc/gl-hw-info/device_mac 2> /dev/null`
	pa2=`cat /proc/gl-hw-info/device_ddns 2> /dev/null`
	pa3=`cat /proc/gl-hw-info/model 2> /dev/null`
	if [ "${pa1}" != "" ] && [ "${pa2}" != "" ]; then
		ROUTE_VERSION="1.0.4"

		if [ "${pa3}" = "mt3000" ] || [ "${pa3}" = "mt2500" ] || \
				[ "${pa3}" = "x3000" ] || [ "${pa3}" = "xe3000" ]; then
			ROUTE_MODE="GL_MT3000"
			return
		elif [ "${pa3}" = "ax1800" ] || [ "${pa3}" = "axt1800" ]; then
			ROUTE_MODE="GL_AXT1800"
			return
		elif [ "${pa3}" = "mt6000" ]; then
			ROUTE_MODE="GL_MT6000"
			return
		elif [ "${pa3}" = "b3000" ]; then
			ROUTE_VERSION="1.1.0"
			ROUTE_MODE="GL_B3000"
			return
		fi
	fi

	#mi
	pa1=`getmac wan 2> /dev/null`
	pa2=`bdata get SN 2> /dev/null`
	pa3=`bdata get model 2> /dev/null`
	if [ "${pa1}" != "" ] && [ "${pa2}" != "" ]; then
		ROUTE_VERSION="1.0.4"

		if [ "${pa3}" = "RB04" ]; then
			ROUTE_MODE="MI_GAME"
			return
		elif [ "${pa3}" = "RB06" ]; then
			ROUTE_MODE="REDMI_AX6000"
			return
		elif [ "${pa3}" = "RB08" ]; then
			ROUTE_MODE="MI_HOMEWIFI"
			return
		elif [ "${pa3}" = "RC01" ]; then
			ROUTE_MODE="MI_BE10000"
			return
		elif [ "${pa3}" = "RD03" ]; then
			ROUTE_MODE="MI_AX3000T"
			return
		fi
	fi

	#leishen
	type="InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.1.MACAddress"
	pa1=`cfg_cmd get ${type} 2> /dev/null | sed -n 's;^[^v]*value=;;p' 2> /dev/null`
	type="InternetGatewayDevice.DeviceInfo.SerialNumber"
	pa2=`cfg_cmd get ${type} 2> /dev/null | sed -n 's;^[^v]*value=;;p' 2> /dev/null`
	type="InternetGatewayDevice.DeviceInfo.ModelName"
	pa3=`cfg_cmd get ${type} 2> /dev/null | sed -n 's;^[^v]*value=;;p' 2> /dev/null`
	if [ "${pa1}" != "" ] && [ "${pa2}" != "" ]; then
		ROUTE_VERSION="1.0.5"

		if [ "${pa3}" = "SR3101FA-PLUS" ]; then
			ROUTE_MODE="LEISHEN_X3"
			return
		elif [ "${pa3}" = "SR3101FA" ]; then
			ROUTE_MODE="LEISHEN_X3"
			return
		elif [ "${pa3}" = "XR2142T" ]; then
			ROUTE_MODE="LEISHEN_X1"
			return
		elif [ "${pa3}" = "XR2242T" ]; then
			ROUTE_MODE="LEISHEN_X1"
			return
		elif [ "${pa3}" = "SR5301ZA" ]; then
			ROUTE_MODE="LEISHEN_X4"
			return
		fi
	fi

	#ruijie
	type=`dev_sta get -m sysinfo 2> /dev/null`
	pa1=`echo ${type} | grep -oE '"sys_mac"[: ]*"[^"]*"'`
	pa2=`echo ${type} | grep -oE '"serial_num"[: ]*"[^"]*"'`
	pa3=`echo ${type} | grep -oE '"model"[: ]*"[^"]*"' | awk -F '"' '{printf $4}'`
	if [ "${pa1}" != "" ] && [ "${pa2}" != "" ]; then
		ROUTE_VERSION="1.0.5"

		if [ "${pa3}" = "X60-PRO" ]; then
			ROUTE_MODE="RUIJIE_X60PRO"
			return
		fi
	fi

	#asus
	pa1=`nvram get build_name 2> /dev/null`
	pa2=`nvram get odmpid 2> /dev/null`
	pa3=`nvram get productid 2> /dev/null`
	gccver=`sed -n 's;.*gcc[^0-9]*\([0-9]*\).*;\1;p' /proc/version 2> /dev/null`
	#echo "[${pa1}] [${pa2}] [${pa3}] [${ver}]"
	if [ "${pa1}${pa2}${pa3}" != "" ]; then
		ROUTE_VERSION="1.0.5"

		if [ "${gccver}" -ge 5 ] && [ -e /sys/class/net/br0 ]; then
			ROUTE_MODE="ASUS_RTARM53"
			return
		fi
	fi

	#tplink
	pa1=`cat /etc/network/interfaces 2> /dev/null | grep -oE TP-LINK`
	pa2="/var/run/game_acc/game_acc.sock"
	pa3=`uname -m`
	if [ "${pa1}" = "TP-LINK" ]; then
		ROUTE_VERSION="1.0.5"

		if [ -e ${pa2} ] && [ "${pa3}" = "armv7l" ]; then
			ROUTE_MODE="TL_RTV1"
			return
		fi
	fi
}

get_pkg()
{
	ROUTE_URL="${PKG_URL}_${ROUTE_MODE}_${ROUTE_VERSION}.tar.gz"

	rm -rf ${ROUTE_FILE}
	curl -s -k -L -m 120 "${ROUTE_URL}" -o ${ROUTE_FILE} 2> /dev/null
	if [ -e ${ROUTE_FILE} ]; then
		return
	fi

	rm -rf ${ROUTE_FILE}
	wget -q -T 120 ${ROUTE_URL} -O ${ROUTE_FILE} --no-check-certificate 2> /dev/null
	if [ -e ${ROUTE_FILE} ]; then
		return
	fi
}

dec_pkg()
{
	rm -rf /tmp/qy
	tar -zxf ${ROUTE_FILE} -C /tmp &> /dev/null
	rm -rf ${ROUTE_FILE}
}

env_chk()
{
	now=`date "+%s"`
	[ "${now}" = "" ] || [ ${now} -gt 1715702400 ] || date -s 2024-05-15

	insmod tun &> /dev/null
}

stop_pkg()
{
	if [ ! -e ${INIT_DIR}/${INIT_FILE} ]; then
		return
	fi

	killall -9 qy_acc &> /dev/null
	sleep 1
	chmod 0777 ${INIT_DIR}/${INIT_FILE}
	cd ${INIT_DIR} && ./${INIT_FILE} stop &> /dev/null
	rm -rf ${INIT_DIR}
}

run_pkg()
{
	chmod 0777 ${INIT_DIR}/${INIT_FILE}
	cd ${INIT_DIR} && ./${INIT_FILE} &> /dev/null
}

install_to_jffs()
{
	SH_TMP="/tmp/qyplug.sh"
	SH_FILE="/jffs/qy/qyplug.sh"
	START_FILE="/jffs/scripts/services-start"

	if [ ! -e ${SH_TMP} ] && [ -e ${SH_FILE} ]; then
		cp ${SH_FILE} ${SH_TMP}
		return
	fi

	if [ ! -e ${START_FILE} ] || [ ! -e ${SH_TMP} ]; then
		return
	fi

	[ -d /jffs/qy ] || mkdir /jffs/qy
	cp ${SH_TMP} ${SH_FILE}
	chmod 777 ${SH_FILE}

	sed -i '/qyplug.sh/d' ${START_FILE}
	sed -i '/^$/d' ${START_FILE}
	echo "" >> ${START_FILE}
	echo "${SH_FILE} start &" >> ${START_FILE}
}

uninstall_to_jffs()
{
	START_FILE="/jffs/scripts/services-start"

	if [ ! -e ${START_FILE} ]; then
		return
	fi

	sed -i '/qyplug.sh/d' ${START_FILE}
	rm -rf /jffs/qy
}

install_to_systemctl() {
	SH_TMP="/tmp/qyplug.sh"
	SH_FILE="/home/deck/qy/qyplug.sh"
	qy_acc_init="/etc/systemd/system/qy_acc.service"

	echo "[Unit]" > ${qy_acc_init}
	echo "Description=QY Plugin" >> ${qy_acc_init}
	echo "Wants=network-online.target" >> ${qy_acc_init}
	echo "After=network.target network-online.target" >> ${qy_acc_init}
	echo "" >> ${qy_acc_init}
	echo "[Service]" >> ${qy_acc_init}
	echo "ExecStart=${SH_FILE} start" >> ${qy_acc_init}
	echo "KillMode=process" >> ${qy_acc_init}
	echo "Restart=on-failure" >> ${qy_acc_init}
	echo "" >> ${qy_acc_init}
	echo "[Install]" >> ${qy_acc_init}
	echo "WantedBy=default.target" >> ${qy_acc_init}

	chmod 755 ${qy_acc_init}
	[ -d /home/deck/qy ] || mkdir -p /home/deck/qy
	[ ! -e ${SH_TMP} ]|| cp ${SH_TMP} ${SH_FILE}
	chmod 755 ${SH_FILE}

	systemctl enable qy_acc &> /dev/null
}

uninstall_to_systemctl() {
	qy_acc_init="/etc/systemd/system/qy_acc.service"

	systemctl disable qy_acc &> /dev/null
	rm -rf ${qy_acc_init}
	rm -rf /home/deck/qy
}

install_pkg()
{
	if [ "${ROUTE_MODE}" = "SD_V1" ]; then
		install_to_systemctl
		return
	fi
	if [ -d /jffs ]; then
		install_to_jffs
		return
	fi
}

uninstall_pkg()
{
	if [ "${ROUTE_MODE}" = "SD_V1" ]; then
		uninstall_to_systemctl
		return
	fi
	if [ -d /jffs ]; then
		uninstall_to_jffs
		return
	fi
}

pid_kill()
{
	pid=`cat ${PID_FILE} 2> /dev/null`
	if [ "${pid}" != "" ]; then
		kill -9 ${pid} &> /dev/null
	fi
	rm -rf ${PID_FILE}
}

pid_start()
{
	pid=$$
	echo ${pid} > ${PID_FILE}
}

pid_exit()
{
	rm -rf ${PID_FILE}
}

stop_qy()
{
	echo "start" > ${RET_FILE}

	pid_kill
	stop_pkg
	uninstall_pkg

	echo "succeeded" > ${RET_FILE}
}

case $ACTION in
stop)
	stop_qy
	;;
esac

cat ${RET_FILE}
