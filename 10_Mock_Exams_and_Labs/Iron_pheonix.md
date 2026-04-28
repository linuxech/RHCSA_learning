Project: Iron Phoenix.

For Phases 1 through 4, the hints are minimal. For Phase 5 (Quadlets), I am giving you the exact standard operating procedure to build confidence.

Boot up your RHEL 10 VM. Let's build.

🗄️ Phase 1: Intense Storage (LVM & Swap)
We need a dedicated data drive and extra swap space. Assume you have a 5GB disk at /dev/vdb.

Task 1: Create a Volume Group named vg_phoenix on /dev/vdb with a Physical Extent (PE) size of 8MB.

Task 2: Create a Logical Volume named lv_data that is 500MB in size, and format it with XFS.

Task 3: Create a second Logical Volume named lv_swap that is 256MB in size, and format it as swap space.

Task 4: Create a mount point at /mnt/phoenix_data. Add both lv_data and lv_swap to /etc/fstab so they mount/activate automatically on boot. Mount the drive and turn on the swap to verify.

SysAdmin Hint (Fstab): You can use the device paths (e.g., /dev/vg_phoenix/lv_data) in /etc/fstab if you don't want to copy UUIDs. Remember, the filesystem type for swap is just swap. Use mount -a and swapon -a to test!

🔐 Phase 2: Strict Permissions & ACLs
Locking down the new drive.

Task 5: Create a group named data_handlers. Change the group ownership of /mnt/phoenix_data to this group.

Task 6: Using octal math, set the permissions on /mnt/phoenix_data so the Owner and Group have full rwx, Others have ---, and all new files inherit the data_handlers group (SGID).

Task 7: The system user nobody needs automatic read access to all future files created here. Set a Default ACL on /mnt/phoenix_data granting nobody read and execute (r-x) access.

🗜️ Phase 3: Archiving Under Pressure
Testing a different compression algorithm.

Task 8: Create five empty files inside /mnt/phoenix_data: file1.txt through file5.txt.

Task 9: Compress the entire /mnt/phoenix_data directory into a bzip2 compressed tarball located at /root/data_backup.tar.bz2.

SysAdmin Hint (Archiving): Last time you used -z for gzip. To use bzip2 with tar, swap the z for a j. Syntax: tar -cjvf [file.tar.bz2] [directory].

🛡️ Phase 4: SELinux & Firewall Precision
Opening a custom port for Nginx.

Task 10: Install the nginx package. (Make sure you are running this as root).

Task 11: Open the main nginx configuration file (/etc/nginx/nginx.conf). Find the line that says listen 80; and change it to listen 8085;.

Task 12: Use semanage to permanently tell SELinux that port 8085 (tcp) is an allowed http_port_t.

Task 13: Open port 8085/tcp permanently in the firewall and reload it. Enable and start the nginx service.

🐳 Phase 5: The Beginner Quadlet (Guided)
We are dropping the traps. We will use a standard user with a standard shell to ensure the systemd session initializes perfectly.

Task 14: Create a normal user named container_boss with a standard shell, and set a password for them.

Bash

sudo useradd container_boss
sudo passwd container_boss
Task 15: As root, turn on lingering for this user. This is the magic command that tells the system: "Keep this user's systemd services running even when they aren't logged in."

Bash

sudo loginctl enable-linger container_boss
Task 16: Switch to the user properly. Because this is a standard user, su - will work perfectly and load their environment.

Bash

su - container_boss
Task 17: Create the nested systemd directory. Notice we are safely inside the user's home directory now.

Bash

mkdir -p ~/.config/containers/systemd/
Task 18: Create the Quadlet file.

Bash

nano ~/.config/containers/systemd/myweb.container
Paste this exact text into the file:

Ini, TOML

[Container]
Image=docker.io/library/httpd:latest
PublishPort=8080:80

[Install]
WantedBy=default.target
Task 19: Reload the user's systemd daemon to generate the service, then start and enable it.

Bash

systemctl --user daemon-reload
systemctl --user enable --now myweb.service
Task 20: Verify the container is running!

Bash

podman ps
Run through it step-by-step. Let's see if you can conquer the LVM and permissions without hints, and get that Quadlet container running smoothly! Paste your output when you are done.
