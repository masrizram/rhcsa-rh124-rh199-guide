# 📖 Glosarium — Istilah RHCSA

Daftar istilah yang sering muncul di panduan & ujian EX200.

> **Catatan bahasa (KBBI):** Istilah teknis Linux/Red Hat (mis. `systemd`,
> `podman`, `SELinux`, `dnf`) **tidak terdapat di Kamus Besar Bahasa Indonesia**
> karena merupakan nama perangkat lunak — padanannya mengikuti dokumentasi
> resmi Red Hat. Untuk kata Indonesia di penjelasan, panduan ini menggunakan
> padanan **KBBI**, mis. *berkas* (bukan "file"), *direktori* (bukan "folder"),
> *penyunting teks* (bukan "text editor"), *perangkat* (bukan "device").

| Istilah | Arti |
|---------|------|
| **RHCSA** | Red Hat Certified System Administrator (sertifikasi EX200) |
| **RH124 / RH199** | Kursus System Administration I (pemula / akselerasi) |
| **RHEL** | Red Hat Enterprise Linux |
| **systemd** | Init system & manajer layanan modern RHEL 7+ |
| **unit** | Objek yang dikelola systemd (layanan, target, soket, dll) |
| **DAC** | Discretionary Access Control (izin biasa: rwx) |
| **MAC** | Mandatory Access Control (SELinux) |
| **SELinux** | Mekanisme keamanan wajib di RHEL (label/context) |
| **boolean** | Saklar kebijakan SELinux (on/off) |
| **context** | Label keamanan `user:role:type:level` milik SELinux |
| **restorecon** | Mengembalikan context berkas ke bawaan |
| **LVM** | Logical Volume Manager — fleksibilitas partisi dinamis |
| **PV / VG / LV** | Physical Volume / Volume Group / Logical Volume |
| **XFS** | Sistem berkas bawaan RHEL (bisa di-grow online) |
| **fstab** | Berkas konfigurasi kait permanen (`/etc/fstab`) |
| **UUID** | ID unik perangkat (lebih stabil dari `/dev/sdX`) |
| **NetworkManager** | Manajer jaringan RHEL (pakai `nmcli`/`nmtui`) |
| **nmcli** | CLI konfigurasi jaringan |
| **firewalld** | Firewall dinamis RHEL (zona & layanan/port) |
| **DNF** | Package manager RHEL 8+ (pengganti YUM) |
| **repository** | Sumber paket perangkat lunak |
| **Podman** | Engine container rootless (pengganti Docker di RHEL) |
| **systemd timer** | Penjadwal modern pengganti cron |
| **cron / crontab** | Penjadwal tugas berulang |
| **at** | Penjadwal tugas sekali waktu |
| **journald / journalctl** | Sistem log systemd |
| **Cockpit** | Web console RHEL (port 9090) |
| **shell** | Antarmuka perintah (bash bawaan di RHEL) |
| **privilege escalation** | Menaikkan hak (via `sudo` / `wheel`) |
| **ACL** | Access Control List — izin berkas granular per-user |
| **target** | "Runlevel" systemd (`multi-user`, `graphical`, `rescue`) |
| **EX200** | Kode ujian RHCSA (performance-based, 3 jam) |
| **performance-based** | Ujian praktik (bukan pilihan ganda) |
| **Stratis** | Manajemen storage modern (pool/filesystem thin-provision + snapshot) |
| **VDO** | Virtual Data Optimizer — deduplikasi & kompresi block storage |
| **disk quota** | Batas pemakaian ruang/inode per user/group pada filesystem |
| **autofs** | Mount otomatis on-demand (sering untuk NFS client) |
| **nmstate** | Konfigurasi jaringan deklaratif via state file YAML (RHEL 10) |
| **chrony** | Client/server NTP (time service) bawaan RHEL |
| **tuned** | Profil penyesuaian performa/daya sistem |
| **Flatpak** | Format paket aplikasi terisolasi (sandbox) |
| **bootc** | Image mode / bootable container (RHEL 10) |
| **rd.break** | Interupsi boot untuk reset password root (lewat GRUB) |
| **grub2** | Bootloader RHEL (bisa diubah via `grubby`/`grub2-mkconfig`) |
| **IPv6** | Alamat jaringan versi 6 (wajib dikonfig di EX200 selain IPv4) |

### Padanan KBBI (kata Indonesia)

| Istilah Asing | Padanan KBBI (dipakai di panduan) |
|--------------|-----------------------------------|
| file | **berkas** |
| folder / directory | **direktori** |
| text editor | **penyunting teks** |
| device | **perangkat** |
| user | **pengguna** |
| group | **kelompok** |
| permission | **izin** |
| service / daemon | **layanan** |
| log | **catatan** (dalam konteks sistem) |
| repository | **repositori** (serapan, lazim di KBBI) |

> Tips: kuasai semua istilah di atas sebelum ujian — soal EX200 menggunakan
> istilah ini secara harfiah.
