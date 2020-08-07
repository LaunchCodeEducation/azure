================================================
Exploration: an Automated Deployment Bash Script
================================================

.. admonition:: Warning

   Do not run this script! You will be writing your own automated deployment script in a future chapter. So it is in your interest to understand what this script is doing, but we do not recommend running it because there are a few extra steps when using the Azure CLI when working with WSL that are not included in this article.

A huge benefit of using the Azure CLI from a shell terminal is that we can bundle many commands together in a script. In this walkthrough, we will explore a Bash script that does a complete deployment using the Azure CLI.

The deployment Bash scripts will be used to:

#. Provision resources
#. Configure resources
#. Deliver source code
#. Deploy source code

Bash Scripts Breakdown
======================

To orient ourselves, let's take a look at the entry point script, ``provision-resources.sh``. This is a rather involved script that dictates our deployment. After we look at the script as a whole, we will break down its individual sections.

.. admonition:: Note

   Recall that the Azure CLI is cross-platform, so its CLI commands should work the same regardless of the underlying operating system. Although this script is a Bash script, a PowerShell script will look very similar.

Provision Resources Script
==========================

Provision Resources Script Steps
--------------------------------

This script does quite a few things. Most of them are related to our Azure resources:

#. Declare variables
#. Configure the default location
#. Provision resource group
#. Configure the default resource group
#. Provision virtual machine & capture output information in variables
#. Extract data from VM output into useable variables: ``$vm_id`` and ``$vm_ip``
#. Open port 443 on the VM
#. Configure the default virtual machine
#. Provision a Key Vault
#. Create a new secret in the Key Vault with a description, name, and value
#. Attach a new access policy to the Key Vault granting the VM access
#. Send three separate Bash scripts to the VM using ``az vm run-command invoke``
#. Print out the public IP address of the VM

Script Goal
-----------

This script is responsible for setting up and configuring the resources using the Azure CLI. 

Take note of the second-to-last step in the list: "Send three separate Bash scripts to the vm using ``az vm run-command invoke``". It is passing three additional Bash scripts to be run by the VM using the RunCommand tool we worked with in the Azure Portal.

We need to do this because we have additional VM configuration steps that we cannot accomplish with just the Azure CLI. However, we can access ``RunCommand`` from the Azure CLI which allows us to run any additional scripts on the VM that are needed.

Provision Resources Script
--------------------------

Let's take a look at the script and then talk about what it's doing:

.. sourcecode:: bash

   #! /usr/bin/env bash

   set -e

   # --- start ---

   # variables

   student_name="student"

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

   # RG: provision

   az group create -n "$rg_name"

   # set az rg default

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

   # KV: grant access to VM

   az keyvault set-policy --name $kv_name --object-id $vm_id --secret-permissions list get

   # VM setup-and-deploy script

   az vm run-command invoke --command-id RunShellScript --scripts @configure-vm.sh @configure-ssl.sh @deliver-deploy.sh

   # finished print out IP address

   echo "VM available at $vm_ip"

   # --- end ---

Provision Resources Script Sections
===================================

Declare Variables
-----------------

The Bash script first declares a suite of variables:

- ``student_name``
- ``rg_name``
- ``vm_name``
- ``vm_admin_username``
- ``vm_admin_password``
- ``vm_size``
- ``vm_image``
- ``kv_name``
- ``kv_secret_name``
- ``kv_secret_value``

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

All of the name variables use the underlying ``student_name`` variable to create a consistent naming pattern. This allows us to easily spin up a new stack by changing this one variable; it is a single source of truth.

.. admonition:: tip

   For this script to work the deployed Azure Key Vault name is needed to adequately fill out the ``appsettings.json`` file.

Provision Resource Group
------------------------

After our variables we start provisioning our Azure resources using the Azure CLI. 

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Provision resource group

   az group create -n "$rg_name"

The resource group must be provisioned first because it is the container that holds all the other resources. To provision a new resource group, we need to provide the name. These names must be unique to your subscription.

Provision Virtual Machine
-------------------------

After the resource group we have some flexibility. 

We could spin up the Key Vault or Virtual Machine first, however consider the dependencies of these resources. We will eventually need to set an access policy on our Key Vault that includes information about our Virtual Machine. 

For this reason, it makes more sense to provision the Virtual Machine first.

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Provision VM and store response in vm_data


   vm_data=$(az vm create -n $vm_name --size $vm_size --image $vm_image --admin-username $vm_admin_username --admin-password $vm_admin_password --authentication-type password --assign-identity --query "[ identity.systemAssignedIdentity, publicIpAddress ]" -o tsv)

.. admonition:: note

   This Bash script captures the output of the ``az vm create`` command in the ``vm_data`` variable. We can do the same thing in PowerShell with slightly different syntax.

Capture Virtual Machine's System Assigned Identity
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Upon creating our virtual machine, we store the output from the command in a Bash variable. We do this because we are going to do some Bash scripting to extract some information:

- The virtual machine system-managed identity
- The virtual machine public IP address

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Extract the necessary information from vm_data


   # get the 1st line (identity)
   vm_id=$(echo "$vm_data" | head -n 1)

   # get the 2nd line (ip)
   vm_ip=$(echo "$vm_data" | tail -n +2)

.. admonition:: note

   Getting the variables from the Azure CLI output is tedious in Bash. Recall that Bash is a string-based scripting language, so the output from the Azure CLI is a string. In Bash, we must manipulate the string to get the information we need. 
   
   In PowerShell, the Azure CLI output will be an object. Accessing properties can be accomplished using dot-notation, a much easier process!

Create Appropriate Network Security Group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Our application hasn't been deployed yet, but let's go ahead and open the HTTPS port so that end users can access the ``CodingEventsAPI``.

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Open VM HTTPS port


   az vm open-port --port 443

.. admonition:: tip

   Creating the NSG for our VM that contains the proper port is an easy thing to forget to do, so we are opening it while we are working with our VM. If an appropriate NSG inbound rule is not created users will receive a **connection timeout** when attempting to access our API.

Provision Key Vault
-------------------

We now have a VM and all the information we need to create an access policy for a Key Vault. So let's provision a Key Vault:

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Provision Key Vault

   az keyvault create -n $kv_name --enable-soft-delete false --enabled-for-deployment true

.. admonition:: Note

   For a VM to access the Key Vault, it must be ``enabled-for-deployment``. We also turn off the ``soft-delete`` so the Key Vault can be deleted in less than 30 days.

Set Key Vault Secret
^^^^^^^^^^^^^^^^^^^^

After the Key Vault has been provisioned, we can add whatever secrets our application needs. In this case, we only have one secret: a database connection string.

The database connection string secret needs:

- Description
- Name (key)
- Value

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Add connection string secret to Key Vault


   az keyvault secret set --vault-name $kv_name --description 'connection string' --name $kv_secret_name --value $kv_secret_value

Set Key Vault Access Policy
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Finally, we use the variable we created earlier that contains the VM system-assigned identity to create an access policy that grants the VM permission to *list* and *get* secrets stored in the Key Vault.

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Create Key Vault access policy for VM

   az keyvault set-policy --name $kv_name --object-id $vm_id --secret-permissions list get

Send Bash Scripts to VM Via RunCommand
--------------------------------------

Now that all of our infrastructure has been provisioned, we need to finish configuring our VM. 

The VM still needs:

- Software dependency installations
- Web server configurations
- Database
- Database user
- Source code
- Deployed application

To accomplish these final steps additional Bash scripts will be sent to the VM using the ``az vm run-command invoke`` command.

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Send (and invoke) configure scripts to VM

   az vm run-command invoke --command-id RunShellScript --scripts @configure-vm.sh, @configure-ssl.sh, @deliver-deploy.sh

When you are writing your own automated deployment script, in a future chapter, these bash scripts will be provided for you.
 
However you should look over them and read the comments that describe what they are doing. Many of the tasks they accomplish go beyond the scope of this course, but are a necessary part of this deployment.

.. admonition:: Warning

   The ``deliver-deploy.sh`` script clones a project repository and then switches to a specific branch. 
   
   When you are writing this automation script in a future lesson:

   *You will be responsible for creating this branch and pushing the appropriate code*. 
   
   You will need to update the ``appsettings.json`` file in this branch to include your Key Vault name and AADB2C information. You will need to push to this branch before running the ``deliver-deploy.sh`` script!

Print Public IP Address to STDOUT
---------------------------------

As a final step, the script prints the public IP address to the console. This shows exactly where to access the deployed application.

.. sourcecode:: bash
   :caption: ``provision-resources.sh``: Print out VM public IP address


   echo "VM available at $vm_ip"

VM RunCommand Scripts
---------------------

It is important that the three VM RunCommand scripts run in a specific order. We have defined their order in our ``az vm run-command invoke`` command. These scripts must run in this order:

#. ``configure-vm.sh``: Installs ``dotnet``, MySQL, and creates the database and user that our application needs
#. ``configure-ssl.sh``: Installs and configures the NGINX web server
#. ``deliver-deploy.sh``: Delivers, builds, and deploys source code

The ``configure-vm.sh`` script should look familiar, since it's a collection of the steps we have used multiple times throughout this class. 

The ``configure-ssl.sh`` script is outside the scope of this class. In a nutshell, it downloads and configures the NGINX web server our application uses to enable TLS and HTTPS so that our app can be used with AADB2C.

Deliver & Deploy Script
=======================

The ``deliver-deploy.sh`` script has a couple of variables that need to be set by the user. Let's take a look.

.. sourcecode:: bash

   #! /usr/bin/env bash

   set -ex

   # -- env vars --

   # for cloning in delivery
   github_username=student_github_account_name
   solution_branch=github_repository_solution_branch

   # api
   api_service_user=api-user
   api_working_dir=/opt/coding-events-api

   # needed to use dotnet from within RunCommand
   export HOME=/home/student
   export DOTNET_CLI_HOME=/home/student

   # -- end env vars --

   # -- set up API service --

   # create API service user and dirs
   useradd -M "$api_service_user" -N
   mkdir "$api_working_dir"

   chmod 700 /opt/coding-events-api/
   chown $api_service_user /opt/coding-events-api/

   # generate API unit file
   cat << EOF > /etc/systemd/system/coding-events-api.service
   [Unit]
   Description=Coding Events API
   [Install]
   WantedBy=multi-user.target
   [Service]
   User=$api_service_user
   WorkingDirectory=$api_working_dir
   ExecStart=/usr/bin/dotnet ${api_working_dir}/CodingEventsAPI.dll
   Restart=always
   RestartSec=10
   KillSignal=SIGINT
   SyslogIdentifier=coding-events-api
   Environment=ASPNETCORE_ENVIRONMENT=Production
   Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false
   Environment=DOTNET_HOME=$api_working_dir
   EOF

   # -- end setup API service --

   # -- deliver --

   # deliver source code

   git clone https://github.com/$github_username/coding-events-api /tmp/coding-events-api

   cd /tmp/coding-events-api/CodingEventsAPI

   # checkout branch that has the appsettings.json we need to connect to the KV
   git checkout $solution_branch

   dotnet publish -c Release -r linux-x64 -o "$api_working_dir"

   # -- end deliver --

   # -- deploy --

   # start API service
   service coding-events-api start

   # -- end deploy --

This final script needs to know the GitHub user account name and repository that contains the source code to be deployed.

The middle section does some VM operations work, namely creating directories, granting privileges to those directories, and creating a Systemd unit file that will be used to deploy the application.

.. admonition:: note

   Unit files are outside the scope of this class. Briefly, they allow you to define how an application is run and can be configured to auto-restart the application if it fails. You can learn more by viewing the Digital Ocean `Systemd Unit File <https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files>`_ article.

The final section of the script clones and checks out the solution branch, publishes the project to the directory indicated by the unit file, and then starts the service which runs our application. 

This deployment requires the source code from the solution repository to have an ``appsettings.json`` file that contains information about the Key Vault and AADB2C utilized by the application.

An example of this ``appsettings.json`` file is:

.. sourcecode:: json

   {
      "Logging": {
         "LogLevel": {
            "Default": "Information",
            "Microsoft": "Warning",
            "Microsoft.Hosting.Lifetime": "Information"
         }
      },
      "AllowedHosts": "*",
      "ServerOrigin": "",
      "KeyVaultName": "student-bash-kv",
      "JWTOptions": {
         "Audience": "e13f6217-f8c1-495a-b1e1-b5cd28b26708",
         "MetadataAddress": "https://student0720tenant.b2clogin.com/paul0720tenant.onmicrosoft.com/v2.0/.well-known/openid-configuration?p=B2C_1_coding-events-api-susi",
         "RequireHttpsMetadata": true,
         "TokenValidationParameters": {
            "ValidateIssuer": true,
            "ValidateAudience": true,
            "ValidateLifetime": true,
            "ValidateIssuerSigningKey": true
         }
      }
   }

Assuming the source code was error free---and that it's ``appsettings.json`` file contains the appropriate information about the Key Vault and AADB2C---the application will be deployed with no issues.

Deploying
=========

We now understand what the Bash scripts are doing. After the user provides the proper information to the scripts, including a branch with the appropriate ``appsettings.json`` file, they can execute the ``provision-resources.sh`` script to automatically deploy the entire application.

Understanding the steps of deploying is a necessary part of creating an automation script. In the PowerShell chapter you will be writing your own automated deployment script.

Conclusion
==========

The steps are similar across deployments, but they can be achieved in different ways. Let's review the different approaches we have used throughout this course:

- Manual deployment with a GUI: Azure Portal
- Manual deployment with a CLI tool: Azure CLI
- Automated deployment via shell scripts like ``provision-resources.sh`` and it's companion scripts
- Automated deployment via pipelining tools: `Azure Pipelines <https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops>`_
- Any combination of these

However, you cannot automate a process until you understand the individual steps necessary to achieve automation. We started from the the Azure Portal, where it was easier to form a mental model of the many new concepts due to the familiarity of a GUI interface. Since then, we have moved towards the CLI environment, which trades the tangibility of a GUI for automation potential and conciseness. Automation is only possible when you have a clear mental model of the units and interactions involved in a deployment.

As you may have come to realize, *automation is the end-goal* in operations. Some of the many benefits of automated deployments include reduced time to deploy, decreased likelihood of human error, and predictable behavior. Each of these benefits contributes to faster turnaround of new features and fixes for customers.
