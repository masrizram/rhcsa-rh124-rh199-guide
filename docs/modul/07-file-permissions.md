# Modul 07 — Access to Files (Permissions & Ownership)

> Referensi video: `FmyIyp73bGM`

## 1. Model Izin Linux

Setiap berkas punya: **pemilik (owner)**, **group**, dan **izin** untuk
**user / group / other** (ugo).

```bash
$ ls -l file.txt
-rw-r--r--. 1 budi dev 123 Jan 1 10:00 file.txt
 ^^^^^^^^^     ^^^^ ^^^
 │             │    └ group
 │             └ pemilik
 └ izin: u=g+rw, g=r, o=r
```

- `-` berkas biasa | `d` direktori | `l` symlink
- `r` = read (4), `w` = write (2), `x` = execute (1)

## 2. Mengubah Izin: `chmod`

```bash
chmod 755 skrip.sh        # rwxr-xr-x (owner penuh, lainnya baca+jalankan)
chmod u+x file            # tambah execute untuk owner
chmod go-w file           # hilangkan write dari group & other
chmod -R 644 /data        # rekursif ke isi direktori
```

## 3. Mengubah Pemilik: `chown` & `chgrp`

```bash
sudo chown budi file.txt          # ubah owner
sudo chown budi:dev file.txt      # ubah owner DAN group
sudo chgrp dev file.txt           # ubah hanya group
sudo chown -R budi:dev /data      # rekursif
```

## 4. Default Izin: `umask`

`umask` menentukan izin yang *tidak* diberikan saat berkas baru dibuat.

```bash
umask              # lihat (mis. 022)
umask 027          # owner penuh, group baca, other tidak ada
# efek: file baru = 640, direktori = 750
```

## 5. Special Permissions

| Bit | Nilai | Fungsi |
|-----|-------|--------|
| SUID | 4 | eksekusi sebagai pemilik berkas |
| SGID | 2 | eksekusi sebagai group; di direktori → warisan group |
| Sticky | 1 | di direktori, hanya pemilik yg bisa hapus isinya (`/tmp`) |

```bash
chmod 2755 dir/       # set SGID
chmod 1777 /tmp       # sticky bit
```

## 6. ACL (Access Control Lists)

Untuk izin lebih granular dari ugo standar.

```bash
setfacl -m u:andi:rwx file.txt     # beri andi akses rwx
setfacl -m g:dev:rx file.txt       # beri group dev akses rx
getfacl file.txt                   # lihat ACL
setfacl -x u:andi file.txt         # hapus ACL user andi
setfacl -R -m d:u:andi:rwx /data   # default ACL (warisan) untuk direktori
```

## 7. Latihan Singkat (Review)

Suatu berkas `data.txt` milik `budi:dev` dengan izin `-rw-r-----`.
Jelaskan siapa yang bisa baca/tulis. (Owner budi rw; group dev r; other tidak ada)

## 8. Jebakan Umum (EX200)

!!! danger "Jebakan"
    - `chmod 777` untuk "memperbaiki" akses → **masalah keamanan & salah di ujian**.
      Gunakan ACL (`setfacl`) untuk akses granular, bukan 777.
    - Lupa bahwa **executable bit** (`+x`) wajib agar skrip/program bisa dijalankan.
    - Mengubah owner file di `/home` tapi lupa `restorecon` saat pakai SELinux →
      akses ditolak (lihat Modul 16/SELinux).
    - `umask` hanya berlaku untuk sesi shell saat itu; untuk permanen set di
      `/etc/profile` atau `~/.bashrc`.
    - SGID pada direktori **tidak** mewarisi permission, hanya mewarisi **group**.

## 9. Koneksi ke EX200

!!! success "EX200"
    Soal permission umum: atur hak akses file/direktori sesuai spesifikasi
    (mis. "hanya owner yang baca-tulis, group **baca-saja**"), atau beri user
    tertentu akses lewat **ACL** tanpa mengubah owner. Kunci: `chmod`, `chown`,
    `setfacl`, `getfacl` untuk memverifikasi.

## Kuis Cepat

1. Izin `rwxr-xr--` berapa dalam angka oktal? (750)
2. Perintah untuk memberi user `andi` akses baca-tulis tanpa ubah owner?
   (`setfacl -m u:andi:rw file`)
3. Apa fungsi bit SGID pada direktori? (file baru mewarisi group direktori)

## Latihan
1. Buat berkas `rahasia.txt`, set `chmod 600` (hanya owner).
2. Buat direktori `kerja` dengan SGID agar file baru mewarisi group.
3. Beri user `siswa` akses baca lewat ACL tanpa mengubah pemilik.
4. Verifikasi dengan `getfacl` dan pastikan `ls -l` menampilkan tanda `+`.
