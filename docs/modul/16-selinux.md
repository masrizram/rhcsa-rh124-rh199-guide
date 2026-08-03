# Modul 16 — SELinux (Keamanan Wajib EX200)

> SELinux adalah penyebab **paling sering** peserta EX200 gagal. Jangan
> mematikan — konfigurasikan dengan benar.

## 1. Konsep Dasar

SELinux = *Mandatory Access Control* (MAC) di atas DAC (permission biasa).
Setiap proses & berkas punya **label/context** (user:role:type:level).

```bash
getenforce              # Enforcing / Permissive / Disabled
sestatus               # detail status
ls -Z /var/www/html    # lihat context berkas
ps -Z                  # lihat context proses
```

## 2. Tiga Mode

| Mode | Arti |
|------|------|
| `Enforcing` | aturan ditegakkan (default & wajib di ujian) |
| `Permissive` | hanya mencatat pelanggaran, tidak blokir (buat debug) |
| `Disabled` | mati total (**jangan** di ujian) |

```bash
sudo setenforce 0       # sementara → Permissive
sudo setenforce 1       # sementara → Enforcing
# permanen: edit /etc/selinux/config → SELINUX=enforcing
```

## 3. Booleans (Saklar Kebijakan)

```bash
getsebool -a | grep httpd          # lihat boolean terkait httpd
getsebool httpd_can_network_connect
sudo setsebool -P httpd_can_network_connect on   # -P = permanen
```

Boolean umum EX200:
- `httpd_can_network_connect` — izinkan httpd konek keluar
- `httpd_enable_homedirs` — izinkan serve dari home
- `ftp_home_dir` — akses home via ftp
- `samba_enable_home_dirs`

## 4. File Context & Restorecon

Kalau memindahkan berkas ke lokasi web, context-nya sering salah → akses ditolak.

```bash
# Lihat mapping default context
semanage fcontext -l | grep httpd_sys_content_t

# Terapkan context ke direktori kita
sudo semanage fcontext -a -t httpd_sys_content_t "/web(/.*)?"
sudo restorecon -Rv /web          # terapkan ke filesystem

# Cek:
ls -Z /web
```

## 5. Membaca Denial (Log)

```bash
sudo ausearch -m AVC -ts recent          # log penolakan terbaru
sudo sealert -a /var/log/audit/audit.log # saran perbaikan (jika ada setroubleshoot)
```

## 6. Port Labeling

```bash
sudo semanage port -l | grep http
sudo semanage port -a -t http_port_t -p tcp 8080   # izinkan httpd di 8080
```

## 7. Jebakan Umum (EX200)

!!! danger "Jebakan"
    - **Mematikan SELinux** (`disabled`) karena "biar jalan" → otomatis gagal ujian.
      Gunakan `setsebool` / `restorecon` / `semanage`.
    - Lupa `restorecon` setelah memindahkan berkas web → 403 Forbidden padahal
      permission 755 sudah benar.
    - `setsebool` tanpa `-P` → hilang setelah reboot, ujian verifikasi pasca-reboot.
    - Salah menambah `fcontext` (regex salah) → `restorecon` tidak mempan.

## 8. Koneksi ke EX200

!!! success "EX200"
    Soal klasik: "Jalankan web di port 8080 dengan DocumentRoot `/web`; pastikan
    berfungsi walau SELinux Enforcing." Kunci:
    ```bash
    sudo semanage fcontext -a -t httpd_sys_content_t "/web(/.*)?"
    sudo restorecon -Rv /web
    sudo semanage port -a -t http_port_t -p tcp 8080
    sudo setsebool -P httpd_can_network_connect on   # bila perlu
    sudo firewall-cmd --add-port=8080/tcp --permanent
    ```

## Kuis Cepat

1. Perintah melihat mode saat ini? (`getenforce`)
2. Apa bedanya `Permissive` vs `Disabled`? (Permissive mencatat; Disabled mati total)
3. Setelah pindah berkas ke `/web`, perintah apa agar context benar? (`restorecon -Rv /web`)

## Latihan
1. `getenforce` → pastikan `Enforcing`. Jika `Permissive`, `setenforce 1`.
2. Buat `/web/index.html`, set context `httpd_sys_content_t`, `restorecon -Rv /web`.
3. Izinkan httpd di port 8080 via `semanage port`, verifikasi dengan `semanage port -l | grep 8080`.
