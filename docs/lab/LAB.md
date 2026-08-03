# 🛠️ Latihan Praktik (LAB) — Red Hat RH124

Kumpulan tugas tangan untuk tiap modul. Kerjakan di lab lokal
(Rocky/Alma/Fedora/RHEL container). Jawaban singkat ada di bawah tiap tugas.

---

## Modul 01 — Get Started
- [ ] Akses Cockpit: `systemctl enable --now cockpit.socket` lalu buka `:9090`.
- [ ] Jalankan `whoami`, `pwd`, `hostname`, `date`.

## Modul 02 — Command Line
- [ ] `history` → jalankan ulang perintah ke-N dengan `!N`.
- [ ] `export LAB=RH124` lalu `echo $LAB`.
- [ ] Bandingkan `Ctrl+A` / `Ctrl+E` saat mengetik perintah.

## Modul 03 — Files
- [ ] `mkdir -p lab/m03 && touch lab/m03/a.txt lab/m03/b.txt`
- [ ] `cp -r lab /tmp/lab2`
- [ ] `ls lab/m03/*.txt` dan `ls lab/m03/a?`

## Modul 04 — Help
- [ ] `man hier` (pelajari FHS), `whatis date`, `apropos network`.

## Modul 05 — Text Files
- [ ] Buat berkas via here-doc 3 baris: `cat > x.txt <<'EOF' ... EOF`
- [ ] Di vim: insert 5 baris → `:wq` → buka → `dd` hapus 1 → `:wq`.
- [ ] `wc -l /etc/passwd`, `cut -d: -f1 /etc/passwd | head`.

## Modul 06 — Users & Groups
- [ ] `useradd -m siswa`, `passwd siswa`, `usermod -aG wheel siswa`.
- [ ] `groupadd dev`, `gpasswd -a siswa dev`, `id siswa`.

## Modul 07 — Permissions
- [ ] `touch rahasia && chmod 600 rahasia`.
- [ ] Direktori `kerja` dengan SGID: `chmod 2775 kerja`.
- [ ] ACL: `setfacl -m u:siswa:rwx rahasia`; cek `getfacl`.

## Modul 08 — Processes
- [ ] `sleep 300 &` → `jobs` → `kill %1`.
- [ ] `pgrep sshd`, `ps -p <pid> -o pid,comm,ni`.
- [ ] `nice -n 10 sleep 60 &` lalu `ps -o pid,ni,cmd -p <pid>`.

## Modul 09 — Services (systemd)
- [ ] `systemctl status sshd`, `systemctl get-default`.
- [ ] Buat unit `hello.service` sederhana, `enable --now`, cek `journalctl -u hello`.
- [ ] `systemctl --failed`.

## Modul 10 — SSH
- [ ] `ssh-keygen -t ed25519`, `ssh-copy-id user@lab`.
- [ ] Set `PasswordAuthentication no` + `PermitRootLogin no`, uji `sshd -t`.
- [ ] Alias `Host lab` di `~/.ssh/config`.

## Modul 11 — Networking
- [ ] `ip -br addr`, `hostnamectl set-hostname rhcsa-lab`.
- [ ] `nmcli` set IP statis (atau pastikan DHCP aktif).
- [ ] `firewall-cmd --add-service=http --permanent && firewall-cmd --reload`.

## Modul 12 — Software (DNF)
- [ ] `dnf provides /usr/bin/vim`, `dnf install tree`, `dnf remove tree`.
- [ ] `dnf check-update`, `dnf history`.

## Modul 13 — File Systems
- [ ] Format partisi XFS & mount ke `/mnt/uji`.
- [ ] Tambah ke `/etc/fstab` lalu `mount -a`.
- [ ] (LVM) `pvcreate`→`vgcreate`→`lvcreate`→`mkfs.xfs`→`mount`; lalu `lvextend`+`xfs_growfs`.

## Modul 14 — Support
- [ ] `journalctl -p err -b`, `journalctl -u sshd -f`.
- [ ] Pastikan `cockpit.socket` aktif.

## Modul 15 — EX200 Simulasi (Waktu: 90 menit)
1. User `operator` UID 2000, group `ops` GID 3000, shell bash.
   ```bash
   sudo groupadd -g 3000 ops
   sudo useradd -u 2000 -g ops -m -s /bin/bash operator
   sudo passwd operator
   ```
2. `/data` XFS, mount permanen, min 500M.
   ```bash
   sudo mkfs.xfs /dev/sdb1
   echo "UUID=$(blkid -s UUID -o value /dev/sdb1) /data xfs defaults 0 0" | sudo tee -a /etc/fstab
   sudo mkdir /data && sudo mount -a
   ```
3. SSH: `PermitRootLogin no`, `PasswordAuthentication no`.
   ```bash
   # edit /etc/ssh/sshd_config, lalu:
   sudo sshd -t && sudo systemctl restart sshd
   ```
4. Firewall port 8080 permanen.
   ```bash
   sudo firewall-cmd --add-port=8080/tcp --permanent
   sudo firewall-cmd --reload
   ```
5. `httpd` enable & reachable di :80.
   ```bash
   sudo dnf install -y httpd
   sudo systemctl enable --now httpd
   sudo firewall-cmd --add-service=http --permanent && sudo firewall-cmd --reload
   ```
6. Cron backup `/etc` tiap 02:00.
   ```bash
   (crontab -l 2>/dev/null; echo "0 2 * * * tar czf /backup/etc.tar.gz /etc") | crontab -
   ```
7. SELinux boolean `httpd_can_network_connect` on.
   ```bash
   sudo setsebool -P httpd_can_network_connect on
   ```

> Kerjakan berulang hingga semua langkah bisa diselesaikan < 90 menit.
