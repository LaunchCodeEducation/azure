================================
Studio: Deploy API with KeyVault
================================

In our Studio today we will be continuing with the API we have been publishing throughout the week.

Today we will be using Azure KeyVault to manage the sensitive data that is our Database connection string.

We will also need to setup a database on the VM where our API lives. We will walk you through the Database download, installation, and configuration but you will be responsible for setting up the VM, the API, and the AZ KeyVault.

Provision Resources
===================

Resource Group
--------------

As usual we will need a new Resource Group to hold all of the resources used by this deployment. Look over the walkthrough for assistance on setting up this VM.

Virtual Machine
---------------

We will need a VM that will host our deployed application. Look over the walkthrough for assistance on setting up this VM.

.. note::

   Our VM will need to access a Key vault so make sure when you create the VM you set ``System assigned managed identity`` to ``On``! Also make sure you set the ``Authentication Type`` to ``Password`` and you create a username of ``student``.

VM Dependencies
---------------

We will need the dotnet cli which we have installed multiple times, look over the walkthrough for help on setting up the dotnet CLI

MySQL
-----

Our API requires a MySQL backing service. We will provide you with instructions for downloading MySQL, and setting it up to be used by our application.

During these steps keep track of the information as it will be needed to create our Database connection string.

Docker & MySQL Installation
---------------------------

.. sourcecode:: bash

   # provide script that students can just paste into RunCommand

.. image:: /_static/images/secrets-and-backing/docker-mysql.png

MySQL Initilization
-------------------

.. sourcecode:: bash

   # provide script that students can just paste into RunCommand

.. image:: /_static/images/secrets-and-backing/mysql-setup.png

Configure Network Security Groups
---------------------------------

We will need to create inbound and outbound rules for port 80 so your application is reachable via the internet via HTTP. We have done this a couple of times throughout the class check previous walkthroughs for assistance.

Key Vault
---------

Our API will need access to a Key vault which will store a secret that is our Database connection string. Checkout the walkthrough for assistance on creating your Key vault. Don't forget to set an Access Policy so that your VM can gain access to your Key Vault.

Add Secret to Key Vault
-----------------------

You will need to add a secret to your Key Vault that is your database connection string.

Update Source Code
==================

Pull down the source code and make the changes so that your project points to your Azure KeyVault.

Push your code to a new Github repository under your control.

Pull down your code from your VM.

Publish your source code.

Run your project.

Connect to your project.