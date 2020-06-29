
=========
CLI Tools
=========

The Chocolatey Package Manager
==============================

Windows has a pre-installed manager of Features and Services (native Windows applications and tools) which can be accessed through PowerShell. However, for third-party CLI tools we will need to install ``Chocolatey``, an open-source package manager for Windows. ``Chocolatey`` is not a native package manager like Ubuntu's pre-installed ``apt``, but is `recognized by Microsoft in as an industry standard <https://devblogs.microsoft.com/commandline/join-us-for-a-hot-cup-o-chocolatey/>`_. 

Installing Chocolatey
---------------------

You can find the installation instructions on the `Chocolatey installation article <https://chocolatey.org/install>`_.

We will install ``Chocolatey`` using PowerShell, however it will require elevated permissions to download and install. You will need to open a PowerShell session *as an administrator* before running the following command. Recall that you can open in admin mode by right-clicking the taskbar icon for PowerShell and selecting **run as administrator**:

.. image:: /_static/images/cli-shells/powershell-open-as-admin.png
   :alt: Open PowerShell as administrator from taskbar

Once you have opened PowerShell in admin mode enter the following command:

.. sourcecode:: powershell
   :caption: Windows/PowerShell admin mode

   > Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

This command is lengthy but in summary it is setting a policy to allow the ``Chocolatey`` installation script to be executed and then downloading it by making a request with the .NET standard library ``WebClient`` object. Once the installation script has been downloaded it will automatically execute and install the package manager for you.

``Chocolatey`` is the full name of the package manager, but the name of the CLI program used in PowerShell is simply ``choco``.

.. Need Package Choco?!

Getting Help
------------

After installing ``Chocolatey`` you can access help documentation with the ``--help`` option.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco --help

An advantage of ``choco`` being open-source is that you can find a lot of assistance in online forums and the crowd-sourced `Chocolatey documentation <https://chocolatey.org/docs>`_.

Installing a package
--------------------

``Chocolatey`` is modeled after many popular Linux package managers like ``apt``. For this reason the syntax for chocolatey should look familiar:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco install <package name> -y

``Chocolatey`` also supports a number of options like ``--yes`` or ``-y`` which, like the ``apt`` option, skips confirmation prompts, automatically downloads and installs the package. To view more options view the `Chocolatey install command documentation <https://chocolatey.org/docs/commands-install>`_.

Upgrading a package
-------------------

Upgrading packages in ``Chocolatey`` is again a simple command named ``choco upgrade``.

To upgrade the ``dotnetcore-sdk``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco upgrade <package name> -y

``Chocolatey`` also supports upgrading all of the packages it downloaded and installed.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco upgrade all -y

Updating package sources
------------------------

The ``Chocolatey`` package manager is also responsible for keeping track of package repository sources. When you download ``Chocolatey`` for the first time it automatically loads the ``Chocolatey`` trusted sources which host common packages. In some instances you may need to install a package that is not a part of the ``Chocolatey`` hosted sources, in this case you would need to add a custom source.

We will not be adding any sources beyond the default ``Chocolatey`` sources, but an example of the usage would follow this pattern:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco add source <source target>

You can find more information about adding ``Chocolatey`` repository by viewing the `Chocolatey sources documentation <https://chocolatey.org/docs/commands-sources>`_.

Course Tools Installation
=========================

Two of the CLI tools we will begin using this week are the ``dotnet CLI`` and the ``git`` version control system (VCS). Let's install them now before learning how to use them in the coming days.

.. admonition:: note

   Whenever you install a new CLI tool using ``choco`` you **must exit all PowerShell sessions** before they can be used. You can exit a PowerShell session by entering the ``exit`` command or by closing **all** of the open PowerShell Terminal windows.

Install .NET SDK
----------------

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco install dotnetcore-sdk-3.1 -y

Don't forget to close and re-open PowerShell before entering the following command to test the installation:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > dotnet --version
   # dotnet version output

Install Git VCS
---------------

You likely have been using the **Git BASH** program to access ``git`` and GitHub. What you may not have realized is that Git BASH is a Terminal that emulates basic BASH commands and ``git``. However, now that we are comfortable working from the command-line we can use ``git`` natively within PowerShell and BASH. Let's install ``git`` in PowerShell using ``choco``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco install git -y

After **closing and re-opening** PowerShell you can confirm the installation with the following command:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > git --version
   # git version output