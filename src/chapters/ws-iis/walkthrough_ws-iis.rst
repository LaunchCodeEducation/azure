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

  This walkthrough **requires a local Windows machine in order to use RDP**. Some of the ``az CLI`` steps are shown in both Windows/PowerShell and Linux/BASH to reinforce the cross-platform nature of the tool with minor syntactical changes.
  

Provision the VM
================

Create a Resource Group
-----------------------

As always we will begin by creating a resource group. This time we will combine creating and configuring it as the default group into one step! 

Notice how we use the ``--query`` Argument to have the output of the ``create`` Command be just the name of the new RG. We perform all of this within an in-line evaluation so the output (the RG name) can be assigned as the default group value:

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

Once the VM is created let's set is as the default VM: 

.. sourcecode:: powershell
  :caption: either shell

  > az configure -d vm=ws-vm


Set up & Explore IIS
====================

Now that we have our Windows Server VM we can get our first taste of using RDP. We will use RDP to enter the desktop of the VM and configure it to deploy our sample application.

.. admonition:: note

  **You must use a local Windows machine in order to RDP into the VM using** the pre-installed ``mstsc`` utility.


RDP into the VM
---------------

In order to RDP into a machine you need (at minimum):

- the IP address 
- username: ``student``
- password: ``LaunchCode-@zure1``

Since we have set the VM as our default we can use the ``list-ip-addresses`` Command and a query filter to get its value. We will capture the public IP address in a variable so we can use it to RDP into the machine:

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > $VmPublicIp=$(az vm list-ip-addresses --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress")

.. sourcecode:: bash
  :caption: Linux/BASH

  # output in tsv format
  $ vm_public_ip=$(az vm list-ip-addresses -o tsv --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress")

Now we can use the built-in ``mstsc`` command-line utility to open an RDP session with the machine:

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > mstsc /v:"$VmPublicIp"

This will begin the RDP authentication process and prompt you to enter your credentials:

.. image:: /_static/images/ws/rdp-credentials.png
  :alt: RDP credentials prompt

The first time you connect to a remote machine (using default RDP settings) you will need to confirm that you trust it. This is due to the default usage of a self-signed server certificate in the VM. The discussion of Public Key Infrastructure (PKI) and certificates is outside of the scope of this course but in this context the warning is nothing to be concerned about.


.. admonition:: tip

  In a production setting you would likely `configure a Group Policy Object <https://www.derekseaman.com/2018/12/trusted-remote-desktop-services-ssl-certs-for-win10-2019.html>`_ (GPO) for enforcing trusted connections. If you are curious feel free to look over that link but do not be concerned if it goes over your head! 

For now you can select "don't ask me again" and confirm to continue:

.. image:: /_static/images/ws/rdp-trust-remote-server.png
  :alt: RDP trust remote server prompt

If everything goes well a new window will appear that gives you access to the full desktop of the remote machine!

Explore the Server Manager
^^^^^^^^^^^^^^^^^^^^^^^^^^

The Server Manager application will then open to the dashboard overview:

.. image:: /_static/images/ws/server-manager-dashboard.png
  :alt: Windows Server Manager dashboard view

The SM can be used to monitor and manage fleets of servers, but for our purposes we will focus on a single server. You can select the ``Local Server`` tab on the left to switch to a view specific to the current VM:

.. image:: /_static/images/ws/server-manager-local.png
  :alt: Windows Server Manager local server view

Take a moment to explore this section of the SM. You can find details about how the server is configured as well as live performance statistics like CPU and memory usage.

.. image:: /_static/images/ws/server-manager-local-usage-stats.png
  :alt: Windows Server Manager local server usage statistics

Configure as a Web Server
-------------------------

Before we can host our application we need to configure our VM to operate as a Web Server using IIS. In the top right corner of the SM you will see a ``Manage`` dropdown containing an option to ``Add Roles and Features``. This will open the Roles and Features wizard::

.. image:: /_static/images/ws/server-manager-add-roles-features.png
  :alt: Windows Server Manager add Roles & Features

Next select the 


Explore the IIS Console
-----------------------

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
