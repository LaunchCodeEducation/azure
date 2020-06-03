.. _intro_ws:

==============================
Introduction to Windows Server
==============================

Previously we used the Azure web portal to provision and deploy our API to an Ubuntu Linux VM. In order to execute commands and scripts to configure the deployment we used the RunCommand tool that was built into the web portal. 

Today we will learn about the other choice of OS for hosting our web applications -- Windows Server. Now that you are more comfortable working away from the web portal we will also learn how to remotely access our new Windows Server VM from outside of the browser.

A Native Server OS
==================

Windows Server (WS) is built on top of the same base as the PC-grade Windows 10 operating system but has been customized for use as a server. While there are many Windows 10 editions from consumer to enterprise none of them are optimized for server workloads like WS. Servers naturally have greater operational demand than PCs. As a result WS has been designed to manage significantly greater memory and CPU allocations than what someone would run on a PC -- even a decked out gaming rig.

.. admonition:: fun fact

    Windows Server is capable of managing an incredible 24 **terabytes** of RAM and *any number* of CPU cores! But can it run Crysis?

Because WS is designed for computing it strips away many of the applications and features that are meant for PCs. The result is a smaller OS footprint that reduces resource usage. These savings may seem small for individual machines but can be appreciable when managing large fleets of servers. 

A smaller OS also means **less code to monitor for and protect against** potential vulnerabilities. The reduced attack surface of the slimmer OS is complemented by sensible firewall defaults and other restrictions that further bolster its security profile relative to a PC.

Installation Options
--------------------

WS Desktop Experience
^^^^^^^^^^^^^^^^^^^^^

The default Windows Server VM image includes a full GUI shell just like Windows 10. The WS Desktop Experience installation option makes working with WS as familiar as working on your machine at home. While it gets rid of consumer applications it replaces them with a collection of administrative tools including the Server Manager we will be using in this class.

WS Core
^^^^^^^

Windows Server also comes in a nearly headless **Core** option which removes the majority of the desktop GUI leaving only a PowerShell terminal! Windows Server Core is even leaner than WS Desktop allowing you to start *from the core* and add just the features and applications you need. Windows Server Core represents an *unopinionated* server OS that leaves it to you to customize exactly what is needed for your use case. You can read more about the WS Core design and comparison to the more opinionated WS Desktop Experience `in this article<https://docs.microsoft.com/en-us/windows-server/administration/server-core/what-is-server-core>`_. 

Server Manager
--------------

The Windows Server Manager is a powerful GUI-based tool for monitoring and managing your Windows Server. In more advanced contexts the Server Manager (SM) can even be used to manage multiple physical or virtual WS machines. Windows Server Manager comes pre-installed on the WS Desktop edition but can be manually installed on your Windows 10 PC as well.

The Server Manager is the entry point of the WS VM and is presented to you after opening a Remote Desktop session. 

.. image:: /_static/images/ws/server-manager.png
    :alt: Server Manager dashboard

Within the SM you can configure many aspects of the server including updates, storage access, firewall and other security settings. The Server Manager can also be used to monitor the performance of a server with live insights into its memory, disk and CPU usage.

In this course we will use the SM to manage the Roles and Features of the **Local Server** (local relative to the machine the SM is running on). The Roles and Features wizard can be used to install and configure additional tooling like the IIS Web Server Manager which we will cover in later lessons.

.. image:: /_static/images/ws/sm-roles-features-wiz.png
    :alt: Server Manager Roles and Features Wizard

Remote Management
=================

Remote management is the practice of accessing and managing a (remote) machine from another (local) machine. For consumers, Remote management (RM) is often used by help desk professionals to troubleshoot issues by controlling the client's PC instead of relaying instructions over the phone. In our context we use RM to manage our servers which, being virtual, can never be accessed physically. 

So far you have experienced a simplistic form of RM using the Azure web portal's RunCommand console. Although the RunCommand console was convenient for us to interact with our Ubuntu VM it is not commonly, if ever, used by professionals due to its inherent limitations. As you likely noticed the RunCommand console is browser-based, slow, and only able to send commands and print their outputs one at a time. In order to effectively configure and troubleshoot our VMs we need more robust RM tooling.

Azure CLI RunCommand
--------------------

Recall that both the Azure CLI and the web portal GUI are backed by the same REST API. We have also learned that working from the command-line offers greater portability and automation capability relative to using a browser based GUI. With the ``az CLI`` we are able to use the same RunCommand we experienced in the browser but with all of the benefits of the command-line. 

.. admonition:: tip

    Unlike the browser console you can use the ``az CLI`` to issue RunCommands to *multiple machines at once* using their resource IDs (VM identities)!

Within the Azure CLI the ``vm`` Sub-Group ``run-command`` can be used to toggle commonly used machine settings or execute complete scripts remotely. Every RunCommand has a unique name known as its ``command-id`` which you can view using ``list``:

.. sourcecode:: powershell
    :caption: assumes the default location has been configured

    > az vm run-command list

    # concise table output using a JMESPath query 
    > az vm run-command list --query "[].{ commandId: id, label: label }" -o table

To issue a RunCommand use the ``invoke`` Command:

.. sourcecode:: powershell
    :caption: assumes a default RG, location and VM have been configured

    > az vm run-command invoke --command-id <command ID>

There are several RunCommand commands that perform specific actions on the remote machine. However, you will often want to run custom scripts or shell commands directly. Executing scripts remotely use the ``RunPowerShellScript`` and ``RunShellScript`` command IDs for Windows and Linux respectively.

Using these RunCommand commands is the command-line equivalent of pasting the script into the RunCommand console in the browser. You can run any number of scripts using the ``--scripts`` argument. These can be single quoted shell commands or references to pre-written script files on your local machine.

.. admonition:: tip

  For Windows VMs you should use ``RunPowerShellScript`` and for Linux VMs use ``RunShellScript``. Note that **this is in reference to the remote VM you are interacting with**, not the OS of your local machine that is issuing the RunCommand. 

Here is an example of issuing single shell commands that simply list files in the home directory of the VM. For Windows we use the PowerShell``Get-ChildItem`` and for Linux its BASH equivalent ``ls``. 

.. sourcecode:: powershell
    :caption: assumes a default RG, location and VM have been configured

    # for a windows VM run a PowerShell script (uses PowerShell in the VM)
    > az vm run-command invoke --command-id RunPowerShellScript --scripts "Get-ChildItem"

    # for a linux VM run a Shell script (uses the default shell of the VM)
    > az vm run-command invoke --command-id RunShellScript --scripts "ls"

For longer scripts than one-off commands like the examples above you will want to reference pre-written script files on your local machine. You can do this using the ``@/path/to/script`` syntax. 

Here is an example that uses a script file located in the home (``~``) directory called ``myscript.<ext>`` with the appropriate extension (PowerShell or BASH) corresponding to the OS of the remote VM.

.. sourcecode:: powershell
    :caption: assumes a default RG, location and VM have been configured

    # myscript.ps is a PowerShell script
    > az vm run-command invoke --command-id RunPowerShellScript --scripts @~/myscript.ps

    # myscript.sh is a BASH script
    > az vm run-command invoke --command-id RunShellScript --scripts @~/myscript.sh

There are many other use cases and features of the VM ``run-command`` Sub-Group. Remember that you can always explore it in more detail by using the ``-h`` Argument.


Remote Desktop Protocol
-----------------------

The Remote Desktop Protocol (RDP) is a protocol developed by Microsoft for accessing the GUI desktop of a remote Windows machine. The remote machine can be physical or virtual but in our case we will always use RDP with Windows Server VMs. Instead of interacting with the machine using the command-line you can use the VM as if it were right in front of you!

RDP is often used by technical support staff to help enterprise and consumer customers debug issues on their machines. But RDP is great for DevOps engineers to troubleshoot and configure things manually where a full desktop experience is preferred. 

.. admonition:: fun fact

  RDP is used as both a noun, referring to the protocol itself, and as a verb, referring to the "act of RDP-ing into a machine"!

Jump-Boxes
^^^^^^^^^^

One common use case for RDP is to securely access machines that exist within a protected corporate network. In order to protect production machines their network and firewall configurations are locked down to only accept connections using the private IP addresses of machines that are connected to their protected network.

In addition to the production servers a small number of VMs, called **jump-boxes** or **jump-servers**, are given public IP addresses and RDP access. Jump-boxes bridge the gap between the public internet (your local machine) and the private network (production servers). These operational machines allow you to connect from your local machine to the jump-box and then *jump* to access the protected machines within the private network. You can think of the jump-box like a middle man between the developer's local machine and the protected machines.

For security reasons jump-boxes are configured to expose RDP access only to developers of the company by using an IP address whitelist, VPN tunneling or other more complex patterns. Once you have RDP'd into the jump-box it behaves as if you are using a desktop from within the private network. From there you can access protected machines using RDP or one of the other remote access mechanisms.

.. todo:: replace with proper diagram

.. image:: /_static/images/ws/jump-box.jpg

This strategy minimizes the *exposed network area* of the infrastructure much like the slimmed Windows Server OS minimizes the *exposed software area* for potential attacks. Instead of having to worry about *all of the machines* having public IP addresses and RDP access only a few jump-boxes are exposed. Often times these boxes are started and stopped on demand to further restrict their usage. From these minimal entry points to the system the access between the local machine, jump-boxes and production machines can be carefully restricted, monitored and logged.

MSTSC
^^^^^

Windows provides the ``mstsc`` command-line utility for creating an RDP session between your local and remote machine. Opening an RDP session is very simple and only requires the public IP address of the VM and the login credentials.

Here is the general form of using ``mstsc``:

.. sourcecode:: powershell
  :caption: mstsc is available on Windows machines

  > mstsc /v:<public IP address>

This will prompt you for a username and password to access the VM. Once those are entered a new window will appear that provides the full desktop GUI of the remote machine! We will get to practice using RDP in the upcoming exercises.

.. admonition:: note

  Desktop access over RDP inherently requires the VM to have the desktop GUI shell installed. If the VM is using the ``Windows Server Core`` OS then only a PowerShell terminal is presented during an RDP session.

Windows Remote Management
-------------------------

Windows Remote Management (WinRM) 

PS-Session
^^^^^^^^^^

Invoke-Command
^^^^^^^^^^^^^^

Windows Admin Center
--------------------

Next Step
=========
