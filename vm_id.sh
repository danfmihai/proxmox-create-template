#!/bin/bash
#set -x

set_vm_no () {
    list_vm=./vms.txt
    vms=./vms.txt
    #qm list > $list_vm
    #pct list >> $list_vm
    #awk {'print $1'} $list_vm | sed '/VMID/d' | sort -r > $vms
    
    input="./list.txt"
    i=1
    while IFS= read -r line
    do
        
        #prev_vm=( "$line" "${prev_vm[@]}" )
        len_line=${#line}
        echo "Line $i with vm no $line"
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
        
    done < "$input"

 return $vm_no
}
set_vm_no

echo "New VM is $vm_no"



echo "$vm_no"

#set +x