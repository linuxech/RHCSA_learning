.

🏋️ Drill 1: The Service Account (Identity)
Context: You need to provision a secure account for a background application.

Step 1: Create a group named app_managers.

Step 2: Create a user named service_bot. In one command, ensure their primary group is app_managers, their home directory is explicitly set to /opt/bot_home, and they cannot log into an interactive shell.

Step 3: Configure service_bot's password to expire exactly 30 days from today.

🏋️ Drill 2: The Team Dropbox (Permissions)
Context: You need a shared folder where files inherit the correct group, but is completely locked down from outsiders.

Step 1: Create a directory at /srv/team_data and change its group ownership to app_managers.

Step 2: Using a single octal (numeric) command, set the permissions so: Owner and Group have rwx, Others have ---, and all new files inherit the app_managers group (SGID).

Step 3: Using an Access Control List (ACL), grant the built-in system user nobody read-only access (r--) to this directory.

🏋️ Drill 3: Storage Provisioning (LVM)
Context: Your database needs a dedicated, specifically sized drive. (Assume you have a raw 5GB disk attached at /dev/vdb).

Step 1: Initialize /dev/vdb as a Physical Volume, then create a Volume Group named vg_database with a Physical Extent (PE) size of 16MB.

Step 2: Create a Logical Volume named lv_sql using exactly 50 extents.

Step 3: Format the volume with the XFS filesystem, create a mount point at /mnt/sql_data, and write out the exact line you would add to /etc/fstab to mount it persistently by UUID.

🏋️ Drill 4: The Custom Port (SELinux & Firewall)
Context: Security requires your internal web server to run on port 8088 instead of 80.

Step 1: Install httpd. (Assume you used nano to edit the config to Listen 8088).

Step 2: Use the semanage command to permanently add port 8088 to the SELinux http_port_t context.

Step 3: Use firewall-cmd to permanently allow TCP traffic on port 8088, and then reload the firewall to apply the changes.
