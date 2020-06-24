==================================================
Walkthrough: dotnet user-secrets & Azure Key vault
==================================================

In our walkthrough today we will be deploying an application to a VM that uses Azure Key vault to manage sensitive data in our production environment (remote).

Before we deploy our application we want to first learn how to secure sensitive data locally on our machine, we will do this first and will use ``dotnet user-secrets`` to manage sensitive data in our development environment (local).

Look Over Code
==============

On your local machine clone the following repository.

.. sourcecode:: bash

   git clone https://github.com/pdmxdd/dotnet-user-secrets-az-keyvault

There are three files we are interested in.

``Startup.cs`` is the file in which we access our secret manager, ``dotnet user-secrets`` is loaded as the default, but can be overridden for specific environments and a different secret manager can be used. We are storing our secret in the static variable named ``Startup.secret``.

.. image:: /_static/images/secrets-and-backing/startup-cs.png

``SecretController.cs`` is the controller file where our secret is used. You will notice it is stored as a static variable named ``Startup.secret``.

.. image:: /_static/images/secrets-and-backing/secretcontroller-cs.png

``appsettings.json`` is the settings file that will contain the information about the Key vault we are connecting to. You will notice a key value pair with the key ``Key vaultName`` and the value is empty. Everyone will need to have a globally unique Key vault name. So we can't fill that for you. After creating our Key vault we will each need to enter in our own unique Key vault names.

.. image:: /_static/images/secrets-and-backing/appsettings-json.png

Before we make any changes to our code let's go ahead and run our project locally to see how it works.

Change into the directory you just cloned ``/dotnet-user-secrets-az-keyvault``. Go ahead and run your application with ``dotnet run`` and then navigate to ``http://localhost:8000/secret``.

You should see a line that says ``null``. This is what we expect for now because we haven't yet configured one of our secret managers, we will do that in the next step.

.. image:: /_static/images/secrets-and-backing/no-user-secrets.png

Development Environment secret manager
======================================

The CLI tool ``dotnet user-secrets`` will be the secret manager we use in our development environment. It is convient to work with because it can be managed easily from the CLI, and is loaded automatically into .NET projects.

In order to change our webpage so that it no longer says ``null`` we will need to enter a user secret for this project.

In your terminal navigate to the project directory ``/dotnet-user-secrets-az-keyvault``. 

From this location run

.. sourcecode:: bash

   dotnet user-secrets --help

You will notice it is the User Secrets Manager. This will allow us to create and manage secrets per project in our development environment.

Let's create our first secret from the terminal in the project directory enter ``dotnet user-secrets set name yourname``. 

.. sourcecode:: bash

   dotnet user-secrets set name yourname

This creates a new user secret for your project with the key value pair of "name=yourname". This can now be accessed by our locally running web app. Rerun your project with ``dotnet run``.

.. image:: /_static/images/secrets-and-backing/yourname-user-secret.png

Our app is now accessing our user secret and it is being displayed in our running webapp!

However, we are going to change ``yourname`` to your actual name. We can achieve this by overwriting the old user secret. ``dotnet user-secrets set name **yourname**``.

.. image:: /_static/images/secrets-and-backing/paul-user-secret.png

Using dotnet user-secrets is a way to keep sensitive data safe from your application, and keep yourself from accidently committing your secrets to Version Control (like git).

``dotnet user-secrets`` is typically only used in a development environment for a production environment like when we are deploying our applications we would use a different tool, specifically the Azure Key vault. The remainder of this walkthrough will show you how to work with Azure Key vault.

Spin up RG and VM
=================

Before we can configure a Key vault we will need to spin up a new Resource Group and VM to deploy this application.

You should use the following naming patterns:
  - Resource Group: yourname-rg-secrets
  - VM: yourname-vm-secrets

You are probably starting to get the hang of provisioning Resource Groups and VMs. Refer to the following pictures for help, if you are still confused checkout the walkthroughs from previous days.

.. image:: /_static/images/secrets-and-backing/provision-rg1.png

.. image:: /_static/images/secrets-and-backing/provision-rg2.png

.. image:: /_static/images/secrets-and-backing/provision-rg3.png

.. image:: /_static/images/secrets-and-backing/provision-vm1.png

.. image:: /_static/images/secrets-and-backing/provision-vm2.png

.. image:: /_static/images/secrets-and-backing/provision-vm3.png

.. image:: /_static/images/secrets-and-backing/provision-vm4.png

After provisioning these two known resources move on to the next step.

Install Dependencies to VM
==========================

After spinning up your VM inside a new Resource Group we will need to install the dependencies of our project namely dotnet.

Remeber to run these bash commands you will need to go to your VM, and under Operations select RunCommand, and then select RunShellScript to access the RunCommand console.

.. sourcecode:: bash

   wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
   sudo dpkg -i packages-microsoft-prod.deb
   sudo apt-get update; \
     sudo apt-get install -y apt-transport-https && \
     sudo apt-get update && \
     sudo apt-get install -y dotnet-sdk-3.1
   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   dotnet --version

You will know it installed correctly if you see the version number of the dotnet installation like the following picture the version is hilighted and is ``3.1.301``.

.. image:: /_static/images/secrets-and-backing/install-dotnet.png

If you are struggling to figure out which line from STDOUT is the version number you can simply run the following commands and it should be the only thing in the output section.

.. sourcecode:: bash

   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   dotnet --version

After you have successfully installed dotnet move on to the next step.

Get Source Code
===============

The project we will be working with can be found at this `github repository <https://github.com/pdmxdd/dotnet-user-secrets-az-keyvault>`_

Clone it to your Virtual Machine with the following bash commands in the RunCommand section of the Azure Portal:

.. sourcecode:: bash

   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   cd /home/student
   git clone https://github.com/pdmxdd/dotnet-user-secrets-az-keyvault
   ls /home/student

You should see a new folder named ``dotnet-user-secrets-az-keyvault`` which will contain the code for our project.

.. image:: /_static/images/secrets-and-backing/vm-clone.png

Once you see ``dotnet-user-secrets-az-keyvault`` in the STDOUT section of your run command move on.

Create Key vault
================

We have the source code of our project on our VM, it is configured to work with an Azure Key vault, however before we deploy our application we need to create our Key vault and put a secret into the Key vault.

Search for the Key vault blade.

.. image:: /_static/images/secrets-and-backing/keyvault-search.png

Looking at the main page we will want to add a new Key vault. Click the add button.

.. image:: /_static/images/secrets-and-backing/keyvault-add.png

This will take you to the Key vault creation wizard.

.. note::

   Key vault names must be globally unique. This means you may have to try a few different Key vault names to get it to work. However, your source code must match the Key vault name you choose. So take note of your Key vault name as we will be referencing it later.

Fill out the form with your resource group name ``yourname-rg-secrets`` and your Key vault name we recommend using a pattern like ``yourname-kv-secrets``, but you may need to make some changes to your Key vault name since all Key vault names are globally unique.

.. image:: /_static/images/secrets-and-backing/keyvault-form.png

After completing the form click create.

.. image:: /_static/images/secrets-and-backing/create-keyvault.png

Add Credentials to Key vault
============================

Now that we have a Key vault we will need to add our secret to this Key vault. Our application is expecting a key value pair of ``Name=yourname``.

Create a new credential in your Key vault.

Update Code to Access Key vault
===============================

Finally we will need to change the code of our project to point to our newly minted Key vault.

You will need to change your code locally, create a new GitHub respository with your changed code, and then finally clone that repository on your VM.

Run Project
===========

Finally to use the Key vault instead of user-secrets you will need to publish your project so that it is in a production environment which will trigger our app to use Key vault instead of user-secrets.