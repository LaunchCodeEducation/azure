===============================
Walkthrough: Hands-On With BASH
===============================

Setup
=====


.. do we want to support macs or have them work from a VM for consistency? apt wont work on mac but everything else will
.. If you are on a UNIX machine (Macs running OSX or a Linux machine) you will already have BASH and a Terminal available. Search for and open your Terminal application. Once in the terminal enter the following command:

.. .. sourcecode:: bash

..    $ echo "$SHELL"
..    # /usr/bin/bash

.. If you are on the latest version of OSX it may print ``/usr/bin/zsh`` which is an alternative Shell to BASH. Z-Shell (ZSH) and BASH 

Windows machines can not natively run BASH because of their OS incompatibility. However, Microsoft has released the **Windows Subsystem for Linux** (WSL) which simulates the Linux Kernel. The WSL is a type of **Virtual Machine** (VM) which, as the name implies, is a virtual computer that runs within a **Physical Machine** host like your laptop.

Once WSL is enabled you can install a Linux Distribution like Ubuntu and use it as if they were a real machine. In order to enable WSL and begin using Ubuntu and BASH you will need to complete the following steps.

Enable WSL
----------

The first step requires you to open the PowerShell Terminal in **admin mode**. You can find PowerShell by searching from your taskbar. Before opening it right-click the icon and select **pin to taskbar** so it is easier to reach in the future:

.. image:: /_static/images/cli-shells/powershell-taskbar-search.png
   :alt: Search for PowerShell in Windows taskbar

From your taskbar right-click on the pinned icon and select **open as administrator**:

.. image:: /_static/images/cli-shells/powershell-open-as-admin.png
   :alt: Open PowerShell as admin

Opening PowerShell directly will open it in with restricted User privileges for your security. When you run a Shell as an admin you have **elevated privileges** that allow you to control the OS without restriction. In order to enable WSL we will need these elevated privileges.

.. admonition:: warning

   When operating a Shell with admin privileges you **must be careful with the actions you take**. While it is unlikely, you **can do irreparable damage** from the command-line by controlling areas of your machine that the Desktop GUI would normally prevent you from accessing. 
   
   All of the instructions provided in this class are safe **as long as you follow them exactly**. While we encourage you to research and practice outside of class we can not help you with anything harmful you do to your machine when straying from the directions we provide. Use common sense and don't run scripts or commands you find on the internet without knowing exactly what they do!

You will be prompted to confirm this decision as a security measure:

.. image:: /_static/images/cli-shells/powershell-admin-prompt.png
   :alt: PowerShell admin security prompt 

With PowerShell open as an admin copy and paste the following commands. Recall that the ``>`` symbol is used to designate **a single PowerShell command** (the contents to the right of it) that you need to copy and paste into your Terminal.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

Now **restart your machine** before continuing to the following steps.

Setup Ubuntu
------------

Next enter the following commands to install the **Ubuntu 18.04 LTS** version. Each line beginning with ``>`` is its own command:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile Ubuntu.appx -UseBasicParsing
   > .\Ubuntu.appx

A dialog box will ask you to confirm the installation:

.. image:: /_static/images/cli-shells/ubuntu-install-dialog.png
   :alt: Install Ubuntu dialog

The Ubuntu VM should now open automatically. It will then take a few minutes to complete the installation.

.. admonition:: note

   If you have any issues with the installation you likely forgot to restart your machine after enabling WSL. For resolving other issues refer to `this troubleshooting article <https://docs.microsoft.com/en-us/windows/wsl/install-win10#troubleshooting-installation>`_.

While waiting for it to install right click on its icon and pin it to your taskbar:

.. image:: /_static/images/cli-shells/ubuntu-pin-taskbar.png
   :alt: Pin Ubuntu VM to taskbar

After installation it will prompt you to enter a username and password for your Ubuntu user account:

.. image:: /_static/images/cli-shells/ubuntu-setup-user.png
   :alt: Ubuntu first time setup user account

You can set up any number of VMs and customize them to your needs. However, for this class we will use the following values to make troubleshooting and helping you more consistent.

.. admonition:: note

   Make sure to use these exact values. Note that when pasting or typing the password the characters will be hidden.

   - **username**: ``student``
   - **password**: ``launchcode``

You will then be presented with the BASH shell running on the Ubuntu Terminal!

.. image:: /_static/images/cli-shells/ubuntu-bash-terminal.png
   :alt: Ubuntu BASH Terminal

As you likely noticed, this version of Ubuntu is **headless** meaning it only includes a Terminal GUI running the BASH Shell. While Ubuntu also comes in a Desktop edition with the full GUI Shell it is only used for consumers. When working with Linux VMs in the cloud we will always use headless OS installations and work exclusively from the Terminal. We will get some practice with a *local* VM before venturing into *remote* VMs in the cloud. 

When you want to close the Ubuntu VM just type ``exit`` into the prompt. The ``exit`` command exits the active Shell process. Because we are using a headless Ubuntu VM closing the Shell is the equivalent of choosing **shut down** from the Desktop. You can practice this now and then re-open it from the pinned taskbar icon:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ exit

Working with BASH
=================

From this point forward all of the commands and examples will be in BASH and need to be entered into the Ubuntu Terminal. As mentioned previously, we will distinguish BASH commands from PowerShell commands by using the ``$`` symbol instead of ``>``. 

This article is a guide for the fundamentals of working with BASH. Like other programming languages BASH has more depth than can be covered as an introduction. The topics covered here will give you a foundation to build the rest of your learning on top of. Keep in mind the following aspects of Linux and BASH:

- **everything is a file**: There are 7 *types of files*. We will only work with regular files and directories (``d`` files) but you can read about the others `in this article <https://linuxconfig.org/identifying-file-types-in-linux>`_.
- **everything is a string**: There are no data types in BASH. All of the inputs and outputs of BASH commands are strings of characters.
- **file extensions don't matter**: All regular files in Linux are treated the same -- just a collection of characters (in a `character encoding <https://en.wikipedia.org/wiki/Character_encoding>`_. It is up to the consumer of a file (a program) to decide how to interpret the characters in it. In other words, *the OS is not opinionated about how a file is used*. A file extension is nothing more than a note for the user to choose a program that will use the file.

File System
===========

Navigation Essentials
---------------------

Show the CWD
^^^^^^^^^^^^

Change directories
^^^^^^^^^^^^^^^^^^

List the CWD contents
^^^^^^^^^^^^^^^^^^^^^

Directory Operations
--------------------

Create
^^^^^^

View contents
^^^^^^^^^^^^^

Move
^^^^

Copy
^^^^

Delete
^^^^^^

File Operations
---------------

Create
^^^^^^

View contents
^^^^^^^^^^^^^

Move, Copy & Delete
^^^^^^^^^^^^^^^^^^^

CLI Tools
=========

Package Manager
---------------

Installing Class Tools
----------------------

Piping
======

Filtering with grep
-------------------

Scripting
=========

Essentials
----------

Executing
---------
