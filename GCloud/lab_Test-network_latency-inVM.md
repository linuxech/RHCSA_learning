The next steps are to create a VM in each subnet and make sure you can connect to them.

Task 1. Connect VMs and check latency
For this task you will create a virtual machine in each zone. Each machine will use network tags that the firewall rules need to allow network traffic.

Run this commands to create an instance named us-test-01 in the subnet-us-east4 subnet:
gcloud compute instances create us-test-01 \
--subnet subnet-us-east4 \
--zone us-east4-c \
--machine-type e2-standard-2 \
--tags ssh,http,rules
Copied!
Be sure to note the external IP for later use in this lab.

Output:

Created [https://www.googleapis.com/compute/v1/projects/cloud-network-module-101/zones/us-east4-c/instances/us-test-01].
NAME        ZONE           MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP     STATUS
us-test-01  us-east4-c  e2-standard-2              10.0.0.2     104.198.230.22  RUNNING
Now make the us-test-02 and us-test-03 VMs in their correlated subnets:
gcloud compute instances create us-test-02 \
--subnet subnet-us-central1 \
--zone us-central1-b \
--machine-type e2-standard-2 \
--tags ssh,http,rules
Copied!
gcloud compute instances create us-test-03 \
--subnet subnet-europe-west1 \
--zone europe-west1-b \
--machine-type e2-standard-2 \
--tags ssh,http,rules
Copied!
Click Check my progress to verify the objective.

Assessment Completed!
Create three instances in specified zones for Traceroute and performance testing.
Assessment Completed!
Verify you can connect your VM
Now do a few exercises to test the connection to your VMs. Use ping to test the reachability of a host and measure the round-trip time for messages sent from the originating host to the destination computer.

Switch back to the Console and navigate to Compute Engine.

Click the SSH button corresponding to the us-test-01 instance. This opens an SSH connection to the instance in a new window.

In the SSH window of us-test-01, type the following command to use an ICMP (Internet Control Message Protocol) echo against us-test-02, adding the external IP address for the VM in-line:

ping -c 3 <us-test-02-external-ip-address>
Copied!
You can locate the external IP of your virtual machines in the Compute Engine browser tab under the External IP field.

Note:Your IP addresses will differ from the picture.
Run this command to use an ICMP echo against us-test-03, adding the external IP address for the VM in-line:
ping -c 3 <us-test-03-external-ip-address>
Copied!
Example output:

PING 35.187.149.67 (35.187.149.67) 56(84) bytes of data.
64 bytes from 35.187.149.67: icmp_seq=1 ttl=76 time=152 ms
64 bytes from 35.187.149.67: icmp_seq=2 ttl=76 time=152 ms
64 bytes from 35.187.149.67: icmp_seq=3 ttl=76 time=152 ms
Now check that SSH also works for instances us-test-02 and us-test-03. Try an ICMP echo against us-test-01.
Use ping to measure latency
Latency refers to the time it takes for a data packet to travel from its source to its destination and back. It's typically measured in milliseconds (ms).

Use ping to measure the latency between these regions - run the following command after opening an SSH window on the us-test-01:
ping -c 3 us-test-02.us-central1-b
Copied!
Command output:

PING us-test-02.us-central1-b.c.cloud-network-module-101.internal (10.2.0.2) 56(84) bytes of data.
64 bytes from us-test-02.us-central1-b.c.cloud-network-module-101.internal (10.2.0.2): icmp_seq=1 ttl=64 time=105 ms
64 bytes from us-test-02.us-central1-b.c.cloud-network-module-101.internal (10.2.0.2): icmp_seq=2 ttl=64 time=104 ms
64 bytes from us-test-02.us-central1-b.c.cloud-network-module-101.internal (10.2.0.2): icmp_seq=3 ttl=64 time=104 ms
The latency you get back is the "Round Trip Time" (RTT) - the time the packet takes to get from us-test-01 to us-test-02.

To test connectivity, ping uses the ICMP Echo Request and Echo Reply Messages.

Note: Things to think about
What is the latency you see between regions? What is special about the connection from `us-test-02` to `us-test-03`?
Note: Internal DNS: How is DNS provided for VM instances?
Each instance has a metadata server that also acts as a DNS resolver for that instance. DNS lookups are performed for instance names. The metadata server itself stores all DNS information for the local network and queries Google's public DNS servers for any addresses outside of the local network.
An internal fully qualified domain name (FQDN) for an instance looks like this: hostName.[ZONE].c.[PROJECT_ID].internal .
You can always connect from one instance to another using this FQDN. If you want to connect to an instance using, for example, just `hostName`, you need information from the internal DNS resolver that is provided as part of Compute Engine.
Task 2. Traceroute and Performance testing
Traceroute is a tool to trace the path between two hosts. A traceroute can be a helpful first step to uncovering many different types of network problems. Support or network engineers often ask for a traceroute when diagnosing network issues.

Note: Functionality
Traceroute shows all Layer 3 (routing layer) hops between the hosts. This is achieved by sending packets to the remote destination with increasing TTL (Time To Live) value (starting at 1). The TTL field is a field in the IP packet which gets decreased by one at every router. Once the TTL hits zero, the packet gets discarded and a "TTL exceeded" ICMP message is returned to the sender. This approach is used to avoid routing loops; packets cannot loop continuously because the TTL field will eventually decrement to 0. By default the OS sets the TTL value to a high value (64, 128, 255 or similar), so this should only ever be reached in abnormal situations.
So traceroute sends packets first with TTL value of 1, then TTL value of 2, etc., causing these packets to expire at the first/second/etc. router in the path. It then takes the source IP/host of the ICMP TTL exceeded message returned to show the name/IP of the intermediate hop. Once the TTL is high enough, the packet reaches the destination, and the destination responds.
The type of packet sent varies by implementation. Under Linux, UDP packets are sent to a high, unused port. So the final destination responds with an ICMP Port Unreachable. Windows and the mtr tool by default use ICMP echo requests (like ping), so the final destination answers with an ICMP echo reply.
Try it out by setting up a traceroute on one of your virtual machines.

For this step, use the us-test-01 VM and us-test-02 VM and SSH into both of them.

Install these performance tools in the SSH window for us-test-01:

sudo apt-get update
sudo apt-get -y install traceroute mtr tcpdump iperf whois host dnsutils siege
Copied!
Now use traceroute with www.icann.org and see how it works:
traceroute www.icann.org
Copied!
In your output, each line represents a hop.

first column: shows the hop number.
second column: shows the IP address (or hostname, if available) of the hop.
remaining columns: show the RTT for additional packets sent to that hop.
Now try a few other destinations and also from other sources:

VMs in the same region or another region (eu1-vm, asia1-vm, w2-vm)
www.wikipedia.org
www.adcash.com
bad.horse (works best if you increase max TTL, so run traceroute -m 255 bad.horse)
Anything else you can think of
To stop traceroute, Ctrl+c in the SSH window and return to the command line.

Note: Things to think about
What do you notice with the different traceroutes?
Assessment Completed!
Traceroute and Performance testing.
Assessment Completed!
Task 3. Use iperf to test performance
iperf measures network throughput and latency. When you use iperf to test the performance between two hosts, one side needs to be set up as the iperf server to accept connections.

Note: The following commands transfer Gigabytes of traffic between regions, which is charged at Internet egress rates. Be mindful of this when using them. If you are not on a allowlisted project, or in the free trial, you might want to skip, or only skim, this section. (Costs should be less than $1 USD.)
SSH into us-test-02 and install the performance tools:
sudo apt-get update

sudo apt-get -y install traceroute mtr tcpdump iperf whois host dnsutils siege
Copied!
SSH into us-test-01 and run:
iperf -s #run in server mode
Copied!
On us-test-02 SSH run this iperf:
iperf -c us-test-01.us-east4-c #run in client mode
Copied!
You will see some output like this:

Client connecting to eu-vm, TCP port 5001
TCP window size: 45.0 KByte (default)
[  3] local 10.20.0.2 port 35923 connected with 10.30.0.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   298 MBytes   249 Mbits/sec
On us-test-01 use Ctrl + c to exit the server side when you're done.
Between VMs within a region
Now you'll deploy another instance (us-test-04)in a different zone than us-test-01. You will see that within a region, the bandwidth is limited by the 2 Gbit/s per core egress cap.

In Cloud Shell, create us-test-04:
gcloud compute instances create us-test-04 \
--subnet subnet-us-east4 \
--zone us-east4-c \
--machine-type=e2-standard-2 \
--tags ssh,http
Copied!
SSH to us-test-04 and install performance tools:
sudo apt-get update

sudo apt-get -y install traceroute mtr tcpdump iperf whois host dnsutils siege
Copied!
Between regions you reach much lower limits, mostly due to limits on TCP window size and single stream performance. You can increase bandwidth between hosts by using other parameters, like UDP.

On us-test-02 SSH run:
iperf -s -u #iperf server side
Copied!
On us-test-01 SSH run:
iperf -c us-test-02.us-central1-b -u -b 2G #iperf client side - send 2 Gbits/s
Copied!
This should be able to achieve a higher speed between EU and US. Even higher speeds can be achieved by running a bunch of TCP iperfs in parallel. Let's test this.

In the SSH window for us-test-01 run:
iperf -s
Copied!
In the SSH window for us-test-02 run:
iperf -c us-test-01.us-east4-c -P 20
Copied!
The combined bandwidth should be really close to the maximum achievable bandwidth.

Click Check my progress to verify the objective.

Assessment Completed!
Test the performance.
Assessment Completed!
Test a few more combinations. If you use Linux on your laptop you can test against your laptop as well. (You can also try iperf3 which is available for many OSes, but this is not part of the lab.)
As you can see, to reach the maximum bandwidth, just running a single TCP stream (for example, file copy) is not sufficient; you need to have several TCP sessions in parallel. Reasons are: TCP parameters such as Window Size; and functions such as Slow Start.

For more information on this and all other TCP/IP topics, refer to TCP/IP Illustrated.

Tools like bbcp can help to copy files as fast as possible by parallelizing transfers and using configurable window size.

