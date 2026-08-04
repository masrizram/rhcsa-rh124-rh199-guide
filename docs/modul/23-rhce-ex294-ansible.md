# Modul 23 — RHCE / EX294 Prep: Ansible Automation (Skala Besar)

> Setelah menguasai RHCSA (single-node) & Modul 21/22 (enterprise & firefighting),
> langkah naik level adalah **RHCE (EX294)** — otomasi dengan **Ansible**.
> Di perbankan, server dikelola ratusan sekaligus; Ansible adalah alat utamanya
> (Red Hat Ansible Automation Platform / AAP). Modul ini adalah *prep padat*.

> 📺 Referensi: dokumentasi resmi Ansible + RH294 (Red Hat Enterprise Linux
> Automation). Modul ini menyelaraskan dengan praktik enterprise.

## 1. Mengapa Ansible? (Idempotensi)

- **Agentless**: cukup SSH, tidak perlu daemon di target.
- **Idempoten**: menjalankan berkali-kali = hasil sama (aman diulang).
- **Declarative**: "keadaan akhir" (state), bukan urutan perintah.

```bash
# Cek koneksi ke semua host (ad-hoc)
ansible all -i inventory.ini -m ping
# Jalankan perintah remote
ansible web -i inventory.ini -m command -a 'uptime'
```

## 2. Inventory & Variables

```ini
# inventory.ini
[web]
web1.panin.local ansible_host=10.0.0.11
web2.panin.local ansible_host=10.0.0.12

[db]
db1.panin.local

[prod:children]
web
db
```
```yaml
# group_vars/prod.yml
ntp_server: 10.0.0.5
selinux_mode: enforcing
```
```bash
ansible prod -i inventory.ini -m setup        # fakta (facts) tiap host
ansible prod -i inventory.ini -m debug -a 'var=ansible_distribution'
```

## 3. Playbook Dasar (LVM, User/SSSD, Firewalld, Patching)

```yaml
# harden.yml
- name: Baseline production servers
  hosts: prod
  become: true
  vars:
    selinux_mode: enforcing
  tasks:
    - name: pastikan firewalld jalan
      ansible.posix.firewalld:
        service: http
        permanent: true
        state: enabled
        immediate: true

    - name: buka port 8080
      ansible.posix.firewalld:
        port: 8080/tcp
        permanent: true
        state: enabled

    - name: SELinux enforcing
      ansible.posix.selinux:
        policy: targeted
        state: "{{ selinux_mode }}"

    - name: pasang httpd
      ansible.builtin.dnf:
        name: httpd
        state: present

    - name: enable & start httpd
      ansible.builtin.service:
        name: httpd
        enabled: true
        state: started
```
```bash
ansible-playbook -i inventory.ini harden.yml
# dry-run (cek tanpa ubah):
ansible-playbook -i inventory.ini harden.yml --check --diff
```

## 4. Automation LVM (idempoten)

```yaml
- name: ensure LV exists & mounted
  hosts: db
  become: true
  tasks:
    - name: buat LV data
      community.general.lvol:
        vg: vg0
        lv: data
        size: 10g
    - name: format XFS (hanya jika belum)
      community.general.filesystem:
        fstype: xfs
        dev: /dev/vg0/data
    - name: mount
      ansible.posix.mount:
        path: /data
        src: /dev/vg0/data
        fstype: xfs
        state: mounted
        fstab: /etc/fstab
```

## 5. Integrasi ke Change Request (CR) Perbankan

Di enterprise, Ansible **bukan** "jalankan sembarang". Alur:
1. Tulis playbook di repo version-control (Git).
2. Review & approval lewat **Merge Request / CR**.
3. Jalankan di **maintenance window** (Ansible Tower/AAP scheduled job).
4. Verifikasi via `assert` task + monitoring, lalu tutup ticket.

```yaml
# task verifikasi (gate)
- name: pastikan httpd listen
  ansible.builtin.command: ss -tulnp | grep ':80'
  register: r
  changed_when: false
  failed_when: r.rc != 0
```

## 6. Vault (Rahasia Aman)

```bash
ansible-vault create secrets.yml          # buat file terenkripsi
ansible-vault edit secrets.yml            # edit
ansible-playbook -i inv site.yml --ask-vault-pass
```
> Jangan commit password mentah ke Git. Pakai `ansible-vault` atau
> credential store AAP.

## 7. Koneksi ke EX294 (RHCE)

!!! success "EX294"
    Soal RHCE: *"Gunakan Ansible untuk mengonfigurasi N host agar memenuhi
    spesifikasi (user, package, service, firewall, SELinux, storage, cron)."*
    Kunci: playbook idempoten + `ansible-navigator`/`ansible-playbook`,
    inventory terstruktur, dan verifikasi via `assert`.

## 8. Jebakan Umum (Ansible)

!!! danger "Jebakan"
    - `command` vs `shell` — `command` tidak punya pipe/`$`; pakai `shell`
      bila perlu, atau modul spesifik (lebih idempoten).
    - Lupa `become: true` → task gagal (butuh root).
    - Hardcode IP di playbook → gunakan inventory + group_vars.
    - Jalankan tanpa `--check` di production → efek tak terduga.
    - Commit secret ke Git → pakai `ansible-vault`.
    - Menghapus (state: absent) tanpa guard → data hilang.

## 9. Self-Check: Siap EX294?

- [ ] Paham inventory (static/ini) & group_vars.
- [ ] Bisa tulis playbook idempoten (service, package, firewall, SELinux).
- [ ] Tahu beda `command`/`shell`/modul spesifik.
- [ ] Pakai `--check --diff` sebelum production.
- [ ] Kelola rahasia via `ansible-vault`.
- [ ] Verifikasi hasil via `assert` / monitoring.

## Latihan
1. Buat `inventory.ini` (2 VM lab), jalankan `ansible all -m ping`.
2. Tulis playbook yang menginstal `httpd`, buka port 80, enable SELinux.
3. Jalankan `--check` lalu real; bandingkan output.
4. Tambah task `assert` bahwa `httpd` listen di :80.
5. Enkripsi variabel via `ansible-vault`, jalankan dengan `--ask-vault-pass`.
