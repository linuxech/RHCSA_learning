Phase 1: Provisioning & Packages
We need tools and secure users to run our application.

Task 1: Check if tar, bzip2, httpd, and podman are installed. If they are not, install them in a single command.

SysAdmin Hint (Packages): Use dnf install or yum install. If you add the -y flag, it won't prompt you to confirm.

sudo dnf install -y tar bzip2 httpd podman

Task 2: Create a group named chimera_devs.
sudo groupadd chimera_devs

Task 3: Create a user named chimera_svc. Ensure their primary group is chimera_devs, give them a custom home directory at /opt/chimera_home, and ensure they cannot log into an interactive shell.

sudo useradd -g chimera_devs -d /opt/chimera_home -s /sbin/nologin chimera_svc

verified the same in /etc/group and /etc/passwd files. 

🔐 Phase 2: The Workspace & ACLs
We need a highly secure shared directory where developers can collaborate.

Task 4: Create a directory at /srv/chimera_data. Change its group ownership to chimera_devs.

sudo mkdir /srv/chimera_data | sudo chgrp chimera_devs /srv/chimera_data

Question: Does change its group ownership to chimera_devs ean only changing the group ownership or Does it also mean changing the files in the folder ownership as well. 
For example in the exam will this cause any error or -ve marking?

Task 5: Using octal math (numbers), set the permissions on /srv/chimera_data so the Owner and Group have full rwx, Others have ---, and all new files inherit the chimera_devs group.

sudo chmod 2770 /srv/chimera_data

Question: How did I do the above command? 
As I had to go through my previous notes to get the concept of suid and guid. 

Task 6: The auditing team needs read access. Set a standard ACL on /srv/chimera_data granting the user nobody read and execute (r-x) access.


SysAdmin Hint (ACLs): The command is setfacl. Use the -m (modify) flag. The syntax is u:username:permissions.

sudo setfacl -m u:nobody:rx /srv/chimera_data

verification: sudo -u nobody ls -ld /srv/chimera_data
\\output show's a + signs after the permissions bits. Not sure if I succedded or not. 

Task 7: Ensure that any future files created in this directory automatically grant the user nobody read-only (r--) access.

SysAdmin Hint (ACLs): You need a "Default ACL". Use the exact same command as Task 6, but add the -d flag before the -m flag.

sudo setfacl -d -m u:nobody:rx /srv/chimera_data

🗜️ Phase 3: Archiving & Compression
Let's simulate data and back it up before we break anything.

Task 8: Create three empty files inside /srv/chimera_data: app.log, error.log, and debug.log.

sudo touch /srv/chimera_data/app.log /srv/chimera_data/error.log /srv/chimera_data/debug.log

Question: Did I do something wrong here, as I created the files using sudo, in the real live exam, I may not have the permission to proceed with the same, was I supposed to switch user to the one that we created earlier?

Task 9: Compress the entire /srv/chimera_data directory into a gzip tarball located at /root/chimera_backup.tar.gz.

SysAdmin Hint (Archiving): tar is the tape archiver. The flags you need are c (create), z (gzip), v (verbose), f (file). The syntax is tar -czvf [destination_file.tar.gz] [source_directory].

sudo tar -czvf /root/chimera_backup.tar.gz /srv/chimera_data

Question: Why the outcome was like this
Removing leading `/' from member names
/srv/chimera_data/
/srv/chimera_data/app.log
/srv/chimera_data/error.log
/srv/chimera_data/debug.log
What does this means?

Task 10: Oh no, a developer deleted the logs! Extract your backup tarball directly into the /tmp/ directory to recover them.

SysAdmin Hint (Archiving): To extract, change the c to an x (extract). To extract to a specific location instead of your current directory, you must use the capital -C flag at the end. Example: tar -xzvf [file.tar.gz] -C /tmp/.

sudo tar -xvzf /root/chimera_backup.tar.gz -C /tmp/

Task 11: The debug.log (currently sitting in /srv/chimera_data) is getting too big. Compress just this single file using bzip2.

SysAdmin Hint (Archiving): tar groups files together. If you just want to compress one single file, just run bzip2 [filename]. It will replace the file with a .bz2 version.

sudo bzip2 /srv/chimera_data/deug.log

Question: If we look at the current RHCSA exam, what % of content come associated with Archiving and compression syllabus?

🧱 Phase 4: Network & Firewall
We are going to run a web server on a non-standard port. We need to open the gates.

Task 12: Ensure the firewalld service is started and enabled to survive reboots.

sudo systemctl enable firewalld
//although it was already enabled maybe because of previous tests. 

Task 13: Add port 8090 (TCP) to the firewall permanently.

sudo firewall-cmd --permanent --add-port=8090/tcp

SysAdmin Hint (Firewall): The command is firewall-cmd. You need the --permanent flag, and the --add-port=PORT/PROTOCOL flag.

sudo firewall-cmd --permanent --add-port=8090/tcp
sudo firewall-cmd --reload

Task 14: The rule is saved but not active. Reload the firewall.

SysAdmin Hint (Firewall): firewall-cmd --reload. Always do this after a --permanent change.
Already did, I learnt that every time we make changes to service it is better to reload that service so the changes can get in effect. I did the same in the past while running httpd and samba services. 

Task 15: Verify your port is actually open.

SysAdmin Hint (Firewall): firewall-cmd --list-ports.

sudo firewall-cmd --list-ports

Output: 8088/tcp 8090/tcp

🛡️ Phase 5: The SELinux Gauntlet
The firewall is open, but SELinux is the internal bouncer. We must appease it.

Task 16: Edit the Apache config (/etc/httpd/conf/httpd.conf) and change Listen 80 to Listen 8090.

nano /etc/httpd/conf/httpd.conf
// Added another line Listen 8090

Task 17: Tell SELinux it is legal for Apache to bind to port 8090.

SysAdmin Hint (SELinux): You are managing SELinux ports. The tool is semanage port. Use -a (add), -t http_port_t (the type), and -p tcp 8090.

sudo semanage -a -t http_port_t -p tcp 8090 \\wrong command got the error as argument errror

sudo semanage port -a -t http_port_t -p tcp 8090 \\ worked. 

Task 18: Edit the Apache config again. Find DocumentRoot "/var/www/html" and change it to DocumentRoot "/srv/chimera_data". Do the same for the <Directory "/var/www/html"> block right below it.

sudo nano /etc/httpd/conf/httpd.conf

Added # to original lines and added the same with recomended /srv/chimera_data.

Task 19: Tell the SELinux database that /srv/chimera_data should be treated as web content.

SysAdmin Hint (SELinux): The tool is semanage fcontext. You need -a (add), and -t httpd_sys_content_t. The tricky part is the regex to include all files inside: "/srv/chimera_data(/.*)?".

sudo semanage fcontext -a -t httpd_sys_content_t "/srv/chimera_data(/.*)?"
// No error

Question: How can I ensure that the regex and other parts are followed properly during exam?

Task 20: The database knows the rule, but the files don't have the labels yet. Forcibly apply the new SELinux labels to the directory.

SysAdmin Hint (SELinux): The tool is restorecon. Use -R (recursive) and -v (verbose). Syntax: restorecon -Rv /srv/chimera_data.

sudo restprecon -R -v /srv/chimera_data

//Feels like cheating, as I am just typing the hint command here. 

Task 21: Start and enable the httpd service. Check its status to ensure it didn't crash.

sudo systemctl reload-or-restart httpd.service

Shut down the system, will check after return, Also, system is installing updates.

--- httpd service not running after restart ------
ran sudo systemctl enable httpd.service
sudo systemctl restart http.service

-- rebooting the device again to confirm if the httpd remain enabled/running after reboot. ---

Survived the reboot. 
httpd running although showing status as Idle/busy workers 100/0;
-- Not sure what went wrong here. ---
--Found the issue network was set for default for backend/ switched to the right one ---

 
🐳 Phase 6: The Modern Deployment (Quadlets)
Web servers are legacy. Let's deploy an Nginx container using the new RHEL 10 standard.

Task 22: We are going to run the container as chimera_svc. As root, enable lingering for this user so their containers survive system reboots.

SysAdmin Hint (Quadlets): loginctl enable-linger chimera_svc.

sudo loginctl enable-linger chimera_svc

Task 23: Switch to the user (su - chimera_svc). Create the exact directory structure required for Quadlets.

the user chimera_svc was a nologin user, 
when trying su - chimera_svc
error as "This account is currently not available"

SysAdmin Hint (Quadlets): Systemd looks in a very specific hidden folder in the user's home directory. mkdir -p ~/.config/containers/systemd/.

-- No existing container folder inthe /.config directory --
still ran sudo mkdir -p ~/.config/containers/systemd/

Task 24: Create a file named proxy.container inside that new directory. Write the configuration to pull nginx:latest and publish host port 8080 to container port 80.

SysAdmin Hint (Quadlets): > [Container]
Image=docker.io/library/nginx:latest
PublishPort=8080:80
[Install]
WantedBy=default.target

sudo nano ~/.config/containers/systemd/proxy.container
--Added the above text From [Container] tp target---
save and exit

Task 25: Tell systemd to read your new file, then enable and start the container in one command.

SysAdmin Hint (Quadlets): First: systemctl --user daemon-reload. Second: systemctl --user enable --now proxy.service (Notice it is .service, not .container!).


try to ran sudo systemctl --user daemon-reload  /No error 
sudo systemctl --user proxy.service //Failed to enable unit: Unit proxy.service does not exist. 

--- I didn't understand any of the steps i did in last phase. 

Mission Complete. Take it Phase by Phase. If you get stuck, read the hint, check the man page, and try again. Paste your terminal output here for whichever Phase you complete first!
