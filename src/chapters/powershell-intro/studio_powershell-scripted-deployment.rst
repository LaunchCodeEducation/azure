======================================================
Studio: PowerShell Scripted CodingEventsAPI Deployment
======================================================

In our studio today we will be using PowerShell to script a complete deployment of the CodingEventsAPI to a Linux VM.

You will write a script that provisions and configures all of the Azure resources we will need for this deployment. Luckily this will be similar to what we did in the Azure CLI chapter. We will simply be combining all of those steps, and our newfound PowerShell skills to perform this task.

Some of the scripts will be provided for you, but it would be in your best interest to read over them, and try to understand what they are doing.

Before we get to writing our PowerShell script for our deployment, let's take a look at the BASH deployment script we saw at the end of the Azure CLI chapter.

.. ::

  - They saw the BASH deployment script (but it never ran)
  - they saw the AZ CLI stuff (so they are familiar with provisioning resources from command line)

  - they will be provided the RunCommand scripts (configure-vm, configure-ssl, deliver-deploy)
  - they will be required to create the azureProvisionScript (az-cli-script.ps1)

  - TAs and instructor will have access to the solution scripts and will see the full deployment in action. They will provide you assistance when you get stuck.

Bash Script Breakdown
=====================

You saw this script earlier, so instead of breaking down every single line, we will organize it into it's major points.

.. the full breakdown needs to happen as the last part of the Azure CLI chapter we will show them the BASH deployment script, and break it down in the article. Here we will just need to hit some key points to help the students form a mental model of the tasks (and their order) they will need to accomplish with their script.

Let's consider the BASH deployment script we saw at the end of the Azure CLI chapter:

.. sourcecode:: bash
   :caption: bash az cli deployment

   #! /usr/bin/env bash

   set -e

   # --- start ---

   # variables

   # TODO: enter your name here in place of 'student'
   student_name=student

   # !! do not edit below !!

   rg_name="${student_name}-cli-scripting-rg"

   # -- vm
   vm_name="${student_name}-cli-scripting-vm"

   vm_admin_username=student
   vm_admin_password='LaunchCode-@zure1'

   vm_size=Standard_B2s
   vm_image=$(az vm image list --query "[? contains(urn, 'Ubuntu')] | [0].urn" -o tsv)

   # -- kv
   kv_name="${student_name}-cli-scripting-kv"
   kv_secret_name='ConnectionStrings--Default'
   kv_secret_value='server=localhost;port=3306;database=coding_events;user=coding_events;password=launchcode'

   # set az location default

   # az configure --default location=eastus

   # # RG: provision

   # az group create -n "$rg_name"

   # # set az rg default

   # az configure --default group=$rg_name

   # VM: provision

   # capture vm output for splitting
   vm_data=$(az vm create -n $vm_name --size $vm_size --image $vm_image --admin-username $vm_admin_username --admin-password $vm_admin_password --authentication-type password --assign-identity --query "[ identity.systemAssignedIdentity, publicIpAddress ]" -o tsv)

   # vm value is (2 lines):
   # <identity line>
   # <public IP line>

   # get the 1st line (identity)
   vm_id=$(echo "$vm_data" | head -n 1)
   # get the 2nd line (ip)
   vm_ip=$(echo "$vm_data" | tail -n +2)

   # set az vm default

   az configure --default vm=$vm_name

   # KV: provision

   az keyvault create -n $kv_name --enable-soft-delete false --enabled-for-deployment true

   # KV: set secret

   az keyvault secret set --vault-name $kv_name --description 'connection string' --name $kv_secret_name --value $kv_secret_value

   # VM: add NSG rule for port 443 (https)

   az vm open-port --port 443

   # VM: grant access to KV

   az keyvault set-policy --name $kv_name --object-id $vm_id --secret-permissions list get

   # VM setup-and-deploy script

   # az vm run-command invoke --command-id RunBashScript --scripts vm-setup-and-deploy.sh

   # finished print out IP address

   echo "VM available at $vm_ip"

   # --- end ---

Declare Variables
-----------------

Provision Resource Group
------------------------

Provision Virtual Machine
-------------------------

Capture Virtual Machine's System Assigned Identity
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create Appropriate Network Security Groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Provision Key Vault
-------------------

Set Key Vault Secret
^^^^^^^^^^^^^^^^^^^^

Set Key Vault Access Policy
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Send Bash Scripts to VM via RunCommand
--------------------------------------



.. ::

  - we will dissect the bash deployment script what are all the things it's doing?
  - sections as subheaders: (provision RG, provision VM, set VM assigned identity variable, provision KV, kv set-access policy using vm assigned identity, configure vm, configure ssl, deliver-deploy)
  - there is some less than desirable code in these scripts (getting the VM assigned identity, keeping track of the VM ip, the variables are all strings) these are limitations of Bash, that we don't have in PowerShell. In ps we would be able to store these variables as objects, and access their properties with .notation, since the output comes in as an object, we can easily access the System Assigned Identity, get the VM public IP address, etc

Your Tasks
==========

Create a script (azureProvisionScript.ps1) that accomplishes the following:

- set variables
- provision RG
- provision VM
  - will need to use the correct image URN, size, authentication-type, admin-username, admin-password, assign-identity
- capture vm.identity.systemAssignedIdentity
- open vm port 443
- provision KV
- create KV secret (database connection string)
- set KV access-policy (using the vm.identity.systemAssignedIdentity)
- send 3 bash scripts to the VM using az vm run-command invoke:
  - configure-vm.sh
  - configure-ssl.sh
  - deliver-deploy.sh

Limited Guidance
================

- you will want to use variables -- you will want to capture the output of az cli commands in a variable or file

.. sourcecode:: powershell
   :caption: capture az CLI output in variable

   > $someVariable = az vm create -n .....

   > $someVariable.someProperty

.. sourcecode:: powershell
   :caption: capture az CLI output in JSON file

   > az vm create -n .... | Set-Content virtualMachine.json

.. sourcecode:: powershell
   :caption: load JSON file into a PS variable

   > $virtualMachine = Get-Content virtualMachine.json | ConvertFrom-Json

   > $virtualMachine.someProperty

Saving the output as a file will allow you to keep the data for as long as you need, if you store it only as a variable if you close your PowerShell session you will lose the data.

- example az vm run-command invoke examples: