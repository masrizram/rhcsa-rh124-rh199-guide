#!/usr/bin/env bash
# =============================================================================
# verify-lab.sh — Verifikasi lab RHCSA di container Podman (Rocky/Alma Linux 9)
# Jalankan di KOMPUTER ANDA (bukan di cloud):
#   ./docs/lab/verify/verify-lab.sh
# Prasyarat: podman (Linux/Mac/WSL2). Windows: jalankan di WSL2/Git Bash.
# Container ephemeral (--rm); tidak mengubah sistem host.
# =============================================================================
set -u
IMG="${IMG:-docker.io/rockylinux:9}"
PASS=0; FAIL=0; SKIP=0
R='\033[0;31m'; G='\033[0;32m'; Y='\033[0;33m'; B='\033[0;34m'; N='\033[0m'

ok()   { echo -e "  ${G}✓ PASS${N} $1"; PASS=$((PASS+1)); }
bad()  { echo -e "  ${R}✗ FAIL${N} $1"; FAIL=$((FAIL+1)); }
skip() { echo -e "  ${Y}⊘ SKIP${N} $1"; SKIP=$((SKIP+1)); }

echo -e "${B}=== Verifikasi Lab RHCSA (container: $IMG) ===${N}"
command -v podman >/dev/null 2>&1 || { echo -e "${R}podman tidak ditemukan. Install dulu (https://podman.io).${N}"; exit 1; }

# Jalankan container, mount skrip cek ke /tmp/check.sh, eksekusi di dalam
# Semua cek dijalankan sebagai root di dalam container (aman, ephemeral).
podman run --rm -i --name rhcsa-verify "$IMG" bash -s <<'CONTAINER'
set -u
P=0; F=0; S=0
ok(){ echo "  ✓ PASS $1"; P=$((P+1)); }
bad(){ echo "  ✗ FAIL $1"; F=$((F+1)); }
skip(){ echo "  ⊘ SKIP $1"; S=$((S+1)); }

echo "--- [Modul 01] Shell & user ---"
id -u root >/dev/null 2>&1 && ok "root ada" || bad "root"
echo "$SHELL" | grep -q bash && ok "default shell bash ($SHELL)" || skip "shell=$SHELL"

echo "--- [Modul 06] User & Group ---"
useradd -m operator 2>/dev/null && ok "useradd operator" || bad "useradd"
echo "RedHat123" | passwd --stdin operator >/dev/null 2>&1 && ok "set password operator" || bad "passwd"
groupadd ops 2>/dev/null; usermod -aG ops operator 2>/dev/null && ok "usermod -aG ops" || bad "usermod group"
id operator | grep -q ops && ok "operator di grup ops" || bad "group membership"
getent group ops >/dev/null && ok "getent group" || bad "getent"

echo "--- [Modul 07] Permission & ACL ---"
mkdir -p /tmp/acltest && touch /tmp/acltest/f.txt
chmod 640 /tmp/acltest/f.txt
[ "$(stat -c %a /tmp/acltest/f.txt)" = "640" ] && ok "chmod 640" || bad "chmod"
setfacl -m u:operator:rwx /tmp/acltest/f.txt 2>/dev/null && ok "setfacl" || skip "setfacl (acl mungkin off)"
getfacl -p /tmp/acltest/f.txt 2>/dev/null | grep -q operator && ok "getfacl lihat ACE" || skip "getfacl read"
command -v setfacl >/dev/null && ok "paket acl tersedia" || skip "acl tools"

echo "--- [Modul 08] Proses ---"
sleep 2 & PID=$!; kill -TERM $PID 2>/dev/null && ok "kill SIGTERM" || bad "kill"
command -v ps >/dev/null && ps aux >/dev/null 2>&1 && ok "ps aux" || bad "ps"
nice -n 10 true 2>/dev/null && ok "nice" || bad "nice"

echo "--- [Modul 09] systemd ---"
command -v systemctl >/dev/null 2>&1 || { echo "  ⊘ SKIP systemd (container tanpa systemd aktif)"; S=$((S+1)); }
if command -v systemctl >/dev/null 2>&1; then
  systemctl list-units --type=service >/dev/null 2>&1 && ok "systemctl list-units" || skip "systemctl (no pid1)"
fi

echo "--- [Modul 10] SSH ---"
command -v sshd >/dev/null 2>&1 || (yum install -y openssh-server >/dev/null 2>&1; command -v sshd >/dev/null) && ok "sshd tersedia" || skip "sshd"
command -v ssh-keygen >/dev/null && ssh-keygen -t ed25519 -f /tmp/k -N "" >/dev/null 2>&1 && ok "ssh-keygen ed25519" || bad "ssh-keygen"
[ -f /tmp/k.pub ] && ok "public key terbuat" || bad "pubkey"

echo "--- [Modul 11] Networking (NetworkManager/nmcli) ---"
command -v nmcli >/dev/null 2>&1 && ok "nmcli ada" || skip "nmcli (container tanpa NM)"
ip -br addr >/dev/null 2>&1 && ok "ip addr" || bad "ip"
hostname | grep -q . && ok "hostname: $(hostname)" || bad "hostname"

echo "--- [Modul 12] DNF ---"
command -v dnf >/dev/null 2>&1 && ok "dnf ada" || bad "dnf"
dnf -y install tree >/dev/null 2>&1 && ok "dnf install tree" || skip "dnf install (no net/subscription)"
command -v tree >/dev/null 2>&1 && ok "tree terpasang" || skip "tree"
rpm -q tree >/dev/null 2>&1 && dnf -y remove tree >/dev/null 2>&1 && ok "dnf remove tree" || skip "dnf remove"

echo "--- [Modul 13] Filesystem & LVM ---"
command -v lvm >/dev/null 2>&1 && ok "lvm tools ada" || skip "lvm"
command -v mkfs.xfs >/dev/null 2>&1 && ok "mkfs.xfs ada" || skip "xfsprogs"
# LVM real butuh block device; cek tools saja (aman di container)
command -v vgcreate >/dev/null 2>&1 && ok "vgcreate ada" || skip "vgcreate"

echo "--- [Modul 14] Log (journald) ---"
command -v journalctl >/dev/null 2>&1 && ok "journalctl ada" || skip "journalctl"
[ -d /var/log ] && ok "/var/log ada" || bad "/var/log"

echo "--- [Modul 15] Podman ---"
command -v podman >/dev/null 2>&1 && ok "podman di dalam container ada" || skip "podman nested (jarang)"
command -v podman >/dev/null 2>&1 && podman --version >/dev/null 2>&1 && ok "podman --version" || skip "podman version"

echo "--- [Modul 16] SELinux ---"
if command -v getenforce >/dev/null 2>&1; then
  mode=$(getenforce 2>/dev/null)
  echo "  ⊘ INFO SELinux mode: $mode (di container sering Disabled/Permissive)"
  ok "getenforce jalan ($mode)"
else
  skip "SELinux tools tidak ada di image ini"
fi
command -v semanage >/dev/null 2>&1 && ok "semanage ada" || skip "semanage (paket policycoreutils belum terpasang)"

echo "--- [Modul 17] Penjadwalan ---"
command -v crontab >/dev/null 2>&1 && ok "crontab ada" || skip "cronie"
echo "*/5 * * * * date" | crontab - 2>/dev/null && ok "pasang crontab" || skip "crontab install"
crontab -l 2>/dev/null | grep -q date && ok "crontab terbaca" || skip "crontab read"
command -v at >/dev/null 2>&1 && ok "at ada" || skip "at"
command -v timedatectl >/dev/null 2>&1 && timedatectl >/dev/null 2>&1 && ok "timedatectl" || skip "timedatectl (no systemd-timedated)"

echo "--- [Modul 04] Help ---"
man --version >/dev/null 2>&1 && ok "man ada" || bad "man"
whatis ls >/dev/null 2>&1 && ok "whatis ls" || skip "whatis (mandb belum)"
apropos network >/dev/null 2>&1 && ok "apropos" || skip "apropos"

echo ""
echo "=== RINGKASAN DI DALAM CONTAINER ==="
echo "PASS=$P FAIL=$F SKIP=$S"
# keluar dengan kode sesuai (skip tidak dihitung gagal)
[ "$F" -eq 0 ] && exit 0 || exit 1
CONTAINER
RC=$?
echo -e "${B}=== Selesai (container exit: $RC) ===${N}"
echo -e "Lihat ringkasan PASS/FAIL/SKIP di atas. SKIP wajar di container (systemd/SELinux/LVM butuh VM nyata)."
exit 0
