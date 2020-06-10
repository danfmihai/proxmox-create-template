#!/bin/bash
set -x

get_vm_number () {
    local used_vms=()
    local count
    local list_vm=./list.txt
    qm list > $list_vm
    pct list >> $list_vm
    used_vms=($(awk {'print $1'} $list_vm | sed '/VMID/d' | sort)) 
    echo "${used_vms[*]}"
    
    #mapfile -t used_vms
    # get the total numbers of Vms
    count=${#used_vms[@]}
    count=$(($count - 1 ))
    # delete the one that has 4 characters
    del=0
    while [ $del -le $count ]; do
        chrlen=${#used_vms[$del]}
        echo "$chrlen"
        if [ $chrlen -ge 4 ] ;then
            unset used_vms[$del]
            #used_vms=("$used_vms[@]/$del")
            used_vms=( "${used_vms[@]}" )
        fi 
        echo "${used_vms[$del]}"
        del=$(( $del + 1 ))
    done      
    
    count=${#used_vms[@]}
    #assign a new vm id to vm_no (3 chars)
    echo "${used_vms[count-1]}"
    vm_no=$((used_vms[count-1] +1))
    echo "$vm_no"
    retun $vm_no
}

get_vm_number

echo "$vm_no"

set +x