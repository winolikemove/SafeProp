# SafeProp — MAUNG PROTOCOL

> Aggressive Device Identity Spoofer untuk Android (Magisk + Root)

## Versi Terbaru

**SafeProp v7.0** — Merge SafeProp v6.5 + AcakTeMPeOPPO

## Apa yang Dilakukan SafeProp?

SafeProp mengubah identitas perangkat Android secara menyeluruh agar tidak terdeteksi oleh sistem tracking:

1. **Spoof device properties** — 105 model HP (Xiaomi, Samsung, OPPO, Realme, Infinix, Vivo, Asus, Google, OnePlus, Advan, Tecno, ZTE, nubia)
2. **3-layer airplane mode** — Radio OFF + Route flush + iptables DROP
3. **2-pass app purge** — STOP semua dulu, baru CLEAR data
4. **SSAID randomize** — Acak value + defaultValue di settings_ssaid.xml
5. **Serial number randomize** — Via MagiskHidePropsConf
6. **BT name + device name spoof** — Termasuk fallback XML edit
7. **Advertising ID + Android ID delete**
8. **Ritual agresif** — Full purge semua sisa jejak sebelum reboot
9. **Dalvik-cache total wipe**
10. **Auto-root** via `exec su -c`

## Cara Pakai

```bash
# Push ke device
adb push SafeProp_v7.0.sh /data/local/tmp/

# Jalankan di device
adb shell
su
sh /data/local/tmp/SafeProp_v7.0.sh
```

Device akan reboot otomatis setelah selesai.

## File Repository

| File | Deskripsi |
|---|---|
| `SafeProp_v7.0.sh` | Script utama (982 baris) |
| `DEVICE_SPECS.md` | Spesifikasi HP target (Redmi Note 7 lavender) |
| `WORKLOG.md` | Log pengerjaan dan riwayat perubahan |

## Requirements

- Android 11 (crDroid)
- Magisk (root)
- MagiskHidePropsConf module
- MagiskProps / xkatrina_snstv_prps module
- magisk-drm-disabler module

## Changelog

### v7.0 (Aggressive Merge)
- Base: SafeProp v6.5 + AcakTeMPeOPPO
- Tambah SSAID randomize (acak1 + acak2)
- Tambah ritual agresif di akhir (full purge)
- Tambah Google apps clear (wipegms style)
- Tambah data folder deletion tambahan
- Tambah fallback XML edit untuk BT/device name
- Tambah VPN Indonesia clear
- Tambah android_id delete
- Tambah dalvik-cache total wipe
- Tambah nuketrack() sebelum reboot

### v6.5
- 105 model database
- 3-layer airplane mode
- 2-pass purge pattern
- Lockfile mechanism
- Auto-root via exec su
