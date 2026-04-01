- Understand the Linux Boot Process

Stages--
	#Firmware Stage: 
	- Execute code in the BIOS for legacy systems
	- Execute code in the UEFI firmware for new computers.
	- Starts bootloader
	#Bootloader Stage:
	- Firmware executes the bootloader(grub2) code on the drive
	- Bootloader reads its configuration file
		BIOS:/boot/grub2/grub2.cfg
		UEFI:/boot/efiEFI/redhat/grub.efi
	- Execute the kernel
	#Kerne State:
	- Loads the ramdisk into RAM
	- Loads device drivers and config files from ramdisk
	- Unmounts ramdisk and mounts root filesystem
	- Starts the initialization stages
	#Initialization Stage:
	Systemd Targets
	- Target is specific configuration
	- Default target graphical.target
	- Systems can be booted into defferent targets.

##################################################################
Rescue a System


#Kernel Panic

- Missing drivers
- Bad drivers
- Boots into older kernel
- Boots into different systemd target

#Change default Boot kernel
sudo grub2-set-default 1

#Systemd Emergency Target
- Requires root password
- Does not:
	- Load drivers
	- Start services
	- Start GUI
	- Mount/read-write

######################################################################
Introduction to Systemd services

Daemon = System Service

System Service

- Web Servers
- File Servers
- Network Servers

#Linux Service Naming Conventions

- httpd
- smbd
- sshd
- dhcpd

#SysV init Proces Tree

init--------------abrtd
	|
	|---------agetty
	|
	|---------auditd---------{gdbus}
	|	
	|---------crond
	|
	|---------dbus-----daemon-----{dbus-daemon}
	|
	|---------hald------hald-runner	
	|
	|		---{hald}

#SysV init Runlevels

- acpid				- acpid
- atd				- atd
- crond				- crond
- iptables			- startx

#SysV init Shortcomings

- Slow startup
- No service dependencies
- No persistent network


#Upstart

- Starts process asynchronously
- Monitors running processes
- Backward compatible with SysV init
- Can be extended to interact with other event systems
- User by Enterprise Linux 6

#Systemd

- Suite of software replacing traditional systems
- Aims to unify Linux service configuration
- Includes init system
- Manages devices,login, network connections and logging
- Most major distributions use systemd

############################################################
Get systemd service status

Systemd Unit Types
- Devices
- Mounted Volumes
- Network sockets
- System timers
- Targets

#Systemd Units
		Systemd objects that store the configuration on disk as a unit file. 

#systemctl list-units
		Command that lists systemd units currently being held in memory
		Units are running or were running previously.

#systemctl list-unit-files
		Command that lists installed unit files stored on disk.
		Includes the auto-start state.

#systemctl status
		Command that shows the status of a specified unit file or the 
		the system status if a unit isn't provided. 

#############################################################################

Managed systemd services

Need privelages-

systemctl disable [service name]
systemctl start [service name]
systemctl restart [service name]

systemctl mask [service name]
systemctl unmask [service name]

##########################################################################

Make systemd services persistent

#########################################################################

Configure Networking

Network Settings

- Hostname
- IP address
- Subnet Mask
- Default Gateway
- Name server

#Configure Hostname
		vi /etc/hostname
		hostname
#Configure Hostname(systemd)
		sudo hostnamectl set-hostname
		rhhost1.localhost.com
#Host Configuration /etc/hosts


#Global Nameserver Configuration
		/etc/resolv.conf
	nameserver 192.168.2.206
	nameserver 192.168.2.207

#Network Interface Settings
		/etc/netwokManager/system-connections/

#Network Interface Settings(Legacy)
		/etc/sysconfig/network-scripts/

#Network Interface Settings (nmcli)
		sudo nuclei con mod eth0 ipv4.dns "192.168.2.254"
		sudo nuclei connection reload
	
#Legacy Network Interface Naming
	Interface Type			Interface Name
	Ethernet			eth0
	Wireless			wlan0
	Wide area network		wan0

#Network Interface Naming
	Interface Type			Interface Name
	BIOS Supplied			en01
	PCI Express slot		ens1
	PCI Slot			enp3s0
	Invalid Firmware information	eth0

#Network Configuration Tools
	- ip/ifconfig
	- nmcli
	- nmtui
	- nm-connection-editor
	- Gnome network GUI

######################################################################
Configure a system to use network time protocol

in GUI
- Go to Date and Time menu

In CLI

#timedatectl list-timezones
			Search for your timezone
#timedatectl set-time 11:25:00
		To set time, you can also use YYYY-MM-DD for date format.

#timedatectl set-time "YYYY-MM-DD HH:MM:SS"
		To set the time, date.

#timedatectl set-ntp true
		To set the time and date update automatically using Network time protocol.

#########################################################################
Manage one-time jobs with at

at Syntax
		at <time format>

#at Time Format
#at time Increments
#at Specifc date and time
#at Combined Time and Date formats
		- at Time date[hh:mm MMDDYY]

#batch job
		Runs only if the system load average is below 0.8.


#######################################################################
Manage reoccuring user jobs with cron

Types of Cron Jobs

- User Cron Jobs
	- Specific to each user
	- Managed by users
	- Stored in /var/spool/cron/user

- System Cron Jobs
	- System-wide
	- Managed by root
	- Run by the operating system
	- Stored in /etc/cron.d

---crontab------Syntax-----Example--------------

45 23 * * 6 /home/user1/bin/backup.sh

Minute - 45 [0-59]-- */10(every 10 minute)
Hour - 23 [0-23]
Day	- * 
Month	- *
Day of the week	- 6	

Command to run	- /home/user1/bin/backup.sh

-------------------------------------------------

Online Crontab Generator 
crontab-generator.org

OR 
See Man pages 

man 5 crontab

########################################################
Manage reoccuring system jobs with cron

User Cronjobs

- Crontab file specific to each user.
- Managed by normal users. 
- Stored in /var/spool/cron/username

--------editing/creating a cron job---------
 
crontab -e

0 1 * * * rsync -a ~/Documents/	~/Documents.bak

---------------exit------------------------

crontab -l (to list the cron jobs)

learn more about using man crontab
learn more about crontab forman use 
man 5 crontab

#########################################################
Limit access to at and cron

System Cron Jobs

Example:
sudo vi /etc/cron.d/backupdocs

#Enter in Insert mode

0	1	*	*	*	root	rsync -a	/home/user1/Documents/	/home/user1/Documents.bak

#Exit the editing file

Test Cronjob action

- Log in as the user
- Run the desired commands.
- If they work, place them in crontab file. 

Read the man page for crontab 

