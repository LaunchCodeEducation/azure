======================================================
Studio: PowerShell Scripted CodingEventsAPI Deployment
======================================================

In our studio today we will be using PowerShell to script a complete deployment of the CodingEventsAPI to a Linux VM.

You will write a script that provisions and configures all of the Azure resources we will need for this deployment. Luckily this will be similar to what we did in the Azure CLI chapter. We will simply be combining all of those steps, and our newfound PowerShell skills to perform this task.

Some of the scripts will be provided for you, but it would be in your best interest to read over them, and try to understand what they are doing.

Before we get to writing our PowerShell script for our deployment, let's take a look at the BASH deployment script we saw at the end of the Azure CLI chapter.

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

   az configure --default location=eastus

   # # RG: provision

   az group create -n "$rg_name"

   # # set az rg default

   az configure --default group=$rg_name

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

   # VM: add NSG rule for port 443 (https)

   az vm open-port --port 443

   # set az vm default

   az configure --default vm=$vm_name

   # KV: provision

   az keyvault create -n $kv_name --enable-soft-delete false --enabled-for-deployment true

   # KV: set secret

   az keyvault secret set --vault-name $kv_name --description 'connection string' --name $kv_secret_name --value $kv_secret_value

   # KV: grant access to KV

   az keyvault set-policy --name $kv_name --object-id $vm_id --secret-permissions list get

   # VM setup-and-deploy script

   # az vm run-command invoke --command-id RunShellScript --scripts vm-setup-and-deploy.sh

   # finished print out IP address

   echo "VM available at $vm_ip"

   # --- end ---

Declare Variables
-----------------

The Bash script first declares a suite of variables:

- student_name
- rg_name
- vm_name
- vm_admin_username
- vm_admin_password
- vm_size
- vm_image
- kv_name
- kv_secret_name
- kv_secret_value

These variables are used throughout the script. As you can see most of them are used as the parameters for provisioning our Azure resources. All of the name variables use the underlying ``student_name`` variable to create a consist naming pattern. This allows us to easily spin up a new stack by changing this one variable, it is a single source of truth.

Provision Resource Group
------------------------

After our variables we start provisioning our Azure resources using the AZ CLI. Recall that the AZ CLI is cross-platform, these commands will work the same regardless of the underlying operating system.

First up is our Resource Group. It must be provisioned before any of our other resources are provisioned, because it's the container that holds all the other resources. All we have to provide is the resource group name. These names must be unique to your account, so make sure the variable being used doesn't match any resource group names that currently exist in your Azure subscription.

Provision Virtual Machine
-------------------------

After the Resource Group we have some flexibility. We could spin up the key vault or virtual machine first, however consider the dependencies. We will eventually need to set an access policy on our key vault that includes information about our virtual machine. For this reason it makes more sense to provision the virtual machine first since our key vault will need some information about our virtual machine.

Capture Virtual Machine's System Assigned Identity
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Upon creating our virtual machine we store the output from the command in a Bash variable. We do this because we are going to do some Bash scripting to extract the information we need:

- the virtual machine system managed identity
- the virtual machine public ip address

Create Appropriate Network Security Groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

While we are working with our VM let's go ahead and open the ports necessary for a user to gain access to our CodingEventsAPI that will eventually be housed on this VM.

The az cli provides a easy to use tool for opening whatever ports we need, in this case 443 (HTTPS).

Provision Key Vault
-------------------

Now that we have a VM and have captured the information we need to create an access policy for a key vault we can provision it next.

First up, provisioning the key vault!

Set Key Vault Secret
^^^^^^^^^^^^^^^^^^^^

After the key vault exists we can add whatever secrets our application will need to run. In this case we only have one secret, a database connection string, we give this secret a name, a key, and a value.

Set Key Vault Access Policy
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Finally we use the variable we created earlier that contains the Virtual Machine system assigned identity to create an access policy that grants the VM permission to use our provisioned key vault.

Send Bash Scripts to VM via RunCommand
--------------------------------------

Now that all of our infrastructure has been provisioned, we need to finish configuring our VM. It will need to have dependencies installed, nginx configured and setup, a user and database created within MySQL, the souce code needs to be delivered, and finally deployed.

These bash scripts are provided for you, however you should look over them as they are commented with what they are doing. Many of the tasks they accomplish go beyond the scope of this course, but are a necessary part of our deployment.

Print Public IP Address to STDOUT
---------------------------------

As a final step to make things easier for us, we print the public IP address to the console to make it easier for us to connect to our deployed application from a web browser.


.. ::

  - we will dissect the bash deployment script what are all the things it's doing?
  - sections as subheaders: (provision RG, provision VM, set VM assigned identity variable, provision KV, kv set-access policy using vm assigned identity, configure vm, configure ssl, deliver-deploy)
  - there is some less than desirable code in these scripts (getting the VM assigned identity, keeping track of the VM ip, the variables are all strings) these are limitations of Bash, that we don't have in PowerShell. In ps we would be able to store these variables as objects, and access their properties with .notation, since the output comes in as an object, we can easily access the System Assigned Identity, get the VM public IP address, etc

Your Tasks
==========

Create a script (azureProvisionScript.ps1) that accomplishes the following:

#. set variables
#. provision RG
#. provision VM
#. capture vm.identity.systemAssignedIdentity
#. open vm port 443
#. provision KV
#. create KV secret (database connection string)
#. set KV access-policy (using the vm.identity.systemAssignedIdentity)
#. send 3 bash scripts to the VM using az vm run-command invoke (configure-vm.sh, configure-ssl.sh, deliver-deploy.sh
#. print VM public IP address to STDOUT or save it as a file

Limited Guidance
================

PowerShell Benefits
-------------------

- bash scripting to get some data for our script (VM public ip address, and VM system assigned identity); this will be easier in PowerShell because of it's object oriented nature.

- you will want to use variables -- you will want to capture the output of az cli commands in a variable or file

Az CLI Help
-----------

You can get help for any Az CLI command, or sub-command with ``-h`` or the longhand ``--help``:

.. sourcecode:: powershell

   > az vm create -h

Capturing Az CLI Output
-----------------------

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

RunCommand from the Az CLI
--------------------------

.. sourcecode:: powershell

  > az vm run-command invoke --command-id RunShellScript --scripts @some-bash-script.sh

Fresh Start
-----------

If you feel you've messed something up, you can easily destroy the entire resource group using the az cli:

.. sourcecode:: powershell

  > $rgName = "<your-rg-name>"
  > az group delete -n "$rgName"

This command takes a couple of minutes to run because it first has to delete each of the resources inside of the resource group. However, this handy command allows you to cleanup easily, or start over if you've made a mistake!