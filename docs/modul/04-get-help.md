# Modul 04 — Get Help in Red Hat Enterprise Linux

> Referensi video: `UC_V5af1Ah0`

## 1. `man` (Manual Pages)

Sumber bantuan utama di Linux.

```bash
man ls                 # buka halaman manual ls
man 5 passwd           # section 5 = format file (bukan perintah)
man -k password        # cari topik terkait (apa-apa?)
```

**Struktur section man:**
1. Perintah pengguna | 2. Panggilan sistem | 3. Pustaka | 4. Berkas device
5. Format berkas & konvensi | 8. Perintah admin

Navigasi di `man`: `Space` (bawah), `b` (atas), `/kata` (cari), `q` (keluar).

## 2. `--help` (Bantuan Singkat Perintah)

```bash
ls --help
grep --help
```

Lebih cepat dari `man` untuk opsi cepat.

## 3. `info` & `pinfo`

Dokumentasi hipertekstual (Project GNU).

```bash
info coreutils
pinfo ls
```

## 4. Dokumentasi di `/usr/share/doc`

```bash
ls /usr/share/doc/ | head
# Contoh berkas README, examples, changelog per paket
```

## 5. `whatis` & `apropos`

```bash
whatis passwd        # satu baris deskripsi
apropos password     # cari semua halaman berisi "password"
```

## 6. Help BASH Internal

```bash
help cd
help echo
type ls              # apakah perintah, alias, atau fungsi?
```

## 7. Red Hat Customer Portal & Documentation

- https://access.redhat.com/documentation — dokumentasi resmi RHEL.
- `cockpit` juga menyediakan panel bantuan.

## Latihan
1. Buka `man hier` untuk memahami struktur direktori, lalu tutup dengan `q`.
2. Bandingkan `whatis date` dan `date --help`.
3. Cari semua halaman yang membahas "network": `apropos network`.

## Kunci Jawaban (klik untuk lihat)

??? note "Kunci Jawaban Latihan"
    1. `man hier` → section 7, menjelaskan `/`, `/usr`, `/var`, dst.
       `q` keluar.
    2. `whatis date` → 1 baris ("date - print or set the system date and time");
       `date --help` → daftar opsi lengkap (`-d`, `-u`, `+FORMAT`).
    3. `apropos network` → mis. `ip(8)`, `nmcli(1)`, `ss(8)` (dokumentasi
       terkait subnet/interface).

## Kuis

1. Perintah mencari halaman manual berdasarkan kata kunci?
   - a. `man -k`  b. `whatis`  c. `info`  d. `help`
2. `man 5 passwd` membahas?
   - a. perintah `passwd`  b. format file `/etc/passwd`  c. password  d. grup
3. Bantuan untuk perintah internal bash (mis. `cd`)?
   - a. `man cd`  b. `cd --help`  c. `help cd`  d. `info cd`

??? note "Kunci Jawaban Kuis"
    1. **a** (`man -k` = `apropos`).
    2. **b** (section 5 = format berkas).
    3. **c** (`help` khusus builtin bash; `man cd` tidak ada karena cd builtin).
