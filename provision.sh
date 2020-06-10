#!/bin/bash

# set -x 
#default image type
img_type=
img_filename=bionic-server-cloudimg-amd64.img
img_id=$(shuf -i 9000-9900 -n 1)
i_vm=$(shuf -i 200-240 -n 1)
ip_vm=192.168.102.$i_vm
gw_vm=192.168.102.1
vm_no=200
  
  set_vm_no () {
    list_vm=./list.txt
    vms=./vms.txt
    qm list > $list_vm
    pct list >> $list_vm
    awk {'print $1'} $list_vm | sed '/VMID/d' | sort -r > $vms
    
    i=1
    while IFS= read -r line
    do
        len_line=${#line}
        if [ $len_line -ge 4 ]  
        then
            i=$(( $i + 1 ))
        else    
          vm_no=$(( $line + 1 ))
          echo "$vm_no"
          return $vm_no
          break
        fi
        echo "$len_line char from $line"
        
    done < "$vms"
  }
    
    set_vm_no

    if [ $# -gt 0 ]; then
        img_type="$1"
        echo "Your image selected is ${img_type}"
    
    else
        echo "You have not given an image type os name. (ubuntu,debian or centos)"
        img_type=ubuntu
        echo "The default image '${img_type}' will be used."
        
    fi

    case $img_type in

    "ubuntu" )
        filename=$(basename -- "$img_filename")
        extension="${filename##*.}"
        filename="${filename%.*}"
        img_filename=$filename
        if ls $img_filename* >/dev/null 2>&1; then
            echo "File(s) exits with ${img_type} image."
        else 
            wget https://cloud-images.ubuntu.com/bionic/current/$img_filename.img
        fi
        # (Important for Ubuntu!) Rename your image suffix
        find . -name "*.img" -exec sh -c 'mv "$1" "${1%.img}.qcow2"' _ {} \;
        img_filename=$filename.qcow2
        ;;

    "debian" )
        img_filename=debian-9-nocloud-amd64-daily-20200210-166.qcow2
        if ls $img_filename* >/dev/null 2>&1; then
            echo "File(s) exits with ${img_type} image."
        else
            wget https://cloud.debian.org/images/cloud/stretch/daily/20200210-166/$img_filename
        fi
        ;;

    "centos" )
        img_filename=CentOS-7-x86_64-GenericCloud.qcow2
        if ls $img_filename* >/dev/null 2>&1; then
            echo "File(s) exits with ${img_type} image."
        else 
            wget https://cloud.centos.org/centos/7/images/$img_filename
        fi    
        ;;

     *)
         echo "Wrong name given. Please select an image name like: ubuntu centos or debian as argument"
            ;;
    esac 

   # Define your virtual machine which you're like to use as a template
   qm create $img_id --name "${img_type}-cloudinit-template" --cores 2 --memory 2048 --net0 virtio,bridge=vmbr0
   # Import the disk image in the local Proxmox storage
   qm importdisk $img_id $img_filename pveimages
   # Configure your virtual machine to use the uploaded image
   qm set $img_id --scsihw virtio-scsi-pci --scsi0 pveimages:vm-$img_id-disk-0
   # Adding the Cloud-init image as CD-Rom to your virtual machine
    qm set $img_id --ide2 pveimages:cloudinit
    # Restrict the virtual machine to boot from the Cloud-init image only
    qm set $img_id --boot c --bootdisk scsi0
    # Attach a serial console to the virtual machine 
    # (this is needed for some Cloud-Init distributions, such as Ubuntu)
    qm set $img_id --serial0 socket --vga serial0
    # Finally create a template
    qm template $img_id
    # Create a virtual machine out of the template
    qm clone $img_id $vm_no --name my-${img_type}-${img_id}-vm
    # Now you can change the Cloud-init settings either in the admin ui or with the qm command:
    qm set $vm_no --sshkey ~/.ssh/id_rsa.pub 
    qm set $vm_no --ipconfig0 ip=$ip_vm/24,gw=$gw_vm

    # With this command you have set a public key for SSH authentication and the static IP 192.168.2.100. 
    # We didn't set a user which means Ubuntu is using the default one (ubuntu). That's it! 
    # Your Cloud-Init image should now boot up fine with the desired settings.
    echo "The new VM ${vm_no} created with:"
    echo "ip: ${ip_vm}"
    echo "Uses default username: ${img_type}"
    
    # set +x
