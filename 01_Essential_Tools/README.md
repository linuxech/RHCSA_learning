# 01: Essential Tools (RHCSA Foundation)

This section covers the fundamental command-line tools required to navigate, manage, and troubleshoot a Red Hat Enterprise Linux system. Proficiency here is mandatory for speed and accuracy during the EX200 exam.

## 🎯 Exam Objectives Covered
* **Shell Access & Command Syntax:** Log in, switch users, and use correct syntax.
* **I/O Redirection:** Use `>`, `>>`, `|`, `2>`, and `&>` to manage data flow.
* **Text Analysis:** Use `grep` and Regular Expressions (regex) to filter logs and files.
* **Remote Access:** Securely access systems using `ssh` and key-based auth.
* **Archiving & Compression:** Use `tar` with `gzip` (z) and `bzip2` (j).
* **File Management:** `mkdir`, `cp`, `mv`, `rm`, and creating hard/soft links.
* **Permissions:** Standard `ugo/rwx` permissions and `umask`.
* **System Documentation:** Efficiently using `man`, `info`, and `/usr/share/doc`.

---

## 🛠️ Key Command Reference

### 1. File Management & Links
| Task | Command |
| :--- | :--- |
| Create Soft Link | `ln -s /path/to/original linkname` |
| Create Hard Link | `ln /path/to/original linkname` |
| Recursive Copy | `cp -rp /source /destination` (p preserves permissions) |

### 2. Search & Filter (Grep/Regex)
* **Search for a string (case insensitive):** `grep -i "error" /var/log/messages`
* **Search for lines starting with "root":** `grep "^root" /etc/passwd`
* **Search for lines ending with "nologin":** `grep "nologin$" /etc/passwd`

### 3. Archive & Compress
* **Create Gzip Archive:** `tar -cvzf archive.tar.gz /path/to/dir`
* **Extract Bzip2 Archive:** `tar -xvjf archive.tar.bz2 -C /target/dir`

### 4. Permissions (The Basics)
* **Change Ownership:** `chown user:group filename`
* **Numeric Permissions:** `chmod 755 filename` (rwxr-xr-x)
* **Symbolic Permissions:** `chmod g+w,o-r filename`

---

## 🚀 Lab Exercises to Practice
1. **The Link Test:** Create a file, create both a hard and soft link to it, delete the original file, and see which link still works.
2. **The Grep Challenge:** Find all files in `/etc` that contain the word "network" and save the list to `~/network_files.txt`.
3. **The Archive Drill:** Archive the `/etc/ssh` directory into your home folder using `tar` and verify the contents without extracting.

---

## 📝 RHEL 10 Bridge Notes
* **Flatpak:** In RHEL 10, this folder will also include `flatpak install` and repository management commands. 
* **Documentation:** RHEL 10 places higher emphasis on finding info within the terminal since internet access is prohibited during the exam.
