# Modul 15 — Podman & Containers (RHEL 9+)

> Topik wajib di **EX200 RHEL 9**. RHEL menggantikan Docker dengan **Podman**
> (rootless, daemonless, CLI kompatibel Docker).

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

## 8. Koneksi ke EX200

!!! success "EX200"
    Soal container umumnya: *"Jalankan image X sebagai container bernama Y,
    port P, persistent, dan pastikan hidup setelah reboot."* Kunci: `podman run`
    + `-v` + `podman generate systemd --new` + `systemctl enable`.

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
