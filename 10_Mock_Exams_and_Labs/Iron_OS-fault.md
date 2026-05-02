Phase 1: Intense Storage (LVM & Swap) We need a dedicated data drive and extra swap space. Assume you have a 5GB disk at /dev/vdb.

sudo pvcreate /dev/vdb

Task 1: Create a Volume Group named vg_phoenix on /dev/vdb with a Physical Extent (PE) size of 8MB.

sudo vgcreate vg_pheonix /dev/vdb -s 8M

Task 2: Create a Logical Volume named lv_data that is 500MB in size, and format it with XFS. sudo lvcreate -L 500M -n lv_data vg_pheonix sudo mkfs.xfs /dev/vg_pheonix/lv_data

Task 3: Create a second Logical Volume named lv_swap that is 256MB in size, and format it as swap space. sudo lvcreate -L 256M -n lv_swap vg_pheonix sudo mkswap /dev/vg_pheonix/lv_swap

Task 4: Create a mount point at /mnt/phoenix_data. Add both lv_data and lv_swap to /etc/fstab so they mount/activate automatically on boot. Mount the drive and turn on the swap to verify. mkdr -p /mnt/pheonix

nano /etc/fstab -- UUID /mnt/phoenix_data xfs defaults 0 0 \for lv_data --UUID /dev/vg_pheonix/lv_swap swap swap defaults 0 0 \for swap

sudo swapon /dev/vg_pheonix/lv-swap SysAdmin Hint (Fstab): You can use the device paths (e.g., /dev/vg_phoenix/lv_data) in /etc/fstab if you don't want to copy UUIDs. Remember, the filesystem type for swap is just swap. Use mount -a and swapon -a to test!

\checked using lvscan and lsblk

After rebooting the system------

It appears to be the system defaulted in the emergency mode. 
logged in with root. 
checked journalctl -xb 

No visible error displayed..

Checked the internet! Found the usual behaviour is the outcome of failed mount devices. 

used vi /etc/fstab
commented the line that I added earlier. 


Phase 2: Strict Permissions & ACLs Locking down the new drive.

Task 5: Create a group named data_handlers. Change the group ownership of /mnt/phoenix_data to this group.

Task 6: Using octal math, set the permissions on /mnt/phoenix_data so the Owner and Group have full rwx, Others have ---, and all new files inherit the data_handlers group (SGID).

Task 7: The system user nobody needs automatic read access to all future files created here. Set a Default ACL on /mnt/phoenix_data granting nobody read and execute (r-x) access.

🗜️ Phase 3: Archiving Under Pressure Testing a different compression algorithm.

Task 8: Create five empty files inside /mnt/phoenix_data: file1.txt through file5.txt.

Task 9: Compress the entire /mnt/phoenix_data directory into a bzip2 compressed tarball located at /root/data_backup.tar.bz2.

SysAdmin Hint (Archiving): Last time you used -z for gzip. To use bzip2 with tar, swap the z for a j. Syntax: tar -cjvf [file.tar.bz2] [directory].


