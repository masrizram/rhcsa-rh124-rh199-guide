# Modul 08 — Monitor and Manage Linux Processes

> 📺 Referensi video: [xeN2_R7W7so](https://www.youtube.com/watch?v=xeN2_R7W7so&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns)

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

## Kunci Jawaban (klik untuk lihat)

??? note "Kunci Jawaban Latihan"
    1. `sleep 300 &` → muncul `[1] <PID>`; `jobs` menampilkan `[1]+ Running`;
       `kill %1` mengirim SIGTERM → job selesai (Done).
    2. `pgrep sshd` → mis. `872`; `ps -p 872 -o pid,comm,ni` →
       `872 sshd 0` (nice default 0).
    3. `uptime` → `load average: 0.00, 0.01, 0.05` (sistem idle);
       `free -h` → total/used/free memori + swap.

## Kuis

1. Perintah untuk melihat **semua** proses dalam format standard adalah?
   - a. `ps aux`  b. `ps -ef`  c. `top`  d. `jobs`
2. Sinyal mana yang **tidak bisa diabaikan** oleh proses?
   - a. SIGTERM (15)  b. SIGKILL (9)  c. SIGHUP (1)  d. SIGINT (2)
3. Perintah mejalankan proses dengan nice value 10?
   - a. `renice 10`  b. `nice -n 10`  c. `kill -10`  d. `nohup 10`

??? note "Kunci Jawaban Kuis"
    1. **b** (`ps -ef` standard; `ps aux` BSD style — keduanya tampilkan semua,
       tapi soal minta "standard" → `ps -ef`).
    2. **b** (SIGKILL tidak bisa diabaikan, risiko data korup).
    3. **b** (`nice -n 10 ./cmd`; `renice` untuk proses yang sudah jalan).
