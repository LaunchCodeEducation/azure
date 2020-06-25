================================
Studio: Deploy API with KeyVault
================================

In our Studio today we will be continuing with the API we have been publishing throughout the week.

Today we will be using Azure KeyVault to manage the sensitive data that is our Database connection string.

We will also need to setup a database on the VM where our API lives. We will walk you through the Database download, installation, and configuration but you will be responsible for setting up the VM, the API, and the AZ KeyVault.

Provision Resources
===================

RG
--

VM
--

.. note::

   Your VM will need to access a Key vault so make sure when you create the VM you set ``System assigned managed identity`` to ``On``! Also make sure you set the ``Authentication Type`` to ``Password`` and you create a username of ``student``.

setup & dependencies

MySQL docker container script

MySQL setup script

Configure Network Security Groups

KeyVault
--------

create

add connection string as secret

grant VM access to KV through access policy

Update Source Code
==================

Pull down the source code and make the changes so that your project points to your Azure KeyVault.

Push your code to a new Github repository under your control.

Pull down your code from your VM.

Publish your source code.

Run your project.

Connect to your project.