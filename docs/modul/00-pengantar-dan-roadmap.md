# Modul 00 — Pengantar & Roadmap Sertifikasi Red Hat

> Referensi video: `pnHqii1Oq8Y` (Introduction), `O58uDdztjGU` (Wrap Up), `2n2P0Awz3U4` (Pass the EX200)

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
| 13–16 | Modul 15 + simulasi EX200 |

## Latihan
1. Tentukan distro yang akan kamu pakai untuk lab dan catat alasannya.
2. Jalankan `cat /etc/redhat-release` dan simpan outputnya.
3. Buat akun latihan bernama `student` (dilakukan di Modul 06 nanti).
