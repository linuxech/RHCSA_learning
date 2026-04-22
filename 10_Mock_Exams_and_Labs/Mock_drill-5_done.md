Drill 5: The Static Link (Networking)
Context: Your server was just plugged into a secondary backend switch via a new network card (eth1), and it needs a static IP.

Step 1: Using nmcli, create a new connection named backend-net bound to the interface eth1 with the IPv4 address 10.50.50.100/24. Do not set a gateway yet.

sudo nmcli connection add type ethernet con-name "backend-net" ifname eth1 ipv4.method manual ipv4.addresses 10.50.50.100/24 
// Connection succesfully. 

Step 2: Modify the backend-net connection to set the DNS server to 10.50.50.1 and ensure the connection method is set to manual (so it doesn't try to pull DHCP).
sudo nmcli con mod "backend-net" ipv4.dns 10.50.50.1 // No errors

sudo nmcli connection show "backend-net" | grep ipv4.method // Outcome as manual

Step 3: Bring the connection up and write the command to verify it is active.

sudo nmcli connection up "backend-net"	\\ Error as no suitable device found. 

-- Rechecking the configuration again-- 
nmcli connection show

Found the bakend-net with Device showing --

sudo nmcli connection modify "backend-net" connection.interface-name enp1s0 \\ No errors

Tried to show connection still showing -- for backedn-net

ran sudo nmcli connection up "backend-net" \\Successfull.

nmcli connection show --active //shows the backend-net with green color. 

-- success--

🏋️ Drill 6: The Ghost Drive (Autofs)

Context: You need a directory to automatically mount only when a user tries to cd into it, to save system resources.

Step 1: Install the autofs package. Create a drop-in file at /etc/auto.master.d/direct.autofs and configure it to watch a master directory called /shares and point to a map file named /etc/auto.direct.
sudo dnf install autofs //installing autofs
-- Failed to download metadata for repo -- error message >> lookig for lernatives
-- Found the cause, I left the previous nmcli connection to the backend-net, so I changed it to the default of enp1s0
 sudo yum install autofs //installed autofs successfully. 

sudo nano /etc/auto.master.d/direct.autofs //created the file and enter in edit mode
	-- Added the text /shares	/etc/auto.directs
exit the file after saving the changes. 
Step 2: Create the map file at /etc/auto.direct. Write the rule so that if someone types cd /shares/ops, it automatically bind-mounts the local directory /var/opt.

sudo nano /etc/auto.direct // created the auto.directs file
	-- Added the text cd /shares/ops	/var/opt
exit the file after saving the changes. 

Step 3: Enable and start the autofs service. Write the exact commands you would use to trigger the automount and verify it worked.

sudo systemctl enable autofs.service	\\ to enable to service unlike the previous firewall hat I missed. 
sudo systemctl restart autofs.service \\ to reload the changes I made. 

-- unable to verify with cd /shares/ops // reviewing the auto.direct file for mistakes--
found the correct line from Internet as following:
/shares/ops -fstype=bind :/var/opt	\\ Added to the auto.direct file
 -- AFter taking help from AI----

Correction in the /etc/auto.master.d/direct.autofs
/shares    /etc/auto.direct	\\ Added the correct line by removing s from directs. 

Corection in the /etc/auto.direct file
ops    -fstype=bind    :/var/opt \\ knowing that shares is syste default and /shares/opt is misunderstood by the system. 
 
-- restarted the autofs.service
---- Worked ---
tried cd /shares/ops
-- entered in the ops diretory. 
-- ran df -h -- listed the file and oter details including the filesystems and mounted info. 


🏋️ Drill 7: The Time Machine (Archiving & Scheduling)
Context: You need to automate a backup of critical configurations before leaving for the weekend.

Step 1: Write the single command to create a gzip-compressed tarball named /root/network_backup.tar.gz containing the entire /etc/NetworkManager directory.
sudo gzip -kNr /etc/NetworkManager /root/network_backup.tar.gz \\ Understood from man pages --Incorrect
tar -czvf /root/network_bckup.tar.gz /etc/NetworkManager \\found from the internet -- Ran this and worked.

Step 2: Schedule a cron job for the root user to execute this exact backup command every Sunday at 3:15 AM.
sudo crontab -e \\opened the crontab file
	-- Added the line 15 3 * * 0 tar -czvf /root/network_bckup.tar.gz /etc/NetworkManager --


Step 3: Write the command to list the root user's cron jobs to verify your schedule was saved correctly.
sudo crontab -l \\ No error but Doubtfull
Output as following:  

*/5 * * * * /usr/bin/uptime >> /var/log/system_heartbeat.log 2>> /dev/null
15 3 * * 0 tar -czvf /root/network_bckup.tar.gz /etc/NetworkManager


🏋️ Drill 8: The Quadlet (RHEL 10 Containers) -- Used AI and Internet, so I don't deserve the credits for this
Context: This is the new RHEL 10 standard. You must deploy a rootless web container for the user app_admin (assume you are already logged in as app_admin).
sudo useradd app_admin
sudo passwd app_admin	\\ created the new user and set the password
sudo usermod -aG wheel app_admin \\ gave the sudo permission by adding it to wheel group. 
switched into the app-admin user as logged in. 

Step 1: Create the exact, deeply nested hidden directory path required by systemd to store user-level Podman Quadlet files.
mkdir -p ~/.config/containers/systemd/ 	\\ Never worked on Quadlet, hence using the internet only-- No errors

Step 2: Assume you opened web.container in an editor. Write out the exact text (usually about 5-6 lines) required in this file to use the nginx:latest image and map host port 8080 to container port 80.
sudo nano ~/.config/containers/systemd/web.container \\ Creating the file name web.container
-- Added the configuration as following
	[Container]
Image=docker.io/library/nginx:latest
PublishPort=8080:80

[Install]
WantedBy=default.target 
	End ----

Step 3: Write the two systemd commands required to make the system read your new file, and then enable/start the container service.

sudo systemctl --user daemon-reload	\\ relaoding the systemd so it could read the new quadlet file. 
-- got the error as I was ruuning this as sudo --
"Failed to connect to user scope bus via local transport: $DBUS_SESSION_BUS_ADDRESS and $XDG_RUNTIME_DIR not defined (consider using --machine=<user>@.host --user to connect to bus of other user)
"
systemctl --user daemon-reload \\ ran again and No errros so far. 

systemctl --user enable --now web.service	\\ enableing and starting the services --failed got the error as following
Failed to enable unit: Unit /run/user/1005/systemd/generator/web.service is transient or generated

-- Unable to proceed accept the loss, so I can learn this as beginner and focus on the learning part. --

-- Final steps performed to undo the container changes:
sudo podman rmi docker.io/library/nginx:latest

# 1. Disable linger just in case you ran the pro-tip command earlier
sudo loginctl disable-linger app_admin 

# 2. Delete the user, their group, and their entire home directory
sudo userdel -r app_admin
