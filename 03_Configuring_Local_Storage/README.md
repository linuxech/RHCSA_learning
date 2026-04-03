# 03: Configuring Local Storage (RHEL 9)

This directory covers the management of physical and logical storage. In RHEL 9, speed and precision with LVM are critical for passing the EX200.

## 🎯 Exam Objectives (RHEL 9)
* **Partitioning:** Create and manage MBR and GPT partitions using `fdisk` or `gdisk`.
* **LVM (Logical Volume Management):** Create Physical Volumes (PV), Volume Groups (VG), and Logical Volumes (LV).
* **LVM Resizing:** Extend an existing LV and its filesystem without data loss.
* **Swap Space:** Create, enable, and persistently mount swap partitions or files.
* **VDO & Stratis:** Understand and configure advanced storage solutions (Note: Focus on LVM-based VDO in RHEL 9).

---

## 🛠️ Key Command Reference

### 1. The LVM Workflow (Standard)
| Step | Command | Description |
| :--- | :--- | :--- |
| 1 | `pvcreate /dev/sdb1` | Initialize partition as a Physical Volume |
| 2 | `vgcreate vg_data /dev/sdb1` | Create a Volume Group named `vg_data` |
| 3 | `lvcreate -n lv_docs -L 500M vg_data` | Create a 500MB Logical Volume |
| 4 | `mkfs.xfs /dev/vg_data/lv_docs` | Format with XFS filesystem |
| 5 | `mkdir /mnt/docs` | Create a mount point |

### 2. Extending Storage (Online)
To extend an LV and resize the XFS filesystem simultaneously:
`lvextend -r -L +200M /dev/vg_data/lv_docs`
*(The `-r` flag is your best friend—it resizes the filesystem for you!)*

### 3. Swap Configuration
1. Create partition/file.
2. `mkswap /dev/sdb2`
3. `swapon /dev/sdb2`
4. Add to `/etc/fstab`: `/dev/sdb2 swap swap defaults 0 0`

---

## 🚀 Lab Exercises to Practice
1. **The Growth Drill:** Create a 200MB LV, mount it, add a file, then extend it to 500MB while it's mounted. Verify the file is still there.
2. **Swap on Demand:** Add a new 1GB swap partition to your system and ensure it is active after a reboot.
3. **VG Extension:** Add a second physical disk to your KVM VM, turn it into a PV, and add it to an existing Volume Group to increase the "free pool."

---

## ⚠️ The "Persistence" Warning
If you create a partition or LV but forget to add it to `/etc/fstab`, the system may boot, but you will lose points. **Always test your mounts with `mount -a` before rebooting.**
