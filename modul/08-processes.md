# Modul 08 — Monitor and Manage Linux Processes

> Referensi video: `xeN2_R7W7so`

## 1. Apa itu Proses?

Proses = program yang sedang berjalan. Setiap proses punya **PID** (Process ID).
Proses dibuat dari *parent* via `fork()`; `systemd` (PID 1) adalah akar semua
proses di RHEL modern.

## 2. Melihat Proses

```bash
ps                      # proses di shell saat ini
ps aux                  # semua proses (BSD style)
ps -ef                  # semua proses (standard)
ps -ef | grep httpd     # saring
top                     # tampilan dinamis (q untuk keluar)
htop                    # versi interaktif (jika terinstal)
```

## 3. Mengelola Proses

```bash
kill 1234               # kirim SIGTERM (15) — minta berhenti sopan
kill -9 1234            # SIGKILL — paksa mati (hindari kecuali perlu)
pkill httpd             # matikan by name
killall firefox         # matikan semua instance
```

> SIGTERM (15) memberi proses kesempatan membersihkan diri; SIGKILL (9) tidak
> bisa diabaikan tapi bisa meninggalkan data korup.

## 4. Job Control (Latar Belakang)

```bash
sleep 100 &             # jalankan di background, dapat [jobnum] PID
jobs                    # lihat daftar job
fg %1                   # bawa job 1 ke foreground
Ctrl + Z                # suspend (jeda) foreground job
bg %1                   # lanjutkan job di background
```

## 5. Prioritas (Nice Value)

Semakin rendah *nice value* (–20 s.d. 19), semakin tinggi prioritas.

```bash
nice -n 10 ./berat      # jalankan dgn nice 10
renice -n 5 -p 1234     # ubah nice proses 1234
```

## 6. Beban Sistem

```bash
uptime                  # load average (1, 5, 15 menit)
w                       # siapa login + beban
free -h                 # memori & swap
vmstat 1                # statistik memori/IO/CPU per detik
```

## Latihan
1. Jalankan `sleep 300 &`, cek `jobs`, lalu `kill %1`.
2. Temukan PID `sshd` dengan `pgrep sshd`, lalu `ps -p <PID> -o pid,comm,ni`.
3. Amati beban: `uptime` dan `free -h`.
