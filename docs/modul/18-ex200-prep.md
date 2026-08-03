# Modul 18 — EX200 (RHCSA) Exam Preparation

> 📺 Referensi video: [RHCSA & EX200 Prep](https://www.youtube.com/watch?v=eGbNXqPdUa4&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns) · [Pass the EX200](https://www.youtube.com/watch?v=2n2P0Awz3U4&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns)

Ini adalah **modul persiapan utama (kanonik)** untuk ujian EX200. Halaman
ringkas taktis ada di [Persiapan EX200 (referensi)](../referensi/EX200-prep.md),
tapi seluruh materi & simulasi soal berada di modul ini.

## 1. Format Ujian EX200

- **Tipe**: *performance-based* (hands-on di server nyata, bukan pilihan ganda).
- **Durasi**: 3 jam (180 menit).
- **Skor lolos**: Red Hat tidak mengumumkan angka pasti; historis ~210/300.
  Strategi aman: kejar **semua** tugas, jangan mengejar nilai tertentu.
- **Lingkungan**: beberapa VM RHEL yang harus kamu konfigurasi.
- **Aturan**: tanpa internet, tanpa bawa catatan; boleh pakai `man`, `vim`,
  dokumentasi lokal (`/usr/share/doc`), dan Cockpit.

## 2. Lingkup Ujian (Objektif Lengkap EX200)

Berikut pemetaan objektif resmi EX200 (RHEL 10) ke modul di repo ini.
Semua poin tertutup — termasuk yang sering luput (autofs, Flatpak,
tuned, bootloader/grub2, VFAT, chrony/IPv6) **serta storage modern
(Stratis, VDO, disk quota) dan network deklaratif (nmstate) untuk track
RHEL 9/10**.

| Area objektif | Contoh tugas | Modul |
|------|-------------|-------|
| Understand and use essential tools | `man`, `vim`, redireksi, `tar`, `grep`, `find`, `ssh`, hard/soft link | 02, 03, 04, 05 |
| Manage software | RPM repo, DNF, **Flatpak** repo & paket | 12 |
| Create simple shell scripts | `if`/`for`/`while`, `$1 $# $@`, output command | 20 |
| Operate running systems | `systemctl`, `journalctl`, proses, `nice`, **tuned**, interrupt boot | 08, 09 |
| Configure local storage | partisi GPT, LVM (PV/VG/LV), mount by UUID/label, swap, **Stratis**, **VDO** | 13 |
| Create & configure file systems | XFS/ext4/**VFAT**, NFS, **autofs**, extend LV, permission, **disk quota** | 13 |
| Deploy/adjust/maintain systems | `cron`/`at`/systemd timer, boot target, **chrony**, **grub2/bootloader**, `bootc` (RHEL10) | 09, 17 |
| Manage basic networking | **IPv4 & IPv6**, hostname, DNS, firewalld, **nmstate** (RHEL10) | 11 |
| Manage users & groups | `useradd`, `usermod`, `passwd`, `sudo`, `chage` | 06 |
| Manage security | `firewalld`, **SELinux** (enforcing), `ssh` key-based, `umask` | 07, 10, 16 |
| Containers (RHEL 9+) | `podman` pull/run, **skopeo/buildah**, podman sebagai service | 15 |

> ⚠️ **SELinux** sering jadi penyebab gagal. Jangan mematikan — konfigurasikan
> dengan benar (`setsebool`, `semanage`, `restorecon`, `chcon`).

## 3. Topik Baru yang Sering Luput

Ini bagian yang di versi lama catatan sering kosong. Pastikan kamu hafal
perintah dasarnya (detail ada di modul masing-masing):

- **autofs** — mount NFS/USB otomatis on-demand (Modul 13, §VFAT/autofs).
- **Flatpak** — repo & paket desktop containerized (Modul 12, §Flatpak).
- **tuned** — profil tuning performa (`tuned-adm`, Modul 09).
- **grub2 / bootloader** — ubah parameter boot & interrupt boot via `rd.break`
  (Modul 09, §Bootloader & Akses Darurat).
- **VFAT** — format & mount FAT32 (`mkfs.vfat`, Modul 13).
- **chrony / IPv6** — client time service & alamat IPv6 (`nmcli`, Modul 11 & 17).
- **Stratis / VDO / disk quota** — storage modern wajib RHEL 9/10: pool
  Stratis + snapshot, volume VDO dedup, dan `xfs_quota` batas user (Modul 13, §10–§12).
- **nmstate** — network deklaratif via `nmstatectl apply` (RHEL 10, Modul 11, §7c).

## 4. Perbedaan RHEL 9 vs RHEL 10 (Penting!)

| Aspek | RHEL 9 | RHEL 10 |
|-------|--------|---------|
| Init & service | systemd | systemd (sama) |
| Container | Podman (rootless) | Podman + **bootc** |
| OS model | Package-based (RPM/DNF) | **Image mode** (bootc) tersedia |
| `bootc` | tidak ada | sistem berbasis image (mirip Container OS) |
| Default FS | XFS | XFS |
| Networking | NetworkManager/nmcli | NetworkManager/nmcli (sama) |

**Bootc / Image Mode (RHEL 10):** sistem dikelola sebagai *image* yang
di-update via `bootc` (bukan `dnf update` tradisional). Untuk EX200, fokus
tetap ke administrasi standar (user, storage, service, network, SELinux,
Podman) — `bootc` bobotnya kecil. Perintah dasar:
```bash
bootc status          # lihat status image/rollback
bootc upgrade         # upgrade ke image baru
bootc rollback        # kembalikan ke image sebelumnya
bootc switch <image>  # ganti ke image/repo berbeda
```
> Catatan: pada RHEL 9 (paling umum diuji saat ini), `bootc` **tidak ada**.
> Jangan panik jika perintah ini tidak ada di lab RHEL 9 — fokus ke `dnf`.

## 5. Strategi Hari-H

1. **Baca semua soal dulu** — petakan mana yang saling bergantung.
2. **Mulai dari yang mudah & independen** untuk mengamankan poin.
3. **Selalu uji perubahan**: setelah `sshd_config`, jalankan `sshd -t` & buka
   sesi baru sebelum logout.
4. **Jangan reboot sembarangan** — reboot bisa memunculkan error fstab yang
   membuat VM tidak boot (grub rescue).
5. **Catat IP & kredensial** yang diberikan — jangan sampai terkunci keluar.
6. **Waktu**: 3 jam untuk ~15–20 tugas. Alokasikan ~8 menit/tugas, sisakan
   buffer untuk verifikasi.

## 6. Simulasi Soal Latihan

1. Buat user `operator` dengan UID 2000, group `ops` (GID 3000), shell `/bin/bash`.
2. Atur `/data` (XFS, mount permanen via fstab, ukuran min 500M).
3. Konfigurasi `sshd` agar root dilarang login & hanya kunci yang diizinkan.
4. Buka port 8080 di `firewalld` secara permanen.
5. Pasang `httpd`, jadikan enable, dan pastikan bisa diakses di port 80.
6. Buat cron job: backup `/etc` ke `/backup/etc.tar.gz` setiap jam 02:00.
7. Set SELinux boolean `httpd_can_network_connect` on.
8. (Tambahan) Pasang paket Flatpak `gedit`, konfigurasi autofs untuk mount
   NFS lab on-demand, dan aktifkan profil `tuned` `throughput-performance`.
9. (Storage modern RHEL 9/10) Buat pool Stratis `mypool` dari disk lab, buat
   filesystem `data1`, mount permanen di `/mnt/stratis`.
10. (Storage modern) Buat volume VDO dedup `--vdoLogicalSize` 50G di disk lab,
    format XFS, mount di `/mnt/vdo`, verifikasi dengan `vdostats`.
11. (Disk quota) Pasang opsi `usrquota,grpquota` di `/home`, set batas user
    `user1` maks 120M block & 1200 inode via `xfs_quota -x -c 'limit ...'`.

(Jawaban & langkah ada di `../lab/LAB.md` dan
`../referensi/EX200-prep.md`. Untuk perbaikan sistem rusak, baca
**[Break & Fix / Troubleshooting](../referensi/BREAK-FIX.md)** — ~40% soal
EX200 adalah troubleshooting.)

## 7. Sumber Belajar Tambahan

- RH124 + RH134 (wajib).
- `lab/LAB.md` di repo ini — kerjakan berulang hingga cepat.
- Dokumentasi lokal: `file:///usr/share/doc/`.
- Practice exam environment (mis. lab VirtualBox dengan snapshot).
- [Simulasi Ujian 3 Jam / 180 Menit](../referensi/SIMULASI-UJIAN.md) & [Checklist H-1](../referensi/CHECKLIST-H1.md).

## Latihan
- Kerjakan ke-8 simulasi di atas tanpa melihat jawaban. Catat waktu tiap tugas.

## Kunci Jawaban (klik untuk lihat)
??? note "Kunci Jawaban Latihan"
    - Kerjakan skenario di atas di lab; verifikasi tiap tugas dengan
      `id`, `getfacl`, `sshd -t`, `firewall-cmd --list-all`, `df -h`, `podman ps`,
      `getenforce`, `tuned-adm active`, `flatpak list` — sesuai kolom
      "Cara Buktikan" di tiap skenario.
    - Target: rata-rata < 18 menit/tugas dan skor ≥ 80% sebelum ujian nyata.
