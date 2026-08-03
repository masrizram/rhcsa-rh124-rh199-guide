# Modul 13 — Access Linux File Systems

> 📺 Referensi video: [tuN89JVWjCs](https://www.youtube.com/watch?v=tuN89JVWjCs&list=PLZkuninm20jDUT_jArQrkfCImbbi2jWns)

## 1. Konsep Storage

Hirarki penyimpanan RHEL:
```
Disk fisik (sda)
  └─ Partisi (sda1, sda2)
       └─ Physical Volume (PV)  →  Volume Group (VG)  →  Logical Volume (LV)
            └─ File System (ext4 / xfs / vfat)  →  mount point (/data)
```

RHEL default menggunakan **XFS**. LVM memberi fleksibilitas resize.

## 2. Melihat Storage

```bash
lsblk                 # pohon block device
fdisk -l              # partisi (MBR)
gdisk -l /dev/sda     # partisi (GPT)
df -h                 # pemakaian filesystem ter-mount
du -sh /var/log       # ukuran direktori
```

## 3. Membuat Filesystem

```bash
sudo mkfs.xfs /dev/sdb1        # format partisi jadi XFS
sudo mkfs.ext4 /dev/sdb2       # atau ext4
sudo mkfs.vfat -F 32 /dev/sdc1 # FAT32 (VFAT) — objektif EX200
```

> **VFAT (FAT32)** muncul di objektif EX200 ("mount, unmount, and use VFAT").
> Cocok untuk USB flash disk / share dengan Windows. Tanpa journal, tanpa
> permission Unix (semua file 0777), batas file 4 GB.

## 4. Mount & Unmount

```bash
sudo mkdir /data
sudo mount /dev/sdb1 /data     # mount manual (hilang setelah reboot)
mount | grep data              # verifikasi
sudo umount /data              # lepas
```

## 5. Mount Permanen (`/etc/fstab`)

```bash
# Dapatkan UUID
blkid /dev/sdb1

# Tambahkan ke /etc/fstab (contoh XFS):
UUID=xxxx-xxxx  /data  xfs  defaults  0 0

# Uji tanpa reboot:
sudo mount -a
```

Format fstab: `device  mountpoint  fstype  options  dump  fsck`

Untuk VFAT, opsi umum: `UUID=xxxx  /mnt/usb  vfat  defaults,uid=1000,gid=1000  0 0`
(pakai `uid/gid` agar pemiliknya user biasa, bukan root).

## 6. LVM (Logical Volume Manager)

```bash
# 1. Tandai partisi sebagai PV
sudo pvcreate /dev/sdb1
# 2. Gabung ke VG
sudo vgcreate vgdata /dev/sdb1
# 3. Buat LV
sudo lvcreate -n lvdata -L 5G vgdata
# 4. Format & mount
sudo mkfs.xfs /dev/vgdata/lvdata
sudo mount /dev/vgdata/lvdata /data

# Perbesar LV (LVM unggul di sini):
sudo lvextend -L +2G /dev/vgdata/lvdata
sudo xfs_growfs /data        # untuk XFS
# (ext4: resize2fs /dev/vgdata/lvdata)
```

## 7. Swap

```bash
sudo mkswap /dev/sdc1
sudo swapon /dev/sdc1
swapon --show                 # verifikasi
# permanen: tambahkan ke /etc/fstab:
# /dev/sdc1  swap  swap  defaults  0 0
```

## 8. Label & UUID

Gunakan UUID di fstab (lebih stabil dari nama device `/dev/sdX` yang bisa
berubah antar boot). `blkid` untuk melihat keduanya; `e2label`/`xfs_admin -L`
untuk memberi label.

## 9. autofs — Mount Otomatis on-demand (Wajib EX200)

`autofs` mem-mount filesystem **secara otomatis saat diakses** dan me-lepas
otomatis saat idle. Sangat dipakai untuk NFS di client (tidak perlu entri
fstab statis, tidak hang saat server NFS mati saat boot).

**Langkah di client:**
```bash
# 1. Pasang & aktifkan
sudo dnf install -y autofs
sudo systemctl enable --now autofs

# 2. Master map: arahkan /mnt/nfs ke map file
echo '/mnt/nfs  /etc/auto.nfs' | sudo tee -a /etc/auto.master.d/nfs.autofs

# 3. Map file: direktori tujuan -> sumber NFS
#    sintaks:  <subdir>  <opts>  <server>:<export>
echo 'share  -fstype=nfs,rw,soft,intr  server1.lab.local:/srv/nfs/share' | \
  sudo tee -a /etc/auto.nfs

sudo systemctl restart autofs
```

**Cara membuktikan (verifikasi):**
```bash
cd /mnt/nfs/share          # akses -> autofs otomatis mount!
mount | grep auto.nfs      # terlihat entry automount
# setelah idle (default ~300 dtk), autofs me-lepas sendiri
```

> ⚠️ Bedanya dengan fstab statis: autofs **tidak** mem-block boot bila server
> NFS down. Itu sebabnya sering jadi preferensi di soal EX200.

## 10. Jebakan Umum (EX200)

!!! danger "Jebakan"
    - Salah UUID di `/etc/fstab` → VM **no-boot** (grub rescue). Selalu `mount -a`
      sebelum reboot!
    - Menggunakan nama device `/dev/sdb1` di fstab (bisa berubah antar boot) →
      gunakan **UUID** atau label.
    - Membuat filesystem di partisi yang masih ter-mount → data hilang.
    - Lupa `xfs_growfs` setelah `lvextend` → ukuran LV bertambah tapi FS tetap.
    - ext4 butuh `resize2fs`; XFS butuh `xfs_growfs` (berbeda perintah!).
    - NFS di fstab tanpa opsi `_netdev` → boot hang (tunggu timeout mount).
    - autofs: lupa `systemctl enable --now autofs` → mount on-demand tak jalan.

## 11. Koneksi ke EX200

!!! success "EX200"
    Soal storage sering: "Buat LV 1G, format XFS, mount permanen di `/data`,
    lalu besarkan jadi 2G." Kunci: `pvcreate`→`vgcreate`→`lvcreate`→`mkfs.xfs`→
    fstab (UUID) → `mount -a` → `lvextend -L +1G` → `xfs_growfs /data`.
    Atau: "Pasang share NFS `server:/export` ke `/mnt/data` otomatis saat
    diakses" → pakai **autofs** (§9).

## Kunci Jawaban (klik untuk lihat)

??? note "Kunci Jawaban Latihan"
    1. `lvcreate` butuh VG ada.
    2. `mkfs.xfs` memformat; XFS tidak bisa shrink.
    3. `mount -a` uji semua entri fstab.
    4. VFAT: `mkfs.vfat -F 32 /dev/sdX`; mount type `vfat`.
    5. autofs: isi `/etc/auto.master.d/*.autofs` + map file, lalu `enable --now autofs`.

## Kuis Cepat

1. Perintah verifikasi fstab tanpa reboot? (`mount -a`)
2. Setelah `lvextend` pada volume XFS, apa yang harus dijalankan?
   (`xfs_growfs /mountpoint`)
3. Mengapa pakai UUID daripada nama device di fstab? (nama device bisa berubah)
4. Bedanya autofs vs fstab statis untuk NFS? (autofs mount on-demand, tidak
   block boot bila server mati)

## Latihan
1. Buat partisi + filesystem XFS di disk lab, lalu mount ke `/mnt/uji`.
2. Tambahkan entri ke `/etc/fstab` dan validasi dengan `mount -a`.
3. (Jika ada ruang) buat LV dengan LVM dan perbesar 1 GB.
4. Format flash disk jadi VFAT: `sudo mkfs.vfat -F 32 /dev/sdX`, lalu mount.
5. (Lab berjaringan) pasang autofs untuk mount NFS lab on-demand di `/mnt/nfs`.
