# Modul 11 — Manage Networking

> Referensi video: `sm2LR26JERA`

## 1. Alat Jaringan di RHEL

RHEL 9 menggunakan **NetworkManager** + `nmcli`. Hindari edit manual
`/etc/sysconfig/network-scripts/` (sudah usang).

## 2. Inspeksi Antarmuka

```bash
ip addr                       # lihat semua antarmuka & IP
ip -br addr                   # ringkas (bridge mode)
ip route                     # tabel routing
hostname                     # nama host
hostnamectl                  # info + ubah hostname
```

## 3. `nmcli` — Manajemen Koneksi

```bash
nmcli device status                  # perangkat & status
nmcli connection show                # daftar koneksi
nmcli connection show "con-name"    # detail satu koneksi

# Set IP statis
sudo nmcli connection modify "eth0" \
  ipv4.addresses 192.168.1.50/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns 8.8.8.8 \
  ipv4.method manual

# Aktifkan perubahan
sudo nmcli connection down "eth0"
sudo nmcli connection up "eth0"
```

## 4. DHCP & DNS

```bash
# Kembalikan ke DHCP
sudo nmcli connection modify "eth0" ipv4.method auto

# DNS
resolvectl status              # lihat resolver (systemd-resolved)
cat /etc/resolv.conf           # nameserver aktif
```

## 5. Uji Konektivitas

```bash
ping -c 4 8.8.8.8             # uji reachability IP
ping -c 4 google.com          # uji DNS + reachability
traceroute 8.8.8.8           # jejak rute (mungkin perlu install)
ss -tulnp                    # soket yang mendengar (port terbuka)
```

## 6. Firewall (`firewalld`)

```bash
sudo firewall-cmd --state
sudo firewall-cmd --list-all
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
sudo firewall-cmd --remove-service=http --permanent
```

## 7. Hostname

```bash
sudo hostnamectl set-hostname server1.lab.local
# verifikasi
hostnamectl
```

## Latihan
1. Catat IP saat ini: `ip -br addr`.
2. Ubah hostname menjadi `rhcsa-lab` dengan `hostnamectl`.
3. Buka port 80 di firewall: `firewall-cmd --add-service=http --permanent && firewall-cmd --reload`.
