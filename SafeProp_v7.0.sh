#!/system/bin/sh
# ============================================================
# SafeProp v7.0 — Aggressive Device Identity Spoofer
# Base: SafeProp v6.5 + AcakTeMPeOPPO Ritual
# Target: Redmi Note 7 (lavender) | crDroid Android 11
# Changelog v7.0:
#   + SSAID randomize (acak1 + acak2)
#   + Ritual agresif di akhir (full purge)
#   + Google apps clear tambahan
#   + Data folder deletion tambahan
#   + Fallback XML edit untuk BT/device name
#   + VPN Indonesia clear
#   + android_id delete
# ============================================================

# --- Lockfile (cegah double-run) ---
LOCKFILE="/data/local/tmp/safeprop.lock"
if [ -f "$LOCKFILE" ]; then
    LOCK_AGE=$(($(date +%s) - $(date -r "$LOCKFILE" +%s 2>/dev/null || echo 0)))
    [ "$LOCK_AGE" -gt 300 ] && rm -f "$LOCKFILE" || { printf '%b' "[!] SafeProp masih jalan!\n"; exit 1; }
fi
printf '%s' $(date +%s) > "$LOCKFILE"

# --- Auto root ---
if [ "$(id -u)" != "0" ]; then
    printf '%b' "[!] Bukan root, re-eksekusi via su...\n"
    exec su -c "sh '$0'" "$@"
fi

# --- Warna (Hacker palette) ---
G='\e[0;32m'
BG='\e[01;32m'
C='\e[0;36m'
R='\e[01;31m'
Y='\e[01;33m'
W='\e[0;37m'
N='\e[0m'

# --- Global ---
DISPLAY_NAME=""

# --- Auto-detect device asli ---
DEVICE_CODE=$(getprop ro.product.device 2>/dev/null)
DEVICE_CODE=${DEVICE_CODE:-lavender}

DEVICE_SDK=$(getprop ro.build.version.sdk 2>/dev/null)
DEVICE_SDK=${DEVICE_SDK:-30}

DEVICE_RELEASE=$(getprop ro.build.version.release 2>/dev/null)
DEVICE_RELEASE=${DEVICE_RELEASE:-11}

DEVICE_HW=$(getprop ro.hardware 2>/dev/null)
DEVICE_HW=${DEVICE_HW:-qcom}

DEVICE_BOARD=$(getprop ro.board.platform 2>/dev/null)
DEVICE_BOARD=${DEVICE_BOARD:-sdm660}

DEVICE_FIRST_API=$(getprop ro.product.first_api_level 2>/dev/null)
DEVICE_FIRST_API=${DEVICE_FIRST_API:-28}

# --- Random generator (portable, bukan $RANDOM) ---
rand_num() {
    seed=$(od -An -tu4 -N4 /dev/urandom 2>/dev/null | tr -d ' ')
    [ -z "$seed" ] && seed=1
    echo $((seed % $1))
}

rand_hex() {
    dd if=/dev/urandom bs=64 count=1 2>/dev/null | od -An -tx1 | tr -d ' \n' | cut -c1-"$1"
}

rand_alnum() {
    dd if=/dev/urandom bs=128 count=1 2>/dev/null | tr -cd 'A-Za-z0-9' | cut -c1-"$1"
}

# --- Mode pesawat (NUCLEAR — 3 Layer) ---
modpeson(){
    # Kill VPN dulu (kill switch bisa block radio control)
    am force-stop com.surfshark.vpnclient.android 2>/dev/null
    am force-stop com.tunnel 2>/dev/null
    am force-stop net.openvpn.openvpn 2>/dev/null
    am force-stop free.vpn.secure.turbo.proxy.hotspot.vpnindonesia 2>/dev/null
    settings put global always_on_vpn_app "" 2>/dev/null
    sleep 1

    # LAYER 1: RADIO OFF
    ip link set wlan0 down 2>/dev/null
    svc bluetooth disable 2>/dev/null
    service call phone 3 i32 0 2>/dev/null
    for iface in rmnet0 rmnet1 rmnet2 rmnet_data0 rmnet_data1 rmnet_data2 rmnet_ipa0; do
        ip link set "$iface" down 2>/dev/null
    done
    svc nfc disable 2>/dev/null

    # LAYER 2: ROUTING TABLE KOSONG
    ip route flush table all 2>/dev/null
    ip route flush cache 2>/dev/null

    # LAYER 3: FIREWALL TOTAL
    iptables -P OUTPUT DROP 2>/dev/null
    ip6tables -P OUTPUT DROP 2>/dev/null

    settings put global airplane_mode_on 1 2>/dev/null
}

modpesoff(){
    # Setelah reboot, Android auto-restore semua.
    # iptables reset, routing rebuild, WiFi/BT/Data auto-on, RIL radio on.
    # Jadi gak perlu restore manual.
}

# --- Progress bar ---
progress() {
    pct="$1"; msg="$2"
    w=30
    filled=$((pct * w / 100))
    empty=$((w - filled))
    bar_f=""; bar_e=""
    i=0
    while [ $i -lt $filled ]; do
        bar_f="${bar_f}="
        i=$((i + 1))
    done
    i=0
    while [ $i -lt $empty ]; do
        bar_e="${bar_e}-"
        i=$((i + 1))
    done
    printf '\r  [%b%s%b%s] %3d%% %s' "$G" "$bar_f" "$W" "$bar_e" "$pct" "$msg"
}

anim_bar() {
    from="$1"; to="$2"; msg="$3"
    range=$((to - from))
    [ $range -le 0 ] && { progress "$to" "$msg"; return; }
    step=$((range / 5))
    [ $step -lt 1 ] && step=1
    p=$from
    while [ $p -lt $to ]; do
        progress "$p" "$msg"
        p=$((p + step))
    done
    progress "$to" "$msg"
}

# --- Bersih — 2-pass (STOP dulu, CLEAR kemudian) ---
bersih(){

    # ========== PASS 1: STOP SEMUA ==========

    am kill com.android.phone 2>/dev/null
    am force-stop com.android.phone 2>/dev/null

    # Stop semua tracking app (e-commerce, sosmed, browser, dll)
    for pkg in \
        com.google.android.gms com.google.android.gsf com.android.vending \
        com.android.chrome \
        com.lazada.android com.tokopedia.tkpd com.shopee.id \
        com.ss.android.ugc.trill com.zhiliaoapp.musically \
        com.lemon.lvoverseas \
        com.whatsapp com.whatsapp.w4b \
        jp.naver.line.android id.dana \
        com.facebook.katana com.facebook.orca com.facebook.lite \
        com.evo.browser org.mozilla.firefox com.brave.browser \
        com.kiwibrowser.browser org.chromium.chrome.stable \
        com.vivaldi.browser org.bromite.bromite mark.via.gp \
        com.sec.android.app.sbrowser \
        com.chrome.beta com.microsoft.emmx.beta com.microsoft.emmx.canary \
        net.upx.proxy.browser com.bharat.browser com.browser.tssomas \
        org.gologin.orbita com.google.android.fufufu.deviceid \
        free.vpn.secure.turbo.proxy.hotspot.vpnindonesia
    do
        am force-stop "$pkg" 2>/dev/null
    done

    # Stop WebView
    am force-stop com.android.webview 2>/dev/null

    # Stop system component
    for pkg in \
        com.android.location.fused \
        com.google.android.overlay.gmsconfig.common \
        com.google.android.overlay.gmsconfig.gsa \
        com.android.dialer \
        android.ext.services \
        com.android.ext.services \
        android.ext.shared \
        com.android.ext.shared \
        com.google.android.apps.wellbeing \
        com.android.wifi.resources \
        com.android.wifi.resources.xiaomi_$DEVICE_CODE \
        com.google.android.ims
    do
        am force-stop "$pkg" 2>/dev/null
    done

    # Stop Google apps tambahan (dari AcakTeMPeOPPO)
    for pkg in \
        com.google.android.gm \
        com.google.android.apps.photosgo \
        com.google.android.carriersetup \
        com.google.android.configupdater \
        com.google.android.gms.setup \
        com.google.android.inputmethod.latin \
        com.google.android.markup \
        com.google.android.projection.gearhead \
        com.google.android.soundpicker \
        com.google.android.syncadapters.calendar \
        com.google.android.syncadapters.contacts \
        com.google.android.apps.restore \
        com.google.android.apps.pixelmigrate \
        com.google.android.packageinstaller \
        com.google.android.setupwizard
    do
        am force-stop "$pkg" 2>/dev/null
    done

    # Stop system app tambahan (dari AcakTeMPeOPPO delete function)
    for pkg in \
        com.android.smspush \
        com.android.ime \
        com.android.defcontainer
    do
        am force-stop "$pkg" 2>/dev/null
    done

    # ========== PASS 2: CLEAR SEMUA ==========

    # Clear semua tracking app
    for pkg in \
        com.google.android.gms com.google.android.gsf com.android.vending \
        com.android.chrome \
        com.lazada.android com.tokopedia.tkpd com.shopee.id \
        com.ss.android.ugc.trill com.zhiliaoapp.musically \
        com.lemon.lvoverseas \
        com.whatsapp com.whatsapp.w4b \
        jp.naver.line.android id.dana \
        com.facebook.katana com.facebook.orca com.facebook.lite \
        com.evo.browser org.mozilla.firefox com.brave.browser \
        com.kiwibrowser.browser org.chromium.chrome.stable \
        com.vivaldi.browser org.bromite.bromite mark.via.gp \
        com.sec.android.app.sbrowser \
        com.chrome.beta com.microsoft.emmx.beta com.microsoft.emmx.canary \
        net.upx.proxy.browser com.bharat.browser com.browser.tssomas \
        org.gologin.orbita com.google.android.fufufu.deviceid \
        free.vpn.secure.turbo.proxy.hotspot.vpnindonesia
    do
        pm clear "$pkg" 2>/dev/null
    done

    # Clear WebView
    pm clear com.android.webview 2>/dev/null
    pm clear com.android.htmlviewer 2>/dev/null

    # Clear system component
    for pkg in \
        com.android.location.fused \
        com.google.android.overlay.gmsconfig.common \
        com.google.android.overlay.gmsconfig.gsa \
        com.android.dialer \
        android.ext.services \
        com.android.ext.services \
        android.ext.shared \
        com.android.ext.shared \
        com.google.android.apps.wellbeing \
        com.android.wifi.resources \
        com.android.wifi.resources.xiaomi_$DEVICE_CODE \
        com.google.android.ims
    do
        pm clear "$pkg" 2>/dev/null
    done

    # Clear Google apps tambahan (dari AcakTeMPeOPPO wipegms + ritual)
    for pkg in \
        com.google.android.gm \
        com.google.android.apps.photosgo \
        com.google.android.carriersetup \
        com.google.android.configupdater \
        com.google.android.gms.setup \
        com.google.android.inputmethod.latin \
        com.google.android.markup \
        com.google.android.projection.gearhead \
        com.google.android.soundpicker \
        com.google.android.syncadapters.calendar \
        com.google.android.syncadapters.contacts \
        com.google.android.apps.restore \
        com.google.android.apps.pixelmigrate \
        com.google.android.packageinstaller \
        com.google.android.setupwizard \
        com.android.localtransport \
        com.android.packageinstaller
    do
        pm clear "$pkg" 2>/dev/null
    done

    # Hapus data folder (backup kalau pm clear gagal)
    for pkg in \
        com.google.android.gms com.google.android.gsf com.android.vending \
        com.lazada.android com.tokopedia.tkpd com.shopee.id \
        com.ss.android.ugc.trill com.android.chrome id.dana \
        jp.naver.line.android \
        com.whatsapp com.whatsapp.w4b \
        com.lemon.lvoverseas com.facebook.katana
    do
        rm -rf /data/data/"$pkg"/* 2>/dev/null
        rm -rf /data/user/0/"$pkg"/* 2>/dev/null
        rm -rf /data/user_de/0/"$pkg"/* 2>/dev/null
    done

    # Dalvik-cache per-app
    for pkg in \
        com.lazada.android com.tokopedia.tkpd com.shopee.id \
        com.ss.android.ugc.trill com.zhiliaoapp.musically \
        com.lemon.lvoverseas com.whatsapp com.whatsapp.w4b \
        jp.naver.line.android id.dana com.facebook.katana \
        com.facebook.orca com.facebook.lite com.android.chrome \
        com.google.android.gms com.google.android.gsf com.android.vending
    do
        find /data/dalvik-cache/ -name "data@app@${pkg}*" -type f -delete 2>/dev/null
    done

    # Biometric & fingerprint
    rm -rf /data/system/users/0/fpdata
    rm -rf /data/system/users/0/registered_services

    # Cache & log
    rm -rf /data/system/appops/history/
    rm -rf /data/system/netstats/
    rm -rf /data/system/job/
    rm -rf /data/system/dropbox/*
    rm -rf /data/system/usagestats/*
    rm -rf /data/cache/*
    rm -rf /data/clipboard/*
    rm -rf /data/log/*
    rm -rf /data/tombstones/*
    rm -rf /data/last_alog /data/last_kmsg
    rm -f /data/*.log 2>/dev/null
    rm -rf /data/dalvik-cache/*.tmp

    # Cache & log tambahan (dari AcakTeMPeOPPO)
    rm -rf /data/dontpanic/*.tmp 2>/dev/null
    rm -rf /data/kernelpanics/*.tmp 2>/dev/null
    rm -rf /data/mlog/* 2>/dev/null
    rm -rf /data/backup/pending/*.tmp 2>/dev/null
    rm -rf /data/dalvik-cache/*.apk 2>/dev/null
    rm -rf /cache/*.apk 2>/dev/null
    rm -rf /cache/*.tmp 2>/dev/null

    # Sdcard nuke total
    rm -rf /storage/emulated/0/Android
    rm -rf /storage/emulated/0/.mixplorer
    rm -rf /storage/emulated/0/Pictures/*
    rm -rf /storage/emulated/0/LOST.DIR/*
    rm -rf /storage/emulated/0/WhatsApp
    rm -rf /storage/emulated/0/Tokopedia
    rm -rf /storage/emulated/0/shopeeID
    rm -rf /storage/emulated/0/Music
    rm -rf /storage/emulated/0/Musik
    rm -rf /storage/emulated/0/Movies
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
    rm -rf /storage/emulated/0/cache
    rm -rf /storage/emulated/0/.cri
    rm -rf /storage/emulated/0/NikGapps

    # Hapus folder kosong — kecuali folder sistem yang penting
    find /storage/emulated/0/ -mindepth 1 -maxdepth 1 -type d -empty \
        ! -name "Download" ! -name "DCIM" ! -name "Documents" \
        ! -name "Alarms" ! -name "Notifications" ! -name "Ringtones" \
        -delete 2>/dev/null

    # Hapus old system.prop
    for m in /data/adb/modules/xkatrina_snstv_prps \
             /data/adb/modules/MagiskProps \
             /data/adb/modules/MagiskHidePropsConf; do
        rm -f "$m/system.prop" "$m/post-fs-data.sh" 2>/dev/null
    done
}

# --- System.prop — 105 model ---
systemprops(){
    # Cari Magisk module path (3 slot)
    MOD1=""; MOD2=""; MOD3=""
    modcount=0
    for m in /data/adb/modules/xkatrina_snstv_prps /data/adb/modules/MagiskProps /data/adb/modules/MagiskHidePropsConf; do
        [ -d "$m" ] || mkdir -p "$m"
        modcount=$((modcount + 1))
        case $modcount in
            1) MOD1="$m" ;;
            2) MOD2="$m" ;;
            3) MOD3="$m" ;;
        esac
    done

    # Buat module.prop kalau belum ada
    for m in "$MOD1" "$MOD2" "$MOD3"; do
        if [ ! -f "$m/module.prop" ]; then
            cat > "$m/module.prop" << 'MODPROP'
id=safeprop
name=SafeProp Device Spoofer
version=7.0
versionCode=70
author=maung
description=Spoof device properties
MODPROP
        fi
    done

    # DRM disabler
    DRM_DIR=""
    for d in /data/adb/modules/magisk-drm-disabler /data/adb/modules/drm-disabler; do
        [ -d "$d" ] && DRM_DIR="$d" && break
    done

    # 105 model — Android 11, fingerprint real
    MODEL_DB="POCO F3 (Global)|Xiaomi|POCO|M2012K11AG|alioth|alioth_global|POCO/alioth_global/alioth:11/RKQ1.201125.002/V12.5.1.0.RKHMIXM:user/release-keys|2021-06-01|qcom
POCO X3 Pro (Global)|Xiaomi|POCO|M2102J20SG|vayu|vayu_global|POCO/vayu_global/vayu:11/RKQ1.200826.002/V12.5.1.0.RJUMIXM:user/release-keys|2021-05-01|qcom
POCO X3 GT (Global)|Xiaomi|POCO|21061110AG|chopin|chopin_global|POCO/chopin_global/chopin:11/RP1A.200720.011/V12.5.1.0.RKPMIXM:user/release-keys|2021-07-01|mt6893
POCO M3 Pro 5G (Global)|Xiaomi|POCO|M2103K19PG|camellia|camellia_global|POCO/camellia_global/camellia:11/RP1A.200720.011/V12.0.8.0.RKSMIXM:user/release-keys|2021-06-01|mt6833
POCO F4 (Global)|Xiaomi|POCO|22021211RG|munch|munch_global|POCO/munch_global/munch:11/RKQ1.211006.001/V13.0.1.0.SLMMIXM:user/release-keys|2022-05-01|qcom
POCO F2 Pro (Global)|Xiaomi|POCO|M2004J11G|lmi|lmi_global|POCO/lmi_global/lmi:11/RKQ1.200826.002/V12.2.1.0.RJKMIXM:user/release-keys|2021-02-01|qcom
POCO X3 NFC (Global)|Xiaomi|POCO|M2007J20CG|surya|surya_global|POCO/surya_global/surya:11/RKQ1.200826.002/V12.0.1.0.RJGMIXM:user/release-keys|2021-05-01|qcom
POCO M4 Pro 5G (Global)|Xiaomi|POCO|21091116AG|evergo|evergo_global|POCO/evergo_global/evergo:11/RP1A.200720.011/V12.5.2.0.RGBMIXM:user/release-keys|2021-11-01|mt6833
POCO M4 Pro 4G (Global)|Xiaomi|POCO|2201117PG|fleur|fleur_global|POCO/fleur_global/fleur:11/RP1A.200720.011/V13.0.3.0.RKEMIXM:user/release-keys|2022-02-01|qcom
POCO X4 Pro 5G (Global)|Xiaomi|POCO|2201116PG|veux|veux_global|POCO/veux_global/veux:11/RKQ1.211103.002/V13.0.1.0.RKCMIXM:user/release-keys|2022-03-01|qcom
POCO M2 Pro (India)|Xiaomi|POCO|M2003J6CI|gram|gramin|POCO/gramin/gram:11/RKQ1.200826.002/V12.0.1.0.RJPINXM:user/release-keys|2021-04-01|qcom
POCO X2 (India)|Xiaomi|POCO|M1912G7BI|phoenix|phoenixin|POCO/phoenixin/phoenix:11/RKQ1.200826.002/V12.1.2.0.RGHINXM:user/release-keys|2021-01-01|qcom
POCO M2 (India)|Xiaomi|POCO|M2004J19PI|shiva|shivain|POCO/shivain/shiva:11/RP1A.200720.011/V12.0.1.0.RJRINXM:user/release-keys|2021-05-01|qcom
POCO C3 (India)|Xiaomi|POCO|M2006C3MI|angelicain|angelicain|POCO/angelicain/angelicain:11/RP1A.200720.011/V12.0.3.0.RCPINXM:user/release-keys|2021-10-01|mt6765
POCO F3 GT (India)|Xiaomi|POCO|2104K10I|ares|aresin|POCO/aresin/ares:11/RP1A.200720.011/V12.5.4.0.RKJINXM:user/release-keys|2021-08-01|mt6893
Xiaomi Mi 11 (Global)|Xiaomi|Xiaomi|M2011K2G|venus|venus_global|Xiaomi/venus_global/venus:11/RKQ1.201105.002/V12.0.1.0.RKBMIXM:user/release-keys|2021-01-01|qcom
Xiaomi Mi 11 Ultra (Global)|Xiaomi|Xiaomi|M2102K1G|star|star_global|Xiaomi/star_global/star:11/RKQ1.201112.002/V12.0.1.0.RKAMIXM:user/release-keys|2021-04-01|qcom
Xiaomi 11T (Global)|Xiaomi|Xiaomi|21081111RG|agate|agate_global|Xiaomi/agate_global/agate:11/RP1A.200720.011/V12.5.2.0.RKWMIXM:user/release-keys|2021-09-01|mt6893
Xiaomi 11T Pro (Global)|Xiaomi|Xiaomi|2107113SG|vili|vili_global|Xiaomi/vili_global/vili:11/RKQ1.210503.001/V12.5.3.0.RKDMIXM:user/release-keys|2021-08-01|qcom
Xiaomi Mi 11 Lite 4G (Global)|Xiaomi|Xiaomi|M2101K9AG|courbet|courbet_global|Xiaomi/courbet_global/courbet:11/RKQ1.200826.002/V12.0.2.0.RKQMIXM:user/release-keys|2021-03-01|qcom
Xiaomi Mi 10T Pro (Global)|Xiaomi|Xiaomi|M2007J3SG|apollo|apollo_global|Xiaomi/apollo_global/apollo:11/RKQ1.200826.002/V12.1.2.0.RJDMIXM:user/release-keys|2021-02-01|qcom
Xiaomi Mi 10 (Global)|Xiaomi|Xiaomi|M2001J2G|umi|umi_global|Xiaomi/umi_global/umi:11/RKQ1.200826.002/V12.2.1.0.RJBMIXM:user/release-keys|2021-01-01|qcom
Xiaomi Mi 10 Pro (Global)|Xiaomi|Xiaomi|M2001J1G|cmi|cmi_global|Xiaomi/cmi_global/cmi:11/RKQ1.200826.002/V12.2.1.0.RJAMIXM:user/release-keys|2021-01-01|qcom
Xiaomi Pad 5 (Global)|Xiaomi|Xiaomi|21051182G|nabu|nabu_global|Xiaomi/nabu_global/nabu:11/RKQ1.201112.002/V12.5.8.0.RKXMIXM:user/release-keys|2021-12-01|qcom
Xiaomi Mi 11 Lite 5G (Global)|Xiaomi|Xiaomi|M2101K9G|renoir|renoir_global|Xiaomi/renoir_global/renoir:11/RKQ1.201112.002/V12.5.1.0.RKIMIXM:user/release-keys|2021-04-01|qcom
Redmi Note 10 Pro (Global)|Xiaomi|Redmi|M2101K6G|sweet|sweet_global|Redmi/sweet_global/sweet:11/RKQ1.200826.002/V12.5.1.0.RKFMIXM:user/release-keys|2021-05-01|qcom
Redmi Note 10 (Global)|Xiaomi|Redmi|M2101K7AG|mojito|mojito_global|Redmi/mojito_global/mojito:11/RKQ1.201022.002/V12.0.1.0.RKGMIXM:user/release-keys|2021-03-01|qcom
Redmi Note 11 (Global)|Xiaomi|Redmi|2201117TG|spes|spes_global|Redmi/spes_global/spes:11/RKQ1.211001.001/V13.0.1.0.RGCMIXM:user/release-keys|2022-01-01|qcom
Redmi 10 (Global)|Xiaomi|Redmi|21061119AG|selene|selene_global|Redmi/selene_global/selene:11/RP1A.200720.011/V12.5.1.0.RKUMIXM:user/release-keys|2021-08-01|mt6769
Redmi Note 9 Pro (Global)|Xiaomi|Redmi|M2003J6B2G|joyeuse|joyeuse_global|Redmi/joyeuse_global/joyeuse:11/RKQ1.200826.002/V12.0.1.0.RJZMIXM:user/release-keys|2021-02-01|qcom
Redmi 9 (Global)|Xiaomi|Redmi|M2004J19G|lancelot|lancelot_global|Redmi/lancelot_global/lancelot:11/RP1A.200720.011/V12.5.1.0.RJCMIXM:user/release-keys|2021-06-01|mt6769
Redmi 9T (Global)|Xiaomi|Redmi|M2010J19SY|lime|lime_global|Redmi/lime_global/lime:11/RKQ1.201004.002/V12.0.1.0.RJQMIXM:user/release-keys|2021-04-01|qcom
Redmi Note 10 5G (Global)|Xiaomi|Redmi|M2103K19G|camellian|camellian_global|Redmi/camellian_global/camellian:11/RP1A.200720.011/V12.0.2.0.RKSMIXM:user/release-keys|2021-05-01|mt6833
Redmi 10 Prime (India)|Xiaomi|Redmi|21061119BI|selene|selenein|Redmi/selenein/selene:11/RP1A.200720.011/V12.5.2.0.RKUINXM:user/release-keys|2021-09-01|mt6769
Redmi Note 8 2021 (Global)|Xiaomi|Redmi|21081111CI|biloba|biloba_global|Redmi/biloba_global/biloba:11/RP1A.200720.011/V12.5.1.0.RCUMIXM:user/release-keys|2021-07-01|mt6769
Samsung Galaxy S21 Ultra 5G|samsung|samsung|SM-G998B|p3s|p3sxxx|samsung/p3sxxx/p3s:11/RP1A.200720.012/G998BXXU1AUAC:user/release-keys|2021-01-01|qcom
Samsung Galaxy A52 (4G)|samsung|samsung|SM-A525F|a52q|a52qnsxx|samsung/a52qnsxx/a52q:11/RP1A.200720.012/A525FXXU1AUB6:user/release-keys|2021-03-01|qcom
Samsung Galaxy Note 20 Ultra|samsung|samsung|SM-N986B|c2s|c2sxxx|samsung/c2sxxx/c2s:11/RP1A.200720.012/N986BXXU1CTL1:user/release-keys|2021-01-01|qcom
Samsung Galaxy S20 FE|samsung|samsung|SM-G780F|r8s|r8sxxx|samsung/r8sxxx/r8s:11/RP1A.200720.012/G780FXXU1BTL1:user/release-keys|2021-01-01|qcom
Samsung Galaxy M51|samsung|samsung|SM-M515F|m51|m51nsxx|samsung/m51nsxx/m51:11/RP1A.200720.012/M515FXXU2BUC1:user/release-keys|2021-03-01|qcom
Samsung Galaxy S21 5G|samsung|samsung|SM-G991B|o1s|o1sxxx|samsung/o1sxxx/o1s:11/RP1A.200720.012/G991BXXU1AUAC:user/release-keys|2021-01-01|qcom
Samsung Galaxy A12|samsung|samsung|SM-A125F|a12|a12nsxx|samsung/a12nsxx/a12:11/RP1A.200720.012/A125FXXU1BUE3:user/release-keys|2021-05-01|mt6765
Samsung Galaxy S21+ 5G|samsung|samsung|SM-G996B|t2s|t2sxxx|samsung/t2sxxx/t2s:11/RP1A.200720.012/G996BXXU1AUAC:user/release-keys|2021-01-01|qcom
Samsung Galaxy A32 5G|samsung|samsung|SM-A326B|a32x|a32xxx|samsung/a32xxx/a32x:11/RP1A.200720.012/A326BXXU1AUB3:user/release-keys|2021-02-01|mt6853
Samsung Galaxy M12|samsung|samsung|SM-M127G|m12|m12nsxx|samsung/m12nsxx/m12:11/RP1A.200720.012/M127GXXU1AUE1:user/release-keys|2021-05-01|mt6765
OPPO Reno6 5G|OPPO|OPPO|CPH2251|OP52D1L1|CPH2251|oppo/CPH2251/OP52D1L1:11/RP1A.200720.011/16256789:user/release-keys|2021-07-01|mt6893
OPPO A74|OPPO|OPPO|CPH2219|OP4F7DL1|CPH2219|oppo/CPH2219/OP4F7DL1:11/RKQ1.201112.002/16154321:user/release-keys|2021-04-01|qcom
OPPO Reno5 5G|OPPO|OPPO|CPH2145|OP5111L1|CPH2145|oppo/CPH2145/OP5111L1:11/RKQ1.201105.002/16104433:user/release-keys|2021-01-01|qcom
OPPO A54|OPPO|OPPO|CPH2239|OP4F11L1|CPH2239|oppo/CPH2239/OP4F11L1:11/RP1A.200720.011/16167890:user/release-keys|2021-05-01|mt6765
OPPO F19 Pro|OPPO|OPPO|CPH2213|OP4F81L1|CPH2213|oppo/CPH2213/OP4F81L1:11/RP1A.200720.011/16145566:user/release-keys|2021-03-01|mt6769
OPPO Reno4 Pro|OPPO|OPPO|CPH2109|OP4E31L1|CPH2109|oppo/CPH2109/OP4E31L1:11/RKQ1.201112.002/16122233:user/release-keys|2021-02-01|qcom
OPPO A16|OPPO|OPPO|CPH2269|OP52C5L1|CPH2269|oppo/CPH2269/OP52C5L1:11/RP1A.200720.011/16233344:user/release-keys|2021-07-01|mt6765
OPPO Find X2|OPPO|OPPO|CPH2023|OP4B0BL1|CPH2023|oppo/CPH2023/OP4B0BL1:11/RKQ1.200903.002/16099900:user/release-keys|2021-01-01|qcom
OPPO Reno6 Z 5G|OPPO|OPPO|CPH2237|OP5267L1|CPH2237|oppo/CPH2237/OP5267L1:11/RP1A.200720.011/16211122:user/release-keys|2021-06-01|mt6853
OPPO K9 5G|OPPO|OPPO|PCLM10|PCLM10|PCLM10|oppo/PCLM10/PCLM10:11/RKQ1.201105.002/16133344:user/release-keys|2021-03-01|qcom
Realme GT Master Edition|realme|realme|RMX3360|RMX3360L1|RMX3360|realme/RMX3360/RMX3360L1:11/RKQ1.210503.001/16277788:user/release-keys|2021-08-01|qcom
Realme 8 (4G)|realme|realme|RMX3085|RMX3085L1|RMX3085|realme/RMX3085/RMX3085L1:11/RP1A.200720.011/16199988:user/release-keys|2021-05-01|qcom
Realme 7 Pro|realme|realme|RMX2170|RMX2170L1|RMX2170|realme/RMX2170/RMX2170L1:11/RKQ1.201112.002/16145566:user/release-keys|2021-03-01|qcom
Realme C25|realme|realme|RMX3191|RMX3191L1|RMX3191|realme/RMX3191/RMX3191L1:11/RP1A.200720.011/16167890:user/release-keys|2021-04-01|mt6769
Realme Narzo 30 Pro 5G|realme|realme|RMX2117|RMX2117L1|RMX2117|realme/RMX2117/RMX2117L1:11/RP1A.200720.011/16144433:user/release-keys|2021-03-01|mt6853
Realme GT Neo|realme|realme|RMX3031|RMX3031L1|RMX3031|realme/RMX3031/RMX3031L1:11/RP1A.200720.011/16166677:user/release-keys|2021-04-01|mt6893
Realme 8 5G|realme|realme|RMX3241|RMX3241L1|RMX3241|realme/RMX3241/RMX3241L1:11/RP1A.200720.011/16188899:user/release-keys|2021-05-01|qcom
Realme C21|realme|realme|RMX3201|RMX3201L1|RMX3201|realme/RMX3201/RMX3201L1:11/RP1A.200720.011/16177700:user/release-keys|2021-04-01|mt6765
Realme X7 Pro 5G|realme|realme|RMX2121|RMX2121L1|RMX2121|realme/RMX2121/RMX2121L1:11/RP1A.200720.011/16122211:user/release-keys|2021-02-01|mt6885
Realme V13 5G|realme|realme|RMX3041|RMX3041|RMX3041|realme/RMX3041/RMX3041:11/RP1A.200720.011/16155566:user/release-keys|2021-04-01|mt6833
Infinix Note 10 Pro|Infinix|Infinix|Infinix X695|Infinix-X695|X695-GL|Infinix/X695-GL/Infinix-X695:11/RP1A.200720.011/210519V322:user/release-keys|2021-05-01|mt6769
Infinix Hot 11s NFC|Infinix|Infinix|Infinix X6812B|Infinix-X6812B|X6812B-GL|Infinix/X6812B-GL/Infinix-X6812B:11/RP1A.200720.011/210915V437:user/release-keys|2021-09-01|mt6769
Infinix Zero X Pro|Infinix|Infinix|Infinix X6811|Infinix-X6811|X6811-GL|Infinix/X6811-GL/Infinix-X6811:11/RP1A.200720.011/210822V110:user/release-keys|2021-08-01|mt6769
Infinix Smart 5|Infinix|Infinix|Infinix X657C|Infinix-X657C|X657C-GL|Infinix/X657C-GL/Infinix-X657C:11/RP1A.200720.011/210330V123:user/release-keys|2021-03-01|mt6765
Infinix Note 11 Pro|Infinix|Infinix|Infinix X671|Infinix-X671|X671-GL|Infinix/X671-GL/Infinix-X671:11/RP1A.200720.011/211025V456:user/release-keys|2021-10-01|mt6769
Vivo V21 5G|vivo|vivo|V2050|PD2083F|PD2083F|vivo/PD2083F/PD2083F:11/RP1A.200720.011/compilation:user/release-keys|2021-05-01|mt6853
Vivo Y53s|vivo|vivo|V2058|PD2103F|PD2103F|vivo/PD2103F/PD2103F:11/RP1A.200720.011/compilation:user/release-keys|2021-06-01|mt6833
Vivo X60 Pro+|vivo|vivo|V2056A|PD2056|PD2056|vivo/PD2056/PD2056:11/RKQ1.201105.002/compilation:user/release-keys|2021-01-01|qcom
Vivo Y21|vivo|vivo|V2111|PD2139F|PD2139F|vivo/PD2139F/PD2139F:11/RP1A.200720.011/compilation:user/release-keys|2021-08-01|mt6765
Vivo T1 5G|vivo|vivo|V2141|PD2165F|PD2165F|vivo/PD2165F/PD2165F:11/RKQ1.211119.001/compilation:user/release-keys|2021-11-01|qcom
Asus ROG Phone 5|asus|asus|ASUS_I005D|ASUS_I005D|WW_I005D|asus/WW_I005D/ASUS_I005D:11/RKQ1.201022.002/18.0840.2103.26:user/release-keys|2021-03-01|qcom
Asus ZenFone 8|asus|asus|ASUS_I006D|ASUS_I006D|WW_I006D|asus/WW_I006D/ASUS_I006D:11/RKQ1.201022.002/18.0610.2104.127:user/release-keys|2021-04-01|qcom
Asus ZenFone 7 Pro|asus|asus|ASUS_I002D|ASUS_I002D|WW_I002D|asus/WW_I002D/ASUS_I002D:11/RKQ1.201022.002/30.40.30.93:user/release-keys|2021-02-01|qcom
Asus ROG Phone 3|asus|asus|ASUS_I003D|ASUS_I003D|WW_I003D|asus/WW_I003D/ASUS_I003D:11/RKQ1.201022.002/18.0410.2102.112:user/release-keys|2021-02-01|qcom
Asus ZenFone 8 Flip|asus|asus|ASUS_I004D|ASUS_I004D|WW_I004D|asus/WW_I004D/ASUS_I004D:11/RKQ1.201022.002/18.0840.2106.86:user/release-keys|2021-06-01|qcom
Google Pixel 5|Google|google|Pixel 5|redfin|redfin|google/redfin/redfin:11/RQ3A.210805.001.A1/7474174:user/release-keys|2021-08-01|qcom
Google Pixel 4a (5G)|Google|google|Pixel 4a (5G)|bramble|bramble|google/bramble/bramble:11/RQ3A.211001.001/7641976:user/release-keys|2021-10-01|qcom
Google Pixel 4 XL|Google|google|Pixel 4 XL|coral|coral|google/coral/coral:11/RP1A.201105.002/6869234:user/release-keys|2020-11-01|qcom
Google Pixel 4|Google|google|Pixel 4|flame|flame|google/flame/flame:11/RP1A.201005.004/6783344:user/release-keys|2020-10-01|qcom
Google Pixel 3a XL|Google|google|Pixel 3a XL|bonito|bonito|google/bonito/bonito:11/RQ3A.210805.001/7474174:user/release-keys|2021-08-01|qcom
OnePlus 9 Pro|OnePlus|OnePlus|LE2123|OnePlus9Pro|OnePlus9Pro|OnePlus/OnePlus9Pro_EEA/OnePlus9Pro:11/RKQ1.201105.002/2103072000:user/release-keys|2021-03-01|qcom
OnePlus Nord 2 5G|OnePlus|OnePlus|DN2103|OnePlusNord2|OnePlusNord2|OnePlus/OnePlusNord2/OnePlusNord2:11/RP1A.200720.011/2107122200:user/release-keys|2021-07-01|mt6893
OnePlus 8T|OnePlus|OnePlus|KB2003|OnePlus8T|OnePlus8T|OnePlus/OnePlus8T/OnePlus8T:11/RP1A.200720.011/2010151100:user/release-keys|2020-10-01|qcom
OnePlus Nord CE 5G|OnePlus|OnePlus|EB2103|OnePlusNordCE|OnePlusNordCE|OnePlus/OnePlusNordCE/OnePlusNordCE:11/RKQ1.201112.002/2105251800:user/release-keys|2021-05-01|qcom
OnePlus 9R|OnePlus|OnePlus|LE2101|OnePlus9R|OnePlus9R|OnePlus/OnePlus9R/OnePlus9R:11/RKQ1.201105.002/2104081600:user/release-keys|2021-04-01|qcom
Advan GX|ADVAN|ADVAN|Advan_GX|Advan_GX|Advan_GX|ADVAN/Advan_GX/Advan_GX:11/RP1A.201005.001/20210712:user/release-keys|2021-07-01|mt6769
Advan Tab VX|ADVAN|ADVAN|Advan_VX|Advan_VX|Advan_VX|ADVAN/Advan_VX/Advan_VX:11/RP1A.201005.001/20211115:user/release-keys|2021-11-01|mt6765
Advan G9 Plus|ADVAN|ADVAN|G9_Plus|G9_Plus|G9_Plus|ADVAN/G9_Plus/G9_Plus:11/RP1A.201005.001/20210325:user/release-keys|2021-03-01|mt6769
Advan G5 Plus|ADVAN|ADVAN|G5_Plus|G5_Plus|G5_Plus|ADVAN/G5_Plus/G5_Plus:11/RP1A.201005.001/20210610:user/release-keys|2021-06-01|mt6765
Advan Tab Sketsa 2|ADVAN|ADVAN|Sketsa_2|Sketsa_2|Sketsa_2|ADVAN/Sketsa_2/Sketsa_2:11/RP1A.201005.001/20220120:user/release-keys|2022-01-01|mt6769
Tecno Pova 2|TECNO|TECNO|TECNO LE7|TECNO-LE7|LE7-GL|TECNO/LE7-GL/TECNO-LE7:11/RP1A.200720.011/210515V391:user/release-keys|2021-05-01|mt6769
Tecno Camon 17 Pro|TECNO|TECNO|TECNO CG8|TECNO-CG8|CG8-GL|TECNO/CG8-GL/TECNO-CG8:11/RP1A.200720.011/210420V182:user/release-keys|2021-04-01|mt6769
Tecno Spark 7 Pro|TECNO|TECNO|TECNO KF8|TECNO-KF8|KF8-GL|TECNO/KF8-GL/TECNO-KF8:11/RP1A.200720.011/210325V110:user/release-keys|2021-03-01|mt6769
Tecno Spark 8C|TECNO|TECNO|TECNO KG5|TECNO-KG5|KG8-GL|TECNO/KG8-GL/TECNO-KG8:11/RP1A.200720.011/220105V045:user/release-keys|2022-01-01|ums512
Tecno Pova Neo|TECNO|TECNO|TECNO LE6|TECNO-LE6|LE6-GL|TECNO/LE6-GL/TECNO-LE6:11/RP1A.200720.011/211012V254:user/release-keys|2021-10-01|mt6769
ZTE Blade V30|ZTE|ZTE|ZTE V2022|P610|ZTE_V2022_GL|ZTE/ZTE_V2022_GL/P610:11/RP1A.201005.001/20210615:user/release-keys|2021-06-01|ums512
ZTE Axon 30 Ultra|ZTE|ZTE|A2022P|A2022P|A2022P_GL|ZTE/A2022P_GL/A2022P:11/RKQ1.201105.002/20210710:user/release-keys|2021-07-01|qcom
ZTE Blade A71|ZTE|ZTE|ZTE A7030|P605|ZTE_A7030_GL|ZTE/ZTE_A7030_GL/P605:11/RP1A.201005.001/20210520:user/release-keys|2021-05-01|ums512
ZTE Blade A51|ZTE|ZTE|ZTE A51|P603|ZTE_A51_GL|ZTE/ZTE_A51_GL/P603:11/RP1A.201005.001/20210412:user/release-keys|2021-04-01|ums512
RedMagic 6|nubia|nubia|NX669J|NX669J|NX669J_GL|nubia/NX669J_GL/NX669J:11/RKQ1.210608.001/V3.08:user/release-keys|2021-06-01|qcom"

    # Random pick
    TOTAL=$(printf '%s\n' "$MODEL_DB" | wc -l)
    RNUM=$(rand_num "$TOTAL")
    RNUM=$((RNUM + 1))
    pick=$(printf '%s\n' "$MODEL_DB" | sed -n "${RNUM}p")

    # Fallback
    [ -z "$pick" ] && pick=$(printf '%s\n' "$MODEL_DB" | head -1)

    # Parse
    display_name=$(printf '%s' "$pick" | cut -d'|' -f1)
    manuc=$(printf '%s' "$pick" | cut -d'|' -f2)
    brand=$(printf '%s' "$pick" | cut -d'|' -f3)
    model=$(printf '%s' "$pick" | cut -d'|' -f4)
    device=$(printf '%s' "$pick" | cut -d'|' -f5)
    fingerprint=$(printf '%s' "$pick" | cut -d'|' -f7)
    security_patch=$(printf '%s' "$pick" | cut -d'|' -f8)

    # Set global
    DISPLAY_NAME="$display_name"

    # Build info
    build_id=$(printf '%s' "$fingerprint" | cut -d'/' -f4)
    build_type=$(printf '%s' "$fingerprint" | cut -d'/' -f5 | cut -d':' -f2)
    build_tags=$(printf '%s' "$fingerprint" | cut -d'/' -f6)
    build_display="$build_id"
    [ -z "$build_type" ] && build_type="user"
    [ -z "$build_tags" ] && build_tags="release-keys"

    BOOTLOADER=$(rand_alnum 10)

    case "$brand" in
        Xiaomi|POCO|Redmi) build_user="builder"; build_host="build.miui.com" ;;
        samsung) build_user="dpi"; build_host=$(rand_alnum 8) ;;
        google|Google) build_user="android-build"; build_host="abfarm-$(rand_alnum 5)" ;;
        OPPO|realme|vivo) build_user="release"; build_host=$(rand_alnum 10) ;;
        *) build_user="builder"; build_host="build.server" ;;
    esac

    # Tulis system.prop
    dir=/data/local/tmp/system.prop
    rm -f "$dir"

    cat > "$dir" << PROPS
# SafeProp v7.0 — Generated $(date +%Y-%m-%d)
# Device: $display_name

# Model
ro.product.model=$model
ro.product.system.model=$model
ro.product.vendor.model=$model
ro.product.product.model=$model
ro.product.odm.model=$model
ro.product.system_ext.model=$model

# Manufacturer
ro.product.manufacturer=$manuc
ro.product.system.manufacturer=$manuc
ro.product.vendor.manufacturer=$manuc
ro.product.product.manufacturer=$manuc
ro.product.odm.manufacturer=$manuc
ro.product.system_ext.manufacturer=$manuc

# Brand
ro.product.brand=$brand
ro.product.system.brand=$brand
ro.product.vendor.brand=$brand
ro.product.product.brand=$brand
ro.product.odm.brand=$brand
ro.product.system_ext.brand=$brand

# Build version
ro.build.version.release=$DEVICE_RELEASE
ro.system.build.version.release=$DEVICE_RELEASE
ro.vendor.build.version.release=$DEVICE_RELEASE
ro.product.build.version.release=$DEVICE_RELEASE
ro.odm.build.version.release=$DEVICE_RELEASE
ro.system_ext.build.version.release=$DEVICE_RELEASE
ro.build.version.sdk=$DEVICE_SDK
ro.build.version.codename=REL
ro.product.first_api_level=$DEVICE_FIRST_API
ro.build.version.security_patch=$security_patch

# Boot state
ro.boot.verifiedbootstate=green
ro.boot.flash.locked=1
vendor.boot.verifiedbootstate=green
ro.boot.veritymode=enforcing
vendor.boot.vbmeta.device_state=locked

# Security
ro.build.type=$build_type
ro.build.tags=$build_tags
ro.debuggable=0
ro.secure=1
ro.adb.secure=1

# Build info
ro.build.id=$build_id
ro.build.display.id=$build_display
ro.build.user=$build_user
ro.build.host=$build_host
ro.build.fingerprint=$fingerprint
ro.system.build.fingerprint=$fingerprint
ro.vendor.build.fingerprint=$fingerprint
ro.product.build.fingerprint=$fingerprint
ro.odm.build.fingerprint=$fingerprint
ro.bootloader=$BOOTLOADER

# Hardware (asli — JANGAN override!)
ro.hardware=$DEVICE_HW
ro.product.board=$device
ro.board.platform=$DEVICE_BOARD
ro.build.product=$device
ro.build.flavor=$device-user
PROPS

    # Copy ke Magisk module
    cp -f "$dir" "$MOD1/system.prop" 2>/dev/null
    cp -f "$dir" "$MOD2/system.prop" 2>/dev/null
    cp -f "$dir" "$MOD3/system.prop" 2>/dev/null
    [ -n "$DRM_DIR" ] && cp -f "$dir" "$DRM_DIR/system.prop" 2>/dev/null

    # BT name + device name + advertising_id + android_id
    BTNAME=$(dd if=/dev/urandom bs=64 count=1 2>/dev/null | tr -cd 'A-Z' | cut -c -1)$(dd if=/dev/urandom bs=64 count=1 2>/dev/null | tr -cd 'aeiou' | cut -c -1)$(dd if=/dev/urandom bs=64 count=1 2>/dev/null | tr -cd 'bcdfghjklmnpqrstvwxyz' | cut -c -1)$(dd if=/dev/urandom bs=64 count=1 2>/dev/null | tr -cd 'aeiou' | cut -c -1)$(dd if=/dev/urandom bs=64 count=1 2>/dev/null | tr -cd 'bcdfghjklmnpqrstvwxyz' | cut -c -1)$(dd if=/dev/urandom bs=64 count=1 2>/dev/null | tr -cd 'aeiou' | cut -c -1)
    NEWNAME="$BTNAME $display_name"

    settings put secure bluetooth_name "$NEWNAME" 2>/dev/null
    settings put global device_name "$display_name" 2>/dev/null
    settings delete secure advertising_id 2>/dev/null
    settings delete secure android_id 2>/dev/null

    # Backup ke bt_config.conf
    if [ -f /data/misc/bluedroid/bt_config.conf ]; then
        sed -i '/[Nn]ame *=/d' /data/misc/bluedroid/bt_config.conf
        printf 'Name = %s\n' "$NEWNAME" >> /data/misc/bluedroid/bt_config.conf
    fi

    # Fallback XML edit (dari AcakTeMPeOPPO)
    FUBTNAME=$(grep -n bluetooth_name /data/system/users/0/settings_secure.xml 2>/dev/null | grep -o 'value=".*"*' | cut -d '"' -f2)
    FUDVNAME=$(grep -n device_name /data/system/users/0/settings_global.xml 2>/dev/null | grep -o 'value=".*"*' | cut -d '"' -f2)

    # Edit settings_secure.xml
    if [ -n "$FUBTNAME" ]; then
        sed -i "s/$FUBTNAME/$NEWNAME/g" /data/system/users/0/settings_secure.xml 2>/dev/null
    fi
    # Edit fallback
    if [ -f /data/system/users/0/settings_secure.xml.fallback ]; then
        FUBTNAMEFB=$(grep -n bluetooth_name /data/system/users/0/settings_secure.xml.fallback 2>/dev/null | grep -o 'value=".*"*' | cut -d '"' -f2)
        [ -n "$FUBTNAMEFB" ] && sed -i "s/$FUBTNAMEFB/$NEWNAME/g" /data/system/users/0/settings_secure.xml.fallback 2>/dev/null
    fi

    # Edit settings_global.xml
    if [ -n "$FUDVNAME" ]; then
        sed -i "s/$FUDVNAME/$display_name/g" /data/system/users/0/settings_global.xml 2>/dev/null
    fi
    # Edit fallback
    if [ -f /data/system/users/0/settings_global.xml.fallback ]; then
        FUDVNAMEFB=$(grep -n device_name /data/system/users/0/settings_global.xml.fallback 2>/dev/null | grep -o 'value=".*"*' | cut -d '"' -f2)
        [ -n "$FUDVNAMEFB" ] && sed -i "s/$FUDVNAMEFB/$NEWNAME/g" /data/system/users/0/settings_global.xml.fallback 2>/dev/null
    fi

    # Copy prop ke DRM disabler module
    for SCRIPTS_FILE in /data/adb/modules/xkatrina_snstv_prps/system.prop /data/adb/modules/MagiskProps/system.prop; do
        if [ -f "$SCRIPTS_FILE" ]; then
            cp -f "$SCRIPTS_FILE" /data/adb/modules/magisk-drm-disabler/system.prop 2>/dev/null
            break
        fi
    done

    # MAC randomization
    settings put global wifi_connected_mac_randomization_enabled 1 2>/dev/null
}

# --- SSAID Randomize — value (dari AcakTeMPeOPPO acak1) ---
# Target: 9 paket tracking utama (sama dengan acak2)
acak1() {
    SSAID_FILE="/data/system/users/0/settings_ssaid.xml"
    [ ! -f "$SSAID_FILE" ] && return

    IDKEY=$(grep -n "userkey" "$SSAID_FILE" | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
    [ -z "$IDKEY" ] && return

    # Randomize value untuk app tracking (9 target)
    _a1_gms=$(grep -n "com.google.android.gms" "$SSAID_FILE" | grep -o 'value=".*"*' | cut -d '"' -f2)
    _a1_vending=$(grep -n "com.android.vending" "$SSAID_FILE" | grep -o 'value=".*"*' | cut -d '"' -f2)
    _a1_lazada=$(grep -n "com.lazada.android" "$SSAID_FILE" | grep -o 'value=".*"*' | cut -d '"' -f2)
    _a1_tokopedia=$(grep -n "com.tokopedia.tkpd" "$SSAID_FILE" | grep -o 'value=".*"*' | cut -d '"' -f2)
    _a1_shopee=$(grep -n "com.shopee.id" "$SSAID_FILE" | grep -o 'value=".*"*' | cut -d '"' -f2)
    _a1_trill=$(grep -n "com.ss.android.ugc.trill" "$SSAID_FILE" | grep -o 'value=".*"*' | cut -d '"' -f2)
    _a1_tiktok=$(grep -n "com.zhiliaoapp.musically" "$SSAID_FILE" | grep -o 'value=".*"*' | cut -d '"' -f2)
    _a1_chrome=$(grep -n "com.android.chrome" "$SSAID_FILE" | grep -o 'value=".*"*' | cut -d '"' -f2)
    _a1_dana=$(grep -n "id.dana" "$SSAID_FILE" | grep -o 'value=".*"*' | cut -d '"' -f2)

    # Generate random 16-char hex dari IDKEY charset
    _a1_r_gms=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a1_r_vending=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a1_r_lazada=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a1_r_tokopedia=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a1_r_shopee=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a1_r_trill=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a1_r_tiktok=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a1_r_chrome=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a1_r_dana=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)

    [ -n "$_a1_gms" ] && sed -i "s/$_a1_gms/$_a1_r_gms/g" "$SSAID_FILE"
    [ -n "$_a1_vending" ] && sed -i "s/$_a1_vending/$_a1_r_vending/g" "$SSAID_FILE"
    [ -n "$_a1_lazada" ] && sed -i "s/$_a1_lazada/$_a1_r_lazada/g" "$SSAID_FILE"
    [ -n "$_a1_tokopedia" ] && sed -i "s/$_a1_tokopedia/$_a1_r_tokopedia/g" "$SSAID_FILE"
    [ -n "$_a1_shopee" ] && sed -i "s/$_a1_shopee/$_a1_r_shopee/g" "$SSAID_FILE"
    [ -n "$_a1_trill" ] && sed -i "s/$_a1_trill/$_a1_r_trill/g" "$SSAID_FILE"
    [ -n "$_a1_tiktok" ] && sed -i "s/$_a1_tiktok/$_a1_r_tiktok/g" "$SSAID_FILE"
    [ -n "$_a1_chrome" ] && sed -i "s/$_a1_chrome/$_a1_r_chrome/g" "$SSAID_FILE"
    [ -n "$_a1_dana" ] && sed -i "s/$_a1_dana/$_a1_r_dana/g" "$SSAID_FILE"
}

# --- SSAID Randomize — defaultValue (dari AcakTeMPeOPPO acak2) ---
# Target: 9 paket tracking utama (sama dengan acak1)
acak2() {
    SSAID_FILE="/data/system/users/0/settings_ssaid.xml"
    [ ! -f "$SSAID_FILE" ] && return

    IDKEY=$(grep -n "userkey" "$SSAID_FILE" | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
    [ -z "$IDKEY" ] && return

    # Randomize defaultValue untuk app tracking (9 target)
    _a2_gms=$(grep -n "com.google.android.gms" "$SSAID_FILE" | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
    _a2_vending=$(grep -n "com.android.vending" "$SSAID_FILE" | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
    _a2_lazada=$(grep -n "com.lazada.android" "$SSAID_FILE" | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
    _a2_tokopedia=$(grep -n "com.tokopedia.tkpd" "$SSAID_FILE" | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
    _a2_shopee=$(grep -n "com.shopee.id" "$SSAID_FILE" | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
    _a2_trill=$(grep -n "com.ss.android.ugc.trill" "$SSAID_FILE" | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
    _a2_tiktok=$(grep -n "com.zhiliaoapp.musically" "$SSAID_FILE" | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
    _a2_chrome=$(grep -n "com.android.chrome" "$SSAID_FILE" | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)
    _a2_dana=$(grep -n "id.dana" "$SSAID_FILE" | grep -o 'defaultValue=".*"*' | cut -d '"' -f2)

    # Generate random 16-char hex dari IDKEY charset
    _a2_r_gms=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a2_r_vending=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a2_r_lazada=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a2_r_tokopedia=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a2_r_shopee=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a2_r_trill=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a2_r_tiktok=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a2_r_chrome=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)
    _a2_r_dana=$(head -3 /dev/urandom | tr -cd "$IDKEY" | cut -c -16)

    [ -n "$_a2_gms" ] && sed -i "s/$_a2_gms/$_a2_r_gms/g" "$SSAID_FILE"
    [ -n "$_a2_vending" ] && sed -i "s/$_a2_vending/$_a2_r_vending/g" "$SSAID_FILE"
    [ -n "$_a2_lazada" ] && sed -i "s/$_a2_lazada/$_a2_r_lazada/g" "$SSAID_FILE"
    [ -n "$_a2_tokopedia" ] && sed -i "s/$_a2_tokopedia/$_a2_r_tokopedia/g" "$SSAID_FILE"
    [ -n "$_a2_shopee" ] && sed -i "s/$_a2_shopee/$_a2_r_shopee/g" "$SSAID_FILE"
    [ -n "$_a2_trill" ] && sed -i "s/$_a2_trill/$_a2_r_trill/g" "$SSAID_FILE"
    [ -n "$_a2_tiktok" ] && sed -i "s/$_a2_tiktok/$_a2_r_tiktok/g" "$SSAID_FILE"
    [ -n "$_a2_chrome" ] && sed -i "s/$_a2_chrome/$_a2_r_chrome/g" "$SSAID_FILE"
    [ -n "$_a2_dana" ] && sed -i "s/$_a2_dana/$_a2_r_dana/g" "$SSAID_FILE"
}

# --- Acak serial ---
acakserial(){
    CONF="/data/adb/mhpc/propsconf_late"
    [ ! -f "$CONF" ] && return
    IDRANDOM=$(rand_hex 12)
    SERIAL=$(grep -i "CUSTOMPROPSPOST" "$CONF" | grep -i "ro.serialno=" | cut -d '"' -f2 | cut -d '=' -f2)
    SERIAL2=$(grep -i "CUSTOMPROPSLATE" "$CONF" | grep -i "ro.serialno=" | cut -d '"' -f2 | cut -d '=' -f2)
    [ -n "$SERIAL" ] && sed -i "s|$SERIAL|$IDRANDOM|g" "$CONF"
    [ -n "$SERIAL2" ] && sed -i "s|$SERIAL2|$IDRANDOM|g" "$CONF"
}

# --- RITUAL AGRESIF (dari AcakTeMPeOPPO — full purge sebelum reboot) ---
# Fungsi ini dipanggil SETELAH semua step lain selesai
# Tujuan: nuke semua sisa jejak yang masih tersisa
ritual(){

    # === PASS 1: STOP ULANG (pastikan semua mati) ===
    am force-stop com.ss.android.ugc.trill 2>/dev/null
    am force-stop org.chromium.chrome.stable 2>/dev/null
    am force-stop com.lazada.android 2>/dev/null
    am force-stop com.tokopedia.tkpd 2>/dev/null
    am force-stop com.android.chrome 2>/dev/null
    am force-stop com.google.android.overlay.gmsconfig.common 2>/dev/null
    am force-stop com.google.android.overlay.gmsconfig.gsa 2>/dev/null
    am force-stop com.google.android.apps.wellbeing 2>/dev/null
    am force-stop com.google.android.gms 2>/dev/null
    am force-stop com.google.android.gsf 2>/dev/null
    am force-stop com.android.vending 2>/dev/null
    am force-stop jp.naver.line.android 2>/dev/null
    am force-stop com.facebook.katana 2>/dev/null
    am force-stop free.vpn.secure.turbo.proxy.hotspot.vpnindonesia 2>/dev/null

    # === PASS 2: CLEAR ULANG (second sweep) ===
    pm clear com.ss.android.ugc.trill 2>/dev/null
    pm clear com.lazada.android 2>/dev/null
    pm clear com.tokopedia.tkpd 2>/dev/null
    pm clear org.chromium.chrome.stable 2>/dev/null
    pm clear com.android.location.fused 2>/dev/null
    pm clear com.android.chrome 2>/dev/null
    pm clear jp.naver.line.android 2>/dev/null
    pm clear com.facebook.katana 2>/dev/null
    pm clear free.vpn.secure.turbo.proxy.hotspot.vpnindonesia 2>/dev/null
    pm clear com.google.android.overlay.gmsconfig.common 2>/dev/null
    pm clear com.google.android.overlay.gmsconfig.gsa 2>/dev/null
    pm clear com.google.android.apps.wellbeing 2>/dev/null
    pm clear com.google.android.gms 2>/dev/null
    pm clear com.google.android.gsf 2>/dev/null
    pm clear com.google.android.ims 2>/dev/null
    pm clear com.android.vending 2>/dev/null
    pm clear com.android.webview 2>/dev/null

    # === PASS 3: NUJEK SEMUA SISA DATA ===

    # Storage — semua mount point
    rm -rf /storage/*-*/Android 2>/dev/null
    rm -rf /storage/emulated/0/.mixplorer 2>/dev/null
    rm -rf /storage/emulated/0/Android 2>/dev/null
    rm -rf /storage/emulated/0/data 2>/dev/null
    rm -rf /storage/emulated/0/Pictures 2>/dev/null
    rm -rf /storage/emulated/0/.cri 2>/dev/null
    rm -rf /storage/emulated/0/LOST.DIR/* 2>/dev/null

    # System tracking files
    rm -rf /data/system/appops/history/ 2>/dev/null
    rm -rf /data/system/netstats/ 2>/dev/null
    rm -rf /data/system/job/ 2>/dev/null
    rm -rf /data/system/users/0/fpdata 2>/dev/null
    rm -rf /data/system/users/0/registered_services 2>/dev/null
    rm -rf /data/system/users/0/package-restrictions.xml 2>/dev/null
    rm -rf /data/system/users/0/settings_ssaid.xml 2>/dev/null
    rm -rf /data/system/users/0/app_idle_stats.xml 2>/dev/null
    rm -rf /data/system/users/0/settings_config.xml 2>/dev/null
    rm -f /data/system/users/0/*.fallback 2>/dev/null

    # Data folder — deep wipe semua sisa
    for pkg in \
        com.android.location.fused \
        com.google.android.gms \
        com.google.android.gsf \
        com.lazada.android \
        android.auto_generated_rro_vendor__ \
        android.ext.services \
        android.ext.shared \
        com.android.backupconfirm \
        com.android.bips \
        com.android.bluetooth \
        com.android.bluetoothmidiservice \
        com.android.bookmarkprovider \
        com.android.calendar \
        com.android.carrierconfig \
        com.android.carrierconfig.auto_generated_rro_vendor__ \
        com.android.htmlviewer \
        com.android.webview
    do
        rm -rf /data/data/"$pkg"/* 2>/dev/null
        rm -rf /data/user/0/"$pkg"/* 2>/dev/null
        rm -rf /data/user_de/0/"$pkg"/* 2>/dev/null
    done

    # Google apps data folder deep wipe
    for pkg in \
        com.google.android.gms \
        com.google.android.gsf \
        com.lazada.android \
        com.tokopedia.tkpd \
        com.shopee.id \
        com.ss.android.ugc.trill \
        com.android.chrome \
        id.dana \
        jp.naver.line.android \
        com.whatsapp \
        com.whatsapp.w4b \
        com.lemon.lvoverseas \
        com.facebook.katana
    do
        rm -rf /data/user/0/"$pkg"/* 2>/dev/null
    done

    # Dalvik-cache total wipe
    rm -rf /data/dalvik-cache/ 2>/dev/null
    rm -rf /data/cache/ 2>/dev/null

    # Akun database
    rm -f /data/system_ce/0/accounts_ce.db* 2>/dev/null
    rm -f /data/system_de/0/accounts_de.db* 2>/dev/null

    # Hapus folder kosong di sdcard
    find /storage/emulated/0/ -mindepth 1 -maxdepth 1 -type d -empty -delete 2>/dev/null
}

# --- Nuke tracking — dipanggil sesaat sebelum reboot ---
nuketrack(){
    rm -f /data/system/users/0/settings_ssaid.xml 2>/dev/null
    rm -f /data/system/users/0/package-restrictions.xml 2>/dev/null
    rm -f /data/system/users/0/settings_config.xml 2>/dev/null
    rm -f /data/system/users/0/app_idle_stats.xml 2>/dev/null
    rm -f /data/system/users/0/*.fallback 2>/dev/null
    rm -f /data/system_ce/0/accounts_ce.db* 2>/dev/null
    rm -f /data/system_de/0/accounts_de.db* 2>/dev/null
}

# ============================================================
# EKSEKUSI UTAMA
# ============================================================

clear
printf '\n'
printf '%b' "${G}  M     M   AA   U     U  N     N  GGGG${N}\n"
printf '%b' "${G}  MM   MM  A  A  U     U  NN    N G    ${N}\n"
printf '%b' "${G}  M M M M  AAAA  U     U  N N   N G GGG${N}\n"
printf '%b' "${G}  M  M  M  A  A   U   U   N  N  N G   G${N}\n"
printf '%b' "${G}  M     M  A  A    UUU    N   N N  GGGG${N}\n"
printf '\n'
printf '%b' "${C}       M A U N G   P R O T O C O L${N} ${W}v7.0${N} ${R}[AGGRESSIVE]${N}\n"
printf '%b' "${W}  ----------------------------------------------${N}\n"
printf '%b' "${W}  ${DEVICE_CODE} | SDK ${DEVICE_SDK} | Android ${DEVICE_RELEASE}${N}\n"
printf '\n'

# Step 1: Airplane mode ON
printf '  %b>%b %bISOLATE%b  %bKill network signals%b\n' "$BG" "$N" "$C" "$N" "$W" "$N"
progress 0 "Isolating..."
modpeson >/dev/null 2>&1
anim_bar 0 100 "Radio silenced"
printf '\n'

# Step 2: Bersih-bersih (2-pass)
printf '  %b>%b %bPURGE%b    %bNuke app data & tracking%b\n' "$BG" "$N" "$C" "$N" "$W" "$N"
progress 0 "Stopping apps..."
bersih >/dev/null 2>&1
anim_bar 0 100 "Purged"
printf '\n'

# Step 3: System.prop
printf '  %b>%b %bFORGE%b    %bInject device identity%b\n' "$BG" "$N" "$C" "$N" "$W" "$N"
progress 0 "Generating props..."
systemprops >/dev/null 2>&1
anim_bar 0 100 "Props injected"
printf '\n'

# Step 4: Acak serial
printf '  %b>%b %bSCRAMBLE%b %bRandomize serial & IDs%b\n' "$BG" "$N" "$C" "$N" "$W" "$N"
progress 0 "Scrambling..."
acakserial >/dev/null 2>&1
acak1 >/dev/null 2>&1
acak2 >/dev/null 2>&1
anim_bar 0 100 "IDs scrambled"
printf '\n'

# Step 5: Ritual agresif
printf '  %b>%b %bRITUAL%b   %bAggressive final purge%b\n' "$BG" "$N" "$R" "$N" "$W" "$N"
progress 0 "Ritual purge..."
ritual >/dev/null 2>&1
anim_bar 0 100 "Ritual complete"
printf '\n'

# Step 6: Finalize
printf '  %b>%b %bSEAL%b     %bFinalize & reboot%b\n' "$BG" "$N" "$C" "$N" "$W" "$N"
progress 0 "Sealing..."
modpesoff >/dev/null 2>&1
anim_bar 0 100 "Sealed"
printf '\n'

# Summary
printf '  %b----------------------------------------------%b\n' "$W" "$N"
printf '  %b>%b %b%s%b\n' "$BG" "$N" "$G" "$DISPLAY_NAME" "$N"
printf '  %b>%b system.prop    %binjected%b\n' "$G" "$N" "$G" "$N"
printf '  %b>%b app data       %bpurged%b\n' "$G" "$N" "$G" "$N"
printf '  %b>%b tracking files %bnuked%b\n' "$G" "$N" "$G" "$N"
printf '  %b>%b BT name        %brandomized%b\n' "$G" "$N" "$G" "$N"
printf '  %b>%b SSAID          %brandomized%b\n' "$G" "$N" "$G" "$N"
printf '  %b>%b android_id     %bdeleted%b\n' "$G" "$N" "$G" "$N"
printf '  %b>%b ritual purge   %bcomplete%b\n' "$G" "$N" "$R" "$N"
printf '\n'

printf '  %bRebooting in 3...%b' "$W" "$N"
sleep 1
printf '\r  %bRebooting in 2...%b' "$W" "$N"
sleep 1
printf '\r  %bRebooting in 1...%b  \n' "$W" "$N"
sleep 1

nuketrack >/dev/null 2>&1
sync
sleep 1
rm -f "$LOCKFILE"
/system/bin/reboot
