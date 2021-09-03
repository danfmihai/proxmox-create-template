#!/bin/bash
clear

tpl_id="$1" # template id provided

# defaults 
i_vm=$(shuf -i 200-240 -n 1) # random ip
ip_vm=192.168.102.$i_vm # ip of new vm
gw_vm=192.168.102.1     # gateway
tpl_image_name=$(qm config ${tpl_id} | grep -i name | awk {'print $2'}) # template image name
img_name=$(sed 's/-.*//' <<< ${tpl_image_name}) # get image name from template
not_a_match=false # boolean variable to check if it matches one of the vm numbers in the list

description () {
    
    cat <<EOF
        Proxmox Server Provisioning Virtual Machine from a template
        VM Template ID: ${tpl_id}
        New VM ID: ${vm_no}
        Image name: ${img_name}
        -----------------------------------------------------------------
        # Usage 
        You need to specify the ID of the template for the new virtual machine.
        If you don't the script will exit
        ./vm-from-template.sh 9000 or 
        ./vm-from-template.sh 9027 
        -----------------------------------------------------------------
        For more info: https://github.com/danfmihai/proxmox-create-template 

EOF
}
 
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
          #echo "$vm_no"
          return $vm_no
          break
        fi
      
    done < "$vms"
   }

create_vm () {
    ## This section creates a vm from above template.
    # # Create a virtual machine out of the template - UNCOMMENT FROM HERE DOWN TO ALSO CREATE A VM FROM TEMPLATE!
     qm clone $tpl_id $vm_no --name vm-from-tpl-${tpl_id}
    # # Now you can change the Cloud-init # settings either in the admin ui or with the qm command:
     qm set $vm_no --sshkey ~/.ssh/id_rsa.pub 
     qm set $vm_no --ipconfig0 ip=$ip_vm/24,gw=$gw_vm

    # # Optionally you can start the vm  
     qm start $vm_no
    # # With this command you have # set a public key for SSH authentication and the static IP 192.168.2.100. 
    # # We didn't # set a user which means Ubuntu is using the default one (ubuntu). That's it! 
    # # Your Cloud-Init image should now boot up fine with the desired # settings.
     echo "*********************************"
     echo "The new VM ${1} created with:"
     echo "ip: ${ip_vm}"
     echo "Template image name: " $tpl_image_name
     echo "Uses default username from image: ${img_name} (ex. ubuntu)"
     echo "*********************************"
     echo "Please wait for the vm to start..."
     sleep 20
     qm status ${vm_no}
     echo "Try to login 'ssh ${img_name}@${ip_vm}'"
     echo
}

set_vm_no
description

if [ $# -gt 0 ]; then
    
    number=$(cat ./vms.txt) # get all vm no from vms.txt

    for vm_numbers in $number
    do
        if [ $tpl_id == $vm_numbers ]; then
            create_vm $vm_no
            not_a_match=false
            break
        else 
            not_a_match=true
        fi
    done
        if $not_a_match ; then
            echo "You have not provided a valid TEMPLATE ID! Will exit now. Check your template ID"   
            echo 
        fi
else

    echo "You have not provided a valid TEMPLATE ID! Will exit now. "
    exit

fi    
echo   
# testing 
# echo "$(qm config 9696 | grep -i name | awk {'print $2'} | sed 's/-.*//')"

# cleaning
rm -rf $vms
rm -rf $list_vm
exit


