=================================================
Walkthrough: dotnet user-secrets & Azure KeyVault
=================================================

In our walkthrough today we will be deploying an application to a VM that uses Azure KeyVault to manage sensitive data in our production environment (remote).

Before we deploy our application we want to first learn how to secure sensitive data locally on our machine, we will do this first and will use ``dotnet user-secrets`` to manage sensitive data in our development environment (local).

Look Over Code
==============

On your local machine clone the following repository.

.. sourcecode:: bash

   git clone https://github.com/pdmxdd/dotnet-user-secrets-az-keyvault

There are three files we are interested in.

``Startup.cs`` is the file in which we access our secret manager, ``dotnet user-secrets`` is loaded as the default, but can be overridden for specific environments and a different secret manager can be used. We are storing our secret in the static variable named ``Startup.secret``.

``SecretController.cs`` is the controller file where our secret is used. You will notice it is stored as a static variable named ``Startup.secret``.

``appsettings.json`` is the settings file that will contain the information about the KeyVault we are connecting to. You will notice an empty key-value pair with the key ``KeyVaultName`` after we create our Azure KeyVault we will need to add the name to this file, so our project will know which KeyVault to get our secrets from.

Before we make any changes to our code let's go ahead and run our project locally to see how it works.

Change into the directory you just cloned ``/dotnet-user-secrets-az-keyvault``. Go ahead and run your application with ``dotnet run`` and then navigate to ``http://localhost:8000/secret``.

You should see a line that says ``null``. This is what we expect for now because we haven't yet configured one of our secret managers, we will do that in the next step.

.. image:: /_static/images/secrets-and-backing/no-user-secrets.png

Development Environment secret manager
======================================

The CLI tool ``dotnet user-secrets`` will be the secret manager we use in our development environment. It is convient to work with because it can be managed easily from the CLI, and is loaded automatically into .NET projects.

In order to change our webpage so that it no longer says ``null`` we will need to enter a user secret for this project.

In your terminal navigate to the project directory ``/dotnet-user-secrets-az-keyvault``. From here enter ``dotnet user-secrets --help`` which will show us the help page for this tool. You will notice it is the User Secrets Manager. This will allow us to create and manage secrets per project in our development environment.

Let's create our first secret from the terminal in the project directory enter ``dotnet user-secrets set name yourname``. This creates a new user secret for your project with the key value pair of "name=yourname". This can now be accessed by our locally running web app. Rerun your project with ``dotnet run``.

.. image:: /_static/images/secrets-and-backing/yourname-user-secret.png

Our app is now accessing our user secret and it is being displayed in our running webapp!

However, we are going to change ``yourname`` to your actual name. We can achieve this by overwriting the old user secret. ``dotnet user-secrets set name **yourname**``.

.. image:: /_static/images/secrets-and-backing/paul-user-secret.png

Using dotnet user-secrets is a way to keep sensitive data safe from your application, and keep yourself from accidently committing your secrets to Version Control (like git).

``dotnet user-secrets`` is typically only used in a development environment for a production environment like when we are deploying our applications we would use a different tool, specifically the Azure KeyVault. The remainder of this walkthrough will show you how to work with Azure KeyVault.

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

When we deploy our application we will be using KeyVault to access our secrets. So we will first need to setup an Azure KeyVault in our Resource Group.

Search for the KeyVault blade.

.. image:: /_static/images/secrets-and-backing/keyvault-search.png

Looking at the main page we will want to add a new KeyVault. Click the add button, which will take you to a form to create your new keyvault follow this pattern for your name ``yourname-kv-secrets``.

After completing the form click create

.. image:: /_static/images/secrets-and-backing/create-keyvault.png

Add Credentials to KeyVault
===========================

Now that we have a KeyVault we will need to add our secret to this KeyVault. Our application is expecting a key value pair of ``Name=yourname``.

Create a new credential in your KeyVault.

Update Code to Access KeyVault
==============================

Finally we will need to change the code of our project to point to our newly minted KeyVault.

You will need to change your code locally, create a new GitHub respository with your changed code, and then finally clone that repository on your VM.

Run Project
===========

Finally to use the KeyVault instead of user-secrets you will need to publish your project so that it is in a production environment which will trigger our app to use KeyVault instead of user-secrets.