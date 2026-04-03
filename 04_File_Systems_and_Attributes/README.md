# 04: File Systems and Attributes (RHEL 9)

This section focuses on advanced file system management, network storage (NFS), and collaborative permissions like SGID and ACLs.

## 🎯 Exam Objectives (RHEL 9)
* **NFS Mounts:** Manually mount and unmount network file systems.
* **Autofs:** Configure on-demand mounting for network shares (Direct and Indirect maps).
* **Collaborative Directories:** Create directories with the `set-GID` bit so all new files inherit the group owner.
* **Access Control Lists (ACLs):** Grant specific permissions to users/groups that don't fit standard `ugo/rwx`.
* **File Attributes:** Diagnose and correct permission problems.

---

## 🛠️ Key Command Reference

### 1. Network File System (NFS)
To mount an NFS share manually:
`mount -t nfs server.example.com:/share /mnt/nfs_data`

To make it persistent in `/etc/fstab`:
`server.example.com:/share  /mnt/nfs_data  nfs  defaults  0 0`

### 2. Autofs (The "Automounter")
1. **Install:** `dnf install autofs nfs-utils -y`
2. **Master Map (`/etc/auto.master.d/custom.autofs`):**
   `/-  /etc/auto.direct` (for direct maps)
   `/mnt/indirect  /etc/auto.indirect` (for indirect maps)
3. **Map File (`/etc/auto.direct`):**
   `/mnt/data -rw,sync server:/export/data`
4. **Restart:** `systemctl enable --now autofs`

### 3. Collaboration & SGID
To ensure all files created in `/common/sales` belong to the `sales` group:
1. `chgrp sales /common/sales`
2. `chmod g+s /common/sales`  # This sets the SGID bit

### 4. Access Control Lists (ACL)
* **Set ACL:** `setfacl -m u:ashish:rwx /project/top_secret`
* **View ACL:** `getfacl /project/top_secret`
* **Remove ACL:** `setfacl -b /project/top_secret`

---

## 🚀 Lab Exercises to Practice
1. **The Collaboration Hub:** Create a directory `/opt/dev`, create a group `developers`, and ensure any file created in that directory is automatically owned by the `developers` group.
2. **The Specific Access:** Create a file owned by `root`. Give a normal user `read` access using ONLY ACLs, without changing standard permissions or ownership.
3. **The Autofs Master:** Configure an indirect map so that accessing `/shares/work` automatically mounts a (simulated) NFS export from your local machine or a second VM.

---

## 📝 Troubleshooting Tip
If an NFS mount fails, always check your firewall first:
`firewall-cmd --add-service=nfs --permanent && firewall-cmd --reload`
Also, ensure the `rpcbind` and `nfs-server` services are healthy on the server side.
