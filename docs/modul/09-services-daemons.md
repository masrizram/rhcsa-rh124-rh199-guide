# Modul 09 — Control Services and Daemons (systemd)

> 📺 Referensi video: [RESDzgTwqYk](https://www.youtube.com/watch?v=RESDzgTwqYk&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns)

## 1. systemd — Init System Modern

RHEL 7+ menggunakan **systemd** sebagai init. Ia mengelola *unit* (service,
target, socket, dll). `systemctl` adalah alat utamanya.

## 2. Perintah Dasar `systemctl`

```bash
systemctl status httpd            # status layanan
sudo systemctl start httpd        # nyalakan sekarang
sudo systemctl stop httpd         # matikan sekarang
sudo systemctl restart httpd      # restart
sudo systemctl reload httpd       # muat ulang konfigurasi (tanpa putus)
sudo systemctl enable httpd       # aktif otomatis saat boot
sudo systemctl disable httpd      # nonaktifkan dari boot
sudo systemctl is-enabled httpd   # cek status enable
```

## 3. Melihat Daftar Unit

```bash
systemctl list-units --type=service        # layanan aktif
systemctl list-unit-files --type=service   # semua + status enable/disable
systemctl --failed                         # unit yang gagal start
```

## 4. Target (Runlevel Pengganti)

```bash
systemctl get-default                  # target default (mis. multi-user)
sudo systemctl set-default graphical.target
sudo systemctl isolate rescue.target   # masuk mode rescue (single-user)
```

| Target lama | Setara |
|-------------|--------|
| runlevel 3 | `multi-user.target` |
| runlevel 5 | `graphical.target` |
| runlevel 6 | `reboot.target` |

## 5. Tuning Profiles (`tuned`) — Wajib EX200

Objektif EX200: *"Manage tuning profiles"*. `tuned` menyediakan profil
optimasi performa/daya yang bisa aktif otomatis.

```bash
sudo dnf install -y tuned tuned-utils
sudo systemctl enable --now tuned
tuned-adm list                 # lihat profil tersedia
tuned-adm active               # profil aktif sekarang
sudo tuned-adm profile throughput-performance   # aktifkan profil
sudo tuned-adm recommend       # saran profil otomatis dari tuned
```

Profil umum: `balanced` (default), `powersave`, `throughput-performance`
(server), `latency-performance`, `virtual-guest`, `virtual-host`.

> Verifikasi: `tuned-adm active` harus menampilkan profil yang kamu set —
> soal EX200 sering: "aktifkan profil throughput-performance dan pastikan
> persisten setelah reboot" (tuned sudah enable --now, profil tersimpan otomatis).

## 6. Bootloader (`grub2`) & Akses Darurat — Wajib EX200

Objektif EX200: *"Modify the system bootloader"* dan *"Interrupt the boot
process in order to gain access to a system"* (mis. lupa root password).

**Mengubah parameter bootloader (grub2):**
```bash
# Lihat entry & edit default via grubby (cara aman di RHEL)
grubby --update-kernel=ALL --args="nomodeset"   # tambah param boot
grubby --info=ALL                               # lihat kernel & args
sudo grub2-mkconfig -o /boot/grub2/grub.cfg      # regenerate grub.cfg
```

**Interrupt boot untuk reset password root (rd.break):**
1. Di menu GRUB, tekan `e` pada kernel default.
2. Di baris `linux`/`linuxefi`, tambahkan `rd.break` di akhir (lalu `Ctrl+X`).
3. Sistem berhenti di `switch_root:/#` (initramfs shell).
4. Remount root writable & masuk chroot:
   ```bash
   mount -o remount,rw /sysroot
   chroot /sysroot
   passwd root          # set password root baru
   touch /.autorelabel  # penting: biar SELinux relabel
   exit; exit           # reboot
   ```
> ⚠️ Tanpa `touch /.autorelabel`, SELinux akan blokir login setelah reboot
> (label konteks berubah). Di RHEL 9+ bisa juga pakai `rw init=/sysroot/bin/sh`
> lalu `chroot` manual.

## 7. Journal (Log systemd)

```bash
journalctl                          # semua log
journalctl -u httpd                 # log satu layanan
journalctl -u httpd -f              # ikuti log (live)
journalctl -p err                   # hanya error ke atas
journalctl --since "2026-01-01" --until "2026-01-02"
journalctl -b                       # sejak boot terakhir
```

## 8. Membuat Unit Service Sederhana

`/etc/systemd/system/hello.service`:
```ini
[Unit]
Description=Hello Service

[Service]
ExecStart=/usr/bin/echo hello
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now hello.service
```

## 9. Jebakan Umum (EX200)

!!! danger "Jebakan"
    - `systemctl restart` memutus koneksi sesaat — di server produksi gunakan
      `reload` bila layanan mendukung (tercantum di `systemctl cat <svc>`).
    - Lupa `systemctl daemon-reload` setelah mengedit file unit → perubahan
      tidak dikenali.
    - `enable` vs `start`: `enable` baru aktif saat boot; untuk jalan sekarang
      butuh `enable --now` atau `start`.
    - Melihat log tapi pakai `cat /var/log/messages` padahal layanan menulis ke
      journal → gunakan `journalctl -u <svc>`.

## 10. Koneksi ke EX200

!!! success "EX200"
    Soal: "Buat layanan `webapp` yang menjalankan `/opt/webapp/run.sh`, auto-start
    saat boot, dan restart bila gagal." Kunci: tulis unit di
    `/etc/systemd/system/webapp.service` dengan `Restart=on-failure` +
    `WantedBy=multi-user.target`, lalu `daemon-reload` → `enable --now`.


## Kunci Jawaban (klik untuk lihat)

??? note "Kunci Jawaban Latihan"
    1. `systemctl enable --now` aktif sekarang & saat boot.
    2. `systemctl status` kolom: Loaded/Active/Sub.
    3. `journalctl -u` filter log unit.

## Kuis Cepat

1. Perintah muat ulang konfig setelah edit unit? (`systemctl daemon-reload`)
2. Bedanya `restart` vs `reload`? (restart putus sejenak; reload tanpa putus)
3. Cek log satu layanan? (`journalctl -u <nama>`)

## Latihan
1. Cek status `sshd`: `systemctl status sshd`.
2. Matikan dan nyalakan kembali `cups` (jika ada), amati dengan `journalctl -u cups`.
3. Lihat target default dan ubah ke `multi-user.target` (jangan lupa kembalikan).
4. Buat unit `hello.service` (echo), `enable --now`, verifikasi `journalctl -u hello`.
5. Cek profil tuned aktif: `tuned-adm active`; coba ganti ke `throughput-performance`.
6. (Lab) simulasikan `rd.break`: di GRUB tekan `e`, tambah `rd.break`, `Ctrl+X`,
   lalu `mount -o remount,rw /sysroot && chroot /sysroot && passwd root && touch /.autorelabel`.
