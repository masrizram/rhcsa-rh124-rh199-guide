# Modul 05 — Create, View, and Edit Text Files

> Referensi video: `-gARZ98HUL4`

## 1. Melihat Isi Berkas

```bash
cat file.txt              # tampilkan seluruh isi
less file.txt             # tampilkan per halaman (aman untuk berkas besar)
head -n 20 file.txt       # 20 baris pertama
tail -n 20 file.txt       # 20 baris terakhir
tail -f /var/log/messages # ikuti (follow) penambahan baru (Ctrl+C)
```

## 2. Editor `vim` (Wajib di RHCSA)

`vim` hampir pasti ada di ujian EX200. Kuasai minimal mode dasar.

**Tiga mode utama:**
- **Normal** (tekan `Esc`) — navigasi & perintah.
- **Insert** (tekan `i`) — mengetik.
- **Command-line** (tekan `:` dari normal) — simpan/keluar.

```bash
vim file.txt
```

| Tombol (mode Normal) | Fungsi |
|----------------------|--------|
| `i` | mulai mengetik (insert) di kursor |
| `a` | insert setelah kursor |
| `o` | baris baru di bawah |
| `Esc` | kembali ke Normal |
| `:w` | simpan |
| `:q` | keluar |
| `:wq` / `ZZ` | simpan & keluar |
| `:q!` | keluar tanpa simpan |
| `dd` | hapus 1 baris |
| `yy` | salin 1 baris |
| `p` | tempel di bawah |
| `/kata` | cari kata |

## 3. Redireksi & Here-Document

```bash
echo "halo" > file.txt        # timpa (overwrite)
echo "tambah" >> file.txt     # tambah (append)
cat < file.txt                # input dari berkas

# Here-document: tulis banyak baris sekaligus
cat > config.txt <<'EOF'
baris satu
baris dua
EOF
```

## 4. Filter & Transformasi Teks

```bash
grep "error" log.txt          # saring baris berisi "error"
grep -i "error" log.txt       # tidak peduli kapital
grep -v "info" log.txt        # kecuali yang berisi "info"
sort data.txt                 # urutkan
uniq data.txt                 # hilangkan duplikat berurutan
wc -l data.txt                # hitung baris
cut -d: -f1 /etc/passwd       # ambil kolom 1, pemisah ":"
tr 'a-z' 'A-Z' < file.txt     # ubah ke kapital
```

## 5. `sed` & `awk` (Dasar)

```bash
sed 's/lama/baru/g' file.txt          # ganti semua "lama" jadi "baru"
sed -i 's/lama/baru/g' file.txt       # ubah di tempat (in-place)
awk -F: '{print $1}' /etc/passwd      # cetak kolom 1
```

## Latihan
1. Buat berkas dengan here-document berisi 3 baris, lalu `cat` untuk verifikasi.
2. Di `vim`, ketik 5 baris, simpan dengan `:wq`, lalu buka lagi dan hapus 1 baris (`dd`).
3. Hitung jumlah user di sistem: `wc -l /etc/passwd`.
