Drill 5: The Static Link (Networking)
Context: Your server was just plugged into a secondary backend switch via a new network card (eth1), and it needs a static IP.

Step 1: Using nmcli, create a new connection named backend-net bound to the interface eth1 with the IPv4 address 10.50.50.100/24. Do not set a gateway yet.

Step 2: Modify the backend-net connection to set the DNS server to 10.50.50.1 and ensure the connection method is set to manual (so it doesn't try to pull DHCP).

Step 3: Bring the connection up and write the command to verify it is active.

🏋️ Drill 6: The Ghost Drive (Autofs)
Context: You need a directory to automatically mount only when a user tries to cd into it, to save system resources.

Step 1: Install the autofs package. Create a drop-in file at /etc/auto.master.d/direct.autofs and configure it to watch a master directory called /shares and point to a map file named /etc/auto.direct.

Step 2: Create the map file at /etc/auto.direct. Write the rule so that if someone types cd /shares/ops, it automatically bind-mounts the local directory /var/opt.

Step 3: Enable and start the autofs service. Write the exact commands you would use to trigger the automount and verify it worked.

🏋️ Drill 7: The Time Machine (Archiving & Scheduling)
Context: You need to automate a backup of critical configurations before leaving for the weekend.

Step 1: Write the single command to create a gzip-compressed tarball named /root/network_backup.tar.gz containing the entire /etc/NetworkManager directory.

Step 2: Schedule a cron job for the root user to execute this exact backup command every Sunday at 3:15 AM.

Step 3: Write the command to list the root user's cron jobs to verify your schedule was saved correctly.

🏋️ Drill 8: The Quadlet (RHEL 10 Containers)
Context: This is the new RHEL 10 standard. You must deploy a rootless web container for the user app_admin (assume you are already logged in as app_admin).

Step 1: Create the exact, deeply nested hidden directory path required by systemd to store user-level Podman Quadlet files.

Step 2: Assume you opened web.container in an editor. Write out the exact text (usually about 5-6 lines) required in this file to use the nginx:latest image and map host port 8080 to container port 80.

Step 3: Write the two systemd commands required to make the system read your new file, and then enable/start the container service.
