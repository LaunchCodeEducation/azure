=====================================================
Studio: Automated Deployment of the Coding Events API
=====================================================

In this studio we will be using *PowerShell to script a complete deployment of the CodingEventsAPI to a Linux VM*.

This PowerShell script will provisions and configure all of the Azure resources we will need for the deployment. The script will combine all the steps from the Azure CLI chapter into one easily runnable deploy-script.

You will be writing the PowerShell script, however the provisioned VM will require three Bash configuration scripts. `The VM Bash configuration scripts <https://github.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment>`_ will be provided for you, but it would be in your best interest to read over them to make sense of what they are doing.

Before we write the PowerShell script for our deployment, let's take a look at the Bash deployment script we saw at the end of the Azure CLI chapter.

Bash Script Breakdown
=====================

You saw this Bash script in an earlier chapter, so instead of breaking down every single line we will organize it into its major tasks. We will then look at the code snippets of how the Bash script achieves the various tasks.

.. admonition:: note

   Recall that the AZ CLI is cross-platform, the AZ CLI commands should work the same regardless of the underlying operating system. Although this script is a Bash script our PowerShell script will look very similar.


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

These variables are used throughout the script. Most of the variables are used as the parameters for provisioning our Azure resources. 

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Variables

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

All of the name variables use the underlying ``student_name`` variable to create a consist naming pattern. This allows us to easily spin up a new stack by changing this one variable, it is a single source of truth.

.. admonition:: tip

   You will need to know your Azure Key Vault name as you will need to include it in the ``appsettings.json`` of your sourcecode!

Provision Resource Group
------------------------

After our variables we start provisioning our Azure resources using the AZ CLI. 

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Provision Resource Group

   az group create -n "$rg_name"

The Resource Group must be provisioned before any of our other resources are provisioned because it's the container that holds all the other resources. To provision a new Resource Group we need to provide the name. These names must be unique to your subscription.

Provision Virtual Machine
-------------------------

After the Resource Group we have some flexibility. 

We could spin up the key vault or virtual machine first, however consider the dependencies of these resources. We will eventually need to set an access policy on our key vault that includes information about our virtual machine. 

For this reason it makes more sense to provision the virtual machine first since our key vault will need some information about our virtual machine.

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Provision VM and store response in vm_data


   vm_data=$(az vm create -n $vm_name --size $vm_size --image $vm_image --admin-username $vm_admin_username --admin-password $vm_admin_password --authentication-type password --assign-identity --query "[ identity.systemAssignedIdentity, publicIpAddress ]" -o tsv)

.. admonition:: note

   This bash script captures the output of the ``az vm create`` command in the vm_data variable. We can do the same thing in PowerShell with slightly different syntax.

Capture Virtual Machine's System Assigned Identity
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Upon creating our virtual machine we store the output from the command in a Bash variable. We do this because we are going to do some Bash scripting to extract the information we need:

- the virtual machine system managed identity
- the virtual machine public ip address

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Extract the necessary information from vm_data


   # get the 1st line (identity)
   vm_id=$(echo "$vm_data" | head -n 1)

   # get the 2nd line (ip)
   vm_ip=$(echo "$vm_data" | tail -n +2)

.. admonition:: note

   Getting the variables from the AZ CLI output is a tedious in Bash. Recall that Bash is a string based scripting language so the output from the AZ CLI is a string. In Bash we must manipulate the string to get the information we need. 
   
   In PowerShell the AZ CLI output will be an object. Accessing properties can be accomplished using dot notation, a much easier process!

Create Appropriate Network Security Group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Our application hasn't been deployed yet, but let's go ahead and open the HTTPS port so end users can access the CodingEventsAPI.

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Open VM HTTPS port


   az vm open-port --port 443

.. admonition:: tip

   Creating the NSG for our VM that contains the proper port is an easy thing to forget so we are opening it while we are working with our VM.

Provision Key Vault
-------------------

Now that we have a VM and have the information we need to create an access policy for a key vault we should provision it.

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Provision Key Vault

   az keyvault create -n $kv_name --enable-soft-delete false --enabled-for-deployment true

.. sourcecode:: note

   For a VM to access the Key Vault it must be ``enabled-for-deployment``, we also turn off the ``soft-delete`` so the Key Vault can be deleted in less than 30 days.

Set Key Vault Secret
^^^^^^^^^^^^^^^^^^^^

After the key vault has been provisioned we can add whatever secrets our application needs. In this case we only have one secret: a database connection string.

The database connection string secret needs:

- a description
- name (key)
- value

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Add connection string secret to Key Vault


   az keyvault secret set --vault-name $kv_name --description 'connection string' --name $kv_secret_name --value $kv_secret_value

Set Key Vault Access Policy
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Finally we use the variable we created earlier that contains the Virtual Machine system assigned identity to create an access policy that grants the VM permission to **get** secrets stored in the key vault.

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Create Key vault access policy for VM

   az keyvault set-policy --name $kv_name --object-id $vm_id --secret-permissions list get

Send Bash Scripts to VM via RunCommand
--------------------------------------

Now that all of our infrastructure has been provisioned, we need to finish configuring our VM. 

The VM still needs:

- software dependency installations
- web server configurations
- database
- database user
- sourcecode
- deployed application

We will accomplish these final steps by using the provided scripts and the ``az vm run-command invoke`` command.

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Send (and invoke) configure scripts to VM

   az vm run-command invoke --command-id RunShellScript --scripts @configure-vm.sh, @configure-ssl.sh, @deliver-deploy.sh

These bash scripts are provided for you, however you should look over them as they are commented with what they are doing. Many of the tasks they accomplish go beyond the scope of this course, but are a necessary part of this deployment.

.. admonition:: warning

   Looking in ``deliver-deploy.sh`` the script clones your project repository, and then switches to the a specific branch. 
   
   **You are responsible for creating this branch and pushing the appropriate code**. 
   
   You will need to update the ``appsettings.json`` file in this branch to include your Key Vault name, and AADB2C information. You will need to push to this branch before running the ``deliver-deploy.sh`` script!

Print Public IP Address to STDOUT
---------------------------------

As a final step we print the public IP address to the console so we know exactly where to access our deployed application.

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Print out VM public IP address


   echo "VM available at $vm_ip"

Your Tasks
==========

Clone the VM Bash configuration scripts and practice resources `repository <https://github.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment>`_.

Practice with the provided resources to re-familiarize yourself with PowerShell.

Update your source code and push to a new branch.

Create a script (``azureProvisionScript.ps1``) that accomplishes the following:

#. set variables
#. provision RG
#. provision VM
#. capture the VM systemAssignedIdentity
#. open vm port 443
#. provision KV
#. create KV secret (database connection string)
#. set KV access-policy (using the vm systemAssignedIdentity)
#. send 3 bash scripts to the VM using az vm run-command invoke (``configure-vm.sh``, ``configure-ssl.sh``, ``deliver-deploy.sh``
#. print VM public IP address to STDOUT or save it as a file

Access your deployed application in your web browser.

.. admonition:: note

   Add your ``azureProvisionScript.ps1`` to the ``powershell-az-cli-scripting-deployment`` repository you cloned, commit it and push when you've completed the tasks and have accessed your deployed application via a web browser.

Limited Guidance
================

Running Custom PowerShell scripts
---------------------------------

Recall that Windows will not let you just run a PowerShell script, you must first set the ``ExecutionPolicy`` before you can run any custom PowerShell scripts.

Azure CLI Response Examples
---------------------------

In the cloned repository you will find a folder called ``exampleResources`` this folder contains three JSON files that represent responses from provisioning Azure resources from the CLI.

You can use these example resources to practice getting the information you will need for your scripts.

For example you can examine the Resource Group name with:

.. sourcecode:: powershell

   (Get-Content ./resourceGroup.json | ConvertFrom-Json).name

.. admonition:: tip

   Your Key Vault will need the VM's ``systemAssignedIdentity`` to properly set an access policy from the Azure CLI. See if you can access this property with PowerShell and ``virtualMachine.json``.

AZ CLI Help
-----------

You can get help for any AZ CLI command, or sub-command with ``-h`` or the longhand ``--help``:

.. sourcecode:: powershell

   > az vm create -h

Capturing AZ CLI Output
-----------------------

.. sourcecode:: powershell
   :caption: capture AZ CLI output in variable

   > $someVariable = az vm create -n .....

   > $someVariable.someProperty

.. sourcecode:: powershell
   :caption: capture AZ CLI output in JSON file

   > az vm create -n .... | Set-Content virtualMachine.json

.. sourcecode:: powershell
   :caption: load JSON file into a PS variable

   > $virtualMachine = Get-Content virtualMachine.json | ConvertFrom-Json

   > $virtualMachine.someProperty

Saving the output as a file will allow you to keep the data for as long as you need, if you store it only as a variable you lose the data when you close your PowerShell session.

RunCommand from the AZ CLI
--------------------------

You can access the ``RunCommand`` for any VM with the following command: 

.. sourcecode:: powershell

  > az vm run-command invoke --command-id RunShellScript --scripts @some-bash-script.sh

You will have to successfully invoke the three provided scripts for you application to finish it's deployment.

Updating the CodingEventsAPI Source Code
----------------------------------------

The ``deliver-deploy.sh`` script expects a branch of your CodingEventsAPI repository to contain all the code necessary for deploying your application. This includes the ``appsettings.json`` file.

You will need to manually update this file to include the necessary Key Vault and AADB2C information and then push it to a new branch. Then you need to give your GitHub user name, and repository name to the ``deliver-deploy.sh`` script so it knows where to find your source code.

The ``appsettings.json`` file needs:

- the Key Vault name
- the AADB2C metadata address
- the AADB2C Coding Events API client ID

Review the AADB2C studio if you need a refresher on where to find the necessary data.

Fresh Start
-----------

If you feel you've messed something up throughout this deployment, you can easily destroy the entire resource group using the AZ CLI:

.. sourcecode:: powershell

  > $rgName = "<your-rg-name>"
  > az group delete -n "$rgName"

This command takes a couple of minutes to run because it first has to delete each of the resources inside of the resource group. However, this handy command allows you to cleanup easily, or start over if you've made a mistake!

.. admonition:: note

   Your Key Vault will only be properly deleted if you have set ``enable-soft-delete`` to ``false``.

Getting Assistance
------------------

Everything your ``provisionResources.ps1`` script accomplishes is something you have done throughout this class. 

For additional help:

- look over the ``provision-resources.sh`` script
- review previous chapters
- discuss strategies with your classmates
- reach out to your TA.

Submitting Your Work
====================

After you have finished and executed your deploy script you will be able to access your running application using HTTPS at the public IP address of your VM. 

Share this link, and your ``powershell-az-cli-scripting-deployment`` with your TA so they know you have completed the studio.