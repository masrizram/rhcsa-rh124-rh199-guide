# 🎯 Persiapan EX200 — Ringkasan Taktis

> ⚠️ **Halaman ini ringkas.** Materi lengkap, objektif EX200 lengkap, dan
> simulasi soal berada di **[Modul 18 — EX200 Prep](../modul/18-ex200-prep.md)**.
> Baca Modul 18 sebagai kanonik; halaman ini hanya pengingat cepat & target waktu.

## 1. Profil Ujian (Singkat)
- **Durasi**: 3 jam (180 menit).
- **Format**: performance-based di VM nyata (bukan pilihan ganda).
- **Skor lolos**: historis ~210/300; kejar **semua** tugas.
- **Tools**: `man`, `vim`, `/usr/share/doc`, Cockpit — **tanpa internet**.
- **Satu kesempatan** — tidak ada ujian ulang gratis. Verifikasi tiap tugas.
## 2. Topik & Bobot (Resmi EX200 — RHEL 10, 2026)

> EX200 **saat ini resmi berbasis RHEL 10**. Objektif resmi terdiri 11 area
> (lihat [Modul 18 §2](../modul/18-ex200-prep.md)). Ringkasan bobot relatif:

1. Essential tools (shell, vim, pipe, `tar`/`gzip`/`bzip2`, `grep`, `ssh`) — 10–15%
2. Operating running systems (`systemctl`, `journalctl`, proses, **tuned**, preserve journals, `rd.break`) — 10–15%
3. Local storage (GPT partisi, LVM, mount UUID/label, swap) — 12–18%
4. File systems (VFAT/ext4/XFS, permission, ACL, **autofs**, NFS, extend LV) — 10–15%
5. Deploy/maintain (DNF, repo, **Flatpak**, `cron`/at/systemd timer, timezone, **chrony**, **grub2**) — 10–15%
6. Users & groups — 10–15%
7. Security (`firewalld`, **SELinux** enforcing/port-label/restorecon, `ssh` key, `umask`, `sudo`) — 12–18%
8. Networking (`nmcli` + **IPv6**, hostname resolution, DNS, **firewalld**) — 10–15%

> ⚠️ **Containers/Podman TIDAK lagi masuk objektif resmi EX200 RHEL 10**
> (diganti **Flatpak**). Stratis/VDO/disk quota/nmstate/bootc juga **tidak**
> diujikan — ada di repo sebagai materi perluasan (bonus), bukan soal wajib.
> Perbedaan RHEL 9 vs 10 lengkap di [Modul 18 §3–§4](../modul/18-ex200-prep.md).

## 3. Checklist H-7
- [ ] Kerjakan semua modul 01–20 tanpa melihat catatan.
- [ ] Selesaikan LAB & [Simulasi 3 Jam / 180 Menit](../referensi/SIMULASI-UJIAN.md) < 90 menit.
- [ ] Kuasai `vim`, `nmcli`, `systemctl`, `journalctl`, `dnf`, `firewall-cmd`, `setsebool`/`restorecon`, **`semanage port`** (SELinux port label).
- [ ] Pahami LVM end-to-end (create → extend → growfs).
- [ ] Kuasai **Flatpak** (`flatpak remote-add`/`install`) — pengganti container di RHEL 10.
- [ ] Latihan `podman run` + generate systemd service + `skopeo inspect/copy` **(bonus RHCE, bukan objektif EX200 RHEL 10)**.
- [ ] Simulasikan reboot VM dan pastikan tidak masuk grub rescue (fstab benar).
- [ ] Kuasai [Break & Fix](../referensi/BREAK-FIX.md) — ~40% soal EX200 adalah troubleshooting.
- [ ] **Topik sering luput (masih relevan RHEL 10)**: autofs, Flatpak, tuned, grub2/rd.break, VFAT, chrony/IPv6, SELinux port labels.

## 4. Jebakan Umum (Penyebab Gagal)
| Jebakan | Solusi |
|---------|--------|
| Mematikan SELinux | Konfigurasi benar: `setsebool -P`, `restorecon`, `semanage` |
| `sshd_config` salah lalu logout | Selalu `sshd -t` & buka sesi ke-2 untuk uji |
| fstab salah → VM no-boot | `mount -a` sebelum reboot; pakai UUID |
| Lupa `enable` service | `systemctl enable --now`, bukan hanya `start` |
| Firewall blokir | `firewall-cmd --add-service/--add-port --permanent` + `--reload` |
| Tidak membaca soal utuh | Baca semua dulu, petakan dependensi |
| Kehabisan waktu | Kerjakan yang mudah & independen dulu |

## 5. Contoh Skor Waktu (target)
- Tugas kecil (user/group, permission): 5–8 menit.
- Tugas menengah (networking, service): 10–15 menit.
- Tugas besar (LVM, storage, container): 15–25 menit.

## 6. Alur Kerja Saat Ujian
1. Catat IP, username, password, nama host yang diberikan.
2. Buka 2 terminal (jika bisa) — satu uji, satu kerja.
3. Untuk tiap tugas: kerjakan → verifikasi → lanjut.
4. Sisakan 20 menit terakhir untuk cek ulang tugas bernilai tinggi.

## 7. Resource Resmi
- https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam
- RH124 + RH134 course content.
- `lab/LAB.md`, `modul/`, dan [Modul 18](../modul/18-ex200-prep.md) di repo ini.

---
> "Orang yang lulus RHCSA bukan yang hafal semua, tapi yang bisa memverifikasi
> pekerjaannya sendiri." — prinsip lab.
