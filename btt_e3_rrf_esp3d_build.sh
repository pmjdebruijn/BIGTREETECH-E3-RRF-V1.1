#!/bin/sh
#
# SKR E3 RRF V1.1  -  ESP3D 3.0  -  firmware build script
#
# Copyright (c) 2021 Pascal de Bruijn
#


trap 'echo $(tput setaf 3; tput setab 1; tput bold)ERROR: $0 line $LINENO !!!$(tput sgr0)' ERR


VENV_DIR=PlatformIO
ESP3D_DIR=ESP3D

SRC_BRANCH=7aeaee823648e092ffd78066f51782dbf134ea8b # from 3.0 branch

BOARD=$1
[ "${BOARD}" == "" ] && BOARD=esp07s && echo "WARNING: Board not specified, defaulting to '${BOARD}' ..."

if [ ! -d "${VENV_DIR}" ]; then
  python3 -m venv ${VENV_DIR}

  ./${VENV_DIR}/bin/pip install -U wheel --no-cache-dir
  ./${VENV_DIR}/bin/pip install -U platformio --no-cache-dir
else
  echo "WARNING: Reusing preexisting ${VENV_DIR} directory..."
fi

if [ ! -d "${ESP3D_DIR}" ]; then
  git clone https://github.com/luc-github/ESP3D ${ESP3D_DIR}

  git -C ${ESP3D_DIR} -c advice.detachedHead=false checkout ${SRC_BRANCH}
else
  echo "WARNING: Reusing preexisting ${ESP3D_DIR} directory..."
fi

git -C ${ESP3D_DIR} reset --hard

sed -i 's@default_envs.*=.*@default_envs = esp8266dev@' ${ESP3D_DIR}/platformio.ini

case ${BOARD} in
  "esp07s")  sed -i 's@board = esp12e@board = esp07s@' ${ESP3D_DIR}/platformio.ini ;;
  "d1_mini") sed -i 's@board = esp12e@board = d1_mini@' ${ESP3D_DIR}/platformio.ini ;;
esac

sed -i 's@.*#define MDNS_FEATURE@//#define MDNS_FEATURE@' ${ESP3D_DIR}/esp3d/configuration.h
sed -i 's@.*#define SSDP_FEATURE@//#define SSDP_FEATURE@' ${ESP3D_DIR}/esp3d/configuration.h
sed -i 's@.*#define NETBIOS_FEATURE@//#define NETBIOS_FEATURE@' ${ESP3D_DIR}/esp3d/configuration.h
sed -i 's@.*#define TIMESTAMP_FEATURE@//#define TIMESTAMP_FEATURE@' ${ESP3D_DIR}/esp3d/configuration.h
sed -i 's@.*#define WEBDAV_FEATURE@//#define WEBDAV_FEATURE@' ${ESP3D_DIR}/esp3d/configuration.h
sed -i 's@.*#define WIFI_FEATURE@#define WIFI_FEATURE@' ${ESP3D_DIR}/esp3d/configuration.h
sed -i 's@.*#define HTTP_FEATURE@//#define HTTP_FEATURE@' ${ESP3D_DIR}/esp3d/configuration.h
sed -i 's@.*#define TELNET_FEATURE@#define TELNET_FEATURE@' ${ESP3D_DIR}/esp3d/configuration.h
sed -i 's@.*#define CAPTIVE_PORTAL_FEATURE@#define CAPTIVE_PORTAL_FEATURE@' ${ESP3D_DIR}/esp3d/configuration.h
sed -i 's@.*#define WEB_UPDATE_FEATURE@//#define WEB_UPDATE_FEATURE@' ${ESP3D_DIR}/esp3d/configuration.h
sed -i 's@.*#define NOTIFICATION_FEATURE@//#define NOTIFICATION_FEATURE@' ${ESP3D_DIR}/esp3d/configuration.h
sed -i 's@.*#define AUTHENTICATION_FEATURE@//#define AUTHENTICATION_FEATURE@' ${ESP3D_DIR}/esp3d/configuration.h

sed -i 's@.*#define DEFAULT_BOOT_RADIO_STATE.*@#define DEFAULT_BOOT_RADIO_STATE 0@' ${ESP3D_DIR}/esp3d/src/core/settings_esp3d.cpp

sed -i 's@const char DEFAULT_HOSTNAME.*@const char DEFAULT_HOSTNAME []   =       "ender3";@' ${ESP3D_DIR}/esp3d/src/core/settings_esp3d.cpp

sed -i 's@const char DEFAULT_AP_SSID.*@const char DEFAULT_AP_SSID []   =        "Ender-3";@' ${ESP3D_DIR}/esp3d/src/core/settings_esp3d.cpp
sed -i 's@const char DEFAULT_AP_PASSWORD.*@const char DEFAULT_AP_PASSWORD []  =     "31415926";@' ${ESP3D_DIR}/esp3d/src/core/settings_esp3d.cpp

sed -i 's@const char DEFAULT_STA_SSID.*@const char DEFAULT_STA_SSID []   =       "Ender-3";@' ${ESP3D_DIR}/esp3d/src/core/settings_esp3d.cpp
sed -i 's@const char DEFAULT_STA_PASSWORD.*@const char DEFAULT_STA_PASSWORD []  =    "31415926";@' ${ESP3D_DIR}/esp3d/src/core/settings_esp3d.cpp

(cd ${ESP3D_DIR}; ../${VENV_DIR}/bin/platformio run)

ls -lh ${ESP3D_DIR}/.pioenvs/*/firmware.*

cp -v ${ESP3D_DIR}/.pioenvs/*/firmware.bin ESP3D.bin

echo 'esptool --port /dev/ttyUSB1 write_flash -fm dio 0x000000 ESP3D/.pioenvs/esp8266*/firmware.bin'
echo 'picocom --baud 115200 --echo /dev/ttyUSB1'
