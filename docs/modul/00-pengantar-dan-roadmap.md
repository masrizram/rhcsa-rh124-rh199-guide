# Modul 00 — Pengantar & Roadmap Sertifikasi Red Hat

> 📺 Referensi video: [Introduction](https://www.youtube.com/watch?v=pnHqii1Oq8Y&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns) · [Wrap Up](https://www.youtube.com/watch?v=O58uDdztjGU&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns) · [Pass the EX200](https://www.youtube.com/watch?v=2n2P0Awz3U4&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns)

## 1. Apa itu Red Hat Enterprise Linux (RHEL)?

RHEL adalah distribusi Linux komersial yang stabil, didukung langganan resmi,
dan menjadi standar di dunia perusahaan (server, cloud, container). Produk di
atas RHEL meliputi:

- **Red Hat OpenShift** — platform Kubernetes enterprise.
- **Red Hat Ansible Automation Platform** — otomasi IT.
- **Red Hat OpenShift Virtualization / Virtualization** — virtualisasi.
- **Podman / Buildah** — container (RHEL 9+ menggunakan Podman sebagai default).

RHEL memiliki versi mayor yang didukung bertahun-tahun (mis. RHEL 9, RHEL 10).
Panduan ini berbasis **RHEL 9.3** namun berlaku pula untuk **RHEL 10.x**.

## 2. Jalur Sertifikasi (Certification Path)

```
RH124 (SA I)  ──►  RH134 (SA II)  ──►  EX200 = RHCSA
                                    └─► (lanjut) RH294 + EX294 = RHCE
```

- **RH124 / RH199** — System Administration I (pemula → admin dasar).
- **RH134** — System Administration II (lanjutan).
- **EX200 (RHCSA)** — ujian sertifikasi *performance-based* (hands-on, bukan
  pilihan ganda). Kamu diberi server nyata dan diminta menyelesaikan tugas.
- **RHCE (EX294)** — otomasi dengan Ansible (tingkat lanjut).

## 3. Mengapa RHCSA penting?

RHCSA membuktikan kamu mampu mengelola sistem Linux secara praktis: instalasi,
konektivitas jaringan, storage, keamanan dasar, dan service. Ini fondasi karier
sysadmin / DevOps / SRE.

## 4. Menyiapkan Lingkungan Belajar (Gratis)

RHEL butuh langganan untuk update resmi, tapi untuk belajar gunakan klon gratis:

| Opsi | Cara |
|------|------|
| Rocky Linux / AlmaLinux | ISO gratis, biner-kompatibel 100% dengan RHEL |
| Fedora | `wsl --install -d FedoraLinux-42` (di Windows) |
| Container | `podman run -it rockylinux:9 bash` |

```bash
# Cek versi RHEL-like yang sedang berjalan
cat /etc/redhat-release
# Contoh output: Rocky Linux release 9.4 (Blue Onyx)
```

## 5. Roadmap Belajar 16 Minggu (Saran)

| Minggu | Fokus |
|--------|-------|
| 1–2 | Modul 01–04 (akses, shell, berkas, bantuan) |
| 3–4 | Modul 05–07 (teks, user/grup, permission) |
| 5–6 | Modul 08–09 (proses, service) |
| 7–8 | Modul 10–12 (SSH, jaringan, DNF) |
| 9–10 | Modul 13–14 (filesystem, support) |
| 11–12 | Ulangi semua LAB |
| 13–16 | Modul 18 (EX200 Prep) + 19 (Skenario) + simulasi EX200 |

## Latihan
1. Tentukan distro yang akan kamu pakai untuk lab dan catat alasannya.
2. Jalankan `cat /etc/redhat-release` dan simpan outputnya.
3. Buat akun latihan bernama `student` (dilakukan di Modul 06 nanti).

## Kunci Jawaban (klik untuk lihat)

??? note "Kunci Jawaban Latihan"
    1. Pilih Rocky/AlmaLinux (100% RHEL-compatible, gratis) atau Fedora (WSL).
       Alasan: tanpa langganan RHEL resmi tetap bisa latihan penuh.
    2. Output mis. `Rocky Linux release 9.4 (Blue Onyx)` — bukti distro RHEL-like.
    3. Akun `student` dibuat di Modul 06 (useradd); di sini cukup rencanakan.

## Kuis

1. Ujian EX200 (RHCSA) berbasis?
   - a. Pilihan ganda  b. Performance/hands-on  c. Esai  d. Wawancara
2. Jalur setelah RH124 untuk menjadi RHCSA adalah?
   - a. RH134 → EX200  b. EX200 langsung  c. RH294  d. RHCE
3. Distro gratis pengganti RHEL untuk latihan?
   - a. Ubuntu  b. Rocky/AlmaLinux  c. Debian  d. Arch

??? note "Kunci Jawaban Kuis"
    1. **b** (performance-based, diberi server nyata).
    2. **a** (RH124 → RH134 → EX200).
    3. **b** (Rocky/AlmaLinux biner-kompatibel RHEL).
