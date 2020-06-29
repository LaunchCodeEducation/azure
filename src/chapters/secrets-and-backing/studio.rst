================================
Studio: Deploy API with KeyVault
================================

In our Studio today we will be deploying the CodingEventsAPI that uses Azure Key vault, and uses a MySQL database.

We will use Azure KeyVault to manage our Database connection string.

We will also need to setup a database on the VM where our API lives. A script will be provided for you that will download and setup a MySQL database on your VM.

Checklist
=========

Let's start by considering the steps that we will need to take to complete the deployment this application:

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

There are steps in this process that can be easily over-looked. 

As you work keep in mind:

- Your VM must have the ``Authentication Type`` of ``Password``
- Your VM must have a username of ``student`` and a home directory of ``/home/student``
- Your VM property: ``System assigned managed identity`` must be set to: ``On``
- Your Key vault must be configured to grant access to your VM
- The source code you publish must be updated with your Key vault name
- Your deployed application will not be reachable until the VM network security groups have been opened

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

   Azure Key vault names must be globally unique. If you can't create your key vault attempt changing up the name you assign it. Make sure to keep track of your Key vault name as you will need to include it in your source code later.

Configure Key vault
-------------------

To configure your Key vault you will need to create a new secret and grant your VM access.

The secret you create will need to be set to:

- Name: ``ConnectionStrings--Default``
- Value: ``server=localhost;port=3306;database=coding_events;user=coding_events;password=launchcode``

Refer to the previous walkthrough to re-familiarize yourself with granting a VM access to a Key vault.

Update Code
-----------

You will need to do update your ``appsettings.json`` file to include the name of your Key vault.

.. admonition:: note

   This week is focused on Operations and not on Development, however if you look at the code base of the ``2-mysql-solution`` branch you will notice the Key vault, and secret are accessed in slightly different ways than we have seen before.

You will need to fork the project repository. Clone the code to your local machine. Switch to the ``2-mysql-solution`` branch. Make the Key vault name change to the ``appsettings.json`` file, and then commit, and push your code back to your GitHub repository.

The line you will be looking for:

.. sourcecode:: csharp
   :caption: appsettings.json

   "KeyVaultName": "<your-keyvault-name>"

.. admonition:: warning

   If you do not update your code and push it back to your GitHub repository your deployed application will fail when trying to launch because it won't know which Key vault to access!

Configure VM & Deploy
---------------------

We have been using the RunCommand tool to run BASH scripts on our Virtual Machine. This tool is handy, but not the most pleasant experience because of the delay. Instead of running multiple commands through the RunCommand let's put together one script that will do everything necessary to deploy our application. 

.. admonition:: tip

   After learning the specific steps of a deployment process it's almost always a good idea to put those steps together in a script. The more practice you get with Operations, the more saving steps in a script will become second nature. As added practice review previous walkthroughs and studios to combine all of the steps, fom each article, into one script.

We will provide you with a starter script that installs and sets up MySQL. However, you will be responsible for piecing the rest of the script together yourself. 

Take notice of the ``TODOs`` in the script below. After you have completed the script you will need to run it in the RunCommand section of your VM and your application will be deployed all in one step!

.. sourcecode:: bash

   # set HOME environment variable
   export HOME=/home/student

   # update apt-get repositories
   apt-get update

   ### MySQL section START ###
   # download the apt-get repository package
   wget https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb

   # add the repository package to apt-get
   dpkg -i mysql-apt-config_0.8.15-1_all.deb

   # update apt-get now that it has the new repo
   apt-get update

   # set environment variables that are necessary for MySQL installation
   debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password lc-password"
   debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password lc-password"

   # install MySQL in a noninteractive way since the environment variables set the necessary information for setup
   sudo DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server

   # create a setup.sql file which will create our database, our user, and grant our user privileges to the database
   cat >> setup.sql << EOF
   CREATE DATABASE coding_events;
   CREATE USER 'coding_events'@'localhost' IDENTIFIED BY 'launchcode';
   GRANT ALL PRIVILEGES ON coding_events.* TO 'coding_events'@'localhost';
   FLUSH PRIVILEGES;
   EOF

   # using the mysql CLI run the setup.sql file as the root user in the mysql database
   mysql -u root --password=lc-password mysql < setup.sql

   ### MySQL section END ###

   # TODO: download and install the dotnet SDK
   

   # TODO: set DOTNET_CLI_HOME environment variable
   

   # TODO: clone your source code
   

   # TODO: change into project directory
   

   # TODO: checkout the correct branch
   

   # TODO: change into CodingEventsAPI/
   

   # TODO: publish source code
   

   # deploy application by running executable (this assumes your CWD is /home/student/coding-events-api/CodingEventsAPI)
   ASPNETCORE_URLS="http://*:80" ./bin/Release/netcoreapp3.1/linux-x64/publish/CodingEventsAPI

.. solution script can be found here: https://gist.github.com/pdmxdd/b0ac6b03d9b14e2ae955ce5837bb7cd6

Connect to Application
----------------------

Once you complete and run your RunCommand script your application will be deployed assuming there were no errors with your script or application. You can access it at ``http://<YOUR-VM-IP>``. If you had errors in your RunCommand section double check the steps especially the ``Gotchas`` listed above.

.. admonition:: note

   If you cannot access your VM from your browser double check that you created inbound and outbound port rules for port 80.

You will know you have succeeded when you can view the Swagger homepage from your browser:

.. image:: /_static/images/secrets-and-backing/secrets-studio-final.png
