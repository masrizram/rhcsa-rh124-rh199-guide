# Modul 11 — Manage Networking

> 📺 Referensi video: [sm2LR26JERA](https://www.youtube.com/watch?v=sm2LR26JERA&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns)

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

## 8. Jebakan Umum (EX200)

!!! danger "Jebakan"
    - `set-default graphical.target` di server **headless** → tidak ada GUI,
      boot terasa "hang". Untuk server pakai `multi-user.target`.
    - Edit `/etc/sysconfig/network-scripts/ifcfg-*` secara manual → diabaikan
      NetworkManager (usang di RHEL 9). Selalu pakai `nmcli`/`nmtui`.
    - Lupa `nmcli connection down/up` setelah `modify` → perubahan tak aktif.
    - DNS salah → `ping IP` jalan tapi `ping nama` gagal. Cek `resolvectl`.
    - Firewall blokir port meski konfig benar → selalu `firewall-cmd --add-... --permanent && reload`.

## 9. Koneksi ke EX200

!!! success "EX200"
    Soal: "Set IP statis 192.168.1.50/24, gateway .1, DNS 8.8.8.8, pastikan
    persisten & bisa ping gateway." Kunci:
    ```bash
    sudo nmcli connection modify "eth0" ipv4.addresses 192.168.1.50/24 \
      ipv4.gateway 192.168.1.1 ipv4.dns 8.8.8.8 ipv4.method manual
    sudo nmcli connection down "eth0" && sudo nmcli connection up "eth0"
    ip -br addr; ping -c2 192.168.1.1
    ```


## Kunci Jawaban (klik untuk lihat)

??? note "Kunci Jawaban Latihan"
    1. `nmcli con up` mengaktifkan koneksi.
    2. `ip addr` tampilkan interface & IP.
    3. `hostnamectl set-hostname` ubah hostname.

## Kuis Cepat

1. Alat modern konfig jaringan RHEL 9? (`nmcli` / NetworkManager)
2. Aktifkan perubahan koneksi? (`nmcli connection down/up "nama"`)
3. Cek resolver DNS? (`resolvectl status`)

## Latihan
1. Catat IP saat ini: `ip -br addr`.
2. Ubah hostname menjadi `rhcsa-lab` dengan `hostnamectl`.
3. Buka port 80 di firewall: `firewall-cmd --add-service=http --permanent && firewall-cmd --reload`.
4. (Opsional) coba `nmtui` untuk set IP via antarmuka TUI.
