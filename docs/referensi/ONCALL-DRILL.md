# 🚑 On-Call Drill — Latihan Insiden (Muscle Memory)

> Ini **lembar drill**, bukan materi baru. Ambil 1 kartu secara acak, **jangan
> lihat Modul 22**, coba selesaikan di VM lab dalam batas waktu. Setelah selesai,
> buka Modul 22 untuk self-grade. Ulangi hingga < 10 menit per skenario.

> 🎯 Tujuan: kecepatan & ketenangan saat insiden (incident response time).
> Semua drill dijalankan di **lab VM**, BUKAN production.

---

## 🎴 Dek Kartu Skenario (acak satu)

### Kartu A — "Server tidak mau boot"
- **Gejala:** Setelah reboot, masuk ke `emergency mode`.
- **Waktu:** 10 menit.
- **Target:** sistem `running` kembali.
- **Hint opsional:** `/etc/fstab`.

### Kartu B — "Web tidak jalan, padahal service aktif"
- **Gejala:** `systemctl is-active httpd` = active, tapi `curl localhost` →
  `Permission denied` / 503.
- **Waktu:** 10 menit.
- **Target:** layanan merespons, SELinux tetap Enforcing.
- **Hint opsional:** `ausearch -m AVC`.

### Kartu C — "Server lambat & banyak service crash"
- **Gejala:** `df -h` → `/var` 100% Use.
- **Waktu:** 8 menit.
- **Target:** ruang bebas, service stabil (tanpa reboot).
- **Hint opsional:** `journalctl --vacuum-size`.

### Kartu D — "Aplikasi tiba-tiba unreachable pasca reboot"
- **Gejala:** port 8080 `connection refused` dari luar, padahal `ss` menunjukkan
  listen di localhost.
- **Waktu:** 8 menit.
- **Target:** port terbuka dari luar, firewall tetap aktif.
- **Hint opsional:** `firewall-cmd --list-all`.

### Kartu E — "Volume hilang setelah maintenance storage"
- **Gejala:** `vgs` menunjukkan `<vg>` dengan `unknown device` / `pvs` kosong.
- **Waktu:** 12 menit.
- **Target:** LV aktif & ter-mount kembali.
- **Hint opsional:** `vgchange -ay`, `vgcfgrestore`.

### Kartu F — "Tidak bisa login root"
- **Gejala:** root ditolak (lupa password / faillock).
- **Waktu:** 8 menit.
- **Target:** bisa login root via console, SELinux tetap Enforcing.
- **Hint opsional:** `rd.break enforcing=0`.

### Kartu G — "Service restart terus-menerus"
- **Gejala:** `systemctl status app` → `active (auto-restart)` / `failed`.
- **Waktu:** 8 menit.
- **Target:** service `active` stabil 1 menit.
- **Hint opsional:** `journalctl -u app`.

---

## 📋 Score Sheet (isi per drill)

| Tanggal | Kartu | Waktu (m) | Selesai tanpa lihat? | SELinux tetap Enforcing? | Skor (/10) |
|---------|-------|-----------|----------------------|--------------------------|------------|
|         | A     |           | Y / T                | Y / T                    |            |
|         | B     |           | Y / T                | Y / T                    |            |
|         | C     |           | Y / T                | Y / T                    |            |
|         | D     |           | Y / T                | Y / T                    |            |
|         | E     |           | Y / T                | Y / T                    |            |
|         | F     |           | Y / T                | Y / T                    |            |
|         | G     |           | Y / T                | Y / T                    |            |

**Gradasi:**
- 9–10: siap on-call hari pertama.
- 6–8: perkuat bagian lemah (lihat Modul 22 §terkait).
- < 6: ulangi drill + baca Modul 22 pelan-pelan.

---

## 🔁 Rutinitas Mingguan
- **Senin:** 3 kartu acak, tanpa catatan.
- **Rabu:** 2 kartu berbeda.
- **Jumat:** full deck (7 kartu), target total < 60 menit.

> Kombinasikan dengan **Pocket Runbook** (bawa ke DC) & **Modul 22** (referensi
> lengkap). Tiga lapis ini = amunisi on-call yang matang untuk enterprise/
> perbankan.
