# RHCSA Mock Exam Level 2: The Logic Puzzle (Solutions)

This document contains the exact commands, logical explanations, and verification steps for the Level 2 Mock Exam. 

---

### Task 1: The Non-Standard User
**The Goal:** Create a service account with a specific GID, custom home directory, and no shell access.

**The Solution:**
```bash
# 1. Create the group with the specific GID (-g)
sudo groupadd -g 3050 legacy_app

# 2. Create the user with strict parameters
sudo useradd -g legacy_app -d /opt/app_runner -s /sbin/nologin app_runner
Logic Breakdown: * -g legacy_app: Assigns the primary group (capital -G would make it a secondary group).

-d /opt/app_runner: Overrides the default /home/username path.

-s /sbin/nologin: Ensures if the application is compromised, the attacker doesn't get a bash shell.

Verification:

Bash

id app_runner  # Check UID/GID
grep app_runner /etc/passwd  # Verify home dir and shell
Task 2: The "Safe" Collaboration Directory
The Goal: Create a shared directory where files inherit the group owner, but users cannot delete each other's files.

The Solution:

Bash

sudo mkdir -p /mnt/dev_share
sudo chgrp legacy_app /mnt/dev_share

# Apply standard rwx (7), SGID (2), and Sticky Bit (1)
sudo chmod 3770 /mnt/dev_share
Logic Breakdown: * 3 is the sum of SGID (2) and Sticky Bit (1).

SGID (Set Group ID): Ensures all new files created inside belong to legacy_app.

Sticky Bit: Prevents users from deleting or renaming files unless they are the specific owner of that file.

Verification:

Bash

ls -ld /mnt/dev_share
# Expected output: drwxrws--T (The 's' is SGID, the 'T' is the Sticky Bit)
Task 3: The Surgical Search
The Goal: Find .conf files under /etc smaller than 10KB and copy them to a backup folder using a single pipeline.

The Solution:

Bash

sudo mkdir /root/conf_backups
sudo find /etc -type f -name "*.conf" -size -10k -exec cp {} /root/conf_backups/ \;
Logic Breakdown:

-type f: Look only for files (ignore directories).

-name "*.conf": Match the extension (quotes are required so the shell doesn't try to expand it early).

-size -10k: The minus sign means "less than". k is kilobytes.

-exec cp {} ... \;: For every file found (represented by {}), execute the copy command. The \; terminates the exec loop.

Verification:

Bash

ls -lh /root/conf_backups
Task 4: The Precision Sudo
The Goal: Allow a user to run exactly one root command without a password using a drop-in file.

The Solution:

Bash

# Open the drop-in file securely
sudo visudo -f /etc/sudoers.d/app_runner
Add this exact line to the file:

Plaintext

app_runner ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart firewalld
Logic Breakdown: Absolute paths (/usr/bin/systemctl) must be used in sudoers files for security, preventing PATH-hijacking attacks.

Verification:

Bash

sudo -l -U app_runner
Task 5: The Silent Cron Job
The Goal: Schedule a task every 5 minutes, append the output, and discard any errors.

The Solution:

Bash

sudo crontab -e
Add this exact line to the file:

Plaintext

*/5 * * * * /usr/bin/uptime >> /var/log/system_heartbeat.log 2> /dev/null
Logic Breakdown:

*/5: Step value syntax meaning "every 5th minute".

>>: Appends standard output (stdout) to the log file.

2> /dev/null: Takes standard error (File Descriptor 2) and throws it into the Linux "black hole" so it doesn't generate local system mail.

Verification:

Bash

sudo crontab -l
Task 6: The Ghost Link
The Goal: Create a symbolic link because hard links cannot cross different partitions (like /tmp and /etc).

The Solution:

Bash

sudo mkdir -p /etc/app
echo "version: 1.0" | sudo tee /etc/app/config.yaml

# Format: ln -s [TARGET] [LINK_NAME]
sudo ln -s /etc/app/config.yaml /tmp/database_config.yaml
Logic Breakdown: If you omit the -s, you create a Hard Link. Hard links share the exact same inode on the disk. Because /tmp is often mounted as a separate tmpfs (RAM disk), a hard link would immediately fail with an "Invalid cross-device link" error.

Verification:

Bash

ls -l /tmp/database_config.yaml
# Expected output shows: /tmp/database_config.yaml -> /etc/app/config.yaml
Task 7: Time Travel
The Goal: Set the system to UTC and verify NTP synchronization.

The Solution:

Bash

sudo timedatectl set-timezone UTC
sudo systemctl status chronyd
Logic Breakdown: timedatectl is the modern systemd utility that replaces manually linking files in /etc/localtime. chronyd is the default NTP daemon in RHEL 9.

Verification:

Bash

timedatectl
# Check "Time zone: UTC" and "NTP service: active"
chronyc sources
# Shows the actual time servers you are connected to.

---

Save this to your repo! When you sit down to do the mock exam on your RHEL 9 VM, try to complete the tasks purely from memory and using `man` pages. Only check this solution file when you are completely stuck or when grading yourself at the end. 

Let me know when you've run through the lab!
