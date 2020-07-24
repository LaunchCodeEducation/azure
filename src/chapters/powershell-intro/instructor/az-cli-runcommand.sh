#! /usr/bin/env bash

vm_name=$(az vm show --query "name" -o tsv)


# az vm run-command invoke --command-id RunShellScript -n "$vm_name" --scripts "@configure-vm.sh" --query "value[0].message"
# az vm run-command invoke --command-id RunShellScript -n "$vm_name" --scripts "@configure-ssl.sh" --query "value[0].message" 
# az vm run-command invoke --command-id RunShellScript -n "$vm_name" --scripts @deliver-deploy.sh --query "value[0].message"

scripts=(configure-vm.sh configure-ssl.sh deliver-deploy.sh)

for script in "${scripts[@]}"; do
   output_file="/tmp/${script}.out"
   echo "writing output to $output_file"

   az vm run-command invoke --command-id RunShellScript -n "$vm_name" --scripts "@$script" --query "value[0].message" -o tsv > "$output_file"
done