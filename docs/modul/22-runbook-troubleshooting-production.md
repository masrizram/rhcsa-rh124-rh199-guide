# Modul 22 — Runbook Troubleshooting Produksi (Day-1 Firefighting)

> Ini **runbook insiden** untuk hari pertama di lingkungan enterprise/perbankan.
> Modul 1–20 memberi Anda sintaks; Modul 21 memberi konteks organisasi; Modul
> ini mengisi gap paling kritis: **"saat sistem mati / anomali di production,
> langkah persis apa yang diambil?"** Setiap skenario punya: gejala → diagnosis
> → recovery → **Cara Buktikan** → jebakan.

> 📺 Referensi: Modul 09 (systemd/boot), 13 (LVM/fstab), 16 (SELinux), 11
> (networking), 14 (log). Modul ini menggabungkannya dalam alur insiden nyata.

> ⚠️ **Aturan emas sebelum firefighting:** (1) catat gejala & waktu, (2) punya
> **rollback plan** (Modul 21 §8), (3) di production selalu lewat **Change
> Request + maintenance window** bila bukan insiden kritis. Untuk insiden yang
> mematikan layanan → **segera recovery dulu, dokumentasikan sesudahnya**.

---

## Skenario 1 — Server No-Boot / Emergency Mode (fstab salah)

**Gejala:** Setelah reboot, server stuck di `Welcome to emergency mode!` /
`you are in rescue mode`, atau GRUB drop ke `dracut:` shell. Penyebab umum:
salah penulisan opsi di `/etc/fstab`, UUID tidak ada, atau disk/LVM tambahan
hilang.

**Diagnosis:**
```
# Di emergency shell, cek pesan:
mount: unknown filesystem type / cannot find UUID=xxxx
# Cek fstab mana yang bermasalah:
cat /etc/fstab
```

**Recovery (lewat Console / iLO / iDRAC / virsh console):**
```bash
# 1. Remount root agar bisa diedit
mount -o remount,rw /
# 2. Perbaiki fstab — komen baris bermasalah, atau tambahkan opsi keamanan:
#    - nofail : jangan gagal boot bila disk tidak ada
#    - x-systemd.requires=... : tunggu dependency
#    contoh aman untuk disk tambahan:
#    UUID=xxxx  /data  xfs  defaults,nofail  0 0
vim /etc/fstab
# 3. Validasi SEMUA entri fstab TANPA reboot (wajib!):
mount -a
# 4. Reboot
reboot
```

**Cara Buktikan:**
```bash
mount -a && echo "FSTAB OK"      # tidak error = aman reboot
systemctl is-system-running      # "running" setelah reboot
```

!!! danger "Jebakan"
    - Edit fstab di emergency tapi lupa `mount -o remount,rw /` → perubahan
      tidak tersimpan.
    - Pakai nama device `/dev/sdb1` di fstab → setelah reboot berubah jadi
      `/dev/sdc1` → no-boot lagi. Selalu **UUID/label**.
    - NFS di fstab tanpa `_netdev` → boot hang menunggu timeout NFS mati.
    - Hapus baris `swap` salah → sistem tetap boot (swap opsional), tapi amati
      OOM bila RAM kecil.

---

## Skenario 2 — SELinux Memblokir Service Produksi

**Gejala:** Nginx/Apache/custom app gagal start, atau bisa start tapi deny
akses ke port/file. `journalctl` menunjukkan `Permission denied` padahal
permission DAC (rwx) sudah benar.

**Diagnosis:**
```bash
# 1. Konfirmasi SELinux aktif & mode
getenforce            # Enforcing
# 2. Cari AVC denial terbaru
sudo ausearch -m AVC -ts recent
sudo ausearch -m AVC -ts recent | audit2why
# 3. (bila terpasang) ringkasan ramah manusia:
sudo sealert -a /var/log/audit/audit.log
# 4. Cek apakah port dipakai sudah berlabel benar
sudo semanage port -l | grep http
```

**Recovery (TANPA mematikan SELinux global!):**
```bash
# A. Salah context file (mis. web root dipindah dari /home):
sudo semanage fcontext -a -t httpd_sys_content_t "/web(/.*)?"
sudo restorecon -Rv /web
# B. Boolean salah (mis. httpd konek DB/network):
sudo setsebool -P httpd_can_network_connect on
# C. Service butuh port non-standar (mis. 8080 sudah ada, pakai 8443):
sudo semanage port -a -t http_port_t -p tcp 8443
# D. Kalau masih buntu, uji sementara (JANGAN biarkan permanen):
sudo setenforce 0      # Permissive -> cek apakah SELinux penyebabnya
#   kalau jalan -> kembalikan ke Enforcing & perbaiki context/boolean/port di atas
sudo setenforce 1
```

**Cara Buktikan:**
```bash
getenforce                                  # Enforcing (tetap!)
sudo ausearch -m AVC -ts recent | wc -l     # 0 (atau tidak bertambah)
systemctl is-active httpd                   # active
curl -s localhost:8443 | head -1            # layanan merespons
```

!!! danger "Jebakan"
    - `setenforce 0` lalu lupa balik ke `1` → temuan audit fatal (bank wajib
      Enforcing).
    - `chcon` (bukan `semanage fcontext`) → context hilang setelah
      `restorecon`/relabel. Pakai `semanage fcontext` + `restorecon`.
    - `audit2allow` sembarangan + `semodule -i` → membuka terlalu lebar.
      Gunakan hanya untuk modul kebijakan minimal & terjustifikasi.

---

## Skenario 3 — Disk Root (/) atau /var/log Penuh (100%)

**Gejala:** Server unresponsive, service crash, tidak bisa login (no space
left), journal meledak. Penyebab: log tidak dirotasi, core dump, atau file
raksasa.

**Diagnosis:**
```bash
df -h                      # cari filesystem 100% Use
du -xh /var/log 2>/dev/null | sort -rh | head     # apa yang gede di /var/log
journalctl --disk-usage                            # journal makan berapa
find / -xdev -size +500M -type f 2>/dev/null       # file raksasa
```

**Recovery (bebaskan ruang dulu, baru perbaiki akar):**
```bash
# 1. Rotasi & bersihkan journal (aman, systemd kelola)
sudo journalctl --vacuum-size=200M
sudo journalctl --vacuum-time=7d
# 2. Hapus/rotasi log besar (jangan rm file yg sedang dibuka -> truncate):
sudo truncate -s 0 /var/log/bigfile.log
# 3. Bersihkan yum/dnf cache:
sudo dnf clean all
# 4. Ekspansi LVM online bila perlu (root/var adalah LV):
sudo lvextend -L +5G /dev/vg0/var
sudo xfs_growfs /var          # XFS
# (ext4: sudo resize2fs /dev/vg0/var)
```

**Cara Buktikan:**
```bash
df -h /var                  # Use turun dari 100%
systemctl is-active <svc>   # service stabil
journalctl --disk-usage     # dalam batas wajar
```

!!! danger "Jebakan"
    - `rm` file log yang masih dibuka proses → ruang TIDAK kembali (inode
      dipegang process). Gunakan `truncate -s 0`.
    - Lupa `xfs_growfs`/`resize2fs` setelah `lvextend` → FS tetap penuh.
    - Setelah bebas, **cari akar**: pasang logrotate, batasi core dump, atau
      perbesar LV permanen — jangan cuma `vacuum` tiap hari.

---

## Skenario 4 — Network / Port Unreachable Pasca Patching/Reboot

**Gejala:** Setelah update/reboot, server tak bisa diakses, port layanan
"Connection refused"/timeout, padahal service `active`.

**Diagnosis:**
```bash
ip addr show                       # interface up? IP ada?
ip route show                      # default gateway ada?
nmcli device status                # koneksi terhubung?
ss -tulppn | grep :80             # service listen di 0.0.0.0:80?
sudo firewall-cmd --list-all      # port/service terbuka di zone aktif?
resolvectl status                 # DNS resolver benar?
```

**Recovery:**
```bash
# A. Interface/IP hilang setelah reboot:
sudo nmcli connection up "ens192"
sudo nmcli connection modify "ens192" ipv4.method manual \
  ipv4.addresses 192.168.1.50/24 ipv4.gateway 192.168.1.1 ipv4.dns 8.8.8.8
sudo nmcli connection down "ens192" && sudo nmcli connection up "ens192"
# B. Firewall blokir (explicit add, jangan disable):
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
# C. Service listen salah interface (hanya localhost):
#    edit config app -> 0.0.0.0, restart service
```

**Cara Buktikan:**
```bash
ping -c2 192.168.1.1                  # gateway reachable
ss -tulppn | grep -E ':80|:8080'      # LISTEN di 0.0.0.0
sudo firewall-cmd --list-all | grep 8080
curl -s http://localhost:8080 | head -1
```

!!! danger "Jebakan"
    - `systemctl stop firewalld` untuk "cek" → di bank = buka lubang keamanan
      & melanggar compliance. Tambahkan port/service, bukan matikan.
    - Edit `/etc/sysconfig/network-scripts/ifcfg-*` manual → diabaikan
      NetworkManager (RHEL 9+). Pakai `nmcli`/`nmtui`.
    - Lupa `--permanent` + `--reload` → aturan hilang setelah reboot.

---

## Skenario 5 — LVM Metadata / PV Hilang (Disk SAN/iSCSI Putus)

**Gejala:** Setelah reboot/storage maintenance, VG tidak aktif, LV tidak
ter-mount, `vgs`/`lvs` kosong atau `unknown device`. Penyebab: LUN terputus,
multipath bergeser, atau metadata corrupt.

**Diagnosis:**
```bash
lsblk                          # PV (disk) terlihat kernel?
pvs                           # PV ada? "unknown device"?
vgs                           # VG muncul? status?
sudo lvmdevices               # (RHEL 9+) cek device managed LVM
sudo cat /etc/lvm/backup/<vg> # backup metadata otomatis LVM
sudo multipath -ll            # (bila SAN) jalur storage aktif?
dmesg | tail                  # error iSCSI/SAN?
```

**Recovery:**
```bash
# A. Disk SAN terputus sementara -> pastikan LUN kembali, lalu:
sudo pvscan --cache
sudo vgchange -ay <vg>          # aktifkan VG
sudo mount /dev/<vg>/<lv> /mnt
# B. Metadata corrupt -> restore dari backup LVM otomatis:
sudo vgcfgrestore <vg>          # pakai /etc/lvm/backup/<vg>
sudo vgchange -ay <vg>
# C. PV hilang permanen tapi VG punya redundancy -> hapus PV rusak:
sudo vgreduce --removemissing <vg>
```

**Cara Buktikan:**
```bash
vgs <vg>                       # #PV/#LV sesuai, tidak "missing"
lvs <vg>                      # LV active
mount | grep <lv>              # ter-mount & bisa baca/tulis
```

!!! danger "Jebakan"
    - `vgreduce --removemissing` **tanpa backup** → data di PV hilang terhapus
      dari metadata. Pastikan `vgcfgrestore` sudah dicoba.
    - Jangan `mkfs` di device yang dicurigai "hilang" — bisa jadi hanya
      multipath bergeser (device lain). Cek `multipath -ll` & `lsblk` dulu.
    - Di bank, storage sering lewat **multipath** + **iSCSI/Fibre** — koordinasi
      dengan tim storage sebelum "memperbaiki" PV.

---

## Skenario 6 (Bonus) — Root Terkunci / Boot Param Salah

**Gejala:** Tidak bisa login root (lupa password / akun lock `faillock`), atau
kernel panic karena parameter boot salah (mis. `quiet` terhapus & ada param
rusak).

**Recovery (rd.break — lihat Modul 09 §6):**
```bash
# Di GRUB tekan e, tambahkan di akhir baris linux:
rd.break enforcing=0
# Ctrl+X, lalu di switch_root:
mount -o remount,rw /sysroot
chroot /sysroot
passwd root                 # reset
# buka lock faillock bila perlu:
faillock --user root --reset
touch /.autorelabel         # PENTING biar SELinux relabel
exit; exit                 # reboot
```

**Cara Buktikan:** login root via console sukses; `getenforce` Enforcing;
`faillock --user root` tidak menunjukkan lock.

---

## Skenario 7 (Bonus) — Service Crash Loop (Restart Terus)

**Gejala:** `systemctl status app` → `active (auto-restart)` / `failed`,
restart tiada henti. Penyebab: config salah, port bentrok, dependency belum
siap, atau OOM.

**Diagnosis & Recovery:**
```bash
journalctl -u <app> -n 50 --no-pager     # error spesifik
journalctl -u <app> -b | grep -i "error\|fail"
ss -tulppn | grep <port>                # port sudah dipakai service lain?
systemctl cat <app>                     # cek ExecStart & dependency
# Jika butuh tunggu dependency (DB) saat boot:
#   tambahkan Wants/After=database.service di unit
```

**Cara Buktikan:** `systemctl is-active <app>` = `active` (tidak restart);
`systemctl reset-failed <app>` lalu pantau 1 menit stabil.

---

## Matriks Cepat Insiden (Cheat Sheet Meja)

| Gejala | Cek pertama | Perintah kunci |
|--------|-------------|----------------|
| No-boot / emergency | fstab | `mount -o remount,rw /` → `vim /etc/fstab` → `mount -a` |
| Service deny akses | SELinux | `ausearch -m AVC`, `semanage fcontext`, `restorecon` |
| Server lambat/crash | disk penuh | `df -h`, `journalctl --vacuum-size=`, `lvextend`+`xfs_growfs` |
| Port unreachable | network/fw | `ip addr`, `ss -tulpn`, `firewall-cmd --add-port --permanent` |
| LV hilang | LVM/PV | `pvs`, `vgchange -ay`, `vgcfgrestore` |
| Root lock | boot | `rd.break enforcing=0` → `passwd root` → `touch /.autorelabel` |
| Service loop | systemd | `journalctl -u <svc>`, `ss -tulpn`, `systemctl reset-failed` |

## Self-Check: Siap Firefighting?

- [ ] Bisa masuk emergency shell & perbaiki fstab tanpa reboot tak tentu.
- [ ] Tahu bedakan `chcon` vs `semanage fcontext` + `restorecon`.
- [ ] Tidak pernah `setenforce 0` lalu biarkan (selalu balik `1`).
- [ ] Tahu `truncate` untuk log yang sedang dibuka (bukan `rm`).
- [ ] Paham `lvextend` harus diikuti `xfs_growfs`/`resize2fs`.
- [ ] Tidak `stop firewalld` — tambah rule, bukan matikan.
- [ ] Tahu `rd.break` + `touch /.autorelabel`.

> Runbook ini melengkapi Modul 21: Modul 21 = *konteks & cegah*, Modul 22 =
> *tangani saat terjadi*. Kombinasi keduanya = amunisi hari pertama di
> enterprise/perbankan.

## Latihan (di lab VM, BUKAN production)
1. Sengaja salah tulis 1 baris fstab (UUID salah), reboot → recovery via console.
2. Pindahkan web root ke `/web`, jalankan httpd → sengaja biarkan context salah
   → perbaiki via `semanage fcontext` + `restorecon` (tanpa `setenforce 0` permanen).
3. Isi `/var/log` sampai penuh (`cat /dev/zero > /var/log/big`), recovery.
4. Blokir port 80 di firewalld, verifikasi "unreachable", lalu buka kembali.
5. Putus PV lab (detach disk), pulihkan VG via `vgchange -ay` / `vgcfgrestore`.
