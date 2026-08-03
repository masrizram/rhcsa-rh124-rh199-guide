# 📖 Glosarium — Istilah RHCSA

Daftar istilah yang sering muncul di panduan & ujian EX200.

| Istilah | Arti |
|---------|------|
| **RHCSA** | Red Hat Certified System Administrator (sertifikasi EX200) |
| **RH124 / RH199** | Kursus System Administration I (beginner / accelerated) |
| **RHEL** | Red Hat Enterprise Linux |
| **systemd** | Init system & manajer layanan modern RHEL 7+ |
| **unit** | Objek yang dikelola systemd (service, target, socket, dll) |
| **DAC** | Discretionary Access Control (permission biasa: rwx) |
| **MAC** | Mandatory Access Control (SELinux) |
| **SELinux** | Mekanisme keamanan wajib di RHEL (label/context) |
| **boolean** | Saklar kebijakan SELinux (on/off) |
| **context** | Label keamanan `user:role:type:level` milik SELinux |
| **restorecon** | Mengembalikan context berkas ke default |
| **LVM** | Logical Volume Manager — fleksibilitas partisi dinamis |
| **PV / VG / LV** | Physical Volume / Volume Group / Logical Volume |
| **XFS** | File system default RHEL (bisa di-grow online) |
| **fstab** | File konfigurasi mount permanen (`/etc/fstab`) |
| **UUID** | ID unik perangkat (lebih stabil dari `/dev/sdX`) |
| **NetworkManager** | Manajer jaringan RHEL (pakai `nmcli`/`nmtui`) |
| **nmcli** | CLI konfigurasi jaringan |
| **firewalld** | Firewall dinamis RHEL (zone & service/port) |
| **DNF** | Package manager RHEL 8+ (pengganti YUM) |
| **repository** | Sumber paket perangkat lunak |
| **Podman** | Engine container rootless (pengganti Docker di RHEL) |
| **systemd timer** | Penjadwal modern pengganti cron |
| **cron / crontab** | Penjadwal tugas berulang |
| **at** | Penjadwal tugas sekali waktu |
| **journald / journalctl** | Sistem log systemd |
| **Cockpit** | Web console RHEL (port 9090) |
| **shell** | Antarmuka perintah (bash default di RHEL) |
| **privilege escalation** | Menaikkan hak (via `sudo` / `wheel`) |
| **ACL** | Access Control List — izin file granular per-user |
| **target** | "Runlevel" systemd (`multi-user`, `graphical`, `rescue`) |
| **EX200** | Kode ujian RHCSA (performance-based, 3 jam) |
| **performance-based** | Ujian praktik (bukan pilihan ganda) |

> Tips: kuasai semua istilah di atas sebelum ujian — soal EX200 menggunakan
> istilah ini secara harfiah.
