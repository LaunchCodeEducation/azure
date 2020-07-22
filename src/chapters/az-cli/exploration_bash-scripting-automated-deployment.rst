====================================================
Exploration: Automated Deployment via Bash Scripting
====================================================

A huge benefit of using the Azure CLI from a shell terminal is that we can bundle many commands together in a script. In this exploration article we will explore a Bash script that does a complete deployment using the Az CLI commands we have used throughout this chapter.

Provision Resources Script
==========================

Let's take a look at the script, and then talk about what it's doing:

.. sourcecode:: bash

   #! /usr/bin/env bash

   set -e

   # --- start ---

   # variables

   # TODO: enter your name here in place of 'student'
   student_name="paul"

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

This script does quite a few things, most of them are related to our Azure resources:

#. declare variables
#. configure az default: location
#. provision resource group
#. configure az default: resource group
#. provision virtual machine & capture output information in variables
#. chop up vm output into useable variables: $vm_id and $vm_ip
#. open vm port 443
#. configure az default: virtual machine
#. provision key vault
#. create a new secret in the kv with a description, name, and value
#. attach a new access policy to the kv granting the vm access
#. send three separate Bash scripts to the vm using ``az vm run-command invoke``
#. print out the public IP address of the vm

This script is responsible for setting up, and configuring the resources with the Azure CLI. You will notice the second to last step in the script passes, and invokes three additional scripts to the VM. From our local machine we cannot configure the VM, so we pass the scripts the VM needs in our provision script.

It is important that these three scripts run in a specific order and we have defined their order in our ``az vm run-command invoke`` command. These scripts must run in this order:

#. ``configure-vm.sh``: installs dotnet, MySQL, and creates the user, and MySQL database our application needs
#. ``configure-ssl.sh``: installs and configures the NGINX we server
#. ``deliver-deploy.sh``: delivers, builds, and deploys source code

The ``configure-vm.sh`` script should look familiar as it's a collection of the steps we have used multiple times throughout this class. 

The ``configure-ssl.sh`` script is outside the scope of this class, but in a nutshell it downloads and configures the NGINX web server our application uses to enable TLS and HTTPS, so that our app can be used with AADB2C.

Deliver & Deploy Script
=======================

The ``deliver-deploy.sh`` script has a couple of variables that need to be set by the user, let's take a look.

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

This final script needs to know the GitHub user account name, and the repository name that contains the source code necessary to be deployed.

The middle section does some VM Operations work, namely creating directories, granting privileges to those directories, and creates a Systemd Unit File we will use to deploy our application.

.. admonition:: note

   Unit Files are outside the scope of this class, but allow you to define how an application is run and can be configured to auto-restart the application if it fails. You can learn more by viewing the Digital Ocean `Systemd Unit File <https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files>`_ article.

The final section of the script clones, checks out the solution branch, publishes the project to the directory indicated by the unit file, and then finally starts the service which runs our application. Assuming the sourcecode was error free, and it's appsettings.json file contains the appropriate information about the Key Vault, and AADB2C the application will be deployed.

Conclusion
==========

All together the four scripts, that are controlled by the ``provision-resources.sh`` script:

#. provision resources 
#. configure resources
#. deliver source code
#. deploy source code.

These four steps are similar across most deployments, they can be achieved in different ways:

- manually with a GUI: Azure Portal
- manually with a CLI tool: Azure CLI
- automated via shell scripts: ``provision-resources.sh`` and it's companion scripts
- automated via Pipelining tools: `Azure Pipelines <https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops>`_

As you may have come to realize automation is awesome, it reduces the time to deploy, it decreases the likelihood of manual mistakes, etc. However, you cannot automate a process until you understand the indivdiual steps necessary to write an automation script, or configure a pipelining tool.