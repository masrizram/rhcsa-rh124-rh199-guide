# 📘 Panduan Lengkap Red Hat System Administration I (RH124 / RH199) → EX200 (RHCSA)

Repo ini berisi panduan belajar **Red Hat Enterprise Linux (RHEL)** secara lengkap,
berdasarkan kurikulum **Red Hat System Administration I (RH124 / RH199)** yang
diajarkan di playlist YouTube *"RH124 RH199 - Red Hat System Administration I - Complete Training"*
(Ozzoy Bits), ditambah persiapan sertifikasi **EX200 (RHCSA)**.

> **Basis materi:** RHEL 9.3 (berlaku juga untuk RHEL 10.x). Semua perintah diuji
> pada lingkungan RHEL / Rocky Linux / AlmaLinux / Fedora yang setara.
>
> 📌 **EX200 saat ini resmi berbasis RHEL 10 (2026).** Panduan ini sudah
> diselaraskan dengan objektif resmi: *Containers/Podman tidak lagi wajib*
> (diganti **Flatpak**), dan Stratis/VDO/disk quota/nmstate/bootc berstatus
> **materi perluasan (bonus)**, bukan soal ujian. Lihat
> [Modul 18 — EX200 Prep](../modul/18-ex200-prep.md) §2–§4 untuk detail.

---

## 🎯 Tujuan Panduan

Setelah menyelesaikan panduan ini, kamu diharapkan mampu:

- Mengakses dan menjalankan perintah di RHEL melalui shell & web console.
- Mengelola berkas, direktori, teks, pengguna, grup, dan hak akses.
- Memantau proses, mengelola *service* `systemd`, dan mengamankan akses SSH.
- Mengonfigurasi jaringan, memasang pembaruan perangkat lunak (DNF), dan
  memasang sistem berkas.
- Memahami alur sertifikasi **RHCSA (EX200)** dan siap mengikuti ujian.

---

## 📚 Struktur Modul (Sesuai Playlist)

| # | Modul | Topik Inti | Video Referensi |
|---|-------|-----------|-----------------|
| 00 | Pengantar & Roadmap Sertifikasi | Ekosistem RHEL, RHCSA/EX200, lab lokal | `pnHqii1Oq8Y`, `O58uDdztjGU`, `2n2P0Awz3U4` |
| 01 | Get Started with RHEL | Akses RHEL, web console, terminal, shell | `i4oSjt2nYhk` |
| 02 | Access the Command Line | Shell, BASH, perintah dasar, sejarah | `aYTFiUhNN7E` |
| 03 | Manage Files from the Command Line | `pwd`, `ls`, `cp`, `mv`, `rm`, globbing, wildcard | `__5fjNolVtU` |
| 04 | Get Help in RHEL | `man`, `info`, `--help`, `pinfo`, dokumentasi | `UC_V5af1Ah0` |
| 05 | Create, View, and Edit Text Files | `vim`, `cat`, `head`, `tail`, redireksi, pipe | `-gARZ98HUL4` |
| 06 | Manage Local Users and Groups | `/etc/passwd`, `/etc/group`, `useradd`, `usermod`, `passwd` | `yg1IdxH38OA` |
| 07 | Access to Files (Permissions) | `chmod`, `chown`, `umask`, ACL, `setfacl` | `FmyIyp73bGM` |
| 08 | Monitor and Manage Linux Processes | `ps`, `top`, `kill`, `jobs`, prioritas | `xeN2_R7W7so` |
| 09 | Control Services and Daemons | `systemd`, `systemctl`, target, journal | `RESDzgTwqYk` |
| 10 | Configure and Secure SSH | `sshd`, kunci, `ssh-copy-id`, hardening | `jGzIZZrdEpE` |
| 11 | Manage Networking | `ip`, `nmcli`, `hostnamectl`, DNS | `sm2LR26JERA` |
| 12 | Install and Update Software | DNF, repo, `rpm`, grup paket | `CDpa7ZpNNEE` |
| 13 | Access Linux File Systems | Partisi, LVM, `mount`, `fstab`, swap | `tuN89JVWjCs` |
| 14 | Analyze Servers and Get Support | Log, `cockpit`, Red Hat Insights, subscription | `44ObsKHr0IA` |
| 15 | Podman & Containers | Pull/run, quadlet, skopeo/buildah | `eGbNXqPdUa4`, `2n2P0Awz3U4` |
| 16 | SELinux (Keamanan Wajib) | Enforcing, boolean, fcontext, `restorecon` | `eGbNXqPdUa4` |
| 17 | Penjadwalan & Time Zone | `cron`, `at`, systemd timer, `timedatectl` | `eGbNXqPdUa4` |
| 18 | EX200 (RHCSA) Exam Prep | Strategi, lingkup ujian, simulasi soal | `eGbNXqPdUa4`, `2n2P0Awz3U4` |
| 19 | Skenario EX200 Terukur | Latihan soal berbobot + kunci | `eGbNXqPdUa4` |
| 20 | Shell Scripting Dasar | `if`/`for`/`while`, variabel, argumen | `eGbNXqPdUa4` |
| 21 | System Engineer Enterprise | SSSD/IDM, SIEM, Satellite, CIS/PCI-DSS, Ansible, HA, DR | — |
| 22 | Runbook Troubleshooting Produksi | fstab no-boot, SELinux, disk penuh, network, LVM, crash | — |

Materi lengkap tiap modul ada di folder [`modul/`](modul/).

---

## 🧪 Lab & Referensi

- 🛠️ **[Latihan Praktik (LAB)](lab/LAB.md)** — tugas tangan langsung per modul.
- ⌨️ **[Cheat Sheet Perintah](referensi/CHEATSHEET.md)** — ringkasan cepat semua perintah.
- 🎓 **[Persiapan EX200](referensi/EX200-prep.md)** — roadmap sertifikasi & tips ujian.

---

## 🖥️ Menyiapkan Lab Lokal (Rekomendasi)

Kamu tidak butuh langganan berbayar untuk belajar. Gunakan salah satu:

1. **VirtualBox + Rocky Linux / AlmaLinux** (clone RHEL, gratis & biner-kompatibel).
2. **WSL2** di Windows: `wsl --install -d FedoraLinux-42` (atau RHEL jika punya subscription).
3. **Podman Container** sebagai "mini-VM" untuk latihan perintah.

```bash
# Contoh: jalankan shell RHEL-like di container (butuh podman/docker)
podman run -it --name lab-rhel rockylinux:9 bash
```

---

## 🤝 Kontribusi

Lihat [CONTRIBUTING.md](CONTRIBUTING.md). Panduan ini terbuka untuk perbaikan
dan penambahan latihan.

---

> 🌐 **Versi web (GitHub Pages):** https://masrizram.github.io/rhcsa-rh124-rh199-guide/

## ⚠️ Catatan Sumber & Status Transkrip

Panduan ini disusun berdasarkan kurikulum resmi **RH124** yang diajarkan di
playlist referensi. **Transkrip ke-19 video belum diambil secara lengkap** —
YouTube memblokir akses transkrip dari IP lingkungan ekstraksi (rate-limit 429 /
IP-ban). Penyusunan mengikuti struktur bab RH124 standar yang dipetakan dari
judul & deskripsi playlist, diperkuat dengan latihan, "Jebakan Umum", "Koneksi
EX200", dan kuis di tiap modul.

> Jika Anda punya transkrip resmi video, silakan kirimkan — saya akan perkaya
> tiap modul dengan contoh kontekstual dari video.

## 🛠️ Struktur Repo (Dua Lapisan)

- **`modul/`, `lab/`, `referensi/` (root)** — sumber Markdown mentah (cocok
  dibaca langsung di GitHub).
- **`docs/` + `mkdocs.yml`** — sumber untuk **situs web dokumentasi** (MkDocs
  Material) dengan navigasi, pencarian, mode gelap, diagram, dan kuis.
- **`requirements.txt`** — dependensi build MkDocs.

### Build & Deploy Lokal (opsional)

```bash
pip install -r requirements.txt
mkdocs build          # hasil di site/
mkdocs serve           # preview lokal di http://127.0.0.1:8000
# Deploy ke GitHub Pages:
mkdocs gh-deploy --force
```


**Playlist referensi:**
https://www.youtube.com/watch?v=pnHqii1Oq8Y&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns

---

## 📄 Lisensi

MIT — bebas digunakan dan disebarluaskan dengan mencantumkan atribusi. Lihat [LICENSE](LICENSE).
