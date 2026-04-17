Welcome to Operation: Breakfix & Build.

This is an Open Book, Methodology-First exam. I do not just want the commands; I want your Standard Operating Procedure (SOP).

🚨 Rules of Engagement
Open Book: Use Google, man pages, Stack Overflow, whatever you want.

The Deliverable: For each task, I want you to write out your Order of Operations.

Step 1: What is the very first thing you check?

Step 2: How do you implement the fix/build?

Step 3: How do you verify it is bulletproof before you log off?

The Environment: Assume a standard RHEL 10 VM.

📝 RHCSA Methodology Exam: Operation Breakfix & Build
🛑 Scenario 1: The Inherited Disaster (Boot Failure)
You just inherited a server named db-node-01. The previous admin was trying to mount an old NFS share and made a typo in /etc/fstab. They rebooted the server, and now it is stuck in a boot loop/hanging indefinitely. Production is down.

The Goal: Get the server back online and fix the bad entry so it boots normally.

Your Task: Explain your exact methodology for breaking into a broken system, finding the problem, fixing it safely, and rebooting.

🏗️ Scenario 2: The Storage Migration (Architecture)
The server app-node-02 currently has its /var/log directory living on the root partition. The logs are growing massively, and the root partition is at 99% capacity. You have attached a brand new, unformatted 50GB virtual disk (/dev/vdb).

The Goal: You need to migrate /var/log to live on a dedicated Logical Volume on the new 50GB disk, without losing any of the existing log files.

Your Task: Explain your architectural approach. How do you prepare the disk, safely move live data, ensure the system knows where to look on the next boot, and avoid SELinux blocks on the new logs?

🔐 Scenario 3: The Restricted Daemon (SELinux & ACLs)
A developer created a custom script that runs as a systemd service under the user account data_bot. The script needs to read configuration files located in /custom/app_config/. However, every time the service starts, it fails with a "Permission Denied" error in the logs.
The developer insists standard permissions are set to 777 (which makes you cringe, but it proves standard permissions aren't the blocker).

The Goal: Securely allow data_bot to read the files, fix the 777 atrocity, and satisfy SELinux.

Your Task: Explain your troubleshooting flow. What logs do you check to prove it's SELinux? How do you lock down the standard permissions safely, and what is your approach to fixing the SELinux context permanently?

🐳 Scenario 4: The Ephemeral Upgrade (Containers)
The company wants to run a lightweight wiki (mediawiki:latest) via a container on wiki-host-01. They do not want to use a dedicated VM for it.

The Goal: Run the container rootlessly as the user wiki_admin. The wiki data must be stored persistently on the host at /opt/wiki_data. The container must survive a host reboot.

Your Task: Outline your deployment strategy using RHEL 10 native tools. What are the major "gotchas" you need to watch out for when mapping host directories to rootless containers? How do you ensure the service persists?
