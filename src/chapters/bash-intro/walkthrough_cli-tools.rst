===================================================
Walkthrough: Working With a Package Manager in Bash
===================================================

Bash comes pre-installed with many essential programs. But when you need to install other tools a package manager can make the process fast and easy. While we will not be doing any *local* development in Bash and Linux we will eventually configure *remote* VMs in Azure. To that end we will be working with the ``apt`` package manager in the Ubuntu VM for practice before venturing into the cloud.

The APT Package Manager
=======================

The Ubuntu Distribution comes pre-installed with the Advanced Packaging Tool (``apt``) program for managing packages. We will focus on the commands that are used most frequently. Like most CLI programs you can view more details about how to use ``apt`` by using the ``--help`` option.

.. admonition:: Tip

   You will typically see ``apt`` used with the ``-y`` option added to the command. This option skips the confirmation prompt, like a popup confirmation you would see in a GUI, for the actions you are taking to speed up the process. 

   .. sourcecode:: bash
      :caption: Linux/Bash

      $ apt <action argument> -y

SUDO
----

Recall that APT, like all system-wide package managers, must have control over your machine to download, install and configure the packages you need. Because it operates on packages stored above the ``/home/<username>`` directory (closer to the root dir) it is considered *outside of the user space* and requires the use of admin privileges:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ sudo apt <action argument> -y

The ``sudo`` command is the equivalent of opening the PowerShell Terminal in admin mode. It is an acronym for **S**\ubstitute **U**\ser to **DO** the command to the right of it. When used without specifying *which user to substitute* it will default to running the command to the right as the ``root`` user -- a special super user account type. 

.. admonition:: Fun Fact

   SUDO is often referred to as *super user do* because of how often it is used to run commands as root. Most people pronounce it *soo-doo* or **soo-doh**.

The first time you use ``sudo`` *per Shell session* you will be prompted for the admin password of your account (``launchcode`` in our case). In simple terms a Shell session is one **independent instance** of a Shell like Bash. In other words, if you were to open a Terminal and then open another one you would have two active Shell sessions. 

Once you have authenticated you will not have to re-authenticate unless you close the Shell (ending the session) or you open a new Shell in a different Terminal window (a new session). You can liken this behavior to how PowerShell requires you to right-click and open as an admin for each Shell session that requires elevated privileges.

Updating repository sources
---------------------------

Any time you are going to use ``apt`` you should begin by updating the metadata in the repository sources. An ``apt update`` will download information about installed packages (like pending upgrades) as well as refresh the package source lists. The latter half  of the update ensures that when you search and install packages you are always getting the latest additions and versions from your package source repositories.

Below you can see the most ubiquitous ``apt`` command in use:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ sudo apt update
   # information about repository source updates

.. admonition:: Note

   Updating the repository sources **only updates the metadata about packages**. The actual installed packages can be **upgraded to the latest version** using the ``apt upgrade`` command. 

Installing CLI Tools
====================

After you have updated you can search for and install package tools on your machine. The ``search`` argument can be used to scan the source repositories for a package. It accepts a search term as a sub-argument which it will use to search the title and descriptions of all the available packages within your group of sources.

.. sourcecode:: bash
   :caption: Linux/Bash

   # always run apt update before searching or installing!
   $ sudo apt search <search term>

If the search results contains your package you can install it using the ``install`` argument. The sub-argument is the **exact package name** of the tool you want to install. The installation prompts (like confirmation dialog boxes in a GUI) can be automatically accepted using the ``-y`` option:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ sudo apt install <package name> -y

Install your first package
--------------------------

Let's practice by searching for the amusing little tool called Cow Say. First let's search for the package by its name, ``cowsay``. This package is available within the default set of source repositories and should show up as the first result:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ sudo apt update

   # searching doesn't require elevated privileges
   $ apt search cowsay

   Sorting... Done
   Full Text Search... Done
   cowsay/focal,focal 3.03+dfsg2-7 all
   configurable talking cow

   cowsay-off/focal,focal 3.03+dfsg2-7 all
   configurable talking cow (offensive cows)

   presentty/focal,focal 0.2.1-1.1 all
   Console-based presentation software

   xcowsay/focal 1.5-1 amd64
   Graphical configurable talking cow

   # you can also search for "talking cow" which will match the description
   $ apt search talking cow

The package that we want is the first one, ``cowsay``. Notice that the search will check both the package name and description. 

Let's install it using the **exact package name**, ``cowsay``:

.. sourcecode:: bash
   :caption: Linux/Bash

   # installing controls your machine and requires sudo
   $ sudo apt install cowsay -y

In the command output you can see that ``apt`` downloads, unpacks and installs the package automatically . You can now try out the newly installed tool!

Use the command program ``cowsay`` and enter a message as its arguments:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ cowsay Hello World!

.. admonition:: Note

   It is okay to leave ``cowsay`` installed. But if you would like to remove it you can use ``apt`` to cleanly uninstall it:

   .. sourcecode:: bash
      :caption: Linux/Bash

      $ sudo apt remove cowsay -y

Adding custom sources
=====================

The default list of package repositories provides access to a large collection of open-source tools from package hosts trusted by the open source community. But in many cases you will need to install additional sources to download packages from. Additional sources can range from private repositories hosted by a company, for internal use, to independently-hosted repositories like the Microsoft packages repository. 

These custom repositories often require both the repository and a **signing key** to be installed. Anyone is able to host a repository of packages. This is why it is important to only install source repositories, and packages from those repositories, from trusted sources. 

As an additional security measure, trusted repositories include a signing key to check that downloaded packages are authentic (from a trusted source) before being installed. 

.. admonition:: Note

   The topics of Public Key Infrastructure (PKI), which includes signing keys, and custom repositories extends outside the scope of this course. You can read more about how these work `in this repository article <https://wiki.debian.org/DebianRepository>`_ and `this repository signing key article <https://wiki.debian.org/SecureApt>`_. Both of these articles offer an overview of the mechanisms involved from a relatively high level.

Installing .NET
---------------

Let's see what this process looks like using the ``dotnet CLI`` installation as an example. 

.. admonition:: Tip

   Like other 3rd party tool installations you can find the instructions on the package maintainer's site. For example, we will be following the instructions from this `Microsoft installation article <https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#1804->`_. 

The first step is to install the official Microsoft package repository. The installation includes both the repository and the signing key. This is a one-time process and future installations of Microsoft tools will be available and trusted automatically:

.. sourcecode:: bash
   :caption: Linux/Bash

   # install the repository source package (includes the repo and signing key)
   $ sudo wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

   # unpack and install the repository and trust the signing key
   $ sudo dpkg -i packages-microsoft-prod.deb

Microsoft only serves their packages over secure connections (HTTPS). We will need to install a utility called ``apt-transport-https`` which, as the name implies, is used to download over HTTPS:

.. sourcecode:: bash
   :caption: Linux/Bash

   # always update before other commands
   $ sudo apt update

   $ sudo apt install apt-transport-https -y
   
Finally with the repository, signing key, and HTTPS tooling installed we can install the ``dotnet`` package we were after. We will install the .NET Core SDK which includes both the SDK (standard library, compiler and runtime) as well as the ``dotnet`` CLI tool itself:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ sudo apt update
   $ sudo apt install dotnet-sdk-3.1 -y

From the output you can see all of the work that ``apt`` does automatically. Imagine doing all of that downloading, unpacking and configuration manually!

You can confirm the installation was successful by viewing the ``--help`` output of ``dotnet``. Viewing the help output of a command program is an easy way to get acquainted with it right from the command-line.

.. sourcecode:: bash
   :caption: Linux/Bash

   $ dotnet --help

.. admonition:: Tip

   We will work with the ``dotnet CLI`` extensively in later lessons. But feel free to poke around with it in the mean time.