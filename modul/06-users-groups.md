# Modul 06 — Manage Local Users and Groups

> Referensi video: `yg1IdxH38OA`

## 1. Konsep User & Group

- Setiap user punya **UID** (User ID) unik.
- Setiap group punya **GID** (Group ID).
- User punya *primary group* dan bisa masuk ke banyak *supplementary group*.

## 2. Berkas Penting

| Berkas | Isi |
|--------|-----|
| `/etc/passwd` | akun user (UID, GID, home, shell) |
| `/etc/shadow` | kata sandi (hash, kedaluwarsa) — hanya root |
| `/etc/group` | definisi group |
| `/etc/gshadow` | sandi group |

Format `/etc/passwd`:
```
nama:password(x):UID:GID:desc:home:shell
```

## 3. Membuat & Mengelola User

```bash
sudo useradd budi                 # buat user
sudo useradd -m -s /bin/bash budi # pastikan home & shell
sudo passwd budi                  # set kata sandi
sudo usermod -aG wheel budi       # tambahkan ke group wheel (sudo)
sudo usermod -c "Budi Santoso" budi   # ubah deskripsi
sudo usermod -s /sbin/nologin budi    # cegah login interaktif
sudo userdel -r budi              # hapus user + home
```

## 4. Mengelola Group

```bash
sudo groupadd devops
sudo groupmod -n dev devops       # ganti nama group
sudo gpasswd -a budi dev          # tambah anggota
sudo gpasswd -d budi dev          # hapus anggota
sudo groupdel dev                 # hapus group
```

## 5. Mengatur Kedaluwarsa Sandi

```bash
sudo chage -l budi               # lihat kebijakan sandi
sudo chage -E 2026-12-31 budi    # masa berlaku sampai tanggal
sudo chage -m 7 -M 90 budi       # min 7 hari, max 90 hari
```

## 6. `id` & `who`

```bash
id budi                  # UID, GID, group dari budi
id                       # identitas saya
who                      # siapa yang sedang login
```

## 7. `sudo` (Menjalankan Sebagai Root)

```bash
sudo -l                  # perintah apa yang boleh saya jalankan
sudo command             # jalankan sebagai root
sudo -i                  # shell root interaktif
```

Konfigurasi di `/etc/sudoers` — **selalu** pakai `visudo` (aman dari corrupt):
```bash
visudo
```

## Latihan
1. Buat user `siswa` dengan home & shell bash, lalu set sandi.
2. Tambahkan `siswa` ke group `wheel` agar bisa `sudo`.
3. Verifikasi: `id siswa` dan `sudo -l -U siswa`.
