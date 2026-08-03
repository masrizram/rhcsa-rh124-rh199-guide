# Simulasi Ujian EX200 — 3 Jam / 180 Menit (Timer & Score Sheet)

> Kerjakan seperti ujian beneran: **180 menit**, tanpa buka kunci jawaban
> sampai selesai. Skor minimal **80% (≥ 8/10 tugas)** = siap ujian.

## ⏱️ Aturan
1. Pakai lab VM/container Rocky/Alma/RHEL 9 (bukan produksi).
2. Snapshot dulu (`virsh snapshot-create` / `podman commit`).
3. Buka stopwatch (hp/online). Mulai sekarang.
4. Kerjakan 10 tugas berurutan. Setiap selesai, **verifikasi** dengan
   perintah cek (lihat kolom "Cara Buktikan").

## 📋 Tugas & Score Sheet

| # | Tugas | Cara Buktikan (verifikasi) | Skor |
|---|-------|----------------------------|------|
| 1 | Buat user `operator` + grup `ops`, password `RedHat123` | `id operator` → gid ops; `passwd -S operator` | /1 |
| 2 | Set umask default 027 di `/etc/profile` | `umask` → 0027 untuk user baru | /1 |
| 3 | Beri `operator` akses sudo tanpa password | `sudo -l -U operator` → NOPASSWD | /1 |
| 4 | Buat file `/shared/data.txt` milik `operator:ops` mode 640 + ACL baca untuk `qa` | `getfacl /shared/data.txt` | /1 |
| 5 | Pasang `vim-enhanced` via DNF, hapus `tree` | `rpm -q vim-enhanced tree` | /1 |
| 6 | Aktifkan & enable layanan `httpd` (atau `nginx`) | `systemctl is-active httpd` = active | /1 |
| 7 | Blokir port 23 (telnet) via firewall, izinkan 8080 | `firewall-cmd --list-all` | /1 |
| 8 | Tambah LV 500M di VG `rhel` (atau buat VG baru), format XFS, mount `/data` fstab | `df -h /data`; `mount | grep /data` | /1 |
| 9 | Jalankan `httpd` sebagai container Podman, systemd-managed (quadlet/--system) | `podman ps`; `systemctl --user is-active` | /1 |
| 10 | Set SELinux `httpd_sys_content_t` pada `/data`, mode enforcing | `ls -Z /data`; `getenforce` = Enforcing | /1 |

## 🧮 Hitung Skor
```
Skor = (jumlah tugas lulus) × 10
Lulus ujian = skor ≥ 80
```

## ✅ Kunci Jawaban Singkat (buka SETELAH 180 mnt)

??? note "Kunci Jawaban"
    1. `useradd -G ops operator; echo RedHat123 | passwd --stdin operator`
    2. Tambah `umask 027` di `/etc/profile` (atau `/etc/bashrc`)
    3. File `/etc/sudoers.d/operator`: `operator ALL=(ALL) NOPASSWD: ALL`
    4. `mkdir -p /shared; touch /shared/data.txt; chown operator:ops /shared/data.txt;
       chmod 640 /shared/data.txt; setfacl -m u:qa:r /shared/data.txt`
    5. `dnf install -y vim-enhanced; dnf remove -y tree`
    6. `dnf install -y httpd; systemctl enable --now httpd`
    7. `firewall-cmd --add-port=8080/tcp --permanent; firewall-cmd --remove-service=telnet --permanent; firewall-cmd --reload`
       (telnet bukan service default; pastikan tidak ada rule terbuka ke 23)
    8. `lvcreate -L 500M -n lvdata rhel; mkfs.xfs /dev/rhel/lvdata;
       mkdir /data; echo '/dev/rhel/lvdata /data xfs defaults 0 0' >> /etc/fstab; mount -a`
    9. `podman run -d --name httpd -p 8080:80 docker.io/library/httpd;
       podman generate systemd --new --files --name httpd;
       systemctl --user enable --now container-httpd.service`
    10. `semanage fcontext -a -t httpd_sys_content_t '/data(/.*)?';
        restorecon -Rv /data; setenforce 1; getenforce`

> Catatan: jawaban di atas contoh; di ujian asli verifikasi dilakukan oleh
> pemeriksa otomatis (skrip) yang mengecek kondisi sistem, bukan perintah.
