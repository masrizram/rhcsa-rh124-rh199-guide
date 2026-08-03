# Modul 12 — Install and Update Software (DNF)

> Referensi video: `CDpa7ZpNNEE`

## 1. DNF vs RPM

- **RPM** = format paket; tidak menyelesaikan dependensi sendiri.
- **DNF** = *package manager* modern (menggantikan `yum`) yang otomatis
  menyelesaikan dependensi. Di RHEL 8/9, `yum` adalah alias ke `dnf`.

## 2. Repositori (Repos)

```bash
dnf repolist                    # daftar repo aktif
dnf repolist all                # semua termasuk nonaktif
sudo dnf config-manager --enable crb   # aktifkan repo (mis. CRB)
```

Repositori didefinisikan di `/etc/yum.repos.d/*.repo`. Untuk RHEL butuh
*subscription*; klon gratis (Rocky/Alma) sudah punya repo publik.

## 3. Mencari & Memasang

```bash
dnf search nginx               # cari paket
dnf info nginx                 # detail paket
dnf provides /usr/bin/ssh      # paket apa yg punya berkas ini?
sudo dnf install -y nginx      # pasang + dependensi
sudo dnf group install "Development Tools"   # grup paket
```

## 4. Memperbarui & Menghapus

```bash
sudo dnf update                # perbarui semua
sudo dnf update nginx          # perbarui satu paket
sudo dnf remove nginx          # hapus
sudo dnf autoremove            # hapus dependensi tak terpakai
```

## 5. Riwayat & Cache

```bash
dnf history                    # lihat transaksi
sudo dnf history undo <id>     # batalkan transaksi
sudo dnf clean all             # bersihkan cache
```

## 6. RPM (Tingkat Rendah)

```bash
rpm -qa | grep httpd           # daftar paket terpasang
rpm -ql nginx                  # berkas milik paket
rpm -qf /etc/nginx/nginx.conf  # paket pemilik berkas
sudo rpm -ivh paket.rpm        # pasang rpm lokal (tanpa resolve dep)
```

## 7. Modul (AppStream) — Penting di RHEL 9

Beberapa paket punya *module stream* (versi berbeda, mis. PostgreSQL 13/15).

```bash
dnf module list                # lihat modul
sudo dnf module enable postgresql:15
sudo dnf install postgresql-server
```

## Latihan
1. Cari paket yang menyediakan `vim`: `dnf provides /usr/bin/vim`.
2. Pasang `tree` lalu hapus: `dnf install tree` → `dnf remove tree`.
3. Cek update yang tersedia: `dnf check-update` (tanpa memasang).
