# WORKLOG — SafeProp / MAUNG PROTOCOL

## Riwayat Pengerjaan

---

### Session 1 — Inisialisasi & Merge v7.0

**Tanggal:** 2026-04-26
**Task:** Merge SafeProp v6.5 + AcakTeMPeOPPO menjadi SafeProp v7.0

**Input:**
- `SafeProp_v6.5_backup.sh` — Versi baru, arsitektur bersih (105 model DB, 3-layer airplane mode, 2-pass purge, lockfile, auto-root)
- `AcakTeMPeOPPO.sh` — Versi lama, lebih agresif (ritual cleanup, SSAID randomize, GMS wipe, fallback XML)

**Permintaan User:**
> "Boleh tambahkan ssaid randomize dari acaktempe oppo, dan masukan semua ritual di bagian akhir juga saya mau agresif seperti accaktempeoppo supaya jejak tidak terdeteksi"

**Fitur yang Di-merge dari AcakTeMPeOPPO ke SafeProp v7.0:**

| Fitur | Sumber | Implementasi |
|---|---|---|
| SSAID randomize (acak1) | AcakTeMPeOPPO | Randomize `value=` di settings_ssaid.xml untuk Lazada, GMS, Vending |
| SSAID randomize (acak2) | AcakTeMPeOPPO | Randomize `defaultValue=` di settings_ssaid.xml untuk Lazada, Tokopedia, Chrome, Dana, Vending, GMS |
| Serial randomize | AcakTeMPeOPPO | Edit propsconf_late (MagiskHidePropsConf) |
| Fallback XML edit | AcakTeMPeOPPO | Edit settings_secure.xml.fallback + settings_global.xml.fallback untuk BT name & device name |
| `settings delete secure android_id` | AcakTeMPeOPPO | Hapus android_id dari secure settings |
| Dalvik-cache total wipe | AcakTeMPeOPPO | `rm -rf /data/dalvik-cache/` di ritual |
| Google apps clear (wipegms) | AcakTeMPeOPPO | GMS, Gmail, Photos, CarrierSetup, ConfigUpdater, GMS Setup, Latin IME, Markup, Gearhead, SoundPicker, Calendar/Contacts Sync, Restore, PixelMigrate, PackageInstaller, SetupWizard |
| System app clear | AcakTeMPeOPPO | smspush, ime, defcontainer, localtransport |
| Data folder deep wipe | AcakTeMPeOPPO | /data/data/*, /data/user/0/*, /data/user_de/0/* |
| VPN Indonesia clear | AcakTeMPeOPPO | free.vpn.secure.turbo.proxy.hotspot.vpnindonesia |
| Ritual agresif | AcakTeMPeOPPO | 3-pass: STOP ulang, CLEAR ulang, NUKE semua sisa data |
| nuketrack() | AcakTeMPeOPPO | Hapus settings_ssaid.xml, package-restrictions.xml, settings_config.xml, app_idle_stats.xml, *.fallback, accounts_ce.db, accounts_de.db sesaat sebelum reboot |
| Cache/log tambahan | AcakTeMPeOPPO | dontpanic, kernelpanics, mlog, backup/pending, cache apk/tmp |

**Fitur dari SafeProp v6.5 yang Dipertahankan:**
- 105 model database (Xiaomi/POCO/Redmi, Samsung, OPPO, Realme, Infinix, Vivo, Asus, Google, OnePlus, Advan, Tecno, ZTE, nubia)
- 3-layer airplane mode (Radio OFF + Route flush + iptables DROP)
- 2-pass purge pattern (STOP dulu, CLEAR kemudian)
- Lockfile mechanism (cegah double-run, auto-expire 5 menit)
- Auto-root via `exec su -c`
- Progress bar animasi
- MAUNG ASCII art banner
- BT name randomize (consonant-vowel pattern)
- Advertising ID delete
- MAC randomization
- Hardware preserve (ro.hardware, ro.board.platform JANGAN di-override)
- 3 Magisk module slot support
- DRM disabler prop copy
- Sdcard nuke (kecuali Download, DCIM, Documents, Alarms, Notifications, Ringtones)

**Hasil:**
- File: `SafeProp_v7.0.sh` (982 baris, ~48KB)
- Semua fitur agresif dari AcakTeMPeOPPO berhasil di-merge
- Tidak ada fitur dari v6.5 yang hilang

---

### Session 2 — Push ke GitHub

**Tanggal:** 2026-04-26
**Task:** Push SafeProp v7.0 ke GitHub repo baru

**Langkah:**
1. Buat repo `SafeProp` di GitHub (winolikemove/SafeProp)
2. Tambah DEVICE_SPECS.md — spesifikasi HP target
3. Tambah WORKLOG.md — riwayat pengerjaan
4. Tambah README.md — dokumentasi project
5. Push semua file ke repo

**Repo URL:** https://github.com/winolikemove/SafeProp

---

## Status Saat Ini

| Item | Status |
|---|---|
| SafeProp v7.0 | Selesai, sudah di repo |
| SSAID randomize | Sudah (acak1 + acak2) |
| Ritual agresif | Sudah |
| Fallback XML edit | Sudah |
| android_id delete | Sudah |
| Google apps wipe | Sudah |
| VPN clear | Sudah |
| GitHub repo | Sudah |

## Ide Pengembangan Selanjutnya

- [ ] Tambah lebih banyak model HP (Android 12, 13)
- [ ] Tambah Build.VERSION.INCREMENTAL randomize
- [ ] Tambah ro.build.description spoof
- [ ] Support per-app spoofing (MagiskHide/DenyList integration)
- [ ] Tambah Wi-Fi MAC manual spoof (bukan cuma randomization enabled)
- [ ] Auto-detect installed apps dan hanya clear yang ada
- [ ] Logging ke file untuk debugging
- [ ] Dry-run mode (preview tanpa eksekusi)
- [ ] Backup original props sebelum spoof
- [ ] Restore function (kembalikan ke identitas asli)
