# Modul 13 — Access Linux File Systems

> Referensi video: `tuN89JVWjCs`

## 1. Konsep Storage

Hirarki penyimpanan RHEL:
```
Disk fisik (sda)
  └─ Partisi (sda1, sda2)
       └─ Physical Volume (PV)  →  Volume Group (VG)  →  Logical Volume (LV)
            └─ File System (ext4 / xfs)  →  mount point (/data)
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
```

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
berubah antar boot).

## 9. Jebakan Umum (EX200)

!!! danger "Jebakan"
    - Salah UUID di `/etc/fstab` → VM **no-boot** (grub rescue). Selalu `mount -a`
      sebelum reboot!
    - Menggunakan nama device `/dev/sdb1` di fstab (bisa berubah antar boot) →
      gunakan **UUID** atau label.
    - Membuat filesystem di partisi yang masih ter-mount → data hilang.
    - Lupa `xfs_growfs` setelah `lvextend` → ukuran LV bertambah tapi FS tetap.
    - ext4 butuh `resize2fs`; XFS butuh `xfs_growfs` (berbeda perintah!).

## 10. Koneksi ke EX200

!!! success "EX200"
    Soal storage sering: "Buat LV 1G, format XFS, mount permanen di `/data`,
    lalu besarkan jadi 2G." Kunci: `pvcreate`→`vgcreate`→`lvcreate`→`mkfs.xfs`→
    fstab (UUID) → `mount -a` → `lvextend -L +1G` → `xfs_growfs /data`.

## Kuis Cepat

1. Perintah apa untuk verifikasi fstab tanpa reboot? (`mount -a`)
2. Setelah `lvextend` pada volume XFS, apa yang harus dijalankan?
   (`xfs_growfs /mountpoint`)
3. Mengapa pakai UUID而非 nama device di fstab? (nama device bisa berubah)

## Latihan
1. Buat partisi + filesystem XFS di disk lab, lalu mount ke `/mnt/uji`.
2. Tambahkan entri ke `/etc/fstab` dan validasi dengan `mount -a`.
3. (Jika ada ruang) buat LV dengan LVM dan perbesar 1 GB.
