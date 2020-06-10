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

Configure Web Server Role
-------------------------

Before we can host our application we need to configure our VM to operate as a Web Server Role. In the top right corner of the SM you will see a ``Manage`` dropdown containing an option to ``Add Roles and Features``. This will open the Roles and Features wizard:

.. image:: /_static/images/ws/server-manager-add-roles-features.png
  :alt: Windows Server Manager add Roles & Features

Because we are configuring this single server we can select the first option:

.. image:: /_static/images/ws/rf-wizard-role-based.png
  :alt: Roles & Features wizard Role based installation

We want to select our server by its name. We should only have a single server in our pool:

.. image:: /_static/images/ws/rf-wizard-select-server.png
  :alt: Roles & Features wizard select server by name

We want to configure our server to assume the Web Server Role to use the IIS Web Server. You can find this Role at the end of the Server Roles list:

.. image:: /_static/images/ws/rf-wizard-select-role.png
  :alt: Roles & Features wizard add Web Server (IIS) Role

Because IIS requires the IIS Management Console to configure it we are prompted to install the required Feature. Although it can be installed and used remotely we will install it locally on this server. Select Add Features to install it:

.. image:: /_static/images/ws/rf-wizard-iis-features.png
  :alt: Roles & Features wizard install IIS Management Console Feature

For our purposes we will not require any other Role Services beyond the defaults. Feel free to read over what each Role Service does by selecting it and reading its description on the right side panel. **Be careful not to check any boxes beyond those that are already selected by default**:

.. image:: /_static/images/ws/rf-wizard-iis-select-role-services.png
  :alt: Roles & Features wizard select IIS Role Service defaults

Finally you can continue to the Confirmation tab. Double check that your selections match the list below. The installation process may take a minute or two but will not require a restart:

.. image:: /_static/images/ws/rf-wizard-iis-confirm.png
  :alt: Roles & Features wizard confirm Web Server (IIS) Role

Explore the IIS Manager
-----------------------

Once the installation is complete you can open the IIS Manager. In your taskbar search for IIS:

.. image:: /_static/images/ws/search-iis-manager.png
  :alt: Search for IIS Manager

The IIS Manager dashboard shows all of the servers that are linked to it. In our case we will see just our single VM listed. Within each Server are sections for configuring the Application Pools and Sites that will be served by IIS from that machine.

IIS includes a pre-configured default Site and Application Pool to get you started. Let's take a look at the Default Site:

.. image:: /_static/images/ws/iis-sites.png
  :alt: IIS Manager Sites view

From the Sites tab you can see all of the Sites that are being served by IIS. Notice how each Site has a name, a binding (what port it listens on) and a path to its content directory.

Selecting the Default Site will display the Site dashboard. From here you can configure all of the content-related aspects of the Site. 

.. image:: /_static/images/ws/iis-default-site.png
  :alt: IIS Manager Default Site dashboard

At the bottom of the view is a tab to switch from Features to Content. Selecting the Content tab shows the contents of the Site's directory. For the default Site there are just two files -- an HTML file and an image:

.. image:: /_static/images/ws/iis-default-site-content-view.png
  :alt: IIS Manager Default Site content view

Within the Content view mode you can select the Explore option on the right-side panel. 

.. image:: /_static/images/ws/iis-default-site-explore-files.png
  :alt: IIS default Site Explore action

This will open the file explorer to the content directory path to see and manage the files directly. Notice how this directory path matches the default Site path we saw in the Sites overview earlier:

.. image:: /_static/images/ws/iis-default-site-files.png
  :alt: IIS default Site contents in file explorer

Connect to the default site within the VM
------------------------------------------

Once IIS has been installed, through the Web Server Role, it immediately begins serving the default Site on port 80. You can open the IE browser within the Server to ``http://localhost`` to view it. Notice how we do not need to include the port because the browser sets it implicitly as the standard ``http`` protocol port. 

.. admonition:: warning

  As part of the Windows Server security defaults IE is locked down to restrict its usage. Unless you have good reason to stray from these defaults you should accept them and proceed to viewing the default Site. 

.. image:: /_static/images/ws/iis-default-site-browser.png
  :alt: IIS default Site in the local Server browser

Connect to the default site from your local machine
----------------------------------------------------

So far we have been able to connect to the default Site within the Server itself. But what about connecting to it publicly over the internet? By now you should understand that navigating to ``http://localhost`` on your local machine will not request the default Site. 

Instead we will need to use the public IP address of our VM in place of ``localhost``. This should make sense because it is not **locally hosted** anymore -- it is publicly hosted! Or is it? 

On your local machine open your browser and navigate to ``http://<your VM public IP>``:

.. image:: /_static/images/ws/iis-default-site-local-browser-timeout.png
  :alt: IIS default Site local browser timeout

Before continuing take a moment to consider *why the connection timed out*. Use what you have learned to apply critical thinking to this all too common issue when hosting on the web. 

.. admonition:: tip

  Connection timeouts are an indication of a *network related issue*. If you receive a status code ``5XX`` it means a connection was formed but something went wrong with the server. Receiving no response at all means that some sort of machine or network level firewall has blocked the connection from ever being formed.

When we provisioned our VM we assumed default network security group (NSG) rules. The default NSG configuration for a new VM does not allow traffic to reach the machine through any port including the common HTTP ports (80 for ``http`` and 443 for ``https``). 

However, when you create a Windows Server VM a new rule that exposes port 3389 is opened automatically to allow for RDP traffic. This behavior is described in the ``az vm create -h`` listing.

Adding a new NSG rule
---------------------

In order to connect to our VM, and therefore the Site, we need to add an additional NSG rule that will allow traffic on port 80. Fortunately this is a quick fix using our trusty ``az CLI`` and the VM ``open-port`` Command.

.. sourcecode:: powershell
  :caption: assumes a default RG, location and VM have been configured

  > az vm open-port --port 80

You will receive a lengthy output showing the current state of the NSG associated with the VM. Most of the output is related to the first property, ``defaultSecurityRules``. Towards the bottom you will the ``securityRules`` list which includes both the RDP and the new port 80 rules.

.. code-block:: json
  :caption: trimmed securityRules list showing rules allowing RDP and http public traffic

  ...
  "securityRules": [
    {
      "access": "Allow",
      "destinationPortRange": "3389",
      "direction": "Inbound",
      "name": "rdp",
      ...
    },
    {
      "access": "Allow",
      "destinationPortRange": "80",
      "direction": "Inbound",
      "name": "open-port-80",
      ...
    }
  ],
  ...

.. admonition:: note

  This Command opens a port for *all public traffic*. In other words, requests from *any IP address* and *any protocol* will be allowed access to our VM on port 80. This is a quick solution for our purposes. But in a production setting you will likely use more rigorous NSG rules with source wIP and protocol restrictions for greater security.


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
