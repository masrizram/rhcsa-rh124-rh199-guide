# Modul 03 — Manage Files from the Command Line

> Referensi video: `__5fjNolVtU`

## 1. Hirarki Sistem Berkas (FHS)

RHEL menggunakan *Filesystem Hierarchy Standard*:

| Direktori | Isi |
|-----------|-----|
| `/` | akar (root) |
| `/home` | direktori home pengguna |
| `/root` | home untuk user root |
| `/etc` | konfigurasi sistem |
| `/var` | data yang berubah (log, mail, cache) |
| `/tmp` | berkas sementara |
| `/usr` | program & pustaka |
| `/bin`,`/usr/bin` | perintah pengguna |
| `/sbin`,`/usr/sbin` | perintah admin |

## 2. Membuat & Menyalin Berkas/Direktori

```bash
touch file.txt            # buat berkas kosong
mkdir proyek              # buat direktori
mkdir -p a/b/c            # buat nested sekaligus
cp file.txt salinan.txt   # salin berkas
cp -r proyek proyek2      # salin direktori rekursif
cp -v file.txt /tmp/      # salin + verbose
```

## 3. Memindah & Menghapus

```bash
mv a.txt b.txt            # ganti nama
mv b.txt /tmp/            # pindah
rm file.txt               # hapus berkas
rm -r proyek             # hapus direktori (rekursif)
rm -i file.txt            # konfirmasi dulu
rm -rf /tmp/proyek       # paksa rekursif (HATI-HATI!)
```

> ⚠️ `rm -rf` tidak bisa dibatalkan. Tidak ada "Recycle Bin" di CLI.

## 4. Wildcard / Globbing

```bash
ls *.txt          # semua berkas berakhiran .txt
ls file?          # satu karakter apa pun (file1, fileA)
ls [abc]*         # diawali a, b, atau c
ls {a,b}.conf     # a.conf dan b.conf
```

## 5. Menghubungkan Perintah (Pipe)

```bash
ls -l /etc | less            # tampilkan per halaman
cat /etc/passwd | wc -l      # hitung baris
ps aux | grep httpd          # saring proses
```

## 6. Path Absolut vs Relatif

- **Absolut**: dimulai dari `/`, contoh `/etc/hosts`.
- **Relatif**: dari posisi sekarang, contoh `../data/file`.

## Latihan
1. Buat struktur: `mkdir -p latihan/modul03` lalu `touch latihan/modul03/coba.txt`.
2. Salin ke `/tmp`: `cp -r latihan /tmp/latihan`.
3. Gunakan wildcard: buat 3 berkas `x1 x2 x3`, lalu `ls x?` untuk membuktikan.
