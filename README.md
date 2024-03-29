
# Provisions proxmox template and a new vm from template
[![Proxmox version](https://img.shields.io/badge/Proxmox-6.4-brightgreen)](https://github.com/danfmihai/proxmox-create-template)  
Creates a proxmox template using the cloud-init images from Ubuntu,Debian and Centos.  Images are pulled from Ubuntu,Debian and Centos mirrors.  
Script will assign by default an ubuntu image if no argument is specified at the time the script is ran.  
Will pull the specified image type and create a template and from there a new vm machine.  
The template will have a random ID in the 9000s and the new VM will have the next available ID.
The VM will be linked clone, not full clone.  

# Installation 
```
git clone https://github.com/danfmihai/proxmox-create-template.git
cd proxmox-create-template/
chmod +x provision.sh
chmod +x vm-from-template.sh
```
# Usage 
You need to specify the image type os ex. "ubuntu" "debian" or "centos". If you don't the script will default to ubuntu image.
```
sh provision.sh ubuntu

sh provision.sh centos

sh provision.sh debian

./provision.sh     --- without anyname will default to ubuntu image

```
After you create a template with the ''' provision.sh''' script you can create as many virtual machines from the created template as you want, like this:
```
./vm-from-template.sh 9000 kubemaster
or
./vm-from-template.sh 9000 kubenode01
or
./vm-from-template.sh 9000    ---  without a name will default to the vm-from-tmpl-<YOURTEMPLATEID>

```
# After provisioning
You can log in to the newly created VMs without password with the default usernames from the default images.
 - For ubuntu image username is: ubuntu
 - For centos image username is: centos
 - For debian image username is: debian
 
ex.
 ```
ssh ubuntu@192.168.1.10 (your vm ip)
 ```
To get root access use 
```
sudo -i or sudo su
```

 Reference link:  
[Deploy Proxmox virtual machines using Cloud-init](https://norocketscience.at/deploy-proxmox-virtual-machines-using-cloud-init/)  
[Proxmox - qm - doc](https://pve.proxmox.com/pve-docs/qm.1.html)  
[Proxmox Cloud-Init Support](https://pve.proxmox.com/wiki/Cloud-Init_Support)  

