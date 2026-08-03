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

## 3. Membuat Partisi (MBR / GPT)

Objektif EX200: *"create and configure file systems"* sering berarti **mulai dari
disk kosong** — kamu harus membagi (partisi) disk dulu sebelum `mkfs`.
RHEL 9/10 default pakai tabel **GPT** (bukan MBR) agar bisa disk > 2 TB dan
lebih dari 4 partisi.

```bash
# Lihat disk yang tersedia (mis. /dev/vdb masih kosong)
lsblk /dev/vdb

# ── Opsi 1: parted (GPT, direkomendasikan EX200) ──
sudo parted -s /dev/vdb mklabel gpt                       # buat tabel partisi GPT
sudo parted -s /dev/vdb mkpart primary xfs 1MiB 501MiB    # partisi 500M pertama
sudo parted -s /dev/vdb set 1 lvm on                      # (opsional) flag LVM
partprobe /dev/vdb                                       # beri tahu kernel (jgn reboot)
lsblk /dev/vdb                                           # cek: muncul /dev/vdb1

# ── Opsi 2: gdisk (GPT interaktif) ──
sudo gdisk /dev/vdb
#   n  → new partition
#   ↵  → default partnum 1
#   ↵  → default first sector
#   +500M → ukuran 500 MiB
#   8300 → Linux filesystem (atau 8e00 untuk LVM)
#   w  → write & quit
partprobe /dev/vdb

# ── Opsi 3: fdisk (MBR, legacy) ──
sudo fdisk /dev/vdb      # n → p → 1 → ↵ → +500M → w
```

> **Verifikasi:** `lsblk /dev/vdb` harus menampilkan `vdb1`. Setelah ini baru
> di-format: `sudo mkfs.xfs /dev/vdb1`. Jangan lupa `partprobe` — tanpa itu
> kernel tidak melihat partisi baru dan `mkfs` gagal dengan "No such file".

## 4. Membuat Filesystem

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

## 10. Stratis — Manajemen Storage Lokal Modern (Wajib EX200)

Stratis menyederhanakan storage tingkat lanjut (snapshot, thin-provision,
pool) di atas LVM/XFS dengan satu perintah. Objektif EX200 RHEL 9/10:
*"Configure and manage storage using the Stratis"* (sic) — jadi **wajib diuji**.

**Konsep:** `blockdev` (disk) → `pool` (kumpulan storage) → `filesystem`
(XFS di atas pool, thin-provision).

```bash
# 1. Pasang & aktifkan layanan stratis
sudo dnf install -y stratis-cli stratisd
sudo systemctl enable --now stratisd

# 2. Buat pool dari satu/lebih block device
sudo stratis pool create mypool /dev/sdb /dev/sdc
stratis pool list

# 3. Buat filesystem (thin-provision, otomatis XFS)
sudo stratis filesystem create mypool data1
stratis filesystem list mypool

# 4. Mount (pakai device mapper Stratis)
sudo mkdir /mnt/stratis-data
sudo mount /dev/stratis/mypool/data1 /mnt/stratis-data

# 5. Mount permanen via /etc/fstab (gunakan _netdev + x-systemd)
echo '/dev/stratis/mypool/data1  /mnt/stratis-data  xfs  defaults,x-systemd.requires=stratisd.service  0 0' | sudo tee -a /etc/fstab
sudo mount -a
```

**Snapshot & recovered (sering muncul di soal):**
```bash
# Snapshot filesystem (readonly awal, bisa di-clone jadi RW)
sudo stratis filesystem snapshot mypool data1 snap1
# Clone snapshot jadi filesystem kerja
sudo stratis filesystem clone mypool snap1 data1-restored
# Hapus filesystem/pool
sudo stratis filesystem destroy mypool data1-restored
sudo stratis pool destroy mypool
```

> ⚠️ Jangan format device yang SUDAH masuk pool Stratis dengan `mkfs`.
> Stratis mengelola XFS di dalamnya sendiri.

## 11. VDO — Deduplikasi & Kompresi (Wajib EX200)

VDO (Virtual Data Optimizer) memberikan deduplikasi + kompresi di atas block
device, sehingga ruang fisik lebih efisien untuk data berulang (backup,
image). Objektif EX200: *"Configure and manage storage using VDO"*.

```bash
# 1. Pasang & aktifkan
sudo dnf install -y vdo kmod-kvdo
sudo systemctl enable --now vdo

# 2. Buat volume VDO (logical size BISA > physical size = thin)
sudo vdo create --name=myvdo --device=/dev/sdb --vdoLogicalSize=50G
#    tunggu sampai 'Operating' (lihat status):
vdo status --name=myvdo

# 3. Format & mount seperti block device biasa
sudo mkfs.xfs -K /dev/mapper/myvdo
sudo mkdir /mnt/vdo
sudo mount /dev/mapper/myvdo /mnt/vdo

# 4. Mount permanen (penting: _netdev + noauto agar tidak hang boot)
echo '/dev/mapper/myvdo  /mnt/vdo  xfs  defaults,x-systemd.requires=vdo.service,_netdev  0 0' | sudo tee -a /etc/fstab

# 5. Cek efisiensi (dedup ratio)
vdostats --human-readable
```

> ⚠️ VDO butuh device **kosong** (belum ada filesystem/partition table).
> Gunakan `vdo remove --name=myvdo` untuk membongkar.

## 12. Disk Quota — Batasi Pemakaian User/Group (Wajib EX200)

Objektif EX200: *"Implement disk quotas"*. Batasi berapa banyak ruang/	jumlah
file yang boleh dipakai tiap user atau group pada suatu filesystem.

```bash
# 1. Mount FS dengan opsi quota (userquota,grpquota)
#    di /etc/fstab:  UUID=xxxx  /home  xfs  defaults,usrquota,grpquota  0 0
sudo mount -o remount,usrquota,grpquota /home

# 2. XFS: bangun ulang database quota (langsung aktif, tanpa quotacheck)
sudo xfs_quota -x -c 'report -h' /home      # lihat status
sudo xfs_quota -x -c 'state' /home           # pastikan quota ON

# 3. Set batas (block soft/hard + inode soft/hard) untuk user
sudo xfs_quota -x -c 'limit bsoft=100M bhard=120M isoft=1000 ihard=1200 user1' /home

# 4. Verifikasi
sudo xfs_quota -x -c 'report -h -u' /home
#    bhard/bsoft = batas block (ruang), ihard/isoft = batas inode (jumlah file)
```

Untuk **ext4** (berbeda alat):
```bash
sudo quotacheck -cugm /home     # bangun aquota.user/aquota.group
sudo quotaon -v /home
sudo edquota -u user1           # edit interaktif (mirip crontab)
repquota -a                     # laporan
```

> ⚠️ `bhard` = batas keras (tulis ditolak setelah lewat). `bsoft` = batas lunak
> (diizinkan lewat dalam masa grace, lalu jadi keras). EX200 sering minta
> set keduanya.

## 13. Jebakan Umum (EX200)

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
    Atau (RHEL 9/10): "Buat pool Stratis `mypool` dari `/dev/sdb`, buat
    filesystem `data1`, mount permanen" → **Stratis** (§10).
    Atau: "Buat volume VDO dedup 50G di `/dev/sdc`, mount di `/mnt/vdo`" →
    **VDO** (§11).
    Atau: "Batasi user `user1` maks 120M & 1200 file di `/home`" →
    **disk quota** (§12, perintah `xfs_quota -x -c 'limit ...'`).

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
6. (RHEL 9/10) buat pool Stratis dari disk lab, buat filesystem, mount permanen.
7. (RHEL 9/10) buat volume VDO dedup, format XFS, cek `vdostats`.
8. (RHEL 9/10) pasang `usrquota,grpquota` di `/home`, set batas user dengan
   `xfs_quota -x -c 'limit ...'`, verifikasi dengan `report -h -u`.
