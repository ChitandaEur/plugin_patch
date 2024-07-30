#!/bin/sh


ROUTER=${1:-asuswrt-merlin}
MODEL=${2}

INSTALL_DIR=""
PLUGIN_EXE="uuplugin"
RUNNING_DIR="/tmp/uu"
MONITOR_FILENAME="uuplugin_monitor.sh"
OLD_MONITOR_FILENAME="uu_asuswrt_monitor.sh"

ASUSWRT_MERLIN="asuswrt-merlin"
XIAOMI="xiaomi"
HIWIFI="hiwifi"
OPENWRT="openwrt"
STEAM_DECK_PLUGIN="steam-deck-plugin"

init_param() {
    case ${ROUTER} in
    ${ASUSWRT_MERLIN})
        INSTALL_DIR="/jffs/uu"
        return 0
        ;;
    ${XIAOMI})
        INSTALL_DIR="/data/uu"
        return 0
        ;;
    ${HIWIFI})
        INSTALL_DIR="/plugins/uu"
        return 0
        ;;
    ${OPENWRT})
        INSTALL_DIR="/usr/sbin/uu"
        return 0
        ;;
    ${STEAM_DECK_PLUGIN})
        INSTALL_DIR="/home/deck/uu"
        return 0
        ;;
    *)
        return 1
        ;;
    esac
}

kill_uuplugin() {
    # Kill uuplugin if it is running.
    local psres=$(ps | grep "${PLUGIN_EXE}" | grep -v "grep")
    local pids=$(echo "${psres}" | sed 's/^[ \t]*//g;s/[ \t]*$//g' | \
        sed 's/[ ][ ]*/#/g' | cut -d'#' -f1)

    local TIMES="1 2 3"
    for i in ${TIMES};do
        if [ -z "${pids}" ];then
            return 0
        else
            sleep 1
        fi

        psres=$(ps | grep "${PLUGIN_EXE}" | grep -v "grep")
        pids=$(echo "${psres}" | sed 's/^[ \t]*//g;s/[ \t]*$//g' | \
            sed 's/[ ][ ]*/#/g' | cut -d'#' -f1)
    done

    for pid in ${pids}; do
        echo "kill -9 ${pid}"
        kill -9 "${pid}"
    done
}

stop_uuplugin() {
    # Stop uuplugin if it is running.
    local psres=$(ps | grep "${PLUGIN_EXE}" | grep -v "grep")
    local pids=$(echo "${psres}" | sed 's/^[ \t]*//g;s/[ \t]*$//g' | \
        sed 's/[ ][ ]*/#/g' | cut -d'#' -f1)

    for pid in ${pids}; do
        echo "kill -SIGINT ${pid}"
        kill -SIGINT "${pid}"
    done

    kill_uuplugin
}

stop_monitor() {
    # Stop monitor script if it is running.
    local psres=$(ps | grep -E "(${MONITOR_FILENAME}|${OLD_MONITOR_FILENAME})" | grep -v "grep")
    local pids=$(echo "${psres}" | sed 's/^[ \t]*//g;s/[ \t]*$//g' | \
        sed 's/[ ][ ]*/#/g' | cut -d'#' -f1)

    for pid in ${pids}; do
        echo "kill -9 ${pid}"
        kill -9 "${pid}"
    done
}

# Return: 0 means it is merlin.
check_merlin() {
    # Check to see if it is merlin
    local br0=$(ip -4 a s br0 | grep inet | grep -v 'grep' | \
        sed 's/^[ \t]*//g;s/[ \t]*$//g' | sed 's/[ ][ ]*/#/g' | cut -d'#' -f2 | cut -d/ -f1)
    [ -z "${br0}" ] && return 1

    local code=$(curl -s -o /dev/null -w "%{http_code}" "http://${br0}/images/merlin-logo.png")
    [ "$code" = "200" ] && return 0

    code=$(wget -Sq -O - "http://${br0}/images/merlin-logo.png" 2>&1 | grep 'HTTP' | \
        sed 's/^[ \t]*//g;s/[ \t]*$//g' | sed 's/[ ][ ]*/#/g' | cut -d'#' -f2)
    [ "$code" = "200" ] && return 0
    return 1
}

asuswrt_clean_up () {
    check_merlin
    if [ "$?" = "0" ];then
        asuswrt_services_clean_up
        return $?
    else
        asuswrt_exec_clean_up
        return $?
    fi
}

asuswrt_exec_clean_up () {
    # Clean up install dir.
    if [ -d "${INSTALL_DIR}" ];then
        rm -r "${INSTALL_DIR}"/* 1>/dev/null 2>&1
    fi

    # clean up uuplugin
    if [ -d "${RUNNING_DIR}" ];then
        rm -r "${RUNNING_DIR}"/* 1>/dev/null 2>&1
    fi

    nvram set jffs2_exec=""
    nvram commit &
    return 0
}

asuswrt_services_clean_up() {
    SERVICES_START_FILE="/jffs/scripts/services-start"
    # Clean up install dir.
    if [ -d "${INSTALL_DIR}" ];then
        rm -r "${INSTALL_DIR}"/* 1>/dev/null 2>&1
    fi

    # clean up uuplugin
    if [ -d "${RUNNING_DIR}" ];then
        rm -r "${RUNNING_DIR}"/* 1>/dev/null 2>&1
    fi

    # clean up services_start
    if [ -f "${SERVICES_START_FILE}" ]; then
        grep "${MONITOR_FILENAME}" "${SERVICES_START_FILE}"  1>/dev/null 2>&1
        if [ "$?" = "0" ];then
            sed -i "/${MONITOR_FILENAME}/d" "${SERVICES_START_FILE}"
        fi

        grep "${OLD_MONITOR_FILENAME}" "${SERVICES_START_FILE}"  1>/dev/null 2>&1
        if [ "$?" = "0" ];then
            sed -i "/${OLD_MONITOR_FILENAME}/d" "${SERVICES_START_FILE}"
        fi
    fi
    return 0
}

xiaomi_clean_up() {
    clean_up_implemention
    return $?
}

hiwifi_clean_up() {
    clean_up_implemention
    return $?
}

openwrt_clean_up() {
    clean_up_implemention
    return $?
}

steam_deck_plugin_clean_up() {
    local uuplugin_service="/etc/systemd/system/uuplugin.service"

    if [ -d "${INSTALL_DIR}" ];then
        rm -r "${INSTALL_DIR}"/* 1>/dev/null 2>&1
    fi

    # clean up uuplugin
    if [ -d "${RUNNING_DIR}" ];then
        rm -r "${RUNNING_DIR}"/* 1>/dev/null 2>&1
    fi

    systemctl disable uuplugin
    systemctl stop uuplugin
    rm ${uuplugin_service}
    return 0
}

clean_up_implemention() {
    local link_script="/etc/rc.d/S99uuplugin"
    [ -h "${link_script}" ] && rm ${link_script}

    if [ -d "${INSTALL_DIR}" ];then
        rm -r "${INSTALL_DIR}"/* 1>/dev/null 2>&1
    fi

    # clean up uuplugin
    if [ -d "${RUNNING_DIR}" ];then
        rm -r "${RUNNING_DIR}"/* 1>/dev/null 2>&1
    fi

    return 0
}

clean_up() {
    case ${ROUTER} in
        ${ASUSWRT_MERLIN})
            asuswrt_clean_up
            return $?
            ;;
        ${XIAOMI})
            xiaomi_clean_up
            return $?
            ;;
        ${HIWIFI})
            hiwifi_clean_up
            return $?
            ;;
        ${OPENWRT})
            openwrt_clean_up
            return $?
            ;;
        ${STEAM_DECK_PLUGIN})
            steam_deck_plugin_clean_up
            return $?
            ;;
        *)
            return 1
            ;;
    esac
}

init_param
[ "$?" != 0 ] && return 1

if [ "${ROUTER}" != "${STEAM_DECK_PLUGIN}" ];then
    stop_monitor
    stop_uuplugin
fi

clean_up
