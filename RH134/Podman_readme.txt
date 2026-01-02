When creating a container ensure you proceed with the following steps when working in podman. 
podman ps 	\It will display the running containers. 
podman ps -a	\It will display all the running containers. 
podman create --name container-name FilePath_or_ImageID	\ To create container using Image
podman pod rm -f podname	\To delete the pod
A pod is group of containers that shares the same network configuration for all the memeber containers. 
podmane pod ps 		\ to check the satus of pod
podman rm  \ to remove the container
podman rmi imagename \ to remove/delete the image


#######How to create the container with specific port number #########
podman run -d \
  --name batman-container \
  -p 8080:8080 \
  docker.io/lovelearnlinux/batman
########################################################

Ensure to run teh podman as root, or else the container will use the Host IP. 

Port Mapping
Port mapping (or port forwarding) is a networking technique that redirects traffic from one port number on a network device (like a router or firewall) to
a specific port on another device within a private network, allowing external access to internal services like web servers, gaming, or remote desktop, even
when hidden behind NAT.


podman inspect File-pAth of Image	\To enter in the image file and gather the expose port number

Port Mapping
##This command will create and run the container at once####
podman run -d --name Container-name -p 8081:80 FilePath 	\To run and create the container in the background and mapping the port 80 to 8081

podman cp source_file destination

Tes to use Nginx for practice
 When you delete a container, it will also delete the data. 

######Volume Mount in Container#################
You will need to label the volume in local host, to ensure it will connect with Container. 
Z to highlight the SELinux. This will help you to keep the data in local system but share that volume with container. 

podman run -d -p 8082:80 -v /var/www/html: usr/share/nginx/html:Z docker.io/library/nginx:latest
				|		|		|	
			   Local  Host     Container	     SeLinux
Ensure to enter name to the above command. 

Using this method you can ensure that the users can access the webpages with the same ip address, without assigning the httpd a new IP for the users. 
Ensure to test and practice the same. 


What can we do to automatically start the contaieners as default when the system is restarted?

mkdir -p .config/systemd/user
cd .config/systemd/user/
podman generate systemd --name web-page --files --new	\This will generate a file which will be assocated with container service
systemctl --user daemon-relaod
systemctl --user enable --now container-web-page.service

##Observe the outcome. 
