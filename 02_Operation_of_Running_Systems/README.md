# 02: Operation of Running Systems (RHEL 9)

This section focuses on managing a live RHEL 9 system, understanding the boot process, and controlling services. Persistence and service availability are the main goals here.

## 🎯 Exam Objectives (RHEL 9)
* **Boot, Reboot, and Shut Down:** Manage runlevels and targets safely.
* **Boot Process Intervention:** Interrupt the boot process to gain access (Root Password Reset).
* **Service Management:** Use `systemctl` to start, stop, enable, and mask services.
* **Process Management:** Identify, terminate, and change the priority of processes (`top`, `ps`, `kill`, `nice`).
* **Log Analysis:** Use `journalctl` to find specific events by time or priority.
* **Tuning:** Use `tuned` to optimize system performance for specific workloads.

---

## 🛠️ Key Command Reference

### 1. The Boot Intervention (Critical Task)
To reset a lost root password in RHEL 9:
1. Interrupt at the GRUB menu (press `e`).
2. Append `rd.break` to the line starting with `linux`.
3. Press `Ctrl+X` to boot.
4. `mount -o remount,rw /sysroot`
5. `chroot /sysroot`
6. `passwd root`
7. `touch /.autorelabel`
8. `exit` and `reboot`.

### 2. Systemd Targets & Services
| Task | Command |
| :--- | :--- |
| Change to CLI mode | `systemctl set-default multi-user.target` |
| Change to GUI mode | `systemctl set-default graphical.target` |
| Disable a service | `systemctl mask <service>` (Prevents starting even by dependencies) |
| List failed services | `systemctl --failed` |

### 3. Log Inspection (Journald)
* **View logs since last boot:** `journalctl -b`
* **Filter by priority (Errors only):** `journalctl -p err`
* **Real-time logs:** `journalctl -f`

---

## 🚀 Lab Exercises to Practice
1. **The Root Recovery:** Use your KVM lab to perform a full root password reset from the GRUB menu. **(High priority for exam)**.
2. **Process Priority:** Start a long-running process (like `dd` or `top`), change its niceness to `5`, and then kill it using its PID.
3. **The Masking Task:** Find a non-essential service (like `cups`), mask it, and try to start it manually to verify the mask works.

---

## 📝 Persistence Check
* Always verify that services you enable are actually running after a `reboot`.
* Ensure your default target is set correctly for the exam requirements (usually `multi-user.target`).
