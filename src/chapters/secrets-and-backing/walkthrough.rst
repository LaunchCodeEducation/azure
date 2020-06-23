=================================================
Walkthrough: dotnet user-secrets & Azure KeyVault
=================================================

In our walkthrough today we will be deploying an application that accesses sensitive data locally via ``dotnet user secrets`` and remotely via ``Azure KeyVault``.

We will accomplish this using an Ubuntu VM.

Look Over Code
==============

On your local machine clone the following repository

.. sourcecode:: bash

   git clone https://github.com/pdmxdd/dotnet-user-secrets-az-keyvault

With dotnet locally you would use ``dotnet user-secrets`` to manage sensitive data which we will do first.

Change into the directory you just cloned ``/dotnet-user-secrets-az-keyvault``. Go ahead and run your application with ``dotnet run`` and then navigate to ``http://localhost:8000/secret``.

You should see nothing as we haven't configured our user secret yet.

.. image:: /_static/images/secrets-and-backing/no-user-secrets.png

dotnet user-secrets
===================

In order to change our webpage so that it no longer says ``null`` we will need to enter a user secret for this project.

In your terminal navigate to the project directory ``/dotnet-user-secrets-az-keyvault``. From here enter ``dotnet user-secrets --help`` which will show us the help page for this tool. You will notice it is the User Secrets Manager. This will allow us to create and manage secrets per project.

Let's create our first secret from the terminal in the project directory enter ``dotnet user-secrets set name yourname``. This creates a new user secret for your project with the key value pair of "name=yourname". This can now be accessed by our locally running web app. Rerun your project with ``dotnet run``.

.. image:: /_static/images/secrets-and-backing/yourname-user-secret.png

Our app is now accessing our user secret and it is being displayed in our running webapp!

However, we are going to change ``yourname`` to your actual name. We can achieve this by overwriting the old user secret. ``dotnet user-secrets set name **yourname**``.

.. image:: /_static/images/secrets-and-backing/paul-user-secret.png

Using dotnet user-secrets is a way to keep sensitive data safe from your application, and keep yourself from accidently committing your secrets to Version Control (like git).

dotnet user-secrets is typically only used in a development environment for a production environment like when we are deploying our applications we would use a different tool, specifically the Azure KeyVault. The remainder of this walkthrough will show you how to work with Azure KeyVault.

Spin up RG and VM
=================

Before we can configure a KeyVault we will need to spin up a new Resource Group and VM to deploy this application.

You should use the following naming patterns:
  - Resource Group: yourname-rg-secrets
  - VM: yourname-vm-secrets

Install Dependencies to VM
==========================

After spinning up your VM inside a new Resource Group we will need to install the dependencies of our project namely dotnet.

.. sourcecode:: bash

   wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
   sudo dpkg -i packages-microsoft-prod.deb
   sudo apt-get update; \
     sudo apt-get install -y apt-transport-https && \
     sudo apt-get update && \
     sudo apt-get install -y dotnet-sdk-3.1

You can verify it installed properly by checking the version of the dotnet CLI:

.. sourcecode:: bash

   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   dotnet --version

Get Source Code
===============

The project we will be working with can be found at this `github repository https://github.com/pdmxdd/dotnet-user-secrets-az-keyvault`_

Clone it to your machine with the following bash commands:

.. sourcecode:: bash

   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   git clone https://github.com/pdmxdd/dotnet-user-secrets-az-keyvault
   ls /home/student

You should see a new folder named ``dotnet-user-secrets-az-keyvault`` which will contain the code for our project.

Create KeyVault
===============

Add Credentials to KeyVault
===========================

Update Code to Access KeyVault
==============================

Run Project
===========