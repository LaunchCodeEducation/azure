=======================================
PowerShell Scripted Deployment Solution
=======================================


.. sourcecode:: Powershell
   :caption: provision-resources.ps1 solution

   # TODO: set variables
   $studentName = "[student-name]"
   $rgName = "$studentName-lc-rg"
   $vmName = "$studentName-lc-vm"
   $vmSize = "Standard_B2s"
   $vmImage = "$(az vm image list --query "[? contains(urn, 'Ubuntu')] | [0].urn")"
   $vmAdminUsername = "student"
   $kvName = "$studentName-lc0820-ps-kv"
   $kvSecretName = "ConnectionStrings--Default"
   $kvSecretValue = "server=localhost;port=3306;database=coding_events;user=coding_events;password=launchcode"

   az configure --default location=eastus

   # TODO: provision RG

   az group create -n $rgName

   az configure --default group=$rgName | Set-Content rg.json

   # TODO: provision VM

   az vm create -n $vmName --size $vmSize --image $vmImage --admin-username $vmAdminUsername --admin-password "LaunchCode-@zure1" --authentication-type "password" --assign-identity | Set-Content vm.json

   az configure --default vm=$vmName

   # TODO: capture the VM systemAssignedIdentity

   $vm = Get-Content vm.json | ConvertFrom-Json

   # TODO: open vm port 443

   az vm open-port --port 443

   # provision KV

   az keyvault create -n $kvName --enable-soft-delete "false" --enabled-for-deployment "true" | Set-Content kv.json

   # TODO: create KV secret (database connection string)

   az keyvault secret set --vault-name $kvName --description "db connection string" --name $kvSecretName --value $kvSecretValue

   # TODO: set KV access-policy (using the vm ``systemAssignedIdentity``)

   az keyvault set-policy --name "$kvName" --object-id $vm.identity.systemAssignedIdentity --secret-permissions list get

   az vm run-command invoke --command-id RunShellScript --scripts @vm-configuration-scripts/1configure-vm.sh

   az vm run-command invoke --command-id RunShellScript --scripts @vm-configuration-scripts/2configure-ssl.sh

   az vm run-command invoke --command-id RunShellScript --scripts @deliver-deploy.sh

   # TODO: print VM public IP address to STDOUT or save it as a file

   Write-Output $vm.publicIpAddress

.. sourcecode:: Powershell
   :caption: deliver-deploy.sh solution

   #! /usr/bin/env bash

   set -ex

   # -- env vars --

   # for cloning in delivery
   github_username=[student-name]
   solution_branch=[student-solution-branch]

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

.. sourcecode:: json
   :caption: appsettings.json solution

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
      "KeyVaultName": "[student-name-lc0820-ps-kv",
      "JWTOptions": {
         .. trimmed ..
         }
      }
   }