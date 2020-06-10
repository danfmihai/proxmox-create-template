# proxmox--create-template
Creates a proxmox template using the cloud-init images from Ubuntu,Debian and Centos
Images are pulled from Ubuntu,Debian and Centos mirrors

# Installation
```
git clone https://github.com/danfmihai/proxmox-create-template.git
cd proxmox-create-template/
chmod +x provision.sh
```
# Usage
You need to specify the image type os ex. "ubuntu" "debian" or "centos"
```
sh provision.sh ubuntu
```