# 🔗 Sumber Resmi & Pendaftaran EX200 (RHCSA)

Halaman ini mengumpulkan **tautan resmi**, informasi pendaftaran, biaya,
bahasa ujian, dan tips mendaftar — supaya panduan ini benar-benar *powerfull*
sebagai acuan utama menuju sertifikasi.

> ⚠️ Informasi biaya/jadwal dapat berubah. **Selalu cek tautan resmi di bawah
> sebelum mendaftar.** Panduan ini tidak menjamin angka tetap.

## 1. Tautan Resmi Red Hat

| Keperluan | Tautan |
|-----------|--------|
| **Halaman ujian EX200** (deskripsi resmi, objektif) | https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam |
| **Kurikulum RH124** (SA I) | https://www.redhat.com/en/services/training/rh124-red-hat-system-administration-i |
| **Kurikulum RH134** (SA II) | https://www.redhat.com/en/services/training/rh134-red-hat-system-administration-ii |
| **Dokumentasi RHEL** | https://access.redhat.com/documentation |
| **Red Hat Customer Portal** | https://access.redhat.com |
| **Cari pusat ujian / jadwal** | https://www.redhat.com/en/services/certification/red-hat-certified-system-administrator-rhcsa#exam |
| **Red Hat Certification Central** (lihat status sertifikat) | https://www.redhat.com/en/services/certification/rhca |

## 2. Format & Profil Ujian (Ringkas)

- **Kode**: EX200 (RHCSA).
- **Tipe**: *performance-based* — kerjakan tugas nyata di VM RHEL, bukan pilihan ganda.
- **Durasi**: **3 jam (180 menit)**.
- **Bahasa ujian**: Inggris, Jepang, dengan penerjemah tersedia di beberapa lokasi
  (cek saat booking). Di Indonesia umumnya **Inggris**.
- **Skor lolos**: Red Hat tidak mengumumkan angka pasti; historis ~210/300.
  Strategi aman: kejar **semua** tugas.
- **Lingkungan**: beberapa VM RHEL yang harus dikonfigurasi. Tanpa internet,
  tanpa catatan; boleh pakai `man`, `vim`, dokumentasi lokal, dan Cockpit.

## 3. Biaya (Indikasi, cek tautan resmi)

- Harga EX200 bervariasi per negara & apakah dibeli terpisah atau dalam paket
  pelatihan. Di wilayah Asia Pasifik umumnya **USD 400 ±** (belum PPN/lokasi).
- Sering disertakan **retake gratis** bila dibeli dalam *Learning Subscription*.
- Mahasiswa/dosen: tanya **akademik Red Hat** atau kerjasama kampus — kadang
  ada harga khusus.

## 4. Cara Mendaftar (Langkah Nyata)

1. Buka halaman **EX200** di redhat.com (tautan di §1).
2. Pilih **Schedule exam** / **Buy & schedule**.
3. Buat/login akun **redhat.com**.
4. Pilih **lokasi**: bisa *onsite* (Pusat Ujian Red Hat/Partner) atau
   *remote* (Online Proctored — butuh webcam & lingkungan terjaga).
5. Pilih **jadwal** (hari & jam).
6. Bayar. Simpan **confirmation number** & kredensial login ujian.
7. H-1: jalankan **[Checklist H-1](../referensi/CHECKLIST-H1.md)**.

## 5. Ujian Remote (Online Proctored) — Tips

- Webcam wajib; ruangan harus bersih & tidak ada catatan terbuka.
- ID pengenal (KTP/paspor) siap saat check-in.
- Koneksi internet stabil; siapkan snapshot VM latihan.
- Jangan tutup sesi sebelum waktu habis — verifikasi tiap tugas.

## 6. Setelah Lulus

- Sertifikat RHCSA berlaku **3 tahun** (sejak RHEL 9, Red Hat menggunakan
  kebijakan berlaku sesuai versi RHEL teruji + masa transisi).
- Cek status di **Red Hat Certification Central**.
- Lanjut ke **RHCE (EX294, Ansible)** untuk jalur *Red Hat Certified Engineer*.

## 7. Sumber Belajar Gratis (Selain Repo Ini)

- **Repo panduan ini**: Modul 0–20, LAB, simulasi, cheat sheet, glosarium.
- Rocky Linux / AlmaLinux 9 ISO — klon RHEL gratis untuk latihan.
- `man`, `vimtutor`, dokumentasi lokal `/usr/share/doc`.
- Komunitas: Rocky Linux Forum, AlmaLinux Chat, server Discord RHEL.

> Butuh latihan langsung? Jalankan **[Simulasi Ujian 3 Jam](../referensi/SIMULASI-UJIAN.md)**
> dan **[Skenario EX200 Terukur (Modul 19)](../modul/19-skenario-ex200.md)** —
> target skor ≥ 80% sebelum mendaftar.
