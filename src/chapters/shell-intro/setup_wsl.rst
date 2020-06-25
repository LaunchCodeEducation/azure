==================================
Setting up Linux and BASH with WSL
==================================

Windows Subsytem for Linux
==========================

Windows machines can not run BASH natively because of their OS incompatibility. However, Microsoft has released the **Windows Subsystem for Linux** (WSL) which simulates the Linux Kernel. The WSL is a type of **Virtual Machine** (VM) which, as the name implies, is a virtual computer that runs within a **Physical Machine** such as your laptop.

Once WSL is enabled you can install a Linux Distribution like Ubuntu and use it as if it were a physical machine. In order to enable WSL and begin using Ubuntu and BASH you will need to complete the following steps.

.. admonition:: warning

   The WSL is only available for machines running Windows 10. Specifically you must be on **Version 2004, Build 19041** or higher. You can check what version you are on by following the `instructions in this article <https://support.microsoft.com/en-us/help/13443/windows-which-version-am-i-running>`_.

Enable WSL
==========

The first step requires you to open the PowerShell Terminal in **admin mode**. You can find PowerShell by searching from your taskbar. 

.. admonition:: tip

   Before opening it right-click the icon and select **pin to taskbar** so it is easier to reach in the future:

   .. image:: /_static/images/cli-shells/powershell-taskbar-search.png
      :alt: Search for PowerShell in Windows taskbar

From your taskbar right-click on the pinned icon and select **run as administrator**:

.. image:: /_static/images/cli-shells/powershell-open-as-admin.png
   :alt: Open PowerShell as admin

Opening PowerShell normally will open it with User privileges with security restrictions. When you run a Shell as an admin you have **elevated privileges** that allow you to control the OS without restriction. In order to enable WSL we will need these elevated privileges.

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

This command will invoke the Deployment Image Servicing and Management (``dism``) tool to enable the WSL feature. Once it has finished you need to **restart your machine** before continuing to the following steps.

Setup Ubuntu
============

Next enter the following commands to install Ubuntu (the **18.04 LTS** version). As a reminder, each line beginning with ``>`` is its own command:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # download the Ubuntu OS installer and save it as Ubuntu.appx
   > Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile Ubuntu.appx -UseBasicParsing

   # execute the Ubuntu installer application file
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

   When pasting or typing the password the characters will be hidden. Make sure to use these exact values:

   - **username**: ``student``
   - **password**: ``launchcode``

You will then be presented with BASH running on the Ubuntu Terminal!

.. image:: /_static/images/cli-shells/ubuntu-bash-terminal.png
   :alt: Ubuntu BASH Terminal

As you likely noticed, this version of Ubuntu is **headless** meaning it only includes a Terminal GUI running BASH. While Ubuntu also comes in a Desktop edition with the full GUI Shell it is only used for consumers. When working with Linux VMs in the cloud we will always use headless OS installations and work exclusively from the Terminal. We will first get some practice with a *local* VM before venturing into *remote* VMs in the cloud.

Managing the Ubuntu VM
======================

When you want to close the Ubuntu VM just type ``exit`` into the prompt. The ``exit`` command exits the active Shell process. While this appears to shut down Ubuntu, WSL will continue to run the VM in the background so that it starts up quickly the next time you need it.

You can practice this now by entering the following command:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ exit

To re-open Ubuntu just select the taskbar icon that you pinned earlier.

Working with WSL
================

WSL is designed to manage any number of VMs. Each VM uses a **system image** which contains the OS files used by the virtual machine. In the context of Linux, WSL refers to these images as **distributions**. 

Viewing available distributions
-------------------------------

You can view the available WSL distributions installed on your machine by using the ``--list`` option:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # list all the installed VM distributions
   > wsl --list

   # list just the running VMs
   > wsl --list --running

Entering a VM Shell directly
----------------------------

You can also enter the Shell of the VM directly from the PowerShell Terminal rather than using the Ubuntu Terminal GUI. This feature is convenient as it does not require you switch between application windows.

You can use the ``--distribution`` option followed by the name of the VM's distribution (one that is installed from the ``--list`` output) to enter the Shell directly:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # start the machine in the PowerShell Terminal (instead of using the taskbar icon)
   > wsl --distribution Ubuntu-18.04
   # shorthand -d
   > wsl -d Ubuntu-18.04

The same concept of using the BASH ``exit`` command applies but will now return you to the PowerShell Terminal instead of closing the Ubuntu Terminal application.

Shutting down a VM
------------------

In some cases you want to completely shut down a VM rather than just exiting the active Shell session. For example, you may find that your computer is running slow and want to free up some memory. Unless you need to free up resources it is fine to leave the Ubuntu VM running in the background. 

You can shut down a VM from the PowerShell Terminal by using the ``--terminate`` option followed by the name of the VM's distribution (``Ubuntu-18.04``):

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # shut down the machine
   > wsl --terminate Ubuntu-18.04
   # shorthand -t
   > wsl -t Ubuntu-18.04