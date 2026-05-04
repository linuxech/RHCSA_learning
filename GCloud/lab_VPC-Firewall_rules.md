Steps for Adding VPC and Firewall rules via CLI

Activate Cloud Shell
Cloud Shell is a virtual machine that is loaded with development tools. It offers a persistent 5GB home directory and runs on the Google Cloud. Cloud Shell provides command-line access to your Google Cloud resources.

Click Activate Cloud Shell Activate Cloud Shell icon at the top of the Google Cloud console.

Click through the following windows:

Continue through the Cloud Shell information window.
Authorize Cloud Shell to use your credentials to make Google Cloud API calls.
When you are connected, you are already authenticated, and the project is set to your Project_ID, qwiklabs-gcp-02-848a5c69a967. The output contains a line that declares the Project_ID for this session:

Your Cloud Platform project in this session is set to qwiklabs-gcp-02-848a5c69a967
gcloud is the command-line tool for Google Cloud. It comes pre-installed on Cloud Shell and supports tab-completion.

(Optional) You can list the active account name with this command:
gcloud auth list
Copied!
Click Authorize.
Output:

ACTIVE: *
ACCOUNT: student-00-ebc9b499962d@qwiklabs.net

To set the active account, run:
    $ gcloud config set account `ACCOUNT`
(Optional) You can list the project ID with this command:
gcloud config list project
Copied!
Output:

[core]
project = qwiklabs-gcp-02-848a5c69a967
Note: For full documentation of gcloud, in Google Cloud, refer to the gcloud CLI overview guide.
Understanding Regions and Zones
Certain Compute Engine resources live in regions or zones. A region is a specific geographical location where you can run your resources. Each region has one or more zones. For example, the us-central1 region denotes a region in the Central United States that has zones us-central1-a, us-central1-b, us-central1-c, and us-central1-f.

Regions	Zones
Western US	us-west1-a, us-west1-b
Central US	us-central1-a, us-central1-b, us-central1-d, us-central1-f
Eastern US	us-east1-b, us-east1-c, us-east1-d
Western Europe	europe-west1-b, europe-west1-c, europe-west1-d
Eastern Asia	asia-east1-a, asia-east1-b, asia-east1-c
Resources that live in a zone are referred to as zonal resources. Virtual machine Instances and persistent disks live in a zone. To attach a persistent disk to a virtual machine instance, both resources must be in the same zone. Similarly, if you want to assign a static IP address to an instance, the instance must be in the same region as the static IP.

Learn more about regions and zones and see a complete list in the Compute Engine page, Regions and zones documentation).
Set your region and zone
Run the following gcloud commands in Cloud Shell to set the default region and zone for your lab:

gcloud config set compute/zone "us-central1-c"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "us-central1"
export REGION=$(gcloud config get compute/region)
Copied!
Task 1. Create custom network with Cloud Shell
Create a network called taw-custom-network and define the option to be able to add your own subnetworks to it by using the --subnet-mode custom flag.

Create the custom network:
gcloud compute networks create taw-custom-network --subnet-mode custom
Copied!
Output:

NAME                MODE    IPV4_RANGE  GATEWAY_IPV4
taw-custom-network  custom

Instances on this network will not be reachable until firewall rules
are created. As an example, you can allow all internal traffic between
instances as well as SSH, RDP, and ICMP by running:

$ gcloud compute firewall-rules create <firewall_name> --network taw-custom-network --allow tcp,udp,icmp --source-ranges <ip_range>
$ gcloud compute firewall-rules create <firewall_name> --network taw-custom-network --allow tcp:22,tcp:3389,icmp
</firewall_name></ip_range></firewall_name>
Now create three subnets for your new custom network. In each command you'll specify the region for the subnet and the network it belongs to.

Create subnet-us-central1 with an IP prefix:
gcloud compute networks subnets create subnet-us-central1 \
   --network taw-custom-network \
   --region us-central1 \
   --range 10.0.0.0/16
Copied!
Output:

Created [https://www.googleapis.com/compute/v1/projects/cloud-network-module-101/regions/us-central1/subnetworks/subnet-us-central1].
NAME               REGION       NETWORK             RANGE
subnet-us-central1  us-central1 taw-custom-network  10.0.0.0/16
Create subnet-us-west1 with an IP prefix:
gcloud compute networks subnets create subnet-us-west1 \
   --network taw-custom-network \
   --region us-west1 \
   --range 10.1.0.0/16
Copied!
Output:

Created [https://www.googleapis.com/compute/v1/projects/cloud-network-module-101/regions/us-west1/subnetworks/subnet-us-west1].
NAME                REGION        NETWORK             RANGE
subnet-us-west1  us-west1  taw-custom-network  10.1.0.0/16
Create subnet-us-east1 with an IP prefix:
gcloud compute networks subnets create subnet-us-east1 \
   --network taw-custom-network \
   --region us-east1 \
   --range 10.2.0.0/16
Copied!
Output:

Created [https://www.googleapis.com/compute/v1/projects/cloud-network-module-101/regions/us-east1/subnetworks/subnet-us-east1].
NAME                REGION        NETWORK             RANGE
subnet-us-west1    us-west1  taw-custom-network  10.2.0.0/16
List your networks:
gcloud compute networks subnets list \
   --network taw-custom-network
Copied!
Output:

NAME                REGION        NETWORK             RANGE
subnet-us-east1    us-east1    taw-custom-network  10.1.0.0/16
subnet-us-west1  us-west1  taw-custom-network  10.2.0.0/16
subnet-us-central1  us-central1   taw-custom-network  10.0.0.0/16
Assessment Completed!
Create a custom network and subnetworks
Assessment Completed!
At this point, the network has routes to the Internet and to any instances you create. But, it has no firewall rules allowing access to instances, even from other instances.

To allow access, you must create firewall rules.

Task 2. Add firewall rules
To allow access to virtual machine (VM) instances, you must apply firewall rules. You will use a network tag to apply the firewall rule to your VM instances.

Network tags are powerful tools for managing firewall rules across groups of VM instances. Imagine you have a cluster of VMs powering a website. Instead of manually configuring firewall rules for each individual instance, you can simply apply a tag like "web-server" to all the relevant VMs. Then, create a firewall rule that allows HTTP traffic to any instance with the "web-server" tag. This approach not only simplifies firewall management but also provides flexibility, allowing you to easily update access control by modifying the tag-based rule.

Note: Tags are also reflected in the metadata server, so you can use them for applications running on your instances.
Start by opening the firewall to allow HTTP Internet requests, then add more firewall rules.

Add firewall rules using Cloud Shell
Now add a firewall rule called nw101-allow-http for the taw-custom-network that will only apply to VMs in the network with the tag http.

Run the following to create the firewall rule:
gcloud compute firewall-rules create nw101-allow-http \
--allow tcp:80 --network taw-custom-network --source-ranges 0.0.0.0/0 \
--target-tags http
Copied!
Output:

The output wherein the name is nw101-allow-http, the network is taw-custom-network, direction is ingress, priority level is 1000, and allow status is tcp:80

Create additional firewall rules
Create additional firewall rules to allow ICMP, internal communication, SSH, and RDP.

Create more firewall rules with the commands below.
ICMP
gcloud compute firewall-rules create "nw101-allow-icmp" --allow icmp --network "taw-custom-network" --target-tags rules
Copied!
Internal Communication
gcloud compute firewall-rules create "nw101-allow-internal" --allow tcp:0-65535,udp:0-65535,icmp --network "taw-custom-network" --source-ranges "10.0.0.0/16","10.2.0.0/16","10.1.0.0/16"
Copied!
SSH
gcloud compute firewall-rules create "nw101-allow-ssh" --allow tcp:22 --network "taw-custom-network" --target-tags "ssh"
Copied!
RDP
gcloud compute firewall-rules create "nw101-allow-rdp" --allow tcp:3389 --network "taw-custom-network"
Copied!
Use the console to review the firewall rules in your network. It should look like this:
The Firewall rules tabbed page on the VPC network details dialog

Note: What about those Routes I see in the Network console?
Google Cloud Networking uses Routes to direct packets between subnetworks and to the Internet. Whenever a subnetwork is created (or pre-created) in your Network, routes are automatically created in each region to allow packets to route between subnetworks. These cannot be modified.
Additional Routes can be created to send traffic to an instance, a VPN gateway, or default internet gateway. These Routes can be modified to tailor the desired network architecture. Routes and Firewalls work together to ensure your traffic gets where it needs to go.
Click Check my progress to verify the objective.

Assessment Completed!
Create firewall rules
Assessment Completed!
When you create VMs in your network, you'll create them with the tag that corresponds to the appropriate firewall rule. The firewall rule will allow internet traffic to them, and the VMs will be able to communicate across your network.

