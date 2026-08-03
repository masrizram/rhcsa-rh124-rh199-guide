# Modul 10 — Configure and Secure SSH

> 📺 Referensi video: [jGzIZZrdEpE](https://www.youtube.com/watch?v=jGzIZZrdEpE&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns)

## 1. SSH (Secure Shell)

SSH menggantikan Telnet — seluruh lalu lintas dienkripsi. Server = `sshd`,
klien = `ssh`.

## 2. Koneksi Dasar

```bash
ssh user@host                 # login jarak jauh
ssh -p 2222 user@host         # port non-default
ssh user@host "uptime"        # jalankan perintah remote
scp file.txt user@host:/tmp/  # salin berkas (secure copy)
rsync -avz dir/ user@host:dir/   # sinkronisasi efisien (inkremental)
```

## 3. Autentikasi Kunci (Public Key)

Lebih aman & wajib di EX200 daripada sandi.

```bash
# Di klien: buat pasangan kunci
ssh-keygen -t ed25519 -C "laptop-saya"
# (tekan Enter untuk lokasi & passphrase default)

# Salin kunci publik ke server
ssh-copy-id user@host
# atau manual:
cat ~/.ssh/id_ed25519.pub | ssh user@host 'cat >> ~/.ssh/authorized_keys'

# Uji: sekarang login tanpa sandi
ssh user@host
```

## 4. Mengamankan `sshd`

Edit `/etc/ssh/sshd_config` lalu `sudo systemctl restart sshd`:

```
PermitRootLogin no            # cegah login langsung root
PasswordAuthentication no     # wajib pakai kunci
Port 2222                     # ubah port default (opsional)
AllowUsers budi andi          # batasi user yang boleh masuk
MaxAuthTries 3                # batasi percobaan
ClientAliveInterval 300       # putus jika idle
```

```bash
sudo sshd -t                  # UJI konfigurasi sebelum restart!
sudo systemctl restart sshd
```

> ⚠️ Jangan logout sebelum yakin `sshd` masih bisa diakses — buka sesi kedua
> untuk uji coba.

## 5. `scp` vs `sftp`

```bash
sftp user@host                # sesi transfer interaktif
# perintah: get, put, ls, lls, bye
```

## 6. Host Alias (`~/.ssh/config`)

```bash
# ~/.ssh/config (chmod 600)
Host server1
    HostName 192.168.1.10
    User budi
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
```
Lalu cukup: `ssh server1`.

## 7. Jebakan Umum (EX200)

!!! danger "Jebakan"
    - Edit `sshd_config` lalu `systemctl restart sshd` **tanpa** `sshd -t` dulu →
      typo membuat SSH mati, kamu terkunci keluar (tidak bisa remote lagi).
    - Mematikan `PasswordAuthentication` sebelum kunci publik ter-copy → lockout.
    - Lupa buka port 22 di `firewalld` setelah install ulang → tidak bisa login.
    - Menjalankan `PermitRootLogin no` tapi butuh root remote → sediakan user
      biasa dengan `sudo` instead.

## 8. Koneksi ke EX200

!!! success "EX200"
    Soal SSH umum: "Amankan server — forbidden root login, wajib kunci, ubah port,
    batasi user." Kunci: edit `/etc/ssh/sshd_config` → `sshd -t` (UJI!) →
    `systemctl restart sshd` → verifikasi dari sesi ke-2.


## Kunci Jawaban (klik untuk lihat)

??? note "Kunci Jawaban Latihan"
    1. `ssh-copy-id` menaruh pubkey ke authorized_keys.
    2. `PermitRootLogin no` cegah root login langsung.
    3. `scp -P 2222` untuk port non-default.

## Kuis Cepat

1. Perintah uji konfigurasi sshd sebelum restart? (`sshd -t`)
2. Bagaimana copy kunci publik ke server dengan aman? (`ssh-copy-id user@host`)
3. Directive untuk melarang login root via SSH? (`PermitRootLogin no`)

## Latihan
1. Buat kunci `ssh-keygen` dan salin ke server lab (atau VM lokal).
2. Set `PasswordAuthentication no` + `PermitRootLogin no`, uji dengan `sshd -t`.
3. Buat alias `Host lab` di `~/.ssh/config` dan login dengan `ssh lab`.
