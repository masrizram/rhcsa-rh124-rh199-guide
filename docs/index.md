<div class="rh-hero">
  <div class="rh-banner">🐧</div>
  <span class="rh-badge">🐧 RHEL 9 & 10 · EX200</span>
  <h1>Belajar RHCSA, Cara yang Benar</h1>
  <p>Panduan langkah-demi-langkah menuju sertifikasi <strong>Red Hat Certified
  System Administrator (EX200)</strong> berbasis kurikulum RH124 / RH199.
  Materi, latihan, jebakan ujian, dan kuis — semua gratis.</p>
  <div class="rh-cta">
    <a class="rh-btn rh-btn-primary" href="pusat-belajar/">🗺️ Mulai Belajar</a>
    <a class="rh-btn rh-btn-ghost" href="modul/00-pengantar-dan-roadmap/">Pengantar →</a>
  </div>
  <div class="rh-kbd-hint">Cepat cari materi: tekan <kbd>Ctrl</kbd>+<kbd>K</kbd> (atau <kbd>⌘</kbd>+<kbd>K</kbd> di Mac)</div>
</div>

<div class="rh-grid">
  <div class="rh-card">
    <div class="rh-ico">📦</div>
    <h3>18 Modul Terstruktur</h3>
    <p>Dari shell dasar hingga Podman & SELinux, disusun sesuai kurikulum resmi.</p>
  </div>
  <div class="rh-card">
    <div class="rh-ico">🛠️</div>
    <h3>Latihan Praktik</h3>
    <p>LAB per modul + simulasi EX200 90 menit, bisa dijalankan tanpa disk tambahan.</p>
  </div>
  <div class="rh-card">
    <div class="rh-ico">🛡️</div>
    <h3>Jebakan & Koneksi EX200</h3>
    <p>Tiap modul kunci diberi tahu apa yang sering membatalkan peserta ujian.</p>
  </div>
  <div class="rh-card">
    <div class="rh-ico">⌨️</div>
    <h3>Cheat Sheet & Glosarium</h3>
    <p>Ringkasan perintah + 35+ istilah RHCSA siap dibuka kapan saja.</p>
  </div>
</div>

# 📘 Panduan Lengkap RHCSA (RH124 / RH199) — RHEL 9 & 10

Selamat datang di panduan langkah-demi-langkah menuju sertifikasi
**Red Hat Certified System Administrator (EX200)**, berbasis kurikulum
**Red Hat System Administration I (RH124 / RH199)**.

> **Basis materi:** RHEL 9.3 (berlaku juga untuk RHEL 10.x). Semua perintah diuji
> pada lingkungan RHEL / Rocky Linux / AlmaLinux / Fedora yang setara.

## 🧭 Mulai dari Mana?

1. Buka **[🗺️ Pusat Belajar](pusat-belajar.md)** — peta jalan 16 minggu & cara pakai.
2. Ikuti **Modul 0 → 16** di panel navigasi kiri.
3. Kerjakan **[🛠️ Latihan (LAB)](lab/LAB.md)** di tiap modul.
4. Gunakan **[⌨️ Cheat Sheet](referensi/CHEATSHEET.md)** sebagai referensi cepat.
5. Persiapan ujian: **[🎯 Persiapan EX200](referensi/EX200-prep.md)**.

## 🎯 Yang Akan Kamu Kuasai

- Akses & perintah RHEL via shell & web console (Cockpit).
- Kelola berkas, teks (`vim`), user/grup, dan hak akses (incl. ACL).
- Pantau proses, kelola `systemd`, amankan SSH.
- Konfigurasi jaringan, DNF, dan file system (incl. LVM).
- Jalankan **container Podman** sebagai systemd service.
- Siap menghadapi ujian **EX200 (RHCSA)**.

## 📚 Daftar Modul

| # | Modul |
|---|-------|
| 00 | [Pengantar & Roadmap](modul/00-pengantar-dan-roadmap.md) |
| 01 | [Get Started with RHEL](modul/01-get-started-rhel.md) |
| 02 | [Access the Command Line](modul/02-access-command-line.md) |
| 03 | [Manage Files](modul/03-manage-files.md) |
| 04 | [Get Help in RHEL](modul/04-get-help.md) |
| 05 | [Text Files (vim)](modul/05-text-files.md) |
| 06 | [Users & Groups](modul/06-users-groups.md) |
| 07 | [Permissions & ACL](modul/07-file-permissions.md) |
| 08 | [Processes](modul/08-processes.md) |
| 09 | [systemd Services](modul/09-services-daemons.md) |
| 10 | [SSH & Security](modul/10-ssh.md) |
| 11 | [Networking](modul/11-networking.md) |
| 12 | [Software (DNF)](modul/12-software-dnf.md) |
| 13 | [File Systems & LVM](modul/13-filesystems.md) |
| 14 | [Support & Logs](modul/14-support.md) |
| 15 | [Podman & Containers](modul/15-podman-containers.md) |
| 16 | [EX200 (RHCSA) Prep](modul/15-ex200-prep.md) |

## 🖥️ Siapkan Lab (Gratis)

```bash
# Opsi container (tanpa install OS):
podman run -it --name lab-rhel rockylinux:9 bash
# Atau VirtualBox + Rocky Linux 9, atau WSL2: wsl --install -d FedoraLinux-42
```

## ⚠️ Catatan Sumber & Status Transkrip

Panduan ini mengikuti kurikulum resmi **RH124** dari playlist referensi.
**Transkrip ke-19 video belum diambil seluruhnya** (YouTube memblokir akses
transkrip dari IP ekstraksi). Materi diperkuat dengan latihan, *Jebakan Umum*,
*Koneksi EX200*, dan kuis di tiap modul. Jika Anda punya transkrip resmi,
kirimkan agar tiap modul bisa diperkaya dengan contoh video.

**Playlist referensi:**
https://www.youtube.com/watch?v=pnHqii1Oq8Y&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns

