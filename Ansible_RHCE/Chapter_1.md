Introduction to RHCE/Ansible

RHCE --RH294 

Ansible-- Automation Tool

-- Intallation
-- Playbook
-- Variables & Loops
-- templates
-- Roles & Certification

Exam: 4 Hrs(1to 10Q)
Marks 300 --210 Passing

--Control/Master Node
	Intall Ansible
	Create a playbook(20 Minutes)
	Execute the playbook(In 30 minutes)-- managing 1000+ servers
	Less chances of Human error
	
Idomptent--Key word

IaC (Infrastrucure as Code)

Ansible is agentless.

							Linux/Unix	--
							Windows		 | Managed
Control Node						Physical/cloud	 | Hosts
(Linux Machine)						Container	--


Server agent = Control Node
Client agent = Managed Host

RHEL to RHEL is agentless.

ssh -- Password
    -- Key based Authentication

Inventory -- Contain all the information like server name, server IP or FQDN for 
		Managed host machines. 


Inventory is used to get the information to Ansible (Control Node)

Modules -- python based commands that are used in Ansible. 
	Action -- mandatory for modules. Optional.

Playbook -- A text file with yaml code with .yml extension. 

Indentation --> spaces/syntax(colon :)

Playbook == usercreation.yml
------------------------------------
Play: description
hosts:server IP/name
tasks:
	name: descriptions
	module:
		action --> doc
------------------------------------

Revise the RUn containers and how to run them. 

Create a new machine with Control Node: Workstation.example.com

Configs for testing:

Control node:
 Memory = 4GB
 CPU = 2 CPU
 Storage= 20GB


Managed Hosts:
Memory = 2GB
CPU = 1
Storage= 10GB
