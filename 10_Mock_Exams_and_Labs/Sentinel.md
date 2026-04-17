🚨 Pre-Flight Setup
Environment: RHEL 10 VM.

Hardware: Attach TWO unformatted virtual disks (e.g., /dev/vdb at 5GB, /dev/vdc at 5GB).

Time Limit: 120 Minutes.

The Golden Rule: You must reboot at the end.

📝 RHCSA RHEL 10 Mock Exam: Operation Sentinel
Task 1: Network & Identity Foundation
Set the system hostname to sentinel.rhcsa.local.

Create a group named automation.

Create a user named deploy_bot.

Requirement: deploy_bot must have automation as its primary group, must not have an interactive shell, and its password must expire exactly 60 days from today.

🧠 RHCSA Standard Approach: > * Networking: Never manually edit configuration files in /etc/NetworkManager. Always use hostnamectl and nmcli.

Users: When creating service accounts, combine your flags (-g for primary group, -s /sbin/nologin for shell) into a single useradd command to avoid mistakes. Use chage to manage expiration, and verify with chage -l.

Task 2: The Collaboration Zone (Permissions Drill)
Create a directory at /var/opt/scripts.

Requirement: Using octal (numeric) notation only, configure the directory so that:

The automation group owns it.

The Owner and Group have full rwx access.

Others have zero access.

All new files created inside automatically belong to the automation group.

🧠 RHCSA Standard Approach:

The grading script checks absolute paths. Never use ./ relative paths.

Always verify your octal math: chmod [Special][Owner][Group][Others]. Remember that 2 in the special slot applies the SGID bit. Verify with ls -ld.

Task 3: The Expansion (Storage Engineering)
Create a Volume Group named vg_app on your first 5GB disk.

Create a Logical Volume named lv_data that is exactly 2GB in size.

Format it with XFS and mount it persistently to /mnt/app_data.

The Twist: Your manager immediately realizes 2GB isn't enough. Expand lv_data to 3GB total, and ensure the mounted filesystem recognizes the new space.

🧠 RHCSA Standard Approach:

Persistence: Always use UUIDs in /etc/fstab, never /dev/sdX names, as hardware enumeration can change on reboot. Use mount -a to test fstab—if mount -a throws an error, do not reboot, or your system will crash.

Expansion: The most efficient Red Hat way to expand an LV and the filesystem simultaneously is using lvextend with the lowercase -l or uppercase -L flag, combined with the -r (resizefs) flag.

Task 4: The Surgical Extraction (Find & Exec)
Requirement: Search the entire /etc directory for files that end in .conf and are smaller than 5KB.

Using a single find pipeline with -exec, copy those files to /root/conf_tiny/.

🧠 RHCSA Standard Approach:

Create the destination directory before running the find command.

Build the find command iteratively. First, run it without -exec just to see if it lists the correct files. Once you confirm the output is correct, press the UP arrow and append -exec cp {} /root/conf_tiny/ \;.

Task 5: The Precise Delegation (Visudo)
The user deploy_bot needs to reload the firewall.

Requirement: Configure the system so deploy_bot can run firewall-cmd --reload with root privileges without being prompted for a password. You must use a drop-in file.

🧠 RHCSA Standard Approach:

Never edit the main /etc/sudoers file. Always use /etc/sudoers.d/.

Never use an external editor like nano directly on the file. Always invoke visudo -f /etc/sudoers.d/deploy_bot.

Always use absolute paths for the command in the sudoers rule. Run which firewall-cmd to find the exact path before writing the rule.

Task 6: The Fragile Link (Symlink Drill)
A legacy monitoring tool expects to read the OS version from /var/tmp/os_version.txt.

The real OS version file is located at /etc/os-release.

Requirement: Create a link at /var/tmp/os_version.txt pointing to the real file. It must survive even if /var/tmp is mounted on a different partition.

🧠 RHCSA Standard Approach:

If it crosses partitions, it must be a soft link (-s).

Read the command left to right: ln -s [THE_REAL_EXISTING_FILE] [THE_NEW_FAKE_LINK].

Task 7: RHEL 10 Modern Containers (Quadlets)
Log in as a regular user (create a user named container_admin).

Pull the httpd:latest image.

Requirement: Using RHEL 10 Quadlets, run a rootless container named web_front. Map host port 8080 to container port 80. Ensure it starts as a systemd service and survives reboots without the user logging in.

🧠 RHCSA Standard Approach:

In RHEL 10, the old podman generate systemd is dead. You must create the ~/.config/containers/systemd/ directory and write a .container file.

The name of your .container file becomes the name of the systemd service.

Always run systemctl --user daemon-reload after writing the file.

To survive reboots, you must log back out to root and run loginctl enable-linger container_admin.

🛑 Evaluation Protocol
Set your timer for 120 minutes. Keep the "RHCSA Standard Approach" blocks in mind as you type.

When you finish, type reboot.
