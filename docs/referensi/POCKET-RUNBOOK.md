# ⚡ Pocket Runbook — Troubleshooting Darurat (Offline)

> Cetak 1–2 halaman ini & bawa ke Data Center / area tanpa internet. Cuplikan
> darurat dari Modul 22. **Jangan pernah `setenforce 0` lalu biarkan**, jangan
> `stop firewalld`. Selalu punya **rollback plan** (Modul 21 §8).

---

## 0. Aturan Emas (baca dulu)
1. Catat gejala + waktu + siapa melapor.
2. Insiden mematikan layanan → **recovery dulu**, dokumentasi sesudah.
3. Perubahan non-insiden → lewat **Change Request + maintenance window**.
4. Selalu `mount -a` / `ss -tulnp` / `journalctl` **sebelum** reboot.

---

## 1. Server No-Boot / Emergency (fstab)
```bash
mount -o remount,rw /                 # edit fstab
vim /etc/fstab                        # komen baris salah / tambah ,nofail
mount -a && echo FSTAB_OK            # wajib test tanpa reboot
reboot
```
✅ Bukti: `systemctl is-system-running` → `running`.

## 2. SELinux Blokir Service
```bash
getenforce
sudo ausearch -m AVC -ts recent | audit2why
sudo semanage fcontext -a -t httpd_sys_content_t "/web(/.*)?"
sudo restorecon -Rv /web
sudo setsebool -P httpd_can_network_connect on
sudo semanage port -a -t http_port_t -p tcp 8443   # port non-standar
# uji sementara (jangan biarkan): sudo setenforce 0 ... lalu sudo setenforce 1
```
✅ Bukti: `getenforce` = `Enforcing`, `ausearch -m AVC -ts recent | wc -l` = 0.

## 3. Disk Penuh (/ atau /var/log)
```bash
df -h                                  # cari 100%
du -xh /var/log 2>/dev/null | sort -rh | head
journalctl --vacuum-size=200M
sudo truncate -s 0 /var/log/big.log    # JANGAN rm file yg sedang dibuka
sudo dnf clean all
# ekspansi LVM online:
sudo lvextend -L +5G /dev/vg0/var && sudo xfs_growfs /var   # (ext4: resize2fs)
```
✅ Bukti: `df -h /var` Use turun; service stabil.

## 4. Network / Port Unreachable
```bash
ip addr; ip route; nmcli device status
ss -tulppn | grep :80
sudo firewall-cmd --list-all
sudo nmcli con up "ens192"
sudo firewall-cmd --add-port=8080/tcp --permanent && sudo firewall-cmd --reload
```
✅ Bukti: `ping -c2 <gw>`; `ss -tulppn | grep :8080`; `curl localhost:8080`.

## 5. LVM / PV Hilang (SAN putus)
```bash
lsblk; pvs; vgs
sudo pvscan --cache
sudo vgchange -ay <vg>
sudo vgcfgrestore <vg>            # restore metadata dari /etc/lvm/backup/
sudo multipath -ll                # cek jalur storage (SAN)
```
✅ Bukti: `vgs <vg>` tidak `missing`; `lvs` active; mount jalan.

## 6. Root Terkunci (rd.break)
```bash
# GRUB: e -> akhir baris linux -> rd.break enforcing=0 -> Ctrl+X
mount -o remount,rw /sysroot
chroot /sysroot
passwd root
faillock --user root --reset
touch /.autorelabel               # PENTING
exit; exit
```
✅ Bukti: login root console sukses; `getenforce` Enforcing.

## 7. Service Crash Loop
```bash
journalctl -u <svc> -n 50 --no-pager
ss -tulppn | grep <port>          # port bentrok?
systemctl reset-failed <svc>
```
✅ Bukti: `systemctl is-active <svc>` = `active` (stabil 1 menit).

---

## Matrix Cepat
| Gejala | Perintah kunci |
|--------|----------------|
| No-boot | `mount -o remount,rw /` → `vim /etc/fstab` → `mount -a` |
| SELinux deny | `ausearch -m AVC`, `semanage fcontext`, `restorecon` |
| Disk 100% | `journalctl --vacuum-size=`, `truncate -s 0`, `lvextend`+`xfs_growfs` |
| Port blocked | `ss -tulppn`, `firewall-cmd --add-port --permanent --reload` |
| LV missing | `pvs`, `vgchange -ay`, `vgcfgrestore` |
| Root lock | `rd.break enforcing=0` → `passwd root` → `touch /.autorelabel` |
| Crash loop | `journalctl -u <svc>`, `systemctl reset-failed` |

> Versi lengkap & latihan: **Modul 22 — Runbook Troubleshooting Produksi**.
> Konteks organisasi & rollback: **Modul 21 — System Engineer Enterprise**.
