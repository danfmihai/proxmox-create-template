
Creates a proxmox template using the cloud-init images from Ubuntu,Debian and Centos
Images are pulled from Ubuntu,Debian and Centos mirrors

# Installation
```
git clone https://github.com/danfmihai/proxmox-create-template.git
cd proxmox-create-template/
chmod +x provision.sh
```
# Usage
You need to specify the image type os ex. "ubuntu" "debian" or "centos". If you don't the script will default to ubuntu image.
```
sh provision.sh ubuntu
```
# After provisioning
You can log in to the newly created VMs without password with the default usernames from the default images.
 -For ubuntu image username is: ubuntu
 -For centos image username is: centos
 -For debian image username is: admin