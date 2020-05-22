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

    Unlike the browser console you can use the ``az CLI`` to issue RunCommands to *multiple machines at once* using their resource IDs!

Within the Azure CLI the ``vm`` Sub-Group ``run-command`` can be used to toggle commonly machine settings or execute complete scripts remotely. Every RunCommand command corresponds to a unique ID which you can view using ``list``:

.. sourcecode:: powershell
    :caption: assumes the default location has been configured

    > az vm run-command list

    # concise table output using a JMESPath query 
    > az vm run-command list --query "[].{ commandId: id, label: label }" -o table

To issue a RunCommand use the ``invoke`` Command:

.. sourcecode:: powershell
    :caption: assumes a default RG, location and VM have been configured

    > az vm run-command invoke --command-id <command ID>

Remote Desktop Protocol (RDP)
-----------------------------

MSTSC
^^^^^

Windows Remote Management (WinRM)
---------------------------------

PS-Session
^^^^^^^^^^

Invoke-Command
^^^^^^^^^^^^^^

Windows Admin Center
--------------------

Next Step
=========