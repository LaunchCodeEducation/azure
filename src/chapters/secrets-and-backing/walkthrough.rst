==================================================
Walkthrough: dotnet user-secrets & Azure Key vault
==================================================

In our walkthrough today we will be deploying an application to a VM that uses Azure Key vault to manage sensitive data in our production environment (remote).

Before we deploy our application we want to first learn how to secure sensitive data locally on our machine, we will do this first and will use ``dotnet user-secrets`` to manage sensitive data in our development environment (local).

Look Over Code
==============

For this walkthrough we will be deploying the same project, but we will each have to fork the project, because we are each going to have to make use our own unique Key vault name. So to start this walkthrough fork `this repository <https://github.com/LaunchCodeEducation/dotnet-user-secrets-az-keyvault>`_ to your own GitHub account.

After you fork this project clone your new repository to your machine.

.. sourcecode:: bash

   git clone https://github.com/YOURUSERNAME/dotnet-user-secrets-az-keyvault

.. note::

   If you got an error trying to clone your project make sure you replaced ``YOURUSERNAME`` with your actual GitHub username after you forked the repo listed above.

There are three files we are interested in. Let's take a look at them.

``Startup.cs`` is the file in which we access our secret manager, ``dotnet user-secrets`` is loaded as the default, but can be overridden for specific environments and a different secret manager can be used. We are storing our secret in the static variable named ``Startup.secret``.

.. image:: /_static/images/secrets-and-backing/startup-cs.png

``SecretController.cs`` is the controller file where our secret is used. You will notice it is stored as a static variable named ``Startup.secret``.

.. image:: /_static/images/secrets-and-backing/secretcontroller-cs.png

``appsettings.json`` is the settings file that will contain the information about the Key vault we are connecting to. You will notice a key value pair with the key ``Key vaultName`` and the value is empty. Everyone will need to have a globally unique Key vault name. So we can't fill that for you. After creating our Key vault we will need to enter in our own unique Key vault names.

.. image:: /_static/images/secrets-and-backing/appsettings-json.png

Before we make any changes to our code let's go ahead and run our project locally to see how it works.

Change into the directory you just cloned ``/dotnet-user-secrets-az-keyvault``. Go ahead and run your application with ``dotnet run`` and then navigate to ``http://localhost:8000/secret``.

You should see a line that says ``null``. This is what we expect for now because we haven't yet configured one of our secret managers, we will do that in the next step.

.. image:: /_static/images/secrets-and-backing/no-user-secrets.png

Development Environment Secret Manager
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

Create Resource Group
=====================

Before we can configure a Key vault we will need to provision a new Resource Group.

You should use the following pattern for your Resource Group Name: ``yourname-rg-secrets``.

Following are images that will remind you how to create a Resource Group. Refer to previous walkthroughs if you need additional help.

.. image:: /_static/images/secrets-and-backing/provision-rg1.png

.. image:: /_static/images/secrets-and-backing/provision-rg2.png

.. image:: /_static/images/secrets-and-backing/provision-rg3.png

After creating your Resource Group move on to the next step.

Provision VM
============

We will need a VM to deploy our application. So let's create a new one now.

You are probably starting to get the hang of provisioning VMs. Refer to the following pictures for help, if you are still confused checkout the walkthroughs from previous days.

.. image:: /_static/images/secrets-and-backing/provision-vm1.png

.. image:: /_static/images/secrets-and-backing/provision-vm2.png

.. image:: /_static/images/secrets-and-backing/provision-vm3.png

.. image:: /_static/images/secrets-and-backing/provision-vm4.png

After provisioning your VM move on to the next step.

Create Key Vault
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

.. image:: /_static/images/secrets-and-backing/keyvault-create.png

Grant VM Access to Key Vault
============================

An important step is to grant our VM access to our Key vault. Even though our application will be configured to access the Key vault. By default the Key Vault blocks everything from accessing it's contents except for things that have been explictly granted.

Since we already have a Key vault, and a VM we can grant our VM access to our Key vault.

We will do this from the Key vault so navigate back to the home page for Key vaults and select the Key vault you created for this project.

.. image:: /_static/images/secrets-and-backing/grant-access1.png

From here you will need to select ``Access Policies`` under the Settings header.

.. image:: /_static/images/secrets-and-backing/grant-access2.png

From here we will need to click ``Add Access Policy`` to grant our VM permission to access this Key vault.

.. image:: /_static/images/secrets-and-backing/grant-access3.png

This pulls up a new form which we will fill out by selecting the template ``Secret Management`` which will auto fill out the next boxes. Then we will need to click on ``None Selected`` next to ``Service Principal``.

.. image:: /_static/images/secrets-and-backing/grant-access4.png

When you click ``None Selected`` next to ``Service Principal`` a window will pop out letting you enter the Service Principal you want to grant access to this Key vault. We will be entering the name of our VM into the search box and it should find it for you.

.. image:: /_static/images/secrets-and-backing/grant-access5.png

After the search box found the VM I simply selected it and then clicked the ``Select`` button and it added it to the form for me.

.. image:: /_static/images/secrets-and-backing/grant-access6.png

Now to complete the creation of this Access Policy I just need to hit the ``Add`` button. Which takes us back to the Access Policy screen and we can see the new Policy that was created for our VM.

.. image:: /_static/images/secrets-and-backing/grant-access7.png

And that's it! We have granted our VM access to the secrets contained within our Key vault. Next we will add a secret.

Add Secret to Key Vault
=======================

Now that we have a Key vault we will need to add our secret to this Key vault. Our application is expecting a key value pair of ``Name=yourname``.

To add secrets to our Key vault we need to first select our newly create Key vault, and navigate to the ``Secrets`` section under Settings.

.. image:: /_static/images/secrets-and-backing/keyvault-secrets.png

Then click the ``Generate/Import`` button.

.. image:: /_static/images/secrets-and-backing/keyvault-generate-import.png

Then fill out the form manually with your Key value pair. 

Key: ``Name``
Value: ``yourname``

.. image:: /_static/images/secrets-and-backing/keyvault-form-filled-out.png

Click the ``Create`` button to add this secret to your Key vault. Which will take us back to the Key vault main page and we will see our new secret's Key:

.. image:: /_static/images/secrets-and-backing/keyvault-secret-final.png

Update Code to Access Key Vault
===============================

Earlier we forked, and cloned the project repistory and looked at three crucial files.

We now need to edit one of those files now that we have a Key vault name.

Open ``appsettings.json`` with your editor of choice (Visual Studio, Visual Studio Code, etc).

You will see a key-value pair with the key being ``KeyVaultName`` for the value enter the Key vault name you created in this walkthrough.

.. image:: /_static/images/secrets-and-backing/edit-appsettings-json.png

Now that we have made changes to this file, make sure to save your changes and then push these changes up to your repo. We will be pulling this repository from our VM, and we need it to have the change we just made so it can access our Key vault!

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

The project we want to deploy is the same repository you created on GitHub just a couple of steps ago. You need to deploy the project on your repository since it contains the source code that references your unique Key vault. Once you have the URL for that repository you will need to replace the URL in the following source code block with the URL to your repository.

Clone it to your Virtual Machine with the following bash commands in the RunCommand section of the Azure Portal making sure to replace ``YOUR-GITHUB-REPO-URL`` with your actual GitHub repo URL:

.. note::

   If you forked the repository your GitHub URL will look something like this ``https://github.com/YOUR-GH-USERNAME/dotnet-user-secrets-az-keyvault``. Double check that you reference the URL correctly or it won't work in the Azure RunCommand.

.. sourcecode:: bash

   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   cd /home/student
   git clone YOUR-GITHUB-REPO-URL
   ls /home/student

.. note::

   If you run into any issues double check that your GitHub URL is correct!

You should see a new folder named ``dotnet-user-secrets-az-keyvault`` which will contain the code for our project.

.. image:: /_static/images/secrets-and-backing/vm-clone.png

Once you see ``dotnet-user-secrets-az-keyvault`` in the STDOUT section of your run command move on.

Publish
=======

Finally to use the Key vault instead of user-secrets you will need to publish your project so that it is in a production environment which will trigger our app to use Key vault instead of user-secrets.

We will need to publish and run our project.

To publish we will need to be in the root directory of our project, and run the ``dotnet publish`` command.

.. note::

   Remember that the RunCommand commands are being run as the root user and therefore doesn't have a home directory so we have to add some environment variables when touching various tools like the dotnet CLI.

.. sourcecode:: bash

   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   cd /home/student/dotnet-user-secrets-az-keyvault
   dotnet publish -c Release -r linux-x64 -p:PublishSingleFile=true

.. image:: /_static/images/secrets-and-backing/dotnet-publish.png

Deploy
======

.. sourcecode:: bash

   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   cd /home/student/dotnet-user-secrets-az-keyvault
   ASPNETCORE_URLS="http://*:80" ./bin/Release/netcoreapp3.1/linux-x64/publish/api-user-secrets

.. image:: /_static/images/secrets-and-backing/dotnet-deploy.png

VM Security Groups
==================