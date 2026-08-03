# Modul 12 — Install and Update Software (DNF)

> 📺 Referensi video: [CDpa7ZpNNEE](https://www.youtube.com/watch?v=CDpa7ZpNNEE&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns)

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

## 8. Flatpak — Repository & Paket (Wajib EX200)

Selain RPM/DNF, objektif EX200 mencantumkan **Flatpak**: "Configure access to
Flatpak repositories" & "Install and remove Flatpak software packages".
Flatpak memakai *runtime* terisolasi (sandbox) — umum untuk aplikasi desktop.

```bash
# 1. Pasang flatpak (di RHEL butuh repo Extra/CRB atau EPEL di klon)
sudo dnf install -y flatpak

# 2. Tambahkan repository Flatpak (contoh Flathub)
sudo flatpak remote-add --if-not-exists flathub \
  https://flathub.org/repo/flathub.flatpakrepo

# 3. Pasang aplikasi
sudo flatpak install -y flathub org.gnome.gedit

# 4. Jalankan & kelola
flatpak run org.gnome.gedit
flatpak list                   # lihat yang terpasang
sudo flatpak remove org.gnome.gedit
flatpak remotes                # lihat repo terdaftar
```

> ⚠️ Di RHEL resmi perlu `subscription-manager` + repo `rhel-9-for-x86_64-appstream-rpms`
> agar `flatpak` bisa diinstall. Di klon gratis cukup `dnf install flatpak`.
> Soal EX200 biasanya: "tambahkan repo Flatpak X lalu pasang aplikasi Y".

## 9. Jebakan Umum (EX200)

!!! danger "Jebakan"
    - `dnf update` tanpa `dnf history` / snapshot → paket krusial (kernel, DB)
      ter-upgrade dan sesuatu rusak. Di lab selalu snapshot dulu.
    - Lupa `sudo` → "permission denied" saat install/remove.
    - `dnf module enable` **setelah** paket terpasang → konflik stream.
      Enable modul **sebelum** `dnf install`.
    - Repo nonaktif (RHEL butuh subscription) → `dnf` gagal. Klon gratis
      (Rocky/Alma) sudah punya repo publik.

## 10. Koneksi ke EX200

!!! success "EX200"
    Soal: "Pasang `httpd` versi terbaru, verifikasi, lalu batalkan instalasi."
    Kunci: `dnf install -y httpd` → `rpm -q httpd` → `dnf history undo <id>`.
    Atau "pasang PostgreSQL 15 via module": `dnf module enable postgresql:15`
    lalu `dnf install postgresql-server`.

## Kuis Cepat

1. Bedanya `dnf` vs `rpm`? (dnf resolve dependensi; rpm tidak)
2. Batalkan instalasi lewat history? (`dnf history undo <id>`)
3. Cari paket pemilik berkas `/usr/bin/ssh`? (`dnf provides /usr/bin/ssh`)

## Latihan
1. Cari paket yang menyediakan `vim`: `dnf provides /usr/bin/vim`.
2. Pasang `tree` lalu hapus: `sudo dnf install tree` → `sudo dnf remove tree`.
3. Cek update yang tersedia: `dnf check-update` (tanpa memasang).
4. Lihat modul: `dnf module list`, enable satu (mis. `postgresql:15`).

## Kunci Jawaban (klik untuk lihat)

??? note "Kunci Jawaban Latihan"
    1. `dnf provides /usr/bin/vim` → mis. `vim-enhanced`.
    2. `dnf install -y tree` lalu `dnf remove -y tree` (pakai sudo bila bukan root).
    3. `dnf check-update` menampilkan update tersedia tanpa memasang.
    4. `dnf module list`; `dnf module enable -y postgresql:15`.

??? note "Kunci Jawaban Kuis"
    1. **`dnf`** (RHEL 8+ menggantikan yum).
    2. **`dnf install pkg`** (tambah `-y` untuk non-interaktif).
    3. **`dnf provides /path`** mencari paket pemilik berkas/biner.
