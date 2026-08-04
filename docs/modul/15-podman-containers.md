# Modul 15 — Podman & Containers (Materi Perluasan)

> ⚠️ **Penting — status di EX200:** Mulai **EX200 berbasis RHEL 10** (ujian
> saat ini, 2026), **Containers/Podman TIDAK LAGI masuk objektif resmi** —
> Red Hat menggantinya dengan **Flatpak** (lihat Modul 12). Modul ini tetap
> sangat berguna sebagai **bonus keahlian** dan persiapan jalur **RHCE
> (EX294, Ansible)**, tapi **tidak wajib** untuk lulus EX200 RHEL 10.
> (Di era RHEL 9, Podman memang pernah masuk objektif — itu sebabnya banyak
> materi lama masih mencantumkannya.)

> 📺 Referensi video: [RHCSA & EX200 Prep](https://www.youtube.com/watch?v=eGbNXqPdUa4&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns) (Podman bagian dari kurikulum RH124/RH199; video playlist tidak memilah per-topik container)

## 1. Mengapa Podman?

- **Rootless**: jalan sebagai user biasa, lebih aman.
- **Daemonless**: tidak ada service latar yang harus hidup.
- **Docker-compatible**: `podman` menggantikan `docker` hampir 1:1.
- Terintegrasi dengan **systemd** untuk auto-start container.

## 2. Perintah Dasar

```bash
podman --version
podman images                  # lihat image lokal
podman pull registry.access.redhat.com/ubi9/ubi   # tarik image
podman pull docker.io/library/nginx:latest

podman run -d --name web -p 8080:80 nginx     # jalankan container
podman ps                                   # container jalan
podman ps -a                                # semua (termasuk stop)
podman logs web                             # lihat log
podman exec -it web bash                    # masuk ke container
podman stop web && podman rm web            # hentikan & hapus
```

## 3. Volume & Persistensi

```bash
# Bind mount direktori host ke container
podman run -d --name web -p 8080:80 -v /srv/html:/usr/share/nginx/html nginx

# Named volume (dikelola podman)
podman volume create webdata
podman run -d --name web -v webdata:/usr/share/nginx/html nginx
```

## 4. Container sebagai systemd Service

Agar container hidup otomatis saat boot (sering muncul di EX200):

```bash
# Generate unit systemd (rootless: ke ~/.config/systemd/user/)
podman generate systemd --new --files --name web
mkdir -p ~/.config/systemd/user
mv container-web.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now container-web.service
loginctl enable-linger $USER          # biar jalan walau user logout (rootless)
```

Untuk **root** (system-wide):
```bash
podman generate systemd --new --files --name web
sudo mv container-web.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now container-web.service
```

## 5. Pod & Multi-Container

```bash
podman pod create --name app -p 8080:80
podman run -dt --pod app --name db nginx
podman run -dt --pod app --name web nginx
```

## 6. Inspeksi & Kebersihan

```bash
podman inspect web            # detail JSON
podman top web                # proses dalam container
podman stats                  # pemakaian resource
podman image prune -a         # hapus image tak terpakai
podman system prune           # bersihkan semua tak terpakai
```

## 7. Jebakan Umum (EX200)


!!! danger "Jebakan"
    - Lupa `loginctl enable-linger` → container rootless mati setelah logout.
    - Menjalankan `podman` dengan `sudo` lalu mengharapkan container user muncul
      di session user (berbeda *storage*). Konsisten root vs rootless.
    - Firewall host blokir port 8080 → tetap `firewall-cmd --add-port=8080/tcp`.
    - SELinux blocks read/write volume → `z`/`Z` flag: `-v /data:/data:Z`.

## 8. Quadlet — Container sebagai systemd Unit (Wajib EX200 RHEL 9)

Cara **modern & direkomendasikan** di EX200 RHEL 9 untuk menjadikan container
auto-start saat boot adalah **quadlet**: cukup tulis file unit `.container`
(semacam systemd unit), lalu `systemctl` yang mengelolanya — tanpa perlu
`podman generate systemd` lagi.

```bash
# 1. Buat file unit quadlet (rootless: ~/.config/containers/systemd/)
mkdir -p ~/.config/containers/systemd
cat > ~/.config/containers/systemd/web.container <<'EOF'
[Unit]
Description=Web server nginx via quadlet
After=network-online.target
Wants=network-online.target

[Container]
Image=docker.io/library/nginx:latest
ContainerName=web
PublishPorts=8080:80
Volume=/srv/html:/usr/share/nginx/html:Z

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF

# 2. Muat & jalankan (systemd membaca quadlet otomatis)
systemctl --user daemon-reload
systemctl --user enable --now web.container
loginctl enable-linger $USER          # agar jalan walau user logout (rootless)
```

Verifikasi:
```bash
systemctl --user is-active web.service   # quadlet otomatis jadi *.service
podman ps | grep web
curl -s localhost:8080 | head -1
```
> Quadlet mendeteksi file `*.container`/`*.volume`/`*.network` di direktori
> systemd dan membangun unit systemd-nya saat `daemon-reload`. Di SOAL EX200
> yang explicit minta "quadlet" atau "systemd-managed container", gunakan cara
> ini (lebih bersih daripada `podman generate systemd --new`).

## 9. skopeo & buildah — Inspeksi, Salin, & Bangun Image (Wajib EX200)

Selain `podman`, EX200 mengenal **skopeo** (inspeksi & copy image antar
registry/tar tanpa perlu pull penuh) dan **buildah** (build image OCI tanpa
daemon). Berguna untuk soal "ambil image dari registry ke local store" atau
"inspeksi image".

```bash
# skopeo: inspeksi image di registry tanpa mendownload layer
skopeo inspect docker://docker.io/library/nginx:latest

# skopeo: salin image registry -> local tar (offline-friendly)
skopeo copy docker://docker.io/library/nginx:latest \
            oci-archive:/tmp/nginx.oci.tar

# skopeo: salin antar registry (mirror)
skopeo copy docker://docker.io/library/nginx:latest \
            docker://registry.access.redhat.com/nginx:latest

# buildah: bangun image dari Containerfile (tanpa docker daemon)
buildah bud -t myapp:1.0 .        # 'bud' = build using dockerfile
buildah images                     # lihat image hasil build
podman pull myapp:1.0             # image buildah bisa dipakai podman
```

> ⚠️ `skopeo copy` tidak butuh `podman pull` dulu — langsung transfer antar
> sumber/tujuan. Di EX200 sering dipakai untuk "mirror image ke registry
> internal" atau "backup image ke file".

## 10. Koneksi ke EX200 (Era RHEL 9 — Bonus di RHEL 10)

!!! success "EX200 (RHEL 9) / Bonus RHEL 10"
    Di era **RHEL 9**, soal container umumnya: *"Jalankan image X sebagai
    container bernama Y, port P, persistent, dan pastikan hidup setelah
    reboot."* Kunci: `podman run` + `-v` + `podman generate systemd --new` +
    `systemctl enable`.
    > Di **EX200 RHEL 10**, container **tidak lagi diujikan** — fokus ke
    > Flatpak (Modul 12). Modul ini bermanfaat untuk jalur RHCE.

## Kuis Cepat

1. Apa bedanya Podman dengan Docker secara arsitektur? (daemonless/rootless)
2. Perintah untuk melihat container yang sedang jalan?
3. Bagaimana agar container rootless otomatis start saat boot?
   (`loginctl enable-linger` + `systemctl --user enable`)

## Latihan
1. `podman pull` image `ubi9/ubi`, jalankan interaktif `podman run -it --rm ubi9/ubi bash`.
2. Jalankan `nginx` di port 8080, akses via browser/curl, lalu hapus.
3. Generate systemd unit untuk container nginx dan enable --now.

## Kunci Jawaban (klik untuk lihat)

??? note "Kunci Jawaban Latihan"
    1. `podman pull registry.access.redhat.com/ubi9/ubi` lalu `podman run -it --rm ubi9/ubi bash`.
    2. `podman run -d -p 8080:80 --name web nginx`; `curl localhost:8080`;
       `podman rm -f web`.
    3. `podman generate systemd --new --files --name web`; pindahkan unit ke
       `~/.config/systemd/user/`; `systemctl --user enable --now container-web.service`
       (butuh `loginctl enable-linger $USER` agar jalan saat boot).
