# 🚑 Break & Fix — Troubleshooting Wajib EX200

> EX200 itu **~40% soalnya adalah troubleshooting**. Peserta yang tidak tahu
> cara *break & fix* sering gagal meski hafal perintah. Halaman ini rangkuman
> kompak cara memperbaiki sistem yang rusak — wajib dikuasai sebelum ujian.

## 1. Reset Password root (Emergency/Rescue)

Saat boot GRUB, tekan `e` pada entri RHEL, lalu di akhir baris `linux`:

```text
# Hapus ro & rhgb quiet, ganti dengan:
rd.break enforcing=0
```
Lalu `Ctrl+X`. Di shell `switch_root`:

```bash
mount -o remount,rw /sysroot
chroot /sysroot
passwd root            # masukkan password baru
# jika SELinux enforcing, relabel agar tidak lock:
touch /.autorelabel
exit
reboot
```

> Di RHEL 9+, bisa pakai opsi `rw init=/sysroot/bin/sh` lalu `chroot` manual.

## 2. Boot ke Target Rescue / Emergency

```bash
systemctl rescue           # mode rescue (mount / penuh, tdk network)
systemctl emergency        # lebih minim (root fs read-only)
# dari GRUB: tambahkan ke akhir linux:
systemd.unit=rescue.target
```

Gunakan saat service gagal membuat boot hang.

## 3. Perbaiki `/etc/fstab` yang Salah (VM No-Boot)

Gejala: stuck di emergency mode / "you are in rescue mode".
```bash
# di emergency shell:
mount -o remount,rw /
vim /etc/fstab            # komen baris yang salah (awali #)
reboot
```
> **Cegah**: selalu `mount -a` sebelum reboot untuk uji fstab.

## 4. SELinux Lock (Permissive ↔ Enforcing)

```bash
getenforce                 # lihat mode
setenforce 0               # permissive sementara (uji)
# jika file salah label:
restorecon -Rv /var/www    # kembalikan label bawaan
# cek denials:
ausearch -m AVC -ts recent | audit2why
setsebool -P httpd_can_network_connect on
```

## 5. Service Tidak Jalan / Port Tertutup

```bash
systemctl status nama.service
journalctl -xeu nama.service        # lihat error spesifik
ss -tlnp | grep :80                 # cek listening
firewall-cmd --list-all              # cek aturan
firewall-cmd --add-port=80/tcp --permanent && firewall-cmd --reload
```

## 6. Network Hilang / IP Tidak Dapat

```bash
ip addr show
nmcli device status
nmcli con show
nmcli con up "ens160"                 # naikkan koneksi
# jika salah konfig, reset:
nmcli con mod ens160 ipv4.method auto
```

## 7. LVM Rusak / Tidak Mount

```bash
pvs; vgs; lvs                      # cek keadaan
vgchange -ay                      # aktifkan VG yang nonaktif
fsck -y /dev/vg0/lv0              # periksa FS (pastikan tidak sedang mount)
mount /dev/vg0/lv0 /mnt
```

## 8. Ceklist Cepat Saat Sistem "Mati"

- [ ] Apakah layar menunjukkan **emergency/rescue**? → perbaiki fstab/root pw.
- [ ] `journalctl -xb` → cari `failed` / `error`.
- [ ] `systemctl --failed` → service apa yang gagal.
- [ ] `getenforce` → jangan matikan, `restorecon` kalau perlu.
- [ ] `ss -tlnp` + `firewall-cmd --list-all` → port terbuka?
- [ ] `df -h` & `mount` → partisi ter-mount benar?

> Latih skenario ini di VM (bukan container) — container tidak punya GRUB/
> systemd init, jadi `rd.break` tidak bisa diuji di podman.

**Link:** [Persiapan EX200](EX200-prep.md) · [Skenario Terukur](../modul/19-skenario-ex200.md) · [LAB](../lab/LAB.md)
