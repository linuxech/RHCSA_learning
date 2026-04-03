# 06: Basic Networking (RHEL 9)

This section covers the configuration of network interfaces, hostname resolution, and basic traffic filtering using the system firewall.

## 🎯 Exam Objectives (RHEL 9)
* **IPv4 and IPv6 Configuration:** Manually configure addresses, gateways, and DNS.
* **Hostname Management:** Set and verify the persistent system hostname.
* **Network Services:** Ensure networking starts automatically at boot.
* **Firewall Management:** Use `firewall-cmd` to allow or restrict services and ports.
* **Name Resolution:** Configure `/etc/hosts` for local resolution.

---

## 🛠️ Key Command Reference

### 1. Networking with `nmcli`
| Task | Command |
| :--- | :--- |
| List Connections | `nmcli con show` |
| Set Static IP | `nmcli con mod "eth0" ipv4.addresses 192.168.1.10/24 ipv4.gateway 192.168.1.1 ipv4.method manual` |
| Set DNS | `nmcli con mod "eth0" ipv4.dns "8.8.8.8 8.8.4.4"` |
| Apply Changes | `nmcli con down "eth0" && nmcli con up "eth0"` |

### 2. Hostname Configuration
* **Set Hostname:** `hostnamectl set-hostname server1.example.com`
* **Check Status:** `hostnamectl status`

### 3. Firewall (Firewalld)
* **List All Rules:** `firewall-cmd --list-all`
* **Allow a Service:** `firewall-cmd --permanent --add-service=http`
* **Allow a Port:** `firewall-cmd --permanent --add-port=8080/tcp`
* **Reload (Required):** `firewall-cmd --reload`

---

## 🚀 Lab Exercises to Practice
1. **The Static Challenge:** Change your VM from DHCP to a static IP address using only `nmcli`. Verify you can still ping your gateway.
2. **The Name Resolver:** Add an entry to `/etc/hosts` so that the name `lab-server` points to your own IP address. Test it with `ping lab-server`.
3. **The Firewall Shield:** Enable the firewall, allow `ssh` and `http`, but block all other incoming traffic. Verify using `firewall-cmd --list-all`.

---

## 📝 The "Double-Check" List
* **Persistence:** Use `nmcli con show` to ensure `autoconnect` is set to `yes`.
* **Testing:** Always use `ip addr` and `ip route` to verify your manual settings took effect.
* **Firewall:** Remember that without `--permanent`, your firewall rules will disappear after a reboot!
