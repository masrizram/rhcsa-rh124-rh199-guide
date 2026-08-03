# Checklist H-1 Sebelum Ujian EX200

> Cetak halaman ini (Ctrl/Cmd+P) dan centang satu per satu sehari sebelum ujian.

## 🧠 Persiapan Mental & Logistik
- [ ] Tahu persis jam & zona waktu ujian (3 jam penuh, tanpa jeda).
- [ ] Koneksi internet stabil + webcam (jika ujian remote/remote-proctored).
- [ ] ID pengenal (KTP/paspor) siap jika diminta.
- [ ] Sudah istirahat cukup (jangan begadang H-1).
- [ ] Snack + air di dekat meja.

## 💻 Lab & Lingkungan
- [ ] VM/container lab sudah fresh snapshot (bisa reset cepat).
- [ ] Tau IP VM, user, password, dan cara masuk (SSH/konsole).
- [ ] `sudo` / `root` password diketahui.
- [ ] Keyboard layout sudah EN (hindari typo di password).

## 🛠️ Skill Wajib (centang = sudah latihan ≥3x)
- [ ] User/grup, password policy, sudo tanpa password.
- [ ] Permission + **ACL** (`setfacl`/`getfacl`).
- [ ] `systemd`: enable/disable/mask, unit file, `journalctl`.
- [ ] **SELinux**: boolean, fcontext, `restorecon`, enforcing.
- [ ] Networking: `nmcli`/`nmtui`, static IP, hostname, `/etc/hosts`.
- [ ] Firewall: `firewall-cmd` zone/port/service.
- [ ] DNF: install/remove/group/module, repo.
- [ ] Storage: **LVM** (pv/vg/lv), XFS, `/etc/fstab` persisten.
- [ ] Podman: run, port, volume, systemd quadlet.
- [ ] Cron/at + timezone (`timedatectl`).
- [ ] Help: `man`, `info`, `apropos`, `cockpit`.

## 🚨 Yang Sering Lupa (Jebakan)
- [ ] **Cek `getenforce`** — kalau Enforcing, jangan matikan (uji justru butuh aktif).
- [ ] **`mount -a`** setelah edit fstab (hindari boot gagal).
- [ ] **`firewall-cmd --reload`** setelah ubah rule.
- [ ] **Verifikasi tiap tugas** sebelum lanjut (pemeriksa cek kondisi, bukan niat).
- [ ] Jangan `chmod 777` — gunakan ACL.

## 📊 Self-Score
- [ ] Sudah lulus **Simulasi Ujian 3 Jam** dengan skor ≥ 80%.
- [ ] Waktu rata-rata per tugas < 18 menit.

> Jika ada satu saja skill wajib belum centang → tunda ujian, latih dulu.
