# ⌨️ Cheat Sheet Perintah RHEL (RH124)

Ringkasan cepat perintah paling sering dipakai. Urut per topik.

## 📂 Berkas & Direktori
```bash
pwd, ls -la, cd, mkdir -p, rmdir
touch, cp -r, mv, rm -rf, ln -s        # symlink
find / -name "x*" , locate x           # cari
```

## 🔍 Teks & Filter
```bash
cat, less, head -n, tail -f, nl
grep -i "x" file, grep -v, grep -r
cut -d: -f1, sort, uniq, wc -l, tr
sed 's/a/b/g', awk -F: '{print $1}'
echo "x" > f, echo "x" >> f, cat < f
```

## 📝 Vim (minimal)
```
i=insert, Esc=normal, :w simpan, :q keluar, :wq / ZZ simpan+keluar
:q! keluar tanpa simpan, dd hapus baris, yy salin, p tempel, /kata cari
```

## 👤 User & Group
```bash
useradd -m nama, passwd nama, usermod -aG wheel nama
userdel -r nama
groupadd, groupmod -n, gpasswd -a/-d, groupdel
id, who, w, chage -l/-E/-M
sudo -l, visudo
```

## 🔐 Izin & ACL
```bash
chmod 755/644, chmod u+x, chmod go-w
chown u:g, chgrp, chown -R
umask 022
setfacl -m u:u:rwx, getfacl, setfacl -x u:u
# bit khusus: SUID 4, SGID 2, Sticky 1  -> chmod 2755 dst
```

## ⚙️ Proses
```bash
ps aux, top, pgrep, pkill, kill -9, killall
jobs, fg %1, bg %1, Ctrl+Z
nice -n, renice, uptime, free -h, vmstat
```

## 🛎️ systemd
```bash
systemctl start|stop|restart|reload|status|enable|disable|is-enabled
systemctl list-units --type=service, systemctl --failed
systemctl get-default, set-default, isolate
journalctl, journalctl -u svc, -f, -p err, -b, --since
```

## 🌐 SSH
```bash
ssh user@host, ssh -p 2222, ssh host cmd
scp f user@h:/tmp/, rsync -avz
ssh-keygen -t ed25519, ssh-copy-id user@h
sshd -t (uji config!), ~/ssh/config (Host alias)
/etc/ssh/sshd_config: PermitRootLogin no, PasswordAuthentication no
```

## 🔌 Jaringan
```bash
ip addr, ip -br addr, ip route, hostname, hostnamectl
nmcli device status, nmcli connection show
nmcli connection modify "eth0" ipv4.addresses 192.168.1.50/24 ipv4.gateway 192.168.1.1 ipv4.dns 8.8.8.8 ipv4.method manual
nmcli connection up "eth0"
ping -c4, ss -tulnp, resolvectl status
firewall-cmd --add-service=http --permanent, --reload, --list-all
```

## 📦 DNF / RPM
```bash
dnf search, dnf info, dnf provides /path, dnf install -y
dnf group install "Development Tools"
dnf update, dnf remove, dnf autoremove, dnf history undo
dnf module list, dnf module enable postgresql:15
rpm -qa | grep, rpm -ql, rpm -qf /file
```

## 💾 Storage / FS
```bash
lsblk, fdisk -l, blkid, df -h, du -sh
mkfs.xfs, mkfs.ext4, mount, umount, mount -a
/etc/fstab: UUID=...  /data  xfs  defaults  0 0
LVM: pvcreate, vgcreate, lvcreate, lvextend -L +2G, xfs_growfs, resize2fs
swapon --show, mkswap
```

## 🔒 SELinux (penting di EX200!)
```bash
getenforce, setenforce 0|1
getsebool -a | grep httpd, setsebool -P httpd_can_network_connect on
semanage fcontext -a -t httpd_sys_content_t "/web(/.*)?"
restorecon -Rv /web, chcon -t ...
ls -Z, ps -Z
# JANGAN disable permanen — konfigurasikan dengan benar
```

## 🐳 Podman (RHEL 9+, muncul di EX200)
```bash
podman pull registry.redhat.io/..., podman images
podman run -d -p 8080:80 --name web nginx
podman ps, podman stop, podman rm, podman logs
podman generate systemd --new --files --name web   # jadikan service
```

## 🕒 Penjadwalan
```bash
crontab -e, crontab -l, (format: m h dom mon dow cmd)
at now + 1 hour  (ketik perintah, Ctrl+D)
systemctl status crond
```
