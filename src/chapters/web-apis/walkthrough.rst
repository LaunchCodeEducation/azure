==============================
Walkthrough: Connect to an API
==============================

In this walkthrough we will be deploying our first API with Azure.

Throughout this week we will use Ubuntu operating system on the hardware of our Virtual Machine. Next week we will be deploying to a Windows Server operating system. Due to the powerful DotNetCore libraries the same project will be deployable to multiple different operating systems.

We have a few steps we will need to accomplish to deploy and access our application:
    - Create a Resource Group
    - Spin up a VM with an Ubuntu OS
    - Configure our VM to run our application
    - Create our source code
    - Create the build artifacts that will be deployed
    - Deploy project
    - Connect to deployed project

Login to Azure Portal
=====================

Before we can deploy our application to a VM, we will need to first access our Azure accounts. You shoud have set this up yesterday, go ahead and login and navigate to the main screen.

.. image:: /_static/images/web-apis/walkthrough-azure-home.png

Create a Resource Group
=======================

A resource group is a great way of organizing your Azure resources. Since we are deploying a project for the first time let's create a unique resource group to contain anything we will need to create for this project.

Navigate to the resource group blade by searching for resource group in the search bar.

.. image:: /_static/images/web-apis/walkthrough-search-resource-group.png

From here you will want to add a new Resource Group, which will provide you with a form for creating your resource group.

.. image:: /_static/images/web-apis/walkthrough-new-rg.png

Name your resource group following this pattern: ``your-name-lc-rg-web-api``. You will need to remember this resource group name so that you can shutdown all your resources at the end of the day.

.. image:: /_static/images/web-apis/walkthrough-new-rg-form.png

After entering your resource group name click review and create, and then finally the create button on the review screen. It will take you back to the resource group home page, and after a couple of minutes you will see your new resource group.

.. image:: /_static/images/web-apis/walkthrough-all-rgs.png

Now if you go to the resource group blade homepage you should see the new resource group with the name you entered in the list.

Spin up VM
==========

Now that we have a resource group to contain all of the resources we need for this project we can start spinning up the resources we will need for our deployment.

Luckily this deployment is pretty simple and will only need 1 Ubuntu VM.

To spin up this VM search for the Virtual Machine blade in the search bar.

.. image:: /_static/images/web-apis/walkthrough-search-vm.png

Clicking this blade will take you to the home page for all your VMs. For now it is most likely an empty list. We will change that soon.

.. image:: /_static/images/web-apis/walkthrough-vm-home.png

We will need to create a new VM, which will require us to go through a lengthy web form. To get started click the add VM button which will take you to the first screen.

.. image:: /_static/images/web-apis/walkthrough-vm-1.png

On this page we will need to fill out quite a few things, but will be sticking to defaults as much as possbile.

We will need to set:
  - Resource group: ``your-name-lc-rg-web-api``
  - Virtual Machine Name: ``your-name-lc-vm-web-api``
  - Region: East US
  - Image: Ubuntu Server 18.04 LTS
  - Size: Standard_B2s - 2 vcpu, 4 GiB memory ($$$)
  - Authentication type: Password
  - username: student
  - password: LaunchCode-@zure1
  - confirm password: LaunchCode-@zure1

.. image:: /_static/images/web-apis/walkthrough-vm-2.png

After filling out the form click review and create. On the review screen double check that you created your VM with the settings listed above, then finally click Create.

After creating the VM it will take a couple of minutes for the VM to fully provision. This takes time because Azure is doing a lot of things for us in the background. They are accessing a server at one of theri many data centers in the region we selected, and creating a virutal machine with the requirements we entered. Then it has to create the file structure on the virutal machine. After that it has to configure the network so the machine is accessible to us through the internet including a public IP. Only when all of that is one can we access our machine.

Configure VM
============

Now that we have created a VM we will need to configure it so that it is ready to run our project. Configuration can be done in many ways, and you will see a couple of them in this class. Today we will configure our VM by sending it BASH commands through the Command section of the Azure Portal.

When we enter commands here they will be run, just like we were in a bash terminal on the VM!

Create Project
==============

Publish Project
===============

Run Project
===========

Connect to Source Code
======================