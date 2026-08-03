# 🎓 Persiapan Ujian EX200 (RHCSA)

Panduan taktis menghadapi ujian sertifikasi RHCSA (EX200).

## 1. Profil Ujian
- **Durasi**: 3 jam (180 menit) untuk RHEL 9; RHEL 10 tetap 3 jam.
- **Format**: performance-based di VM nyata (bukan pilihan ganda).
- **Skor lolos**: Red Hat **tidak mengumumkan** angka pasti; secara historis
  passing score ~ **210/300** untuk EX200 (bisa berubah per rilis). Strategi
  aman: kejar **semua** tugas, jangan mengejar nilai tertentu.
- **Tools tersedia**: `man`, `vim`, `/usr/share/doc`, `cockpit` — **tanpa internet**.
- **Sistem**: diberi VM (atau 2 VM) RHEL, credential & IP diberikan di lembar soal.

> ⚠️ **Tidak ada ujian ulang gratis** — satu kesempatan. Verifikasi tiap tugas
> sebelum lanjut.

## 1b. Perbedaan RHEL 9 vs RHEL 10 (Penting!)
| Aspek | RHEL 9 | RHEL 10 |
|-------|--------|---------|
| Init & service | systemd | systemd (sama) |
| Container | Podman (rootless) | Podman + **bootc** |
| OS model | Package-based (RPM/DNF) | **Image mode** (bootc) tersedia |
| `bootc` | tidak ada | `bootc` untuk sistem berbasis image (imilar ke Container OS) |
| Default FS | XFS | XFS |
| Networking | NetworkManager/nmcli | NetworkManager/nmcli (sama) |

**Bootc / Image Mode (RHEL 10):** sistem dikelola sebagai *image* yang
di-update via `bootc` (bukan `dnf update` tradisional). Untuk EX200, fokus
tetap ke administrasi standar (user, storage, service, network, SELinux,
Podman) — `bootc` muncul sebagai topik baru tapi bobotnya kecil. Perintah dasar:
```bash
bootc status          # lihat status image/rollback
bootc upgrade         # upgrade ke image baru
bootc rollback        # kembalikan ke image sebelumnya
```


## 2. Bobot & Topik (RHEL 9)
1. Essential tools (shell, vim, pipe, `tar`, `grep`, `ssh`) — 10–15%
2. Operating running systems (`systemctl`, `journalctl`, proses) — 10–15%
3. Local storage (partisi, LVM, mount, swap) — 12–18%
4. File systems (XFS/ext4, permission, ACL) — 10–15%
5. Deploy/maintain systems (DNF, repo, `cron`, timezone) — 10–15%
6. Users & groups — 10–15%
7. Security (`firewalld`, **SELinux**, `ssh`, `sudo`) — 12–18%
8. Networking (`nmcli`, DNS, hostname) — 10–15%
9. Containers (`podman`) — bagian baru RHEL 9

## 3. Checklist H-7
- [ ] Kerjakan semua modul 01–17 tanpa melihat catatan.
- [ ] Selesaikan LAB Modul 17 simulasi < 90 menit.
- [ ] Kuasai `vim`, `nmcli`, `systemctl`, `journalctl`, `dnf`, `firewall-cmd`, `setsebool`/`restorecon`.
- [ ] Pahami LVM end-to-end (create → extend → growfs).
- [ ] Latihan `podman run` + generate systemd service.
- [ ] Simulasikan reboot VM dan pastikan tidak masuk grub rescue (fstab benar).
- [ ] **Wajib**: kuasai [Break & Fix / Troubleshooting](BREAK-FIX.md) — ~40% soal EX200 adalah perbaikan sistem.

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

## 5. Alur Kerja Saat Ujian
1. Catat IP, username, password, nama host yang diberikan.
2. Buka 2 terminal (jika bisa) — satu untuk uji, satu untuk kerja.
3. Untuk tiap tugas: kerjakan → verifikasi → lanjut.
4. Sisakan 20 menit terakhir untuk cek ulang tugas bernilai tinggi.

## 6. Contoh Skor Waktu (target)
- Tugas kecil (user/group, permission): 5–8 menit.
- Tugas menengah (networking, service): 10–15 menit.
- Tugas besar (LVM, storage, container): 15–25 menit.

## 7. Resource Resmi
- https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam
- RH124 + RH134 course content.
- `lab/LAB.md` & `modul/` di repo ini.

---
> "Orang yang lulus RHCSA bukan yang hafal semua, tapi yang bisa memverifikasi
> pekerjaannya sendiri." — prinsip lab.
