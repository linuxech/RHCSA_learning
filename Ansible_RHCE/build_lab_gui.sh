#!/bin/bash
# Description: Automated RHEL 9 KVM Lab Builder (GUI Nodes)

# === UPDATE THIS LINE ===
ISO_PATH="/home/your_user/Downloads/rhel-baseos-9.3-x86_64-dvd.iso"
# ========================

if [[ $EUID -ne 0 ]]; then
   echo "❌ This script must be run as root (use sudo)." 
   exit 1
fi

echo "🚀 Starting Automated RHEL GUI Lab Build..."
echo "------------------------------------------------"

read -p "Enter your Red Hat Developer Username: " RH_USER
read -s -p "Enter your Red Hat Developer Password: " RH_PASS
echo -e "\n------------------------------------------------"

SERVERS=("server_a" "server_b" "server_c")

for VM in "${SERVERS[@]}"; do
    echo "⚙️ Generating Kickstart file for $VM..."
    
    cat <<EOF > /tmp/${VM}_ks.cfg
# RHEL 9 Kickstart Configuration
lang en_US.UTF-8
keyboard us
timezone UTC
# Use graphical install mode
graphical
eula --agreed
reboot

# Force the system to boot into the graphical desktop
xconfig --startxonboot

# Network Configuration
network --bootproto=dhcp --device=link --activate --hostname=${VM}.lab.local

# Storage Configuration (10GB Auto-LVM)
clearpart --all --initlabel
autopart --type=lvm

# Security & Users
rootpw --lock
user --name=student --groups=wheel --password=TempPass123 --plaintext

%packages
# Install the full GNOME Server GUI
@^graphical-server-environment
python3
%end

%post --log=/root/ks-post.log
chage -d 0 student
subscription-manager register --username="${RH_USER}" --password="${RH_PASS}" --auto-attach
%end
EOF

    echo "🏗️ Launching $VM in the background..."
    
    # Run virt-install with graphics enabled
    virt-install \
        --name "$VM" \
        --memory 4096 \
        --vcpus 1 \
        --disk size=10,pool=default \
        --location "$ISO_PATH" \
        --os-variant rhel9.0 \
        --initrd-inject "/tmp/${VM}_ks.cfg" \
        --extra-args="inst.ks=file:/${VM}_ks.cfg" \
        --network network=default \
        --graphics spice,listen=none \
        --noautoconsole

    echo "✅ $VM GUI provisioning started!"
    echo "------------------------------------------------"
done

echo "🎉 All GUI virtual machines are building."
echo "Use 'virt-manager' to view their screens."
