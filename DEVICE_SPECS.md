# Spesifikasi Perangkat Target

## Device Utama

| Parameter | Nilai |
|---|---|
| **Nama HP** | Redmi Note 7 |
| **Kode Device** | lavender |
| **Brand** | Xiaomi |
| **Chipset** | Qualcomm Snapdragon 660 (SDM660) |
| **RAM** | 3GB / 4GB |
| **Storage** | 32GB / 64GB |
| **Layar** | 6.3" FHD+ (2340x1080) |
| **Android Versi** | 11 |
| **SDK Level** | 30 |
| **Custom ROM** | crDroid Android 11 |
| **Root** | Magisk / Kernelsu Next |
| **First API Level** | 28 |

## Software Environment

| Komponen | Versi / Status |
|---|---|
| **Magisk** | Installed (root access) |
| **Custom ROM** | crDroid (Android 11) |
| **SELinux** | Enforcing (Magisk handle) |
| **Bootloader** | Unlocked |
| **DM-Verity** | Disabled via Magisk |
| **VBMeta** | Patched |

## Magisk Modules yang Digunakan

| Module | Path | Fungsi |
|---|---|---|
| xkatrina_snstv_prps | `/data/adb/modules/xkatrina_snstv_prps/` | System.prop spoofing slot 1 |
| MagiskProps | `/data/adb/modules/MagiskProps/` | System.prop spoofing slot 2 |
| MagiskHidePropsConf | `/data/adb/modules/MagiskHidePropsConf/` | System.prop spoofing slot 3 + Serial random |
| magisk-drm-disabler | `/data/adb/modules/magisk-drm-disabler/` | DRM disable (Widevine L1 ke L3) |
| MagiskHidePropsConf (mhpc) | `/data/adb/mhpc/` | Props config file (propsconf_late) |

## System Properties Asli (Sebelum Spoof)

```properties
ro.product.model=Redmi Note 7
ro.product.device=lavender
ro.product.brand=xiaomi
ro.product.manufacturer=Xiaomi
ro.product.board=sdm660
ro.board.platform=sdm660
ro.hardware=qcom
ro.build.version.sdk=30
ro.build.version.release=11
ro.product.first_api_level=28
```

## Catatan Penting

- **JANGAN override** `ro.hardware`, `ro.board.platform` -- harus tetap asli (qcom/sdm660) karena driver hardware bergantung padanya
- Serial number disimpan di `/data/adb/mhpc/propsconf_late` (MagiskHidePropsConf config)
- SSAID disimpan di `/data/system/users/0/settings_ssaid.xml`
- BT config di `/data/misc/bluedroid/bt_config.conf`
- Settings XML fallback di `/data/system/users/0/*.fallback`
