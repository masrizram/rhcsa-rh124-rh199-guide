# Modul 14 — Analyze Servers and Get Support

> 📺 Referensi video: [44ObsKHr0IA](https://www.youtube.com/watch?v=44ObsKHr0IA&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns)

## 1. Log Sistem

Di RHEL modern, log dikelola oleh `systemd-journald` dan (biasanya) `rsyslog`.

```bash
journalctl                      # semua log sejak boot
journalctl -p warning          # peringatan ke atas
journalctl -u nginx            # log satu layanan
journalctl -f                  # live tail
ls /var/log/                   # berkas log tradisional
tail -f /var/log/messages      # (jika rsyslog aktif)
```

## 2. Cockpit (Web Console)

Panel all-in-one untuk monitor & administrasi:

```bash
sudo systemctl enable --now cockpit.socket
# Buka https://<host>:9090
```

Fitur: overview CPU/mem/disk, layanan, jaringan, storage, terminal web, log.

## 3. Red Hat Insights

Layanan analitik proaktif (butuh subscription RHEL). Mendeteksi risiko
keamanan & stabilitas.

```bash
# Di sistem RHEL berlangganan:
sudo insights-client --register
sudo insights-client --check-results
```

## 4. Subscription Management (RHEL resmi)

```bash
sudo subscription-manager register --auto-attach
sudo subscription-manager list --available
sudo subscription-manager attach --pool=<pool_id>
sudo subscription-manager repos --list
```

> Untuk klon gratis (Rocky/Alma) langkah ini tidak diperlukan — repo publik
> sudah aktif.

## 5. Sumber Dukungan

- **Red Hat Customer Portal**: https://access.redhat.com
- **KBase articles** & **Solutions**: `https://access.redhat.com/search`
- **RHN / Bugzilla** untuk pelaporan.
- Komunitas: Rocky Linux Forum, AlmaLinux Chat, server Discord RHEL.

## 6. Triase Masalah (Langkah Sistematis)

1. Apa gejalanya? (error message persis)
2. Di layer mana? (aplikasi / service / OS / jaringan / storage)
3. Cek log: `journalctl -u <svc>`, `/var/log/*`.
4. Cek resource: `top`, `free -h`, `df -h`, `ss -tulnp`.
5. Cek konfigurasi & izin.
6. Reproduksi di lingkungan bersih bila perlu.

## Latihan
1. Jalankan `journalctl -p err -b` dan catat 1 error (walau minor).
2. Buka Cockpit di browser lab (atau pastikan socket aktif).
3. Buat "checklist triase" singkat untuk kasus "web tidak bisa diakses".

## Kunci Jawaban (klik untuk lihat)

??? note "Kunci Jawaban Latihan"
    1. `journalctl -p err -b` → error sejak boot; mis. unit failed.
    2. `systemctl enable --now cockpit.socket` lalu buka `https://host:9090`.
    3. Triase: (a) cek service `systemctl status httpd`; (b) firewall
       `firewall-cmd --list-all`; (c) port listen `ss -tulnp | grep :80`;
       (d) log `journalctl -u httpd`.

## Kuis

1. Perintah melihat log live satu layanan?
   - a. `journalctl -f -u nginx`  b. `tail /var/log/nginx`  c. `log nginx`  d. `dmesg -u`
2. Cockpit diakses lewat port?
   - a. 8080  b. 9090  c. 80  d. 22
3. Untuk klon gratis (Rocky), subscription-manager diperlukan?
   - a. Ya  b. Tidak  c. Hanya untuk update  d. Hanya di RHEL 10

??? note "Kunci Jawaban Kuis"
    1. **a** (`journalctl -f -u <svc>` live tail layanan).
    2. **b** (Cockpit port 9090).
    3. **b** (klon gratis tidak perlu subscription-manager).
