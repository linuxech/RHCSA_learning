# 08: Security and SELinux (RHEL 9)

This section focuses on system hardening using the Firewall and Security-Enhanced Linux (SELinux). Success here requires a "Verify Always" mindset.

## 🎯 Exam Objectives (RHEL 9)
* **Firewall Configuration:** Manage zones, services, and ports using `firewall-cmd`.
* **SELinux Modes:** Switch between `Enforcing`, `Permissive`, and `Disabled`.
* **File Contexts:** List, set, and restore SELinux labels on files and directories.
* **SELinux Booleans:** Modify system behavior (e.g., allowing web servers to connect to databases).
* **Port Labeling:** Assign correct SELinux types to non-standard service ports.
* **Troubleshooting:** Diagnose denials using `ausearch` and `sealert`.

---

## 🛠️ Key Command Reference

### 1. SELinux Essentials
| Task | Command |
| :--- | :--- |
| Check Mode | `getenforce` |
| Set Temporary Mode | `setenforce 1` (Enforcing) or `0` (Permissive) |
| Persistent Mode | Edit `/etc/selinux/config` |
| View Context | `ls -Z /path/to/file` |

### 2. Fixing Contexts
* **Change type manually:** `chcon -t httpd_sys_content_t /var/www/html/index.html`
* **Define permanent policy:** `semanage fcontext -a -t httpd_sys_content_t "/custom(/.*)?"`
* **Apply permanent policy:** `restorecon -Rv /custom`

### 3. SELinux Booleans & Ports
* **List all booleans:** `getsebool -a | grep httpd`
* **Set boolean (Persistent):** `setsebool -P httpd_can_network_connect_db on`
* **Add non-standard port:** `semanage port -a -t httpd_port_t -p tcp 8081`

### 4. Advanced Firewall (Review)
* **Add rich rule:** `firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" accept'`
* **Reload changes:** `firewall-cmd --reload`

---

## 🚀 Lab Exercises to Practice
1. **The Web Server Fix:** Move a file from `/tmp` to `/var/www/html`. Observe how the context stays as `user_tmp_t`. Fix it using `restorecon` so Apache can read it.
2. **The Non-Standard Port:** Configure SSH to listen on port `2022`. Use `semanage port` to allow this through SELinux, then update the firewall to permit it.
3. **The Boolean Toggle:** Install a service that needs network access (like a proxy). Identify the correct boolean using `getsebool` and enable it persistently.

---

## 📝 Troubleshooting Checklist
1. **Status Check:** Is it in `Enforcing` mode?
2. **Logs:** Check `/var/log/audit/audit.log` or run `ausearch -m avc -ts recent`.
3. **Context:** Does the file type (`_t`) match the service trying to access it?
