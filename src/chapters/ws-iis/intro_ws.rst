.. _intro_ws:

==============================
Introduction to Windows Server
==============================

Previously we used the Azure web portal to provision and deploy our API to an Ubuntu Linux VM. In order to execute commands and scripts to configure the deployment we used the RunCommand tool that was built into the web portal. 

Today we will learn about the other choice of OS for hosting our web applications -- Windows Server. Now that you are more comfortable working away from the web portal we will also learn how to remotely access our new Windows Server VM from the command line.

A Native Server OS
==================

Windows Server (WS) is built on top of the same base as the PC-grade Windows 10 operating system but has been customized for use as a server. While there are many Windows 10 editions from consumer to enterprise none of them are optimized for server workloads like WS. Servers naturally have greater operational demand than PCs. As a result WS has been designed to manage significantly greater memory and CPU allocations than what someone would run on a PC -- even a decked out gaming rig.

.. admonition:: fun fact

    Windows Server is capable of managing an incredible 24 **terabytes** of RAM and *any number* of CPU cores! But can it run Crysis?

Because WS is designed for computing it strips away many of the applications and features that are meant for PCs. The result is a smaller OS footprint that reduces resource usage. These savings may seem small for individual machines but can be appreciable when managing large fleets of servers. 

A smaller OS also means less code to monitor for and protect against potential vulnerabilities. The reduced attack surface of the slimmer OS is complemented by sensible firewall defaults and other restrictions that further bolster its security profile relative to a PC.

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

In this course we will use the SM to manage the Roles and Features of the **Local Server** (our VM). The Roles and Features wizard can be used to install and configure additional tooling like the IIS Web Server Manager which we will cover in later lessons.

.. image:: /_static/images/ws/sm-roles-features-wiz.png
    :alt: Server Manager Roles and Features Wizard

Remote Management
=================

Remote management is the practice of accessing and managing a (remote) machine from another (local) machine. For consumers, Remote management (RM) is often used by help desk professionals to troubleshoot issues by controlling the client's PC instead of relaying instructions over the phone. In our context we use RM to manage our servers which, being virtual, can never be accessed physically. 

So far you have experienced a simplistic form of RM using the Azure web portal's RunCommand console. Although the RunCommand console was convenient for us to interact with our Ubuntu VM it is not commonly, if ever, used by professionals due to its inherent limitations. As you likely noticed the RunCommand console is slow and only able to send commands and print their outputs one at a time from the browser. In order to effectively configure and troubleshoot our VMs we need more robust RM tooling.

Azure CLI RunCommand
--------------------

Recall that both the Azure CLI and the web portal GUI are backed by the same REST API. Using the ``az CLI`` you are able to use RunCommand from the command line instead of the browser. 

.. admonition:: tip

    Unlike the browser console you can use the ``az CLI`` to issue RunCommands to *multiple machines at once* using their resource IDs (VM identities)!

Within the Azure CLI the ``vm`` Sub-Group ``run-command`` can be used to toggle commonly machine settings or execute complete scripts remotely. Every RunCommand has a unique name known as its ``command-id`` which you can view using ``list``:

.. sourcecode:: powershell
    :caption: assumes the default location has been configured

    > az vm run-command list

    # concise table output using a JMESPath query 
    > az vm run-command list --query "[].{ commandId: id, label: label }" -o table

To issue a RunCommand use the ``invoke`` Command:

.. sourcecode:: powershell
    :caption: assumes a default RG, location and VM have been configured

    > az vm run-command invoke --command-id <command ID>

Here is an example that will invoke a pre-written script. This is the command-line equivalent of pasting the script into the RunCommand console in the browser. You can run any number of scripts using the ``--scripts`` argument. These can be quoted or references to files on your machine.

.. admonition:: tip

  For Windows VMs you should use ``RunPowerShellScript`` and for Linux VMs use ``RunShellScript``. Note that this is in reference to the remote VM you are interacting with *not the OS of your local machine*. 

Here is an example of simply listing files in the home directory. For Windows we use ``Get-ChildItem`` and for Linux its equivalent ``ls``. 

.. sourcecode:: powershell
    :caption: assumes a default RG, location and VM have been configured

    # for a windows VM run a PowerShell script (uses PowerShell in the VM)
    > az vm run-command invoke --command-id RunPowerShellScript --scripts "Get-ChildItem"

    # for a linux VM run a Shell script (uses the default shell of the VM)
    > az vm run-command invoke --command-id RunShellScript --scripts "ls"

For longer scripts than one-off commands like above you will want to reference pre-written script files on your local machine. You can do this using the ``@/path/to/script`` syntax. 

Here is an example that uses a script file located in the home (``~``) directory called ``myscript.<ext>`` with the appropriate extension (PowerShell or BASH) corresponding to the OS of the remote VM.

.. sourcecode:: powershell
    :caption: assumes a default RG, location and VM have been configured

    # myscript.ps is a PowerShell script
    > az vm run-command invoke --command-id RunPowerShellScript --scripts @~/myscript.ps

    # myscript.sh is a BASH script
    > az vm run-command invoke --command-id RunShellScript --scripts @~/myscript.sh


Remote Desktop Protocol
-----------------------

The Remote Desktop Protocol (RDP) is a tool used for accessing the GUI desktop of a remote Windows machine. Note that the Windows machine can be physical or virtual but in our case we will always use RDP with VMs. Instead of interacting with the machine using the command line you can use the VM as if it were right in front of you! 

It is often used by technical support staff to help enterprise and consumer customers debug issues on their machines. But RDP is great for DevOps engineers to troubleshoot and configure things manually where a full desktop experience is preferred. 

One common use case for RDP is to interact with machines that exist within a protected network. These operational machines are typically referred to as **jump-boxes**. In order to protect production machines RDP is locked down to only accept remote access connections from within the protected network. 

Jump-boxes are configured to expose RDP access only to developers of the company identified by their IP address or other more advanced mechanisms. They can RDP into the jump-box and from there *jump to* other machines within the protected network for troubleshooting and configuration.

This strategy minimizes the attack vectors of the system. Instead of having to worry about *all of the machines* having public RDP access only a few jump-boxes need to be monitored. From there access control between the jump-boxes and production machines can be carefully controlled and monitored.

MSTSC
^^^^^

Windows provides the ``mstsc`` command-line utility for creating an RDP session between your local machine and a remote VM. Access is very simple and only requires the public IP address of the VM and the login credentials. In more advanced 

Here is the general form of using ``mstsc``:

.. sourcecode:: powershell

  > mstsc /v:<public IP address>

This will prompt you for a username and password to access the VM. Once those are entered a new window will appear that provides the full desktop GUI of the remote machine! We will practice using RDP in the upcoming exercises.

.. admonition:: note

  Desktop access over RDP inherently requires the VM to have the desktop GUI running. If the VM is using the ``Windows Server Core`` OS then only a PowerShell terminal is presented by default.

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
