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

## 2. Lingkup Ujian (Objektif Resmi EX200 — Berbasis RHEL 10)

EX200 **saat ini resmi berbasis RHEL 10**. Berikut 11 kategori objektif resmi
(Red Hat, 2026) dan pemetaannya ke modul di repo ini. **Ini yang benar-benar
diujikan** — fokuskan latihan ke sini.

| # | Area objektif | Contoh tugas | Modul |
|---|--------------|-------------|-------|
| 1 | Understand and use essential tools | shell prompt, redireksi, `grep`+regex, SSH, `tar`/`gzip`/`bzip2`, vim, file/dir, hard/soft link, ugo/rwx, `man`/`info`/`/usr/share/doc` | 02, 03, 04, 05 |
| 2 | Manage software | repo RPM, install/remove via DNF, **repo & paket Flatpak** | 12 |
| 3 | Create simple shell scripts | `if`/`test`/`[]`, loop `for`, argumen `$1 $2`, output command | 20 |
| 4 | Operate running systems | boot/reboot/shutdown, target manual, **interrupt boot** (`rd.break`), proses CPU/mem (`kill`), `nice`, **tuned**, log/journal, **preserve journals**, service status, transfer file aman | 08, 09 |
| 5 | Configure local storage | partisi **GPT**, PV/VG/LV, mount by **UUID/label**, tambah partisi/LV/swap non-destruktif | 13 |
| 6 | Create & configure file systems | **VFAT/ext4/XFS**, mount NFS, **autofs**, **extend LV**, diagnosis permission | 13 |
| 7 | Deploy/adjust/maintain systems | `at`/`cron`/systemd timer, service auto-boot, boot target, **chrony** (time client), update software, **grub2/bootloader** | 09, 12, 17 |
| 8 | Manage basic networking | **IPv4 & IPv6**, hostname resolution, service auto-boot, **firewalld** | 11 |
| 9 | Manage users & groups | `useradd`/`usermod`/`userdel`, password aging (`chage`), group, privileged access (`sudo`/`wheel`) | 06 |
| 10 | Manage security | **firewalld**, **umask** default, **SSH key-based**, SELinux **enforcing/permissive**, context file/proses, **restorecon**, **SELinux port labels**, **boolean** | 07, 10, 16 |
| 11 | *Containers* | **🚫 TIDAK LAGI masuk objektif resmi EX200 RHEL 10** — lihat catatan §4 | — |

> ⚠️ **SELinux** sering jadi penyebab gagal. Jangan mematikan — konfigurasikan
> dengan benar (`setsebool`, `semanage fcontext`, `restorecon`, `semanage port`).
> Khusus RHEL 10: objektif menekankan **SELinux port labels** (mis. izinkan
> service non-standar mendengarkan port lewat `semanage port`).

## 3. Perubahan Penting EX200 RHEL 9 → RHEL 10 (Jangan Tertipu Materi Lama!)

Banyak panduan lama (RHEL 9) masih beredar. Perbedaan yang **berdampak ke
skor ujian** saat ini:

- **🚫 Containers / Podman DIHAPUS** dari objektif resmi EX200 RHEL 10.
  Red Hat menggantinya dengan **Flatpak** di kategori "Manage software".
  → Modul 15 (Podman) tetap ada sebagai **bonus keahlian & persiapan RHCE**,
  tapi **tidak wajib** untuk lulus EX200 RHEL 10.
- **🚫 Stratis / VDO / disk quota / nmstate / bootc**: **TIDAK** ada di
  objektif resmi EX200 RHEL 10. Modul 13 memuat Stratis/VDO/quota sebagai
  **materi perluasan (bonus)** — bagus untuk wawasan, tapi **jangan menganggap
  ini akan keluar di soal EX200 RHEL 10**.
- **✅ Yang BARU & wajib di RHEL 10**: **Flatpak** (ganti container),
  **SELinux port labels**, **preserve system journals** (`/var/log/journal`
  persisten), **IPv6** eksplisit di networking.

Topik yang sering luput peserta (dan MASIH relevan RHEL 10):
- **Flatpak** — repo & paket desktop (Modul 12).
- **tuned** — profil tuning (`tuned-adm`, Modul 09).
- **grub2 / bootloader + `rd.break`** — interrupt boot (Modul 09).
- **VFAT** — `mkfs.vfat -F 32` (Modul 13).
- **chrony / IPv6** — time client & alamat IPv6 (Modul 11 & 17).
- **autofs** — mount NFS on-demand (Modul 13).
- **SELinux port labels** — `semanage port -a -t ...` (Modul 16).

## 4. RHEL 9 vs RHEL 10 (Fakta, Bukan Spekulasi)

| Aspek | RHEL 9 | RHEL 10 (ujian saat ini) |
|-------|--------|---------------------------|
| Containers di EX200 | **Masuk** objektif | **DIHAPUS** (diganti Flatpak) |
| Storage modern | Stratis/VDO sering dibahas | **Tidak** di objektif resmi |
| Init & service | systemd | systemd (sama) |
| OS model | RPM/DNF package-based | Image mode (`bootc`) *tersedia*, tapi **tidak diujikan** di EX200 |
| Default FS | XFS | XFS |
| Networking | nmcli (IPv4) | nmcli + **IPv6 eksplisit** |
| Security | SELinux enforcing/boolean | + **port labels**, **restorecon** ditekankan |

**Bootc / Image Mode (RHEL 10):** sistem bisa dikelola sebagai *image*
(`bootc upgrade`/`rollback`). **Tidak masuk objektif EX200** — cukup tahu
ada, jangan panik bila tidak ada di lab RHEL 9.
```bash
bootc status          # lihat status image/rollback (RHEL 10 image mode)
bootc upgrade         # upgrade ke image baru
bootc rollback        # kembalikan ke image sebelumnya
```
> Fokus utama EX200 RHEL 10 tetaplah administrasi standar: user, storage
> (GPT/LVM), service (systemd), network (nmcli + IPv6), **SELinux**, dan
> **Flatpak** — bukan container/bootc.

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
9. (BONUS — bukan objektif resmi EX200 RHEL 10) Buat pool Stratis `mypool`
   dari disk lab, buat filesystem `data1`, mount permanen di `/mnt/stratis`.
10. (BONUS) Buat volume VDO dedup `--vdoLogicalSize` 50G di disk lab,
    format XFS, mount di `/mnt/vdo`, verifikasi dengan `vdostats`.
11. (BONUS) Pasang opsi `usrquota,grpquota` di `/home`, set batas user
    `user1` maks 120M block & 1200 inode via `xfs_quota -x -c 'limit ...'`.
    > Soal 9–11 bagus untuk wawasan & persiapan lanjutan, tapi **tidak masuk**
    > objektif resmi EX200 RHEL 10. Prioritaskan soal 1–8.

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
- Kerjakan skenario 1–8 di atas tanpa melihat jawaban (soal 9–11 opsional/bonus). Catat waktu tiap tugas.

## Kunci Jawaban (klik untuk lihat)
??? note "Kunci Jawaban Latihan"
    - Kerjakan skenario di atas di lab; verifikasi tiap tugas dengan
      `id`, `getfacl`, `sshd -t`, `firewall-cmd --list-all`, `df -h`,
      `getenforce`, `tuned-adm active`, `flatpak list` — sesuai kolom
      "Cara Buktikan" di tiap skenario.
    - Target: rata-rata < 18 menit/tugas dan skor ≥ 80% sebelum ujian nyata.
