# Modul 19 — Skenario EX200 Terukur (Latihan Berbobot)

> Ini adalah **simulasi ujian beneran**: 10 tugas dengan *score sheet* seperti
> EX200 asli. Kerjakan di lab (Rocky/Alma/RHEL container/VM), lalu verifikasi
> dengan poin cek di bawah tiap tugas. Target: **skor ≥ 80%** sebelum ujian sungguhan.

## 📋 Aturan Main
- Waktu: **120 menit** (lebih ketat dari ujian 180 mnt agar terlatih).
- Tanpa buka internet. Boleh `man`, `vim`, `history`.
- Setiap tugas bernilai **10 poin** (total 100).
- **Verifikasi** tiap tugas sebelum lanjut — di ujian asli, tugas salah = 0 poin.

---

## 🧪 Tugas 1 — User & Group (10 pt)
Buat group `ops` dengan GID `3000`, user `operator` UID `2000`, shell
`/bin/bash`, home `/home/operator`, password `RedHat123`. Masukkan `operator`
ke group `wheel`.

**Verifikasi:**
```bash
id operator            # uid=2000, gid=ops(3000), groups=...wheel
getent group ops       # ops:x:3000:
sudo -l -U operator    # boleh (wheel)
```

## 🧪 Tugas 2 — Permission & ACL (10 pt)
Buat `/data/laporan.txt`, owner `operator:ops`, izin `640`. Beri user `andi`
(rhcsa) akses baca lewat ACL **tanpa** ubah owner.

**Verifikasi:**
```bash
ls -l /data/laporan.txt     # -rw-r----- + tanda +
getfacl /data/laporan.txt   # user:andi:r--
su - andi -c 'cat /data/laporan.txt'   # sukses
```

## 🧪 Tugas 3 — LVM (10 pt)
Gunakan disk/`/tmp/lvm.img` (loop). Buat PV→VG `vgdata`→LV `lvdata` 1G, format
XFS, mount ke `/data`, **permanen di fstab (UUID)**, lalu besarkan LV jadi 2G
dan grow filesystem.

**Verifikasi:**
```bash
lsblk | grep lvdata; df -h /data      # 2G (setelah grow)
mount | grep /data; grep data /etc/fstab   # UUID, xfs
```

## 🧪 Tugas 4 — Service systemd (10 pt)
Buat unit `/etc/systemd/system/penjaga.service` yang menjalankan
`/usr/local/bin/penjaga.sh` (script echo loop), **auto-start saat boot**,
`Restart=on-failure`. Aktifkan & pastikan jalan.

**Verifikasi:**
```bash
systemctl is-enabled penjaga   # enabled
systemctl is-active penjaga    # active
systemctl status penjaga | grep Restart   # on-failure
```

## 🧪 Tugas 5 — SSH Hardening (10 pt)
Edit `sshd_config`: `PermitRootLogin no`, `PasswordAuthentication no`. Uji
dengan `sshd -t` **sebelum** restart. Pastikan Anda masih bisa login via kunci.

**Verifikasi:**
```bash
sshd -t && echo OK
grep -E "PermitRootLogin|PasswordAuthentication" /etc/ssh/sshd_config
# login dari sesi ke-2 berhasil pakai kunci
```

## 🧪 Tugas 6 — Networking (10 pt)
Set IP statis `192.168.100.50/24`, gateway `.1`, DNS `8.8.8.8` via `nmcli`,
**persisten**. Buka port `8080/tcp` di firewalld permanen.

**Verifikasi:**
```bash
ip -br addr | grep 192.168.100.50
ping -c1 192.168.100.1
firewall-cmd --list-ports | grep 8080
```

## 🧪 Tugas 7 — DNF & Module (10 pt)
Pasang `postgresql-server` dari **module stream 15**. Verifikasi versi, lalu
batalkan instalasi lewat `dnf history undo`.

**Verifikasi:**
```bash
rpm -q postgresql-server        # versi 15.x
dnf module list postgresql      # 15 [e]
# setelah undo:
rpm -q postgresql-server        # tidak terpasang
```

## 🧪 Tugas 8 — Podman (10 pt)
Jalankan `httpd` (httpd:alpine/rockylinux) di container bernama `web`, port
`8080:80`, restart always. Generate systemd service agar container jalan saat boot.

**Verifikasi:**
```bash
podman ps | grep web
curl -s localhost:8080 | head -1     # halaman default
ls ~/.config/systemd/user/ | grep web  # service ter-generate
```

## 🧪 Tugas 9 — SELinux (10 pt)
Server web di port `8080` dengan DocumentRoot `/web` (bukan default). Pastikan
jalan **walau SELinux Enforcing**: set context, izinkan port, jangan matikan.

**Verifikasi:**
```bash
getenforce                      # Enforcing
ls -Z /web                      # httpd_sys_content_t
semanage port -l | grep 8080    # http_port_t
curl -s localhost:8080          # 200 OK
```

## 🧪 Tugas 10 — Cron & Timezone (10 pt)
Set zona waktu `Asia/Jakarta`. Buat cron root yang backup `/etc` tiap hari 02:00
ke `/backup/etc-$(date +\%F).tar.gz`.

**Verifikasi:**
```bash
timedatectl | grep "Asia/Jakarta"
sudo crontab -l | grep "tar czf /backup/etc"
```

## 🧪 Tugas 11 — NFS Share (10 pt)
Konfigurasi berbagi **NFS** (objective EX200 2.3). Di sisi **server**: pasang
`nfs-utils`, aktifkan `nfs-server`, buat `/srv/nfs/share` (beri izin `777`),
ekspor ke subnet lab `192.168.100.0/24(rw,sync,no_root_squash)` lalu muat
dengan `exportfs -r`, dan buka service `nfs` di firewalld. Di sisi **klien**:
pasang `nfs-utils`, mount `server:/srv/nfs/share` ke `/mnt/nfs` secara
**permanen di fstab** dengan opsi `_netdev`, lalu uji `mount -a`.

> Untuk latihan di 1 VM, jadikan host sendiri sebagai server sekaligus klien:
> ganti `server` dengan `localhost` (atau `$(hostname)`).

**Verifikasi:**
```bash
# server
exportfs -v | grep "srv/nfs"      # ekspor aktif
firewall-cmd --list-services | grep nfs
# klien
df -hT /mnt/nfs                   # ter-mount
grep "nfs" /etc/fstab             # entri dengan _netdev
```

---

## 🧪 Tugas 12 — autofs + tuned + chrony (10 pt)

Gabungan 3 objektif yang sering muncul bersama di EX200: *mount otomatis*,
*profil tuning*, dan *client time service*. Kerjakan di **satu VM** (host sendiri
sebagai server NFS sekaligus klien autofs).

1. **NFS server lokal** (sumber autofs): pasang `nfs-utils`, aktifkan
   `nfs-server`, buat `/srv/share/ops` (izin `777`), ekspor ke
   `localhost(rw,sync)` via `exportfs -r`, buka service `nfs` di firewalld.
2. **autofs on-demand**: pasang `autofs`, set master map `/mnt/ops`
   → `/etc/auto.ops`, map `/etc/auto.ops` isi `data -fstype=nfs,rw localhost:/srv/share/ops`.
   Aktifkan & jalankan `autofs`. Bukti: akses `/mnt/ops/data` otomatis ter-mount.
3. **tuned**: aktifkan profil `throughput-performance` dan pastikan persisten.
4. **chrony**: set client waktu ke pool NTP `0.id.pool.ntp.org iburst`
   (edit `/etc/chrony.conf`), aktifkan & jalankan `chronyd`, paksa sinkron.

**Verifikasi:**
```bash
# autofs
systemctl is-active autofs           # active
cd /mnt/ops/data && touch ok && echo MOUNTED   # akses -> mount otomatis
mount | grep auto.ops                 # entry automount muncul

# tuned
tuned-adm active                      # throughput-performance

# chrony
systemctl is-active chronyd          # active
chronyc tracking | grep -i "Leap status"   # Normal
timedatectl | grep "System clock synchronized"   # yes
```

> 💡 Tiga layanan (`autofs`, `tuned`, `chronyd`) harus `enable --now` agar
> bertahan reboot — di EX200, konfigurasi yang tidak persisten = 0 poin.

---

## 📊 Score Sheet

| # | Tugas | Poin | ✅ |
|---|-------|------|---|
| 1 | User & Group | 10 | |
| 2 | Permission & ACL | 10 | |
| 3 | LVM | 10 | |
| 4 | systemd service | 10 | |
| 5 | SSH hardening | 10 | |
| 6 | Networking | 10 | |
| 7 | DNF module | 10 | |
| 8 | Podman | 10 | |
| 9 | SELinux | 10 | |
| 10 | Cron & TZ | 10 | |
| 11 | NFS share | 10 | |
| 12 | autofs + tuned + chrony | 10 | |

**Total:** _____ / 120

- **≥ 96** (80%) → siap ujian.
- **72–95** → ulangi modul yang lemah.
- **< 72** → kerjakan ulang LAB per modul dulu.

## 💡 Tips Lulus
- Selalu **verifikasi** (pakai poin cek di atas) — di EX200, tugas yang tidak
  terverifikasi = 0.
- Kerjakan tugas **independen & mudah dulu** (user, cron, TZ), sisakan waktu
  untuk LVM/SELinux/Podman.
- Jangan **matikan SELinux** — itu jalan pintas yang gagal di ujian.
- Simpan lembar soal; catat IP/user/pass di awal.
