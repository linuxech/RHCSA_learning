Operation: Forge. This contains 6 drills (18 steps total).

Open your terminal. Focus strictly on the exact syntax for each step. When you are done, paste your command history!

🚨 Rules of Engagement
Assume Prerequisites: If a drill mentions a Volume Group like vg_data, assume it already exists on your system with plenty of free space.

No Google: Rely entirely on your memory and the man pages (e.g., man lvextend, man semanage-fcontext).

Just the Commands: You don't have to execute all of this on a live VM if you don't want to break your current setup. You can simply write out the exact commands you would type in a text file and paste them here for grading.

🗄️ Drill 1: The LVM Expansion (Storage)
Context: Your web server is out of space and needs to be expanded live, without unmounting.

Step 1: Create a Logical Volume named lv_web inside vg_data that is exactly 1GB in size. Format it with the ext4 filesystem. (We are using ext4 instead of xfs here to test your tool knowledge).

Step 2: Mount it to /mnt/web.

Step 3: The alarm goes off—you need more space. Extend lv_web to 1.5GB in total, and automatically resize the underlying ext4 filesystem in a single command.

💽 Drill 2: LVM Swap Space (Storage)
Context: The system is running out of memory. You need to provision swap space using logical volumes.

Step 1: Create a Logical Volume named lv_swap inside vg_data that is exactly 512MB in size.

Step 2: Format this new Logical Volume specifically as swap space.

Step 3: Write the exact line you would add to /etc/fstab to make this persistent (you can use the /dev/vg_data/... path instead of UUID for LVMs if you prefer), and write the command to activate the swap immediately without rebooting.

🛡️ Drill 3: The Custom Web Root (SELinux File Contexts)
Context: Apache is installed, but the developers want to serve the website from /custom/www instead of /var/www/html. SELinux is blocking it.

Step 1: Create the directory /custom/www and create an empty index.html file inside it.

Step 2: Use the semanage command to define a permanent SELinux rule that applies the httpd_sys_content_t context to /custom/www and everything inside it.

Step 3: The semanage command only writes the rule to the database; it doesn't apply it to the files. Write the command to forcibly apply this new context to the /custom/www directory immediately.

🚦 Drill 4: The Networked App (SELinux Booleans)
Context: The web server needs to communicate with a remote database, but SELinux strictly prevents Apache from making outbound network connections by default.

Step 1: Write the command to list all SELinux booleans and filter (grep) for ones related to httpd and db.

Step 2: Turn the boolean httpd_can_network_connect_db ON.

Step 3: Ensure that this boolean change is persistent and will survive a system reboot. (Hint: combine Step 2 and 3 if you know the flag!)

🔐 Drill 5: The Architect's Directory (Advanced Permissions & ACLs)
Context: Project Apollo is highly confidential. You need complex layer permissions.

Step 1: Create /project/apollo. Change the group ownership to architects. Using a single octal command, set it so the Owner and Group have rwx, Others have ---, and all new files inherit the architects group.

Step 2: The user auditor needs to be able to read files here. Set a standard ACL on the directory itself granting auditor read and execute (r-x) access.

Step 3: Set a Default ACL on the directory so that any new files created inside automatically grant the user auditor read-only (r--) access.

👤 Drill 6: The Temporary Admin (Users & Sudoers)
Context: A contractor needs temporary, passwordless root access, but you need to stage the account in a locked state first.

Step 1: Create a user named contractor1 and set their password to TempPass123 via the command line without an interactive prompt.

Step 2: Lock the contractor1 account so they cannot log in right now.

Step 3: Write the visudo command to safely create a drop-in file at /etc/sudoers.d/contractor and write the exact rule that allows them to run ALL commands as root without a password.
