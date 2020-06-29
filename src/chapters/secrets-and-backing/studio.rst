================================
Studio: Deploy API with KeyVault
================================

In our Studio today we will be deploying with the CodingEventsAPI that uses Azure Key vault, and uses a MySQL database.

Today we will be using Azure KeyVault to manage our Database connection string.

We will also need to setup a database on the VM where our API lives. A script will be provided for you that will download and setup a MySQL database on your VM.

Checklist
=========

Let's start by considering the steps that will needed to completed to deploy this application:

- provision Resource Group
- provision Virtual Machine
- provision Key vault
- create Key vault secret
- grant Key vault access to VM
- update source code with Key vault name
- download dependencies to VM
- setup MySQL database on VM
- clone source code to VM
- publish source code
- deploy application

Gotchas
-------

There are steps in this process that can be easily over-looked. As you work keep in mind:

- Your VM must have the ``Authentication Type`` of ``Password``
- Your VM must have a username of ``student``
- Your VM's ``System assigned managed identity`` must be set to ``On``
- Your Key vault must be configured to grant access to the VM
- The source code you publish must be updated with your Key vault name
- Your application will not be reachable until the VM network security groups have been opened

Planning
========

#. Provision resources
#. Configure Key vault
#. Update Code
#. Configure VM & Deploy

Limited Guidance
================

The following sections will guide you on specifics and steps you may not have seen yet. Before starting the studio take a moment to read them over and come up with a plan for when and how you will use them.

Provision Resources
-------------------

We will need to create a Resource Group that will contain a Virtual Machine and a Key vault.

We recommend the following naming patterns:

- Resource Group: ``lc-<yourname>-<mmyy>-secrets-rg``
- Virtual Machine: ``lc-<yourname>-<mmyy>-secrets-vm``
- Key vault: ``lc-<yourname>-<mmyy>-secrets-kv``

Replace <mmyy> with the digits for the month and year for example: March of 2020 would be ``0320``.

.. admonition:: note

   Azure Key vault names must be globally unique. If you can't create your key vault attempt changing up the name you assign it.

Configure Key vault
-------------------

Now that you have created all the resources we will need you will need to configure your key vault by granting access to your VM, and by creating a new secret.

The script that will setup our database will be provided in a later step however we already know the database connection sting and can create a Key vault secret for it. The database connection string you will be using is . You will need to create a new secret name: ``ConnectionStrings--Default`` with the value ``server=localhost;port=3306;database=coding_events;user=coding_events;password=launchcode``.

Update Code
-----------

In the walkthrough we updated the code of our application by including the name of our Key vault. We will need to do the same thing now.

You will need to fork the project repository. Clone the code to your local machine. Switch to the `4-mysql`` branch. Make the Key vault name change to the ``appsettings.json`` file, and then commit, and push your code back to your GitHub repository.

The line you will be looking for:

.. sourcecode:: csharp
   :caption: appsettings.json

   "KeyVaultName": "<your-keyvault-name>"

Configure VM & Deploy
---------------------

We have been using the RunCommand tool to run BASH scripts on our Virtual Machine. This tool is handy, but not the most pleasant experience because of the delay. Instead of running multiple commands through the RunCommand let's put together one script that will do everything necessary to deploy our application.

We will provide you with part of the script that does the part you have not seen before (downloading and setting up the database). However, you will be responsible for piecing the rest of the script together yourself. Take notice of the TODOs in the script below. After you have completed the script you will need to run it in the RunCommand section of your VM and your application will be deployed all in one step!

.. admonition:: note

   Since we are primarily focused on Operations work this week we will not explain the changes in the code. However, if you finish your studio early today you may be interested in looking at how this code-base accesses Key vault, and retrieves secrets. The syntax is slightly different.

.. sourcecode:: bash

   # set HOME environment variable
   export HOME=/home/student

   # download docker 

   # TODO: download and install the dotnet SDK

   # TODO: set DOTNET_CLI_HOME environment variable

   # TODO: clone your source code

   # TODO: checkout the correct branch

   # TODO: publish source code

   # TODO: finish the deploy line by adding the absolute path to your executable
   ASPNETCORE_URLS="http://*:80" home/student/<project-root>/bin/
