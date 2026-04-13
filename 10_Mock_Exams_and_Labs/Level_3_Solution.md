# RHCSA Mock Exam Level 3: The Cascade (Solutions)

**Critical Reminder:** If Task 1 fails, Tasks 3, 7, and 8 automatically fail on reboot. Always double-check your `/etc/fstab` syntax!

---

### Task 1: The Foundation (Storage)
**The Goal:** Create a persistent, specifically sized logical volume.

**The Solution:**
```bash
# 1. Create the Physical Volume
sudo pvcreate /dev/vdb

# 2. Create the Volume Group with a 32MB physical extent size
sudo vgcreate -s 32M app_vg /dev/vdb

# 3. Create the Logical Volume using exactly 50 extents (lowercase -l)
sudo lvcreate -l 50 -n lv_webdata app_vg

# 4. Format the volume
sudo mkfs.xfs /dev/app_vg/lv_webdata

# 5. Create the mount point and get the UUID
sudo mkdir -p /srv/web_content
sudo blkid /dev/app_vg/lv_webdata
Edit /etc/fstab and append:

Plaintext

UUID=<your_copied_uuid> /srv/web_content xfs defaults 0 0
Logic Breakdown: The -s 32M flag on vgcreate is crucial. 50 extents * 32MB = 1.6GB volume. If you missed the -s flag, it defaulted to 4MB, and your volume is the wrong size.

Verification: Run sudo mount -a. If it returns no errors, run df -h /srv/web_content to verify the size.

Task 2: The Identity Matrix
The Goal: Create users, assign secondary groups, and configure password aging.

The Solution:

Bash

sudo groupadd web_devs
sudo useradd -G web_devs natasha
sudo useradd -G web_devs clint
sudo chage -M 45 -W 5 natasha
Logic Breakdown: Using -G (capital) ensures web_devs is a secondary group. If you used -g (lowercase), it would override their primary user private group.

Verification: chage -l natasha will display the maximum number of days and the warning threshold.

Task 3: The Collaborative Trap
The Goal: Configure strict collaborative permissions and a specific ACL.

The Solution:

Bash

sudo chgrp web_devs /srv/web_content
sudo chmod 2770 /srv/web_content

# Create the root file for the ACL test
sudo touch /srv/web_content/root_file.txt

# Apply the ACL for clint
sudo setfacl -m u:clint:r-- /srv/web_content/root_file.txt
Logic Breakdown: 2770 sets the SGID bit (2) so files inherit the web_devs group, gives full access to owner and group (77), and zero access to others (0).

Verification: getfacl /srv/web_content/root_file.txt should show user:clint:r--.

Task 4: The Network Storage (Autofs)
The Goal: Automount a local directory when requested to simulate an NFS share.

The Solution:

Bash

sudo dnf install autofs -y
sudo mkdir -p /var/ftp

# 1. Edit the Master Map (create a new file for cleanliness)
sudo vim /etc/auto.master.d/public.autofs
Add this line: /net /etc/auto.public

Bash

# 2. Create the specific mapping file
sudo vim /etc/auto.public
Add this line: public  -fstype=bind  :/var/ftp

Bash

# 3. Enable and start the service
sudo systemctl enable --now autofs
Logic Breakdown: Autofs is an on-demand mounter. It watches /net. When someone tries to access /net/public, it reads /etc/auto.public and dynamically binds /var/ftp to that location.

Verification: Do not use mkdir /net/public (autofs manages this!). Just run cd /net/public and then pwd. If it works, the directory will magically exist.

Task 5: The Silent Web Server
The Goal: Run Apache on a non-standard port and clear SELinux/Firewall blocks.

The Solution:

Bash

sudo dnf install httpd -y

# Change the port
sudo sed -i 's/Listen 80/Listen 8090/' /etc/httpd/conf/httpd.conf
echo "Test Page" | sudo tee /var/www/html/index.html

# SELinux Configuration
sudo semanage port -a -t httpd_port_t -p tcp 8090

# Firewall Configuration
sudo firewall-cmd --permanent --add-port=8090/tcp
sudo firewall-cmd --reload

sudo systemctl enable --now httpd
Logic Breakdown: If you skip the semanage port command, systemd will fail to start httpd entirely, and you will get a "Permission denied" error in the logs because SELinux blocked the socket bind.

Verification: curl http://localhost:8090

Task 6: The "Advanced" Boolean
The Goal: Allow Apache to make outbound network/database connections via SELinux.

The Solution:

Bash

# Search for the boolean
getsebool -a | grep httpd | grep db

# Set it persistently (-P)
sudo setsebool -P httpd_can_network_connect_db 1
Logic Breakdown: The -P flag is required. Without it, the boolean reverts to 0 on reboot, and you fail the objective.

Task 7: The Rootless Container
The Goal: Run an Nginx container as a regular user, mount a host directory, and manage it via systemd.

The Solution:

Bash

# 1. Switch to the user completely
su - natasha

# 2. Pull and run the container (Note the :Z at the end of the volume mount!)
podman pull nginx
podman run -d --name natasha_proxy -p 8080:80 -v /srv/web_content:/usr/share/nginx/html:Z nginx

# 3. Generate systemd service files
mkdir -p ~/.config/systemd/user
cd ~/.config/systemd/user
podman generate systemd --new --name natasha_proxy > container-natasha_proxy.service

# 4. Enable the user service
systemctl --user daemon-reload
systemctl --user enable --now container-natasha_proxy.service

# 5. Exit back to root and enable lingering
exit
sudo loginctl enable-linger natasha
Logic Breakdown: The :Z flag on the volume mount is the most common point of failure. It tells Podman to automatically rewrite the SELinux context of /srv/web_content so the container is allowed to read it. Without :Z, Nginx returns a 403 Forbidden.

Verification: Reboot the server. Log in as root, and run curl http://localhost:8080. If it works, your container, storage, and systemd user services survived the reboot!

Task 8: The Automation Backup
The Goal: Schedule an archive task.

The Solution:

Bash

sudo crontab -e
Add this line:

Plaintext

30 23 * * * tar -czvf /root/web_backup.tar.gz /srv/web_content
Logic Breakdown: 30 23 translates to Minute 30, Hour 23 (11:30 PM).


---

That is a heavy, professional-grade scenario. When you run through this, pay close attention to Task 4 (`autofs`) and Task 7 (the `:Z` flag in containers), as those are historically where candidates get tripped up. 

Let me know how the deployment goes!
