🚨 Pre-Flight Setup
Environment: A fresh RHEL 10 VM.

Hardware: Attach ONE unformatted virtual disk (e.g., /dev/vdb at 10GB).

Network: Ensure the VM has internet access to pull packages.

Time Limit: 120 Minutes (2 Hours).

The Golden Rule: You must reboot at the end. Everything must survive the reboot.

The Ironclad Rule: NO GOOGLE. You may only use man pages or --help commands.

📝 RHCSA RHEL 10 Mock Exam: Operation Ironclad
Task 1: The Foundation

Set the system hostname to ironclad.server.local.

Verify your primary network interface is configured to start automatically on boot.

Task 2: Identity Management

Create a group named auditors.

Create two new users: agent_k and agent_j.

Configure both users so that auditors is their secondary (supplementary) group.

Ensure agent_k's account will completely expire on December 31, 2026.

Task 3: The Vault (Targeted Drill: Permissions)

Create a directory at /shared/audit_data.

Change the group ownership to auditors.

Constraint: Using exactly ONE numeric (octal) command, set the permissions so that:

The Owner and Group have full read, write, and execute access.

"Others" have absolutely zero access.

Any new file created inside this directory automatically inherits the auditors group ownership. (Do not set the sticky bit for this task).

Task 4: The Delegation (Targeted Drill: Sudo)

The user agent_j needs to be able to restart the time-sync service (chronyd) as root, without entering a password.

Constraint: You must use a drop-in file located at /etc/sudoers.d/agent_j. You must use the official syntax-checking tool to create this file, or you fail this objective.

Task 5: Search and Destroy (Targeted Drill: Find/Exec)

Create a directory at /root/log_archive.

Search the entire /var/log directory for files that end with the .log extension and are larger than 1MB.

Constraint: Using a single find command pipeline with the -exec flag, copy (do not move) all matching files into /root/log_archive/.

Task 6: The Ghost File (Targeted Drill: Links)

A critical monitoring script expects to find a configuration file at /tmp/monitor.conf.

However, the actual file must reside at /opt/monitor.conf.

Create the actual file at /opt/monitor.conf and write the word ACTIVE inside it.

Constraint: Create a link at /tmp/monitor.conf pointing to the actual file. It MUST be the type of link that survives even if /tmp and /opt are on different hard drive partitions.

Task 7: Core Storage Engineering (LVM)

Using your 10GB virtual disk, create a Volume Group named vg_ironclad with a physical extent size of 32MB.

Create a Logical Volume named lv_records consisting of exactly 60 extents.

Format it with the XFS file system.

Mount it persistently to /mnt/records using its UUID.

Task 8: Secure Services (SELinux & Firewall)

Install the Apache web server (httpd).

Configure the server to listen on non-standard port 8282.

Create a simple index.html file in /var/www/html that says "Ironclad Secured".

Configure SELinux to permanently allow Apache to bind to port 8282.

Configure the firewall to permanently allow TCP traffic on port 8282.

Start and enable the service.

Task 9: Modern RHEL 10 Containers (Quadlets)

Log in as the user agent_k.

Pull the nginx:latest image from docker.io.

Using RHEL 10 native Quadlets (a .container file), configure this container to run rootless.

Name the container iron_proxy.

Map port 8080 on the host to port 80 in the container.

Start the service using systemctl --user and ensure it survives a system reboot without agent_k needing to log in (enable lingering).

🛑 Evaluation Protocol
Once your 120 minutes are up, type reboot.

When the machine comes back online:

Log in as agent_k and test if you can write a file in /shared/audit_data and check its group ownership.

Log in as agent_j and test running sudo systemctl restart chronyd.

Check ls -l /tmp/monitor.conf.

Curl your web server: curl http://localhost:8282.

Curl your container: curl http://localhost:8080.
