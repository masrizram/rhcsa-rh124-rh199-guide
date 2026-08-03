# Modul 09 — Control Services and Daemons (systemd)

> Referensi video: `RESDzgTwqYk`

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

## 5. Journal (Log systemd)

```bash
journalctl                          # semua log
journalctl -u httpd                 # log satu layanan
journalctl -u httpd -f              # ikuti log (live)
journalctl -p err                   # hanya error ke atas
journalctl --since "2026-01-01" --until "2026-01-02"
journalctl -b                       # sejak boot terakhir
```

## 6. Membuat Unit Service Sederhana

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

## Latihan
1. Cek status `sshd`: `systemctl status sshd`.
2. Matikan dan nyalakan kembali `cups` (jika ada), amati dengan `journalctl -u cups`.
3. Lihat target default dan ubah ke `multi-user.target` (jangan lupa kembalikan).
