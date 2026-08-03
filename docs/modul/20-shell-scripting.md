# Modul 20 — Shell Scripting Dasar (Wajib EX200)

> Objektif EX200: *"Create and use simple shell scripts"*. Ujian sering meminta
> "buat skrip yang …" (mis. `penjaga.sh` di Modul 09). Modul ini mengajarkan
> dari nol: shebang, variabel, argumen, percabangan, perulangan, dan uji.

> 📺 Referensi video: [RHCSA & EX200 Prep](https://www.youtube.com/watch?v=eGbNXqPdUa4&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns)

## 1. Struktur Skrip & Shebang

```bash
#!/bin/bash
# skrip pertama
echo "Halo, $USER"
```

- `#!/bin/bash` = shebang, menentukan interpreter.
- Simpan sebagai `nama.sh`, lalu `chmod +x nama.sh`, jalankan `./nama.sh`.
- Jalankan tanpa eksekusi: `bash nama.sh`.

## 2. Variabel & Argumen

```bash
nama="RHCSA"
echo "Belajar $nama"
echo "Skrip ini: $0"          # $0 = nama skrip
echo "Argumen 1: $1"          # $1 argumen pertama
echo "Jumlah arg: $#"         # $# = jumlah argumen
echo "Semua arg: $@"          # $@ = semua argumen
```

| Variabel | Arti |
|----------|------|
| `$0` | Nama skrip |
| `$1`…`$9` | Argumen ke-1…9 |
| `$#` | Jumlah argumen |
| `$@` | Semua argumen (dikenakan quote) |
| `$?` | Exit code perintah terakhir (0=sukses) |
| `$$` | PID skrip |

## 3. Percabangan (if / test)

```bash
if [ "$1" = "start" ]; then
    echo "Memulai layanan"
elif [ "$1" = "stop" ]; then
    echo "Menghentikan layanan"
else
    echo "Gunakan: $0 start|stop"
fi
```

Uji umum dengan `[ ]` (alias `test`):

| Uji | Arti |
|-----|------|
| `-f file` | file ada & biasa |
| `-d dir` | direktori ada |
| `-r/-w/-x` | readable/writable/executable |
| `-z "$v"` | string kosong |
| `$a -eq $b` | sama (angka) |
| `$a = "$b"` | sama (string) |

## 4. Perulangan

```bash
# for
for i in 1 2 3; do
    echo "Iterasi $i"
done

# for dengan argumen
for arg in "$@"; do
    echo "Memproses $arg"
done

# while
count=1
while [ $count -le 5 ]; do
    echo "Ke-$count"
    count=$((count + 1))
done
```

## 5. Membaca Input & Exit Code

```bash
read -p "Nama: " nama
echo "Halo $nama"

# keluar dengan kode tertentu
grep "root" /etc/passwd && echo "ada root" || exit 1
echo "exit terakhir: $?"
```

## 6. Contoh Skrip EX200 (penjaga.sh)

Tugas umum: buat `/usr/local/bin/penjaga.sh` yang mengecek service.

```bash
#!/bin/bash
# /usr/local/bin/penjaga.sh
svc="$1"
if systemctl is-active --quiet "$svc"; then
    echo "$svc AKTIF"
    exit 0
else
    echo "$svc MATI — mencoba menghidupkan"
    systemctl start "$svc"
    exit $?
fi
```

```bash
chmod +x /usr/local/bin/penjaga.sh
/usr/local/bin/penjaga.sh sshd
```

## 7. Jebakan EX200 (Shell Script)

- Lupa `#!/bin/bash` → "Permission denied" atau salah interpreter.
- `if [ $1 = "x" ]` gagal kalau `$1` kosong → selalu quote: `if [ "$1" = "x" ]`.
- `for` tanpa quote `$@` → argumen bergus spasi rusak.
- `exit` tanpa nilai → pakai exit code terakhir perintah (`$?`) untuk lulus ujian otomatis.

## Latihan
1. Buat `halo.sh` yang mencetak "Halo <nama>" dengan nama dari `$1`.
2. Buat `cek.sh` yang: jika argumen `1` → cetak "ganjil", `2` → "genap", lainnya → "invalid".
3. Buat `backup.sh` yang menerima argumen path dan membuat `path.tar.gz`.
4. Kerjakan contoh `penjaga.sh` di atas, pastikan `sshd` dilaporkan AKTIF.

## Kunci Jawaban (klik untuk lihat)

??? note "Kunci Jawaban Latihan"
    - **halo.sh**: `#!/bin/bash` + `echo "Halo $1"`. Jalankan `./halo.sh Nilma`.
    - **cek.sh**: `if [ "$1" = "1" ]; then echo ganjil; elif [ "$1" = "2" ]; then echo genap; else echo invalid; fi`.
    - **backup.sh**: `tar -czf "$1.tar.gz" "$1"` dengan cek `if [ -e "$1" ]`.
    - **penjaga.sh**: salin skrip di atas, `chmod +x`, jalankan `penjaga.sh sshd` → harus cetak "sshd AKTIF" (exit 0).
    - Verifikasi: `bash -x skrip.sh` untuk melihat tiap baris dieksekusi (debug).
