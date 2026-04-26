# Use colours
G='\e[01;32m'    # GREEN
R='\e[01;31m'    # RED
Y='\e[01;33m'    # YELLOW
B='\e[01;34m'    # BLUE
V='\e[01;35m'    # VIOLET
Bl='\e[01;30m'   # BLACK
C='\e[01;36m'    # CYAN
W='\e[01;37m'    # WHITE
N='\e[00;37;40m' # NEUTRAL
WARNA=('\033[0;31m' '\033[0;32m' '\033[0;33m' '\033[0;34m' '\033[0;35m' '\033[0;36m' '\033[1;31m' '\033[1;32m' '\033[1;33m' '\033[1;34m' '\033[1;35m' '\033[1;36m')
RGB=${WARNA[$((RANDOM % ${#WARNA[@]}))]}
banner() {
echo ""
echo "                                             .         . ";
echo "${B}/====================================================\";"
echo "||████████╗███████╗███╗   ███╗██████╗ ███████╗      ||";
echo "||╚══██╔══╝██╔════╝████╗ ████║██╔══██╗██╔════╝      ||";
echo "||   ██║   █████╗  ██╔████╔██║██████╔╝█████╗        ||";
echo "||   ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝ ██╔══╝        ||";
echo "||   ██║   ███████╗██║ ╚═╝ ██║██║     ███████╗      ||";
echo "||   ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝     ╚══════╝      ||${N}";
echo "${R}||██████╗  ██████╗ ███████╗███████╗ ██████╗ ██╗  ██╗||";
echo "||██╔══██╗██╔═══██╗██╔════╝██╔════╝██╔═══██╗██║ ██╔╝||";
echo "||██████╔╝██║   ██║███████╗███████╗██║   ██║█████╔╝ ||";
echo "||██╔══██╗██║   ██║╚════██║╚════██║██║   ██║██╔═██╗ ||";
echo "||██████╔╝╚██████╔╝███████║███████║╚██████╔╝██║  ██╗||";
echo "||╚═════╝  ╚═════╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝||";
echo "\====================================================/${N}";
echo ""
echo -e ""
echo -e "${R}${N}""${R}  Waktu System : ${N}"; date
echo -e ""
}
modpeson(){
settings put global airplane_mode_on 1
am broadcast -a android.intent.action.AIRPLANE_MODE
}

wipegms() {
            echo ""
            sleep 0.5
        if [ ! -d /data/data/com.google.android.gms ]; then
            echo -e "${G}-----<>${G}" "${RGB}GAPPS TIDAK TERINSTALL${RGB}"
            else
            su -c am force-stop com.google.android.gm
            su -c am force-stop com.google.android.apps.photosgo
            su -c am force-stop com.google.android.apps.wellbeing
            su -c am force-stop com.google.android.carriersetup
            su -c am force-stop com.google.android.configupdater
            su -c am force-stop com.google.android.ext.services
            su -c am force-stop com.google.android.ext.shared
            su -c am force-stop com.google.android.gms
            su -c am force-stop com.google.android.gms.setup
            su -c am force-stop com.google.android.gsf
            su -c am force-stop com.google.android.inputmethod.latin
            su -c am force-stop com.google.android.markup
            su -c am force-stop com.google.android.projection.gearhead
            su -c am force-stop com.google.android.soundpicker
            su -c am force-stop com.google.android.syncadapters.calendar
            su -c am force-stop com.google.android.syncadapters.contacts
            su -c am force-stop com.android.vending
            su -c am force-stop com.android.wifi.resources
            su -c am force-stop com.android.wifi.resources.xiaomi_vince

            su -c pm clear com.google.android.gm
            su -c pm clear com.google.android.apps.photosgo
            su -c pm clear com.google.android.apps.wellbeing
            su -c pm clear com.google.android.carriersetup
            su -c pm clear com.google.android.configupdater
            su -c pm clear com.google.android.ext.services
            su -c pm clear com.google.android.ext.shared
            su -c pm clear com.google.android.gms
            su -c pm clear com.google.android.gms.setup
            su -c pm clear com.google.android.gsf
            su -c pm clear com.google.android.inputmethod.latin
            su -c pm clear com.google.android.markup
            su -c pm clear com.google.android.projection.gearhead
            su -c pm clear com.google.android.soundpicker
            su -c pm clear com.google.android.syncadapters.calendar
            su -c pm clear com.google.android.syncadapters.contacts
            su -c pm clear com.android.vending
            su -c pm clear com.android.wifi.resources
            su -c pm clear com.android.wifi.resources.xiaomi_vince
        fi
            echo -e "${Y}© ${Y}"
            echo -e "${G} \ ${G}"
    		echo -e "${G}  \ ___________/__${G}""${RGB}WIPE GMS/SF SELESAI ${RGB}"
    		mount -o ro,remount /
    		sleep 0.2
    		}

wipedata() {
mount -o rw,remount /
am force-stop com.lazada.android
pm clear com.lazada.android
am force-stop com.tokopedia.tkpd
pm clear com.tokopedia.tkpd
am force-stop com.whatsapp
pm clear com.whatsapp
am force-stop com.whatsapp.w4b
pm clear com.whatsapp.w4b
am force-stop id.dana
pm clear id.dana
pm clear com.android.location.fused
am force-stop com.android.webview
pm clear com.android.webview
pm clear com.android.webview
pm clear com.android.htmlviewer
pm clear com.android.location.fused
pm clear com.android.localtransport
pm clear com.android.packageinstaller
am force-stop jp.naver.line.android
pm clear jp.naver.line.android
am force-stop com.facebook.lite
pm clear com.facebook.lite
am force-stop com.facebook.katana
pm clear com.facebook.katana
am force-stop com.facebook.orca
pm clear com.facebook.orca

#browser
am force-stop com.google.android.fufufu.deviceid
pm clear com.google.android.fufufu.deviceid
am force-stop com.chrome.beta
pm clear com.chrome.beta
am force-stop org.gologin.orbita
pm clear org.gologin.orbita
am force-stop com.android.chrome
pm clear com.android.chrome
am force-stop com.brave.browser
pm clear com.brave.browser
am force-stop mark.via.gp
#pm clear mark.via.gp
am force-stop org.mozilla.firefox
pm clear org.mozilla.firefox
am force-stop com.kiwibrowser.browser
pm clear com.kiwibrowser.browser
am force-stop com.vivaldi.browser
pm clear com.vivaldi.browser
am force-stop com.evo.browser
pm clear com.evo.browser
am force-stop org.bromite.bromite
pm clear org.bromite.bromite
am force-stop com.microsoft.emmx.beta
pm clear com.microsoft.emmx.beta
am force-stop com.bharat.browser
pm clear com.bharat.browser
am force-stop com.sec.android.app.sbrowser
pm clear com.sec.android.app.sbrowser
am force-stop net.upx.proxy.browser
pm clear net.upx.proxy.browser
am force-stop com.sec.android.app.sbrowser
pm clear com.sec.android.app.sbrowser
am force-stop com.microsoft.emmx.canary
pm clear com.microsoft.emmx.canary
am force-stop com.browser.tssomas
pm clear com.browser.tssomas
am kill jp.naver.line.android
am force-stop jp.naver.line.android
pm clear jp.naver.line.android

com.browser.tssomas
# TikCapCut
am force-stop com.ss.android.ugc.trill
pm clear com.ss.android.ugc.trill
am force-stop com.zhiliaoapp.musically
pm clear com.zhiliaoapp.musically
am force-stop com.lemon.lvoverseas
pm clear com.lemon.lvoverseas

rm -rf /data/system/users/0/fpdata
rm -rf /data/system/users/0/registered_services
rm -rf /data/dalvik-cache/
rm -rf /data/cache/
rm -rf "/data/user_de/0/com.android.location.fused/*"
rm -rf "/data/data/com.android.location.fused/*"

rm -rf "/sdcard/data/*"
rm -rf "/data/dalvik-cache/*"
rm -rf "/cache/**"

rm -rf /data/data/com.ss.android.ugc.trill/
rm -rf /storage/emulated/0/WhatsApp
rm -rf /storage/emulated/0/Android
rm -rf /storage/emulated/0/Pictures
rm -rf /storage/emulated/0/Tokopedia
rm -rf /storage/emulated/0/Music
rm -rf /storage/emulated/0/Musik
rm -rf /storage/emulated/0/Movies/
rm -rf /storage/emulated/0/Movies/*.*
rm -rf /storage/emulated/0/Tencent
rm -rf /storage/emulated/0/.UTSystemConfig
rm -rf /storage/emulated/0/.Uc2UTSystemConfig
rm -rf /storage/emulated/0/.Uc2DataStorage
rm -rf /storage/emulated/0/.gs_fs0
rm -rf /storage/emulated/0/.gs_file
rm -rf /storage/emulated/0/.face
rm -rf /storage/emulated/0/.DataStorage
rm -rf /storage/emulated/0/.config
rm -rf /storage/emulated/0/.com.taobao.dp
rm -rf /storage/emulated/0/shopeeID
rm -rf /storage/emulated/0/cache
rm -rf /storage/emulated/0/.cri
rm -rf /storage/emulated/0/*.*
rm -rf /storage/emulated/0/NikGapps
rm -rf /storage/emulated/0/LOST.DIR/*
rm -rf /storage/emulated/0/cache/*.*
rm -rf /cache/*.apk
rm -rf /cache/*.tmp
rm -rf /data/backup/pending/*.tmp
rm -rf /data/cache/*.*
rm -rf /data/clipboard/*
rm -rf /data/dalvik-cache/*.apk
rm -rf /data/dalvik-cache/*.tmp
rm -rf /data/dontpanic/*.tmp
rm -rf /data/kernelpanics/*.tmp
rm -rf /data/last_alog
rm -rf /data/last_kmsg
rm -rf /data/log/*
rm -rf /data/mlog/*
rm -rf /data/system/dropbox/*
rm -rf /data/system/usagestats/*
rm -rf /data/tombstones/*
rm -rf /data/*.log
rm -rf /data/log/*
find /storage/emulated/0/ -type d -empty -print -delete

mount -o ro,remount /
}


modpesoff(){
settings put global airplane_mode_on 0
am broadcast -a android.intent.action.AIRPLANE_MODE
}


clear
banner

        echo -e "${Y}© ${Y}"
        echo -e "${G} \ ${G}"
		echo -e "${G}  \ ___________/__${G}""${RGB}WIPE DATA/CACHE SEDANG DI PROSES !!${RGB}"
            echo ""
            echo ""
            echo ""
modpeson &>/dev/null
echo -ne "${G}▇▇▇▇▇▇▇▇${N}" '(11%)\r'
wipedata &>/dev/null
echo -ne "${G}▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇${N}" '(45%)\r'
sleep 1
echo -ne "${G}▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇${N}" '(63%)\r'
wipegms &>/dev/null
echo -ne "${G}▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇${N}" '(91%)\r'
modpesoff &>/dev/null
echo -ne "${G}▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇${N}" '(100%)\n'
            echo ""
            echo ""
            echo ""
            echo ""
            echo ""
            echo -e "${Y}BERSIH-BERSIH SELESAI !!${N}"
            echo -e "${G}√${N} Folder Android dihapus"
            echo -e "${G}√${N} Sampah dihapus"
            echo -e "${G}√${N} Cache dihapus"
            sleep 1



G='\e[01;32m'    # GREEN
R='\e[01;31m'    # RED
Y='\e[01;33m'    # YELLOW
B='\e[01;34m'    # BLUE
V='\e[01;35m'    # VIOLET
Bl='\e[01;30m'   # BLACK
C='\e[01;36m'    # CYAN
W='\e[01;37m'    # WHITE
N='\e[00;37;40m' # NEUTRAL
WARNA=('\033[0;31m' '\033[0;32m' '\033[0;33m' '\033[0;34m' '\033[0;35m' '\033[0;36m' '\033[1;31m' '\033[1;32m' '\033[1;33m' '\033[1;34m' '\033[1;35m' '\033[1;36m')
RGB=${WARNA[$((RANDOM % ${#WARNA[@]}))]}
banner() {
echo ""
echo "                                             .         . ";
echo "${B}/====================================================\";"
echo "||████████╗███████╗███╗   ███╗██████╗ ███████╗      ||";
echo "||╚══██╔══╝██╔════╝████╗ ████║██╔══██╗██╔════╝      ||";
echo "||   ██║   █████╗  ██╔████╔██║██████╔╝█████╗        ||";
echo "||   ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝ ██╔══╝        ||";
echo "||   ██║   ███████╗██║ ╚═╝ ██║██║     ███████╗      ||";
echo "||   ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝     ╚══════╝      ||${N}";
echo "${R}||██████╗  ██████╗ ███████╗███████╗ ██████╗ ██╗  ██╗||";
echo "||██╔══██╗██╔═══██╗██╔════╝██╔════╝██╔═══██╗██║ ██╔╝||";
echo "||██████╔╝██║   ██║███████╗███████╗██║   ██║█████╔╝ ||";
echo "||██╔══██╗██║   ██║╚════██║╚════██║██║   ██║██╔═██╗ ||";
echo "||██████╔╝╚██████╔╝███████║███████║╚██████╔╝██║  ██╗||";
echo "||╚═════╝  ╚═════╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝||";
echo "\====================================================/${N}";
echo ""
date
echo -e ""
echo -e "${R}${N}""${R}  Waktu System : ${N}"; date
echo -e ""
}
clear
banner
sleep 0.2
modpeson(){
settings put global airplane_mode_on 1
am broadcast -a android.intent.action.AIRPLANE_MODE
}
mount -o rw,remount /
mount -o rw,remount /dev/block/platform/soc/c0c4000.sdhci/by-name/vendor
delete(){
am kill com.android.phone
am kill com.android.dialer
am kill com.android.smspush
am kill com.android.ime
am kill android.ext.services
am kill com.google.android.apps.docs
am kill com.google.android.apps.googleassistant
am kill com.android.download
am kill com.android.tools
am kill com.android.webview
am kill com.android.defcontainer
am force-stop com.android.phone
am force-stop com.android.dialer
am force-stop com.android.smspush
am force-stop com.android.ime
am force-stop android.ext.services
am force-stop com.google.android.apps.docs
am force-stop com.google.android.apps.googleassistant
am force-stop com.android.download
am force-stop com.android.tools
am force-stop com.android.webview
am force-stop com.android.defcontainer
am force-stop com.lazada.android
#am force-stop com.microsoft.office.outlook
am force-stop com.android.chrome
am force-stop id.dana
am force-stop com.evo.browser
am force-stop com.lazada.android
am force-stop com.android.dialer
pm clear com.android.dialer
pm clear com.android.dialer
pm clear com.lazada.android
pm clear com.android.chrome
pm clear com.evo.browser
pm clear id.dana
pm clear jp.naver.line.android
pm clear com.google.android.gms
pm clear com.google.android.gsf
rm -rf /storage/emulated/0/Android/data/* &>/dev/null
rm -rf /data/data/com.lazada.android/* &>/dev/null
rm -rf /data/adb/modules/xkatrina_snstv_prps/system.prop
rm -rf /data/adb/modules/MagiskProps/system.prop
rm -rf /data/adb/modules/xkatrina_snstv_prps/post-fs-data.sh
rm -rf /data/adb/modules/MagiskProps/post-fs-data.sh
sleep 0.5
}
systemprops() {
mount -o rw,remount /
mkdir /data/local/tmp
dir=/data/local/tmp/system.prop
diral=/data/adb/modules/xkatrina_snstv_prps/system.prop
dirart=/data/adb/modules/MagiskProps/system.prop

MOD1=("Xiaomi 14 Ultra" "Xiaomi 14 Pro" "Xiaomi 13T Pro" "Xiaomi 13 Ultra" "Xiaomi 13 Pro" "Xiaomi 12T Pro" "Xiaomi 12S Ultra" "Xiaomi 12 Lite" "Xiaomi 11T Pro" "Xiaomi 11 Ultra" "Mi 11 Lite 5G" "Mi 10T Pro" "Mi 10 Ultra" "Mi 9T Pro" "POCO F5 Pro" "POCO F5" "POCO F4 GT" "POCO F3" "POCO X6 Pro" "POCO X5 Pro" "POCO X4 Pro 5G" "POCO X3 GT" "POCO X3 Pro" "POCO M6 Pro" "POCO M5" "Redmi Note 13 Pro+ 5G" "Redmi Note 13 Pro" "Redmi Note 13 5G" "Redmi Note 12 Pro+ 5G" "Redmi Note 12 Turbo" "Redmi Note 12S" "Redmi Note 11 Pro+ 5G" "Redmi Note 11S" "Redmi Note 10 Pro" "Redmi Note 10 5G" "Redmi Note 9 Pro" "Redmi Note 8 Pro" "Redmi 13C" "Redmi 12 5G" "Redmi 12C" "Redmi 10 2022" "Redmi 10C" "Redmi 9T" "Redmi A3" "Redmi A2" "Xiaomi Pad 6 Max" "Xiaomi Pad 6 Pro" "Xiaomi Pad 5" "Redmi Pad SE" "Redmi Pad Pro")

MOD2=("RMX3840" "RMX3841" "RMX3842" "RMX3741" "RMX3771" "RMX3706" "RMX3709" "RMX3370" "RMX3363" "RMX3360" "RMX3301" "RMX3300" "RMX3311" "RMX3310" "RMX3551" "RMX3561" "RMX3560" "RMX3241" "RMX3242" "RMX3471" "RMX3472" "RMX3478" "RMX3630" "RMX3686" "RMX3612" "RMX3193" "RMX3191" "RMX3115" "RMX3085" "RMX3081" "RMX2170" "RMX2151" "RMX2111" "RMX2086" "RMX2001" "RMX1931" "RMX1901" "RMX3511" "RMX3516" "RMX3501" "RMX3521" "RMX3506" "RMX3610" "RMX3611" "RMX3517" "RMX3830" "RMX3940" "RMX3950" "RMX3393" "RMX3392")

modelok="${MOD2[$RANDOM % ${#MOD2[@]} ]}"

brand="XIAOMI"
manuc="REALME"
and1=("10" "11" "12" "13")
and="${and1[$RANDOM % ${#and1[@]} ]}"

#huruf_jumlah="$(( RANDOM % 4 + 4 ))"
#modelok="$(tr -dc 'BCDFGHJKLMNPQRSTVWXYZAUIEO' </dev/urandom | head -c $huruf_jumlah)$(tr -dc '123456789' </dev/urandom | head -c 4)"
clear
banner
echo -e "${Y}SCRIPT MEMBUAT system.prop OTOMATIS ${N}"
echo ""
echo ""
sleep 0.2
mount -o rw,remount /
rm -f /data/local/tmp/system.prop
sleep 1
echo -e "${Y}Membuat System.prop...${N}"
sleep 1
echo "# This file will be read by resetprop" >> $dir
echo "# MagiskHide Props Config" >> $dir
echo "# Copyright (c) 2018-2021 Didgeridoohan @ XDA Developers" >> $dir
echo "# Licence: MIT" >> $dir
echo "ro.product.model=$modelok" >> $dir
echo "ro.product.system.model=$modelok" >> $dir
echo "ro.product.vendor.model=$modelok" >> $dir
echo "ro.product.product.model=$modelok" >> $dir
echo "ro.product.odm.model=$modelok" >> $dir
echo "ro.product.system_ext.model=$modelok" >> $dir
echo "ro.product.manufacturer=$manuc" >> $dir
echo "ro.product.system.manufacturer=$manuc" >> $dir
echo "ro.product.vendor.manufacturer=$manuc" >> $dir
echo "ro.product.product.manufacturer=$manuc" >> $dir
echo "ro.product.odm.manufacturer=$manuc" >> $dir
echo "ro.product.system_ext.manufacturer=$manuc" >> $dir
echo "ro.build.version.release=$and" >> $dir
echo "ro.system.build.version.release=$and" >> $dir
echo "ro.vendor.build.version.release=$and" >> $dir
echo "ro.product.build.version.release=$and" >> $dir
echo "ro.odm.build.version.release=$and" >> $dir
echo "ro.system_ext.build.version.release=$and" >> $dir
echo "ro.boot.verifiedbootstate=green" >> $dir
echo "ro.boot.flash.locked=1" >> $dir
echo "vendor.boot.verifiedbootstate=green" >> $dir
echo "ro.boot.veritymode=enforcing" >> $dir
echo "vendor.boot.vbmeta.device_state=locked" >> $dir
echo "ro.build.product=$modelok" >> $dir
echo "ro.build.type=user" >> $dir
echo "ro.build.user=tempe_ten" >> $dir
echo "ro.build.host=VPHLR6874" >> $dir
echo "ro.build.tags=release-keys" >> $dir
echo "ro.build.flavor=$modelok-user" >> $dir
echo "ro.debuggable=0" >> $dir
echo "ro.secure=1" >> $dir
echo "ro.bootloader=bfVKUZ2AO" >> $dir
echo "ro.hardware=qcom" >> $dir
echo "ro.product.board=$modelok" >> $dir
echo "ro.product.brand=$brand" >> $dir
echo "ro.product.system.brand=$brand" >> $dir
echo "ro.product.vendor.brand=$brand" >> $dir
echo "ro.product.product.brand=$brand" >> $dir
echo "ro.product.odm.brand=$brand" >> $dir
echo "ro.product.system_ext.brand=$brand" >> $dir

sleep 1
cp -r -f /data/local/tmp/system.prop $diral
cp -r -f /data/local/tmp/system.prop $dirart
echo -e "${C}√ Berhasil √${N}"
clear
N0=$(head -3 /dev/urandom | tr -cd '4-9' | cut -c -1)
N1=("Redmi Note $N0")
FURANDOM=$(head -3 /dev/urandom | tr -cd 'A-Z' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'aeiou' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'bcdfghjklmnpqrstvwxyz' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'aeiou' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'bcdfghjklmnpqrstvwxyz' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'aeiou' | cut -c -1)
FUBTNAME=$(grep -n bluetooth_name /data/system/users/0/settings_secure.xml | grep -o 'value=".*"*' | cut -d '"' -f2)
FUBTNAMEFB=$(grep -n bluetooth_name /data/system/users/0/settings_secure.xml.fallback | grep -o 'value=".*"*' | cut -d '"' -f2)
FUDVNAME=$(grep -n device_name /data/system/users/0/settings_global.xml | grep -o 'value=".*"*' | cut -d '"' -f2)
FUDVNAMEFB=$(grep -n device_name /data/system/users/0/settings_global.xml.fallback | grep -o 'value=".*"*' | cut -d '"' -f2)
settings delete secure advertising_id
echo "settings delete secure advertising_id"
settings delete secure android_id
echo "settings delete secure android_id"
sed -i '/Name =/d' /data/misc/bluedroid/bt_config.conf
echo "Name = $FURANDOM $N1" >> /data/misc/bluedroid/bt_config.conf
sed -i "s/$FUBTNAME/$FURANDOM $N1/g" /data/system/users/0/settings_secure.xml
if [ -f /data/system/users/0/settings_secure.xml.fallback ]; then
echo "Edo, fallback not found"
else
sed -i "s/$FUBTNAMEFB/$FURANDOM $N1/g" /data/system/users/0/settings_secure.xml.fallback
fi
echo "Ganti nama bluetooth"
sed -i "s/$FUDVNAME/$N1/g" /data/system/users/0/settings_global.xml
if [ -f /data/system/users/0/settings_global.xml.fallback ]; then
echo "Edo, fallback not found"
else
sed -i "s/$FUDVNAMEFB/$FURANDOM $N1/g" /data/system/users/0/settings_global.xml.fallback
fi
echo "Ganti nama device"
SCRIPTS_FILE=/data/adb/modules/MagiskHidePropsConf/system.prop
if [ ! -f "$SCRIPTS_FILE" ]; then SCRIPTS_FILE=/data/adb/modules/MagiskHidePropsConf/system.prop;
fi
cp "$SCRIPTS_FILE" /data/adb/modules/magisk-drm-disabler/system.prop
SCRIPTS_FILE=/data/adb/modules/xkatrina_snstv_prps/system.prop
if [ ! -f "$SCRIPTS_FILE" ]; then SCRIPTS_FILE=/data/adb/modules/MagiskProps/system.prop;
fi
cp "$SCRIPTS_FILE" /data/adb/modules/magisk-drm-disabler/system.prop
mount -o ro,remount /
}
acak1() {
IDKEY=$(grep -n "userkey" /data/system/users/0/settings_ssaid.xml | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
IDV1=$(grep -n "com.lazada.android" /data/system/users/0/settings_ssaid.xml | grep -o 'value=".*"*' | cut -d '"' -f2)
IDLINE1=$(grep -n "com.google.android.gms" /data/system/users/0/settings_ssaid.xml | grep -o 'value=".*"*' | cut -d '"' -f2)
IDPS1=$(grep -n "com.android.vending" /data/system/users/0/settings_ssaid.xml | grep -o 'value=".*"*' | cut -d '"' -f2)
IDRANDOM=$(head -3 /dev/urandom | tr -cd $IDKEY | cut -c -16)
IDLINERANDOM=$(head -3 /dev/urandom | tr -cd $IDKEY | cut -c -16)
IDPSRANDOM=$(head -3 /dev/urandom | tr -cd $IDKEY | cut -c -16)
sed -i "s/$IDLINE1/$IDLINERANDOM/g" /data/system/users/0/settings_ssaid.xml
sed -i "s/$IDV1/$IDRANDOM/g" /data/system/users/0/settings_ssaid.xml
sed -i "s/$IDPS1/$IDPSRANDOM/g" /data/system/users/0/settings_ssaid.xml
echo "${W}JANDA ID SELESAI DITAMBAH ${R}$(grep -n "com.lazada.android" /data/system/users/0/settings_ssaid.xml | grep -o 'value=".*"*' | cut -d '"' -f2) "
sleep 0.5
clear
}
acak2 (){
IDKEY=$(grep -n "userkey" /data/system/users/0/settings_ssaid.xml | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
IDV2=$(grep -n "com.lazada.android" /data/system/users/0/settings_ssaid.xml | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
IDV33=$(grep -n "com.tokopedia.tkpd" /data/system/users/0/settings_ssaid.xml | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
IDV2=$(grep -n "com.android.chrome" /data/system/users/0/settings_ssaid.xml | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
IDV2=$(grep -n "id.dana" /data/system/users/0/settings_ssaid.xml | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
IDPS2=$(grep -n "com.android.vending" /data/system/users/0/settings_ssaid.xml | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
IDPSRANDOM2=$(head -3 /dev/urandom | tr -cd $IDKEY | cut -c -16)
IDRANDOM2=$(head -3 /dev/urandom | tr -cd $IDKEY | cut -c -16)
IDRANDOM33=$(head -3 /dev/urandom | tr -cd $IDKEY | cut -c -16)
IDLINE2=$(grep -n "com.google.android.gms" /data/system/users/0/settings_ssaid.xml | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
IDLINERANDOM2=$(head -3 /dev/urandom | tr -cd $IDKEY | cut -c -16)
sed -i "s/$IDLINE2/$IDLINERANDOM2/g" /data/system/users/0/settings_ssaid.xml
sed -i "s/$IDV2/$IDRANDOM2/g" /data/system/users/0/settings_ssaid.xml
sed -i "s/$IDV33/$IDRANDOM33/g" /data/system/users/0/settings_ssaid.xml
sed -i "s/$IDPS2/$IDPSRANDOM2/g" /data/system/users/0/settings_ssaid.xml
echo "${W}JANDA DEFAULAT ID SELESAI DITAMBAH ${R}$(grep -n "com.lazada.android" /data/system/users/0/settings_ssaid.xml | grep -o 'defaultValue=".*"*' | cut -d '"' -f2) "
echo "${W}TOKOPEDIA DEFAULAT ID SELESAI DITAMBAH ${R}$(grep -n "com.tokopedia.tkpd" /data/system/users/0/settings_ssaid.xml | grep -o 'defaultValue=".*"*' | cut -d '"' -f2) "
echo "${W}chrome DEFAULAT ID SELESAI DITAMBAH ${R}$(grep -n "com.android.chrome" /data/system/users/0/settings_ssaid.xml | grep -o 'defaultValue=".*"*' | cut -d '"' -f2) "
echo "${W}Dana DEFAULAT ID SELESAI DITAMBAH ${R}$(grep -n "id.dana" /data/system/users/0/settings_ssaid.xml | grep -o 'defaultValue=".*"*' | cut -d '"' -f2) "
sleep 0.5
clear
}
acakserial(){
IDRANDOM3=$(head -3 /dev/urandom | tr -cd 'a-f0-9' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'a-f0-9' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'a-f0-9' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'a-f0-9' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'a-f0-9' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'a-f0-9' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'a-f0-9' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'a-f0-9' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'a-f0-9' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'a-f0-9' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'a-f0-9' | cut -c -1)$(head -3 /dev/urandom | tr -cd 'a-f0-9' | cut -c -1)
SERIAL=$(grep -i "CUSTOMPROPSPOST" /data/adb/mhpc/propsconf_late | grep -i "ro.serialno=" | cut -d '"' -f2 | cut -d '=' -f2)
SERIAL2=$(grep -i "CUSTOMPROPSLATE" /data/adb/mhpc/propsconf_late | grep -i "ro.serialno=" | cut -d '"' -f2 | cut -d '=' -f2)
sed -i "s/$SERIAL/$IDRANDOM3/g" /data/adb/mhpc/propsconf_late
sed -i "s/$SERIAL2/$IDRANDOM3/g" /data/adb/mhpc/propsconf_late
echo "${W}SERIAL SELESAI DITAMBAH ${R}$(grep -n "ro.serialno=" /data/adb/mhpc/propsconf_late |  cut -d '"' -f2 | cut -d '=' -f2) "
sleep 1
}
ritual(){
am force-stop com.ss.android.ugc.trill
am force-stop org.chromium.chrome.stable
am force-stop com.lazada.android
am force-stop com.tokopedia.tkpd
am force-stop com.android.chrome
pm clear com.lazada.android
pm clear com.tokopedia.tkpd
pm clear org.chromium.chrome.stable
pm clear com.ss.android.ugc.trill
pm clear com.android.location.fused
pm clear com.android.chrome
am force-stop jp.naver.line.android
pm clear jp.naver.line.android
am force-stop com.facebook.katana
pm clear com.facebook.katana
am force-stop free.vpn.secure.turbo.proxy.hotspot.vpnindonesia
pm clear free.vpn.secure.turbo.proxy.hotspot.vpnindonesia
 rm -rf /storage/*-*/Android
 am force-stop com.lazada.android
 pm clear com.ss.android.ugc.trill
 pm clear com.lazada.android
 pm clear com.google.android.overlay.gmsconfig.common
 pm clear com.google.android.overlay.gmsconfig.gsa
 pm clear com.google.android.apps.wellbeing
 pm clear com.google.android.gms
 pm clear com.google.android.gsf
 pm clear com.google.android.ims
 pm clear com.android.vending
 pm clear com.android.webview
 rm -rf /storage/emulated/0/.mixplorer
 rm -rf /storage/emulated/0/Android
 am force-stop com.google.android.overlay.gmsconfig.common
 am force-stop com.google.android.overlay.gmsconfig.gsa
 am force-stop com.google.android.apps.wellbeing
 am force-stop com.google.android.gms
 am force-stop com.google.android.gsf
 am force-stop com.android.vending
 rm -rf /data/system/appops/history/
 rm -rf /data/system/netstats/
 rm -rf /data/system/job/
 rm -rf /data/system/users/0/fpdata
 rm -rf /data/system/users/0/registered_services
 rm -rf /data/system/users/0/package-restrictions.xml
 rm -rf /data/system/users/0/settings_ssaid.xml
 rm -rf /data/system/users/0/app_idle_stats.xml
 rm -rf /data/system/users/0/settings_config.xml
 rm -rf /data/system/users/0/fpdata
 rm -rf /data/system/users/0/registered_services
 rm -rf /data/system/users/0/settings_ssaid.xml
 rm -rf "/data/system/users/0/*.fallback"
 pm clear android.ext.services
 pm clear android.ext.shared
 pm clear com.android.vending
 pm clear com.google.android.gms
 pm clear com.google.android.gsf
 pm clear com.google.android.apps.restore
 pm clear com.google.android.carriersetup
 pm clear com.google.android.configupdater
 pm clear com.google.android.apps.pixelmigrate
 pm clear com.google.android.apps.photosgo
 pm clear com.google.android.packageinstaller
 pm clear com.google.android.apps.wellbeing
 pm clear com.google.android.markup
 pm clear com.google.android.setupwizard
 pm clear com.google.android.syncadapters.calendar
 pm clear com.google.android.syncadapters.contacts
 pm clear com.google.android.soundpicker
rm -rf "/data/user_de/0/com.android.location.fused/*"
rm -rf "/data/data/com.android.location.fused/*"
rm -rf /data/data/com.android.location.fused/*
rm -rf /data/data/com.google.android.gms/*
rm -rf /data/data/com.google.android.gsf/*
rm -rf /data/user/0/com.lazada.android/*
rm -rf /data/data/android.auto_generated_rro_vendor__/*
rm -rf /data/data/android.ext.services/*
rm -rf /data/data/android.ext.shared/*
rm -rf /data/data/com.android.backupconfirm/*
rm -rf /data/data/com.android.bips/*
rm -rf /data/data/com.android.bluetooth/*
rm -rf /data/data/com.android.bluetoothmidiservice/*
rm -rf /data/data/com.android.bookmarkprovider/*
rm -rf /data/data/com.android.calendar/*
rm -rf /data/data/com.android.carrierconfig/*
rm -rf /data/data/com.android.carrierconfig.auto_generated_rro_vendor__/*
rm -rf /data/data/com.android.htmlviewer/*
rm -rf /data/data/com.android.webview/*
rm -rf /data/local/*
rm -rf /storage/emulated/0/.*
rm -rf /storage/emulated/0/.mixplorer
rm -rf /storage/emulated/0/Android/*
rm -rf /storage/emulated/0/Android/
rm -rf /storage/emulated/0/Android/data/*
rm -rf /storage/emulated/0/data/*
rm -rf /storage/emulated/0/data/
rm -rf /storage/emulated/0/Pictures/*
rm -rf /storage/emulated/0/Pictures/
rm -rf /storage/emulated/0/.cri
rm -rf /storage/emulated/0/LOST.DIR/*
 rm -rf "/data/system/users/0/settings_ssaid.xml"
 rm -rf "/data/user/0/com.google.android.gms/*"
 rm -rf "/data/user/0/com.google.android.gsf/*"


##del akun
rm /data/system_ce/0/accounts_ce.db
rm /data/system_de/0/accounts_de.db
find /storage/emulated/0/ -type d -empty -print -delete
}
clear
banner
echo -e "${Y}© ${Y}"
echo -e "${G} \ ${G}"
echo -e "${G}  \ ___________/__${G}""${RGB}SCRIPT MEMBUAT system.prop OTOMATIS  !!${RGB}"
echo ""
echo ""
echo ""
modpeson &>/dev/null
echo -ne "${G}▇▇▇▇▇▇▇▇${N}" '(11%)\r'
delete &>/dev/null
echo -ne "${G}▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇${N}" '(37%)\r'
systemprops &>/dev/null
echo -ne "${G}▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇${N}" '(64%)\r'
acak1 &>/dev/null
acak2 &>/dev/null
acakserial &>/dev/null
echo -ne "${G}▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇${N}" '(83%)\r'
ritual &>/dev/null
echo -ne "${G}▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇${N}" '(100%)\n'
sleep 0.5
echo ""
echo ""
echo ""
echo ""
echo ""
echo -e "${Y}SELESAI MEMBUAT system.prop $modelok !!${N}"
echo -e "${G}√${N} Folder Android dihapus"
echo -e "${G}√${N} Sampah dihapus"
echo -e "${G}√${N} Cache dihapus"
sleep 3
reboot