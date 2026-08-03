# Modul 17 — Penjadwalan (cron, at) & Time Zone

> Muncul di objektif EX200: *"deploy, adjust, and maintain systems"* —
> mencakup cron, at, dan pengaturan waktu/locale.

> 📺 Referensi video: [RHCSA & EX200 Prep](https://www.youtube.com/watch?v=eGbNXqPdUa4&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns) (penjadwalan dalam kurikulum RH124/RH199)

## 1. `cron` — Jadwal Berulang

```bash
crontab -e                   # edit jadwal user saat ini
crontab -l                   # lihat
crontab -r                   # hapus semua (hati-hati!)
sudo crontab -u budi -l      # lihat crontab user lain

# Format:  m  h  dom  mon  dow  perintah
# Contoh: tiap hari 02:00 backup
0 2 * * * tar czf /backup/etc.tar.gz /etc
# Setiap 30 menit
*/30 * * * * /usr/local/bin/cek.sh
# Hanya hari Senin jam 09:15
15 9 * * 1 /path/script
```

### Direktori sistem
```bash
/etc/cron.d/         # cron job gaya sysadmin (format: user perintah)
/etc/cron.hourly/   # jalan tiap jam
/etc/cron.daily/    # tiap hari
/etc/cron.weekly/   # tiap minggu
/etc/cron.monthly/  # tiap bulan
```

### Anacron (untuk desktop/laptop mati)
```bash
cat /etc/anacrontab  # tugas harian/mingguan dengan delay boot
```

## 2. `at` — Jadwal Sekali Waktu

```bash
at now + 1 hour            # jadwalkan 1 jam lagi
at 23:00                   # malam ini jam 23:00
at> backup.sh              # ketik perintah
at> <Ctrl+D>               # kirim (EOF)
atq                        # lihat antrian
atrm 1                     # batalkan job nomor 1
```

## 3. Time Zone & Waktu
```bash
timedatectl                 # lihat tanggal, waktu, zona
sudo timedatectl set-timezone Asia/Jakarta
sudo timedatectl set-time "2026-08-03 10:00:00"
timedatectl list-timezones | grep -i jakarta
```

## 3b. Time Service Client (`chrony`) — Wajib EX200

Objektif EX200: *"Configure time service clients"*. RHEL menggunakan **chrony**
(`chronyd`) sebagai NTP client/server. Konfigurasi di `/etc/chrony.conf`.

```bash
# Cek status sinkronisasi
timedatectl status                 # baris "System clock synchronized"
chronyc tracking                   # detail sumber waktu
chronyc sources -v                 # lihat server NTP aktif

# Tambahkan NTP server (edit /etc/chrony.conf)
sudo sed -i 's/^pool.*/pool 0.id.pool.ntp.org iburst/' /etc/chrony.conf
# atau tambah: server time.google.com iburst
sudo systemctl enable --now chronyd
sudo chronyc makestep              # paksa sinkron sekarang
```

> Verifikasi: `chronyc tracking` → `Leap status : Normal` dan
> `timedatectl` menunjukkan `System clock synchronized: yes`.
> Soal EX200: "konfigurasi client waktu ke NTP server X" → edit
> `/etc/chrony.conf`, ganti/ tambah `server X iburst`, lalu `restart chronyd`.


## 4. `systemd` Timer (Modern)

Timer adalah pengganti cron di many kasus; diujikan di EX200 ("schedule tasks
using systemd timer units"). Timer membutuhkan **dua** unit: `.service` (apa yang
dikerjakan) dan `.timer` (kapan dijalankan).

```bash
# 1) Unit SERVICE — tugas yang dijalankan
sudo tee /etc/systemd/system/backup-etc.service > /dev/null <<'EOF'
[Unit]
Description=Backup /etc ke /backup/etc.tar.gz

[Service]
Type=oneshot
ExecStart=/bin/tar czf /backup/etc.tar.gz /etc
EOF

# 2) Unit TIMER — jadwal (OnCalendar, bukan cron 5-kolom)
sudo tee /etc/systemd/system/backup-etc.timer > /dev/null <<'EOF'
[Unit]
Description=Backup /etc setiap hari 02:00

[Timer]
OnCalendar=*-*-* 02:00:00     # format: Tahun-Bulan-Hari Jam:Menit:Detik
Persistent=true               # jika VM mati saat jadwal, jalankan saat nyala
Unit=backup-etc.service

[Install]
WantedBy=timers.target
EOF

# 3) Aktifkan & verifikasi
sudo systemctl daemon-reload
sudo systemctl enable --now backup-etc.timer
systemctl list-timers --all | grep backup-etc     # lihat next run
sudo systemctl start backup-etc.service           # jalankan manual (tes)
```

Format `OnCalendar` berguna:
```text
*-*-* 02:00:00     # tiap hari 02:00
*-*-* 02,14:00:00  # 02:00 dan 14:00 tiap hari
Mon *-*-* 09:00:00 # tiap Senin 09:00
*:0/15             # tiap 15 menit
daily              # kata kunci (juga: hourly, weekly, monthly)
```

> **Bedanya dengan cron:** timer dijalankan oleh systemd (bukan `crond`),
> mendukung `Persistent=true` (mengejar jadwal terlewat), dan lognya langsung
> masuk `journalctl -u backup-etc.service`. Soal EX200 kadang explicit minta
> "systemd timer", bukan cron.

## 5. Jebakan Umum (EX200)

!!! danger "Jebakan"
    - `crontab -r` tanpa argumen = **hapus semua** jadwal (bukan "remove one").
    - Path di cron tidak punya `$PATH` lengkap → selalu pakai **path absolut**
      ke skrip/perintah.
    - Cron menggunakan `/bin/sh`, bukan bash → hindari bashism (`source`, `[[ ]]`).
    - Lupa `systemctl enable crond` (jarang, tapi pastikan `crond` jalan).

## 6. Koneksi ke EX200

!!! success "EX200"
    Soal: "Buat tugas yang membackup `/etc` tiap hari 02:00 ke `/backup/etc.tar.gz`."
    ```bash
    sudo mkdir -p /backup
    (sudo crontab -l 2>/dev/null; echo "0 2 * * * tar czf /backup/etc.tar.gz /etc") | sudo crontab -
    sudo crontab -l
    ```

## Kuis Cepat

1. Format cron 5 kolom? (menit jam tanggal-bulan hari-dalam-minggu)
2. Perintah hapus semua crontab? (`crontab -r` — berbahaya!)
3. Set zona waktu Jakarta? (`timedatectl set-timezone Asia/Jakarta`)

## Latihan
1. Buat crontab yang mencatat `date` ke `~/log.txt` tiap 5 menit (`*/5 * * * *`).
2. Jadwalkan `at` 1 menit lagi untuk `echo done > ~/at.txt`.
3. Ubah zona waktu ke `Asia/Jakarta`, verifikasi `timedatectl`.

## Kunci Jawaban (klik untuk lihat)

??? note "Kunci Jawaban Latihan"
    1. `crontab -e` → `*/5 * * * * date >> ~/log.txt` (5 kolom: m h dom mon dow).
    2. `echo "echo done > ~/at.txt" | at now + 1 minute`.
    3. `timedatectl set-timezone Asia/Jakarta`; `timedatectl` → Time zone: Asia/Jakarta.

??? note "Kunci Jawaban Kuis"
    1. **5 kolom**: menit, jam, tanggal-bulan, bulan, hari-dalam-minggu.
    2. **`crontab -r`** menghapus semua crontab user (tanpa konfirmasi).
    3. **`timedatectl set-timezone Asia/Jakarta`**.
