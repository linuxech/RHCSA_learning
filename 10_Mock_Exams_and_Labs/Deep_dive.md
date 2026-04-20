These tasks are intentionally obscure, highly specific, and represent the absolute edge cases of the RHCSA RHEL 10 objectives. You are expected to use man pages, --help, or /usr/share/doc to solve these.

🚨 Rules of Engagement
Environment: RHEL 10 VM.

Resources: Full Open Book. Use man pages, info, and your internet search skills.

The Goal: Prove your research ability. Take your time, find the right flags, and execute cleanly.

📝 RHCSA RHEL 10 Mock Exam: Operation Deep Dive
🕵️ Task 1: The Modern Scheduler (Systemd Timers)
Context: Cron is considered legacy. Modern RHEL relies heavily on systemd timers for micro-precision scheduling, but the syntax is entirely different.

The Goal: Create a systemd service named log-cleaner.service that simply runs the command /usr/bin/echo "Logs cleaned". Then, create a systemd timer named log-cleaner.timer that triggers this service to run only on the first Monday of every month at exactly 4:30 AM.

Research Target: You will need to dive into man systemd.timer and man systemd.time to figure out the exact OnCalendar= syntax.

🕵️ Task 2: The Vendor Override (Systemd Drop-ins)
Context: A vendor installed an application (httpd, for example), but it takes too long to spin up, and systemd keeps killing it because it hits the default 90-second timeout.

The Goal: You need to increase the TimeoutStartSec for httpd to 300 seconds.

The Ironclad Constraint: You are strictly forbidden from editing the vendor-provided unit file at /usr/lib/systemd/system/httpd.service. If that package updates, your changes will be overwritten. You must use the official systemd method to create an override/drop-in file.

Research Target: Look into the systemctl edit command.

🕵️ Task 3: The Illusion of Space (LVM Thin Provisioning)
Context: Your developers want 50GB of storage for testing, but you only have a 10GB physical disk (/dev/vdb). You need to overcommit your storage using LVM Thin Provisioning.

The Goal: Create a Volume Group named vg_thin on /dev/vdb. Inside it, create a Thin Pool named pool01. Finally, create a Thinly Provisioned Logical Volume named lv_dev_space with a virtual size of 50GB. Format it with XFS and mount it to /mnt/dev_space.

Research Target: You will need to dig into man lvmthin or the lvcreate man page to find the specific flags for thin pools (-T) and virtual sizes (-V).

🕵️ Task 4: The Resilient Link (Network Bonding)
Context: The server has two network interfaces (eth1 and eth2). To prevent a switch failure from taking down the server, you need to bond them together.

The Goal: Create a network bond interface named bond0 using the active-backup mode. Enslave both eth1 and eth2 to this bond. Assign the static IP 192.168.100.50/24 directly to the bond interface.

Research Target: The nmcli syntax for bonding is notoriously complex. You will need to consult man nmcli-examples (yes, Red Hat provides a dedicated examples manual page just for this tool).

🕵️ Task 5: The Self-Updating Container (Quadlet Advanced)
Context: You are running a rootless Nginx container via Quadlets (like we did in the previous mock). Security mandates that whenever the host system updates, the container should automatically pull the newest image from the registry and restart itself.

The Goal: Create a Quadlet .container file for nginx:latest. Add the specific configuration line required so that when the systemd timer podman-auto-update.timer fires, this specific container automatically updates itself.

Research Target: You will need to search the Podman documentation, specifically man quadlet5 or man podman-auto-update, to find the exact key-value pair to add to your Quadlet file.
