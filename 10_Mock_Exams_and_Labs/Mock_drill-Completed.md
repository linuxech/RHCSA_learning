.

🏋️ Drill 1: The Service Account (Identity)
Context: You need to provision a secure account for a background application.

Step 1: Create a group named app_managers.

Step 2: Create a user named service_bot. In one command, ensure their primary group is app_managers, their home directory is explicitly set to /opt/bot_home, and they cannot log into an interactive shell.

useradd  -d /opt/bot_home -g app_managers -K UID_MAX=30 -s /sbin/nologin service_bot // Unable to proceed

useradd -d /opt/bot_home -g app_managers -s /bin/nologin service_bot  //Successful

Step 3: Configure service_bot's password to expire exactly 30 days from today.
chage -M 30 service_bot   //Successful

🏋️ Drill 2: The Team Dropbox (Permissions)
Context: You need a shared folder where files inherit the correct group, but is completely locked down from outsiders.

Step 1: Create a directory at /srv/team_data and change its group ownership to app_managers.
mkdir /srv/team_data
chgrp app_managers /srv/team_data 

Step 2: Using a single octal (numeric) command, set the permissions so: Owner and Group have rwx, Others have ---, and all new files inherit the app_managers group (SGID).
chmod 2770 /srv/team_data

Step 3: Using an Access Control List (ACL), grant the built-in system user nobody read-only access (r--) to this directory.

setfacl -m u:nobody:r-- /srv/team/data //Search for ACL's

🏋️ Drill 3: Storage Provisioning (LVM)
Context: Your database needs a dedicated, specifically sized drive. (Assume you have a raw 5GB disk attached at /dev/vdb).

Step 1: Initialize /dev/vdb as a Physical Volume, then create a Volume Group named vg_database with a Physical Extent (PE) size of 16MB.

pvcreate /dev/vdb	\\Success
vgcreate vg_database -s 16M /dev/vdb	\\success

Step 2: Create a Logical Volume named lv_sql using exactly 50 extents.

lvcreate --extent 50 -n lv_sql vg_dtabase \\didn't tried figured from MAn pages. 
lvcreate -l 50 -n lv_sql vg_database \\Successful

Step 3: Format the volume with the XFS filesystem, create a mount point at /mnt/sql_data, and write out the exact line you would add to /etc/fstab to mount it persistently by UUID.
sudo mkds.xfs /dev/vg_database/lv_sql	\\Success
sudo mkdir /mnt/sql_data
sudo mount /dev/vg_database/lv_sql /mnt/sql_data \\Mounting the lv.

UUID=a160e44c-1922-40d5-a067-3c3368f57493 /dev/vg_database/lv_sql /mnt/sql_data		xfs	default		0 0	//Line in fstab file //failed

Initial error with parse, but after correction entered this
UUID=a160e44c-1922-40d5-a067-3c3368f57493 /mnt/sql_data      xfs     defaults	 0 0

Ran mount -a // no error 
//Success


🏋️ Drill 4: The Custom Port (SELinux & Firewall)
Context: Security requires your internal web server to run on port 8088 instead of 80.

Step 1: Install httpd. (Assume you used nano to edit the config to Listen 8088).
/etc/httpd/conf/httpd.conf

sudo nano /etc/httpd/conf/httpd.conf \\ Update the listen port to 8088

tried to restart the httpd--got error "Job for httpd.service failed because the control process exited with error code.
See "systemctl status httpd.service" and "journalctl -xeu httpd.service" for details."
use -- semanage port -l | grep http	\\to list the ports

Step 2: Use the semanage command to permanently add port 8088 to the SELinux http_port_t context.

semanage port -a -t http_port_t -p tcp 8088  // No error \\ used my notes

Step 3: Use firewall-cmd to permanently allow TCP traffic on port 8088, and then reload the firewall to apply the changes.

sudo firewall-cmd --permanent --add-port=8088/tcp //success

-- Now restarting with cross fingers----

