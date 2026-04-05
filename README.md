# 🐧 RHCSA (EX200) Preparation & Lab Environments

**Infrastructure Specialist | Minimalist Hardware | Maximal Automation** *Currently architecting headless lab environments and mastering RHEL 9, with a transitional roadmap to RHEL 10.*

This repository serves as a structured syllabus, script archive, and documentation hub for my Red Hat Certified System Administrator (RHCSA) journey. It is strictly organized by the official Red Hat EX200 exam objectives.

## 🛠️ Lab Architecture
To practice real-world system recovery and virtualization management, my lab environment is built entirely on-premise:
* **Hypervisor:** KVM (Kernel-based Virtual Machine)
* **Host OS:** Ubuntu 
* **Guest VMs:** Red Hat Enterprise Linux 9 (RHEL 9)
* **Design Philosophy:** Headless, terminal-driven management to maximize hardware efficiency.

## 🗂️ Repository Structure (RHEL 9 Objectives)
The directories below map directly to the skills required for the EX200 exam. Each folder contains specific `README.md` files, bash scripts, and configuration notes.

1.  **[01_Essential_Tools](./01_Essential_Tools):** I/O Redirection, Tar, Grep, SSH, Links.
2.  **[02_Operation_of_Running_Systems](./02_Operation_of_Running_Systems):** Boot intervention (`rd.break`), systemd targets, tuning.
3.  **[03_Configuring_Local_Storage](./03_Configuring_Local_Storage):** LVM (PV, VG, LV), resizing filesystems, Swap.
4.  **[04_File_Systems_and_Attributes](./04_File_Systems_and_Attributes):** NFS, Autofs, SGID, ACLs.
5.  **[05_Deploy_and_Maintain_Systems](./05_Deploy_and_Maintain_Systems):** Cron, DNF local repositories, Chrony, Kickstart.
6.  **[06_Basic_Networking](./06_Basic_Networking):** `nmcli`, static IPs, `firewall-cmd`.
7.  **[07_Manage_Users_and_Groups](./07_Manage_Users_and_Groups):** Password aging (`chage`), `visudo`, user groups.
8.  **[08_Security_and_SELinux](./08_Security_and_SELinux):** Contexts, Booleans, Port labeling, Troubleshooting.
9.  **[09_Container_Management](./09_Container_Management):** Rootless Podman, systemd service integration.
10. **[10_Mock_Exams_and_Labs](./10_Mock_Exams_and_Labs):** Comprehensive, multi-objective practice scenarios.
* **[Cheatsheet_Docs](./Cheatsheet_Docs):** Quick-reference guides and exam overviews.

## 🚀 The RHEL 10 Transition Plan
While this repository currently focuses on RHEL 9 maturity, a transition to RHEL 10 is planned. Future updates will introduce:
* Managing desktop applications via **Flatpaks**.
* Leveraging the **Lightspeed** AI terminal assistant.
* Adapting to Kernel 6.12 nuances and the removal of core Podman objectives from the base EX200 exam.

---
*"If it doesn't survive a reboot, it didn't happen."*
