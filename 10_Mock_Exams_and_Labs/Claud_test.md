RHCSA v9 (EX200) Practical Exam Overview
Sample Practical Questions Red Hat Creates
Here are the types of questions you'll encounter (not the exact ones, but representative scenarios):
Task 1: Storage & LVM Management
You are tasked to add 500GB of storage to a production system. Create a new 
partition, add it to a volume group called "data_vg", create a logical volume 
of 400GB called "data_lv", and format it with XFS. Mount it persistently at 
/data with proper permissions (root:root 755). All changes must persist after reboot.
Task 2: Network Configuration
Configure the system with:
- Hostname: prod-server01.example.com
- Static IP: 192.168.1.50/24
- Gateway: 192.168.1.1
- DNS: 8.8.8.8, 1.1.1.1
- Ensure connectivity and persistence
Task 3: User & Access Control
Create users: alice, bob, charlie
Create group: developers
- alice & bob are in developers group with sudo access to specific commands
- charlie is a system user (/sbin/nologin)
- Implement SELinux context for /opt/app directory
Task 4: SELinux & Security
A web application in /var/www/html/app is generating SELinux denial errors. 
Diagnose the issue using auditd logs, identify the incorrect context, and 
restore proper contexts without disabling SELinux.
Task 5: Systemd & Service Management
Create a custom systemd service that:
- Starts a custom application at boot
- Restarts on failure
- Creates a systemd timer to restart the service every Sunday at 2 AM
- Ensure proper logging and status checks
Task 6: Troubleshooting (Time-critical)
System won't boot. Access it via recovery mode, identify the issue 
(corrupted /etc/fstab, missing mount points, broken symlinks), and fix it 
without losing data.
