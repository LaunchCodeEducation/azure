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

The script that will setup our database will be provided in a later step however we already know the database connection sting and can create a Key vault secret for it. The database connection string you will be using is . You will need to create a new secret name: ``db-connection-string`` with the value ``<db-connection-string>``.

Update Code
-----------

In the walkthrough we updated the code of our application by including the name of our Key vault. We will need to do the same thing now.

You will need to fork the project repository. Clone the code to your local machine. Switch to the `4-mysql`` branch. Make the Key vault name change to the ``appsettings.json`` file, and then commit, and push your code back to your GitHub repository.

The line you will be looking for:

.. sourcecode:: csharp
   :caption: appsettings.json

   "AzureKeyVaultName": "<your-keyvault-name>"

Configure VM & Deploy
---------------------

The last step will be running a script in our VM RunCommand section. This will be a rather large script that does quite a few things for us. 
