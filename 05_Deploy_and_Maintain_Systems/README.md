# 05: Deploy, Configure, and Maintain Systems (RHEL 9)

This section focuses on lifecycle management: scheduling tasks, managing software packages, and ensuring core system services like time synchronization are functional.

## 🎯 Exam Objectives (RHEL 9)
* **Task Scheduling:** Use `at` for one-time tasks and `cron` for recurring tasks.
* **Package Management:** Install, update, and remove software using `dnf`.
* **Repository Configuration:** Create and configure local or remote `.repo` files.
* **Time Synchronization:** Configure the system as a client for NTP using `chronyd`.
* **Bootloader Management:** Basic modifications to the GRUB bootloader.
* **System Targets:** Set and switch between different boot targets (Multi-user vs Graphical).

---

## 🛠️ Key Command Reference

### 1. Scheduling with Cron
* **Edit user crontab:** `crontab -e`
* **Format:** `MIN HOUR DOM MON DOW COMMAND`
* **Example (Daily at 2 AM):** `0 2 * * * /usr/local/bin/backup.sh`
* **List jobs:** `crontab -l`

### 2. Software & Repositories
* **Install a package:** `dnf install <package_name> -y`
* **Create a local repo:**
  1. Create file: `/etc/yum.repos.d/local.repo`
  2. Content:
     ```ini
     [Local-BaseOS]
     name=Local BaseOS
     baseurl=file:///mnt/BaseOS
     enabled=1
     gpgcheck=0
     ```
* **Clean cache:** `dnf clean all && dnf makecache`

### 3. Time Sync (Chrony)
* **Check status:** `chronyc sources -v`
* **Config file:** `/etc/chrony.conf` (Add `server <ip> iburst`)
* **Set timezone:** `timedatectl set-timezone Asia/Kolkata`

### 4. Boot Targets
* **Get default:** `systemctl get-default`
* **Set to CLI:** `systemctl set-default multi-user.target`

---

## 🚀 Lab Exercises to Practice
1. **The Automation Master:** Schedule a `cron` job that appends the current date and time to a file in your home directory every minute.
2. **The Local Repo:** Mount the RHEL 9 ISO to `/mnt`, then create a `.repo` file that points to it. Try to install `httpd` using your new local repo.
3. **The Time Traveler:** Change your system's timezone to `UTC` using `timedatectl`, then verify that `chronyd` is successfully syncing with a public NTP pool.

---

## 📝 Persistence Note
Software updates and repository configurations must persist. If you mount an ISO for a local repo, remember that it needs an entry in `/etc/fstab` (Type: `iso9660`) so it stays mounted after a reboot!
