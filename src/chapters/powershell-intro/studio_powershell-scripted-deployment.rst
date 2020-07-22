======================================================
Studio: PowerShell Scripted CodingEventsAPI Deployment
======================================================

.. it will contain the three scripts they are given, and a folder of practice JSON objects

.. need to add practice JSON files to https://github.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment

.. setting up adb2c appsettings.json needs the kv name, the adb2c metadata URL, and the validAudience (audience ID the client ID assigned the Coding Events API application in AADB2C the Client ID, in the token it is the Audience)

In our studio today we will be using PowerShell to script a complete deployment of the CodingEventsAPI to a Linux VM.

We will be writing a PowerShell script that provisions and configures all of the Azure resources we will need for this deployment. The script we will be writing will combine all the steps from the Azure CLI chapter into one script to make for an easy deployment.

You will be writing the PowerShell script the VM you provision will require three Bash configuration scripts. `The VM Bash configuration scripts <https://github.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment>`_ will be provided for you, but it would be in your best interest to read over them and try to understand what they are doing.

Before we get to writing our PowerShell script for our deployment, let's take a look at the Bash deployment script we saw at the end of the Azure CLI chapter.

Bash Script Breakdown
=====================

You saw this script earlier, so instead of breaking down every single line, we will organize it into it's major points, and show code snippets of how the Bash script achieves the various tasks.

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

.. sourcecode:: bash

   student_name=student

   rg_name="${student_name}-cli-scripting-rg"

   vm_name="${student_name}-cli-scripting-vm"

   vm_admin_username=student
   vm_admin_password='LaunchCode-@zure1'

   vm_size=Standard_B2s
   vm_image=$(az vm image list --query "[? contains(urn, 'Ubuntu')] | [0].urn" -o tsv)

   kv_name="${student_name}-cli-scripting-kv"
   kv_secret_name='ConnectionStrings--Default'
   kv_secret_value='server=localhost;port=3306;database=coding_events;user=coding_events;password=launchcode'

Provision Resource Group
------------------------

After our variables we start provisioning our Azure resources using the AZ CLI. Recall that the AZ CLI is cross-platform, these commands will work the same regardless of the underlying operating system. Although this script is a Bash script, our PowerShell script will look very similar.

The Resource Group must be provisioned before any of our other resources are provisioned because it's the container that holds all the other resources. To provision a new Resource Group we need to provide the name. These names must be unique to your subscription.

.. sourcecode:: bash

   az group create -n "$rg_name"

Provision Virtual Machine
-------------------------

After the Resource Group we have some flexibility. 

We could spin up the key vault or virtual machine first, however consider the dependencies. We will eventually need to set an access policy on our key vault that includes information about our virtual machine. 

For this reason it makes more sense to provision the virtual machine first since our key vault will need some information about our virtual machine.

.. sourcecode:: bash

   vm_data=$(az vm create -n $vm_name --size $vm_size --image $vm_image --admin-username $vm_admin_username --admin-password $vm_admin_password --authentication-type password --assign-identity --query "[ identity.systemAssignedIdentity, publicIpAddress ]" -o tsv)

Capture Virtual Machine's System Assigned Identity
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Upon creating our virtual machine we store the output from the command in a Bash variable. We do this because we are going to do some Bash scripting to extract the information we need:

- the virtual machine system managed identity
- the virtual machine public ip address

.. sourcecode:: bash

   # get the 1st line (identity)
   vm_id=$(echo "$vm_data" | head -n 1)

   # get the 2nd line (ip)
   vm_ip=$(echo "$vm_data" | tail -n +2)

.. admonition:: note

   Getting the variables from the Az CLI output is a tedious in Bash. Recall that Bash is a string based scripting language the output from the AZ CLI is a string, so we must manipulate the string to get the information we need. 
   
   In PowerShell the Az CLI output will be an object, so accessing properties can be accessed using dot notation. This is something you should explore throughout this studio.

Create Appropriate Network Security Groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

While we are working with our VM let's go ahead and open the ports necessary for a user to gain access to our CodingEventsAPI that will eventually be housed on this VM.

The az cli provides a easy to use tool for opening whatever ports we need, in this case 443 (HTTPS).

.. sourcecode:: bash

   az vm open-port --port 443

Provision Key Vault
-------------------

Now that we have a VM and have captured the information we need to create an access policy for a key vault we should provision it.

.. sourcecode:: bash

   az keyvault create -n $kv_name --enable-soft-delete false --enabled-for-deployment true

Set Key Vault Secret
^^^^^^^^^^^^^^^^^^^^

After the key vault exists we can add whatever secrets our application will need to run. In this case we only have one secret, a database connection string, we give this secret a name, a key, and a value.

.. sourcecode:: bash

   az keyvault secret set --vault-name $kv_name --description 'connection string' --name $kv_secret_name --value $kv_secret_value

Set Key Vault Access Policy
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Finally we use the variable we created earlier that contains the Virtual Machine system assigned identity to create an access policy that grants the VM permission to use our provisioned key vault.

.. sourcecode:: bash

   az keyvault set-policy --name $kv_name --object-id $vm_id --secret-permissions list get

Send Bash Scripts to VM via RunCommand
--------------------------------------

Now that all of our infrastructure has been provisioned, we need to finish configuring our VM. It will need to have dependencies installed, nginx configured and setup, a user and database created within MySQL, the souce code needs to be delivered, and finally deployed.

.. sourcecode:: bash

   az vm run-command invoke --command-id RunShellScript --scripts @configure-vm.sh, @configure-ssl.sh, @deliver-deploy.sh

These bash scripts are provided for you, however you should look over them as they are commented with what they are doing. Many of the tasks they accomplish go beyond the scope of this course, but are a necessary part of our deployment.

.. admonition:: warning

   Looking in ``deliver-deploy.sh`` the script clones your project repository, and then switches to the ``powershell-az-cli-deploy`` branch. 
   
   **You are responsible for creating this branch and pushing the appropriate code**. 
   
   You will need to update the ``appsettings.json`` file in this branch to include your Key Vault name, and AADB2C information. You will need to push to this branch before running the ``deliver-deploy.sh`` script.

Print Public IP Address to STDOUT
---------------------------------

As a final step to make things easier for us, we print the public IP address to the console to make it easier for us to connect to our deployed application from a web browser.

.. sourcecode:: bash

   echo "VM available at $vm_ip"

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

Submitting Your Work
====================

After you have finished and executed your deploy script, you will be able to access your running application using HTTPS at the public IP address of your VM. Share this link with your TA so they know you have completed the studio.