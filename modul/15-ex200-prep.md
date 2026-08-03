# Modul 15 — EX200 (RHCSA) Exam Preparation

> Referensi video: `eGbNXqPdUa4` (RHCSA & EX200 Prep), `2n2P0Awz3U4` (Pass the EX200)

## 1. Format Ujian EX200

- **Tipe**: *performance-based* (hands-on di server nyata, bukan pilihan ganda).
- **Durasi**: 3 jam (biasanya).
- **Skor lolos**: ±210/300 (berkembang tiap rilis).
- **Lingkungan**: beberapa VM RHEL yang harus kamu konfigurasi.
- **Aturan**: tanpa internet, tanpa bawa catatan; boleh pakai `man`, `vim`,
  dokumentasi lokal (`/usr/share/doc`).

## 2. Lingkup Ujian (Objektif Umum)

| Area | Contoh tugas |
|------|-------------|
| Understanding & using essential tools | `man`, `vim`, redireksi, `tar`, `grep`, `ssh` |
| Operating running systems | `systemctl`, `journalctl`, proses, `nice` |
| Configuring local storage | partisi, LVM, mount `fstab`, swap |
| Creating & configuring file systems | XFS/ext4, permission, ACL, `umask` |
| Deploying/adjusting/ maintaining systems | DNF, repo, `cron`, `at`, timezone |
| Managing users & groups | `useradd`, `usermod`, `passwd`, `sudo`, `chage` |
| Managing security | `firewalld`, `SELinux` (enforcing), `ssh` hardening |
| Networking | `nmcli`, hostname, DNS, routing |
| Containers (RHEL 9+) | `podman` pull/run, `podman` sebagai service |

> ⚠️ **SELinux** sering jadi penyebab gagal. Jangan mematikan — konfigurasikan
> dengan benar (`setsebool`, `semanage`, `restorecon`, `chcon`).

## 3. Strategi Hari-H

1. **Baca semua soal dulu** — petakan mana yang saling bergantung.
2. **Mulai dari yang mudah & independen** untuk mengamankan poin.
3. **Selalu uji perubahan**: setelah `sshd_config`, jalankan `sshd -t` & buka
   sesi baru sebelum logout.
4. **Jangan reboot sembarangan** — reboot bisa memunculkan error fstab yang
   membuat VM tidak boot (grub rescue).
5. **Catat IP & kredensial** yang diberikan — jangan sampai terkunci keluar.
6. **Waktu**: 3 jam untuk ~15–20 tugas. Alokasikan ~8 menit/tugas, sisakan
   buffer untuk verifikasi.

## 4. Simulasi Soal Latihan

1. Buat user `operator` dengan UID 2000, group `ops` (GID 3000), shell `/bin/bash`.
2. Atur `/data` (XFS, mount permanen via fstab, ukuran min 500M).
3. Konfigurasi `sshd` agar root dilarang login & hanya kunci yang diizinkan.
4. Buka port 8080 di `firewalld` secara permanen.
5. Pasang `httpd`, jadikan enable, dan pastikan bisa diakses di port 80.
6. Buat cron job: backup `/etc` ke `/backup/etc.tar.gz` setiap jam 02:00.
7. Set ELinux boolean `httpd_can_network_connect` on.

(Jawaban & langkah ada di `lab/LAB.md` dan `referensi/EX200-prep.md`.)

## 5. Sumber Belajar Tambahan

- RH124 + RH134 (wajib).
- `lab/LAB.md` di repo ini — kerjakan berulang hingga cepat.
- Dokumentasi lokal: `file:///usr/share/doc/`.
- Practice exam environment (mis. lab VirtualBox dengan snapshot).

## Latihan
- Kerjakan ke-7 simulasi di atas tanpa melihat jawaban. Catat waktu tiap tugas.
