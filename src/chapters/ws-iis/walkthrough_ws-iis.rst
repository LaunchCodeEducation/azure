.. _walkthrough_ws-iis:

============================================
Walkthrough: Windows Server & IIS Deployment
============================================

Now that we have learned about remote access mechanisms and the IIS Manager it's time to get our hands dirty! In this walkthrough we will:

- provision a Windows Server VM
- RDP into the machine to install, explore and configure IIS
- execute scripts remotely to configure the host  machine
- deploy a .NET starter API to IIS

.. admonition:: note

  This walkthrough requires a local Windows machine in order to use RDP. Some of the ``az CLI`` steps are shown in both Windows/PowerShell and Linux/BASH to illustrate that they can work cross-platform with minor syntactical changes.
  

Provision the VM
================

Create a Resource Group
-----------------------

As always we will begin by creating a resource group. This time we will combine the creating and configuring the default into one step! Notice how we use the ``--query`` Argument to have the output of the ``create`` Command be just the name of the new RG. We perform all of this within an in-line evaluation so the output (the RG name) can be assigned as the default group value:

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > az configure -d group=$(az group create -n <name>-ws-wt --query "name")

.. sourcecode:: bash
  :caption: Linux/BASH

  # remember in BASH we have to output in tsv format to remove the default JSON quote characters
  $ az configure -d group=$(az group create -n <name>-ws-wt -o tsv --query "name")

Create a Windows Server VM
---------------------------

Next let's create our Windows Server VM within the new RG. Windows Server has been around for many years. For our purposes we will use the latest, 2019, edition. Just as we did with the Ubuntu VM let's search the available VM images for the ``urn`` of the 2019 Windows Server image. In this case we need to provide a *compound filter* that will look for a ``urn`` that ``contains`` both ``Windows`` *and* ``2019``:

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > az vm image list --query "[? contains(urn, 'Windows') && contains(urn, '2019')] | [0].urn"
  # "MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest"

Let's assign this value to a variable:

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > $WsImageUrn=$(az vm image list --query "[? contains(urn, 'Windows') && contains(urn, '2019')] | [0].urn")

.. sourcecode:: bash
  :caption: Linux/BASH

  # don't forget to output in tsv format
  $ ws_image_urn=$(az vm image list -o tsv --query "[? contains(urn, 'Windows') && contains(urn, '2019')] | [0].urn")

To create our VM we will use most of the same Arguments as we did when creating the Linux machine. Whereas Linux VMs will enable SSH access by default, new Windows Server VMs will have RDP enabled instead. However, recall that RDP uses a basic username and password credential set instead of the RSA keys used in SSH. We will need to provide one additional flag ``--admin-password`` when creating the WS VM:

.. admonition:: warning

  It is important that you do not change the admin username (``student``) or password (``LaunchCde-@zure1``). Although it is a poor practice to use the same password for everyone we do so for consistency in order to make it easy to help you debug if somethings goes wrong.

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > az vm create -n ws-vm --size "Standard_B2s" --image "$WsImageUrn" --admin-username "student" --admin-password "LaunchCde-@zure1" --assign-identity

.. sourcecode:: bash
  :caption: Linux/BASH

  $ az vm create -n ws-vm --size "Standard_B2s" --image "$ws_image_urn" --admin-username "student" --admin-password "LaunchCde-@zure1" --assign-identity

Once the VM is created let's set is as the default VM and capture its public IP address in a variable so we can use it to RDP into the machine:

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > az configure -d vm=ws-vm

  > $VmPublicIp=$(az vm list-ip-addresses --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress")

.. sourcecode:: bash
  :caption: Linux/BASH

  $ az configure -d vm=ws-vm

  # output in tsv format
  $ vm_public_ip=$(az vm list-ip-addresses -o tsv --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress")


Set up & Explore IIS
====================

RDP into the VM
---------------

Install IIS Server Manager
--------------------------

Connect to the default site within the VM
------------------------------------------

Connect to the default site from your local machine
----------------------------------------------------

Configure the Host VM
=====================

Install Dependencies
--------------------

Configure IIS to host a .NET API site
-------------------------------------

Deploy a .NET API
=================

Create the starter API
----------------------

Publish the API
---------------

Next Step
=========

Test your work
--------------

Clean up resources
------------------
