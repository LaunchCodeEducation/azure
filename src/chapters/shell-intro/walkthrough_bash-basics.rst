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

Windows machines can not run BASH natively because of their OS incompatibility. However, Microsoft has released the **Windows Subsystem for Linux** (WSL) which simulates the Linux Kernel. The WSL is a type of **Virtual Machine** (VM) which, as the name implies, is a virtual computer that runs within a **Physical Machine** such as your laptop.

Once WSL is enabled you can install a Linux Distribution like Ubuntu and use it as if it were a physical machine. In order to enable WSL and begin using Ubuntu and BASH you will need to complete the following steps.

Enable WSL
----------

The first step requires you to open the PowerShell Terminal in **admin mode**. You can find PowerShell by searching from your taskbar. Before opening it right-click the icon and select **pin to taskbar** so it is easier to reach in the future:

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
------------

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

When you want to close the Ubuntu VM just type ``exit`` into the prompt. The ``exit`` command exits the active Shell process. While this appears to shut down Ubuntu, WSL will continue to run the VM in the background.

You can practice this now and then re-open it from the pinned taskbar icon:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ exit

.. admonition:: note

   WSL is designed to manage any number of VMs. Each VM uses an **image** which contains the OS files that the machine will run on. In the context of Linux, WSL refers to these images as distributions. You can view the available WSL distributions installed on your machine by using the ``--list`` option:

   .. sourcecode:: powershell
      :caption: Windows/PowerShell
   
      # list all the installed VM distributions
      > wsl --list

      # list just the running VMs
      > wsl --list --running

   You can also enter the Shell of the VM directly from the PowerShell Terminal rather than using the Ubuntu Terminal GUI. This feature is convenient as it does not require you switch between application windows.
   
   You can use the ``--distribution`` option followed by the name of the VM's distribution (one that is installed from the ``--list`` output) to enter the Shell directly:

   .. sourcecode:: powershell
      :caption: Windows/PowerShell

      # start the machine in the PowerShell Terminal (instead of using the taskbar icon)
      > wsl --distribution Ubuntu-18.04
      # shorthand -d
      > wsl -d Ubuntu-18.04

   The same concept of using the BASH ``exit`` command applies but will now return you to the PowerShell Terminal instead of closing the Ubuntu Terminal application.

   You can completely shut down a VM (rather than just exiting its Shell session) from the PowerShell Terminal by using the ``--terminate`` option followed by the name of the VM's distribution (``Ubuntu-18.04``):

   .. sourcecode:: powershell
      :caption: Windows/PowerShell

      # shut down the machine
      > wsl --terminate Ubuntu-18.04
      # shorthand -t
      > wsl -t Ubuntu-18.04
   
Working with BASH
=================

From this point forward all of the commands and examples will be in BASH and need to be entered into the Ubuntu Terminal. As mentioned previously, we will distinguish BASH commands from PowerShell commands by using the ``$`` symbol instead of ``>``. 

This article is a guide for the fundamentals of working with BASH. Like other programming languages BASH has more depth than can be covered as an introduction. The topics covered here will give you a foundation to build the rest of your learning on top of. 

While learning about and practicing these commands some will seem foreign to you if you come from a Windows background. Keep in mind the following aspects of Linux and BASH to help you understand why things work the way they do:

   **Everything is a file**

There are 7 `types of files <https://linuxconfig.org/identifying-file-types-in-linux>`_ in Linux. The majority of the time you will be working with:

- **regular files**: individual text files (denoted by ``-``)
- **directory files**: container files (denoted by ``d``).

   **Everything is a string**
   
There are **no data types** in BASH. All of the inputs and outputs of BASH commands are strings of characters.

   **File extensions don't matter**

All regular files in Linux are treated the same -- just a collection of characters (in a `character encoding <https://en.wikipedia.org/wiki/Character_encoding>`_). It is up to the consumer of a file (a program) to decide how to interpret the characters in it. In other words, *the Linux OS is not opinionated about how a file is used*, unlike what you are familiar with in Windows. In Linux-land a file extension is not required and only serves as a note for the user to choose a program that will interpret the file.

File System
===========

Everything in the File System (FS) and operations done to it are based around relative and absolute paths. Refer to the previous article for a more detailed explanation. Below is a practical refresher:

- **relative path**: relative to a variable location, your current working directory (CWD)
- **absolute path**: relative to a constant directory (root, ``/``, in Linux)

You will notice that most of the FS related commands make use of path arguments that can be written as relative or absolute paths.

Navigation Essentials
---------------------

Let's begin by reviewing the essential commands for navigating the FS from the command-line. Take some time to practice using these to navigate around your machine.

Show the CWD
^^^^^^^^^^^^

In order to navigate *relative* to where you are you need to identify your working directory (CWD). The ``pwd`` (print working directory) command will give you the absolute path of your current location in the FS:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

If you are in a new Shell session it will default to a CWD of ``/home/<username>``.

.. admonition:: note

   If you entered BASH through PowerShell (``wsl -d Ubuntu-18.04``) rather than the Ubuntu taskbar icon it will default to a different directory like ``/mnt/c/Users/<username>``. This is *not your home directory* but is a default when entering through PowerShell.

   This behavior can be changed by creating a ``.bash_profile`` file. You can read more about it `in this article <https://www.thegeekdiary.com/what-is-the-purpose-of-bash_profile-file-under-user-home-directory-in-linux/>`_ but it falls outside of the scope of this class. 


Change directories
^^^^^^^^^^^^^^^^^^

The ``cd`` (change directory) command takes one argument -- the relative or absolute path of where you want to go:

.. sourcecode:: bash
   :caption: Linux/BASH

   # relative paths begin with a './'
   $ cd ./path/name
   # or just the path name with no leading '/'
   $ cd path/name

   # absolute paths always begin from the root (/) directory
   cd /home/student/path/name

If you want to change to a directory using a relative path that is *under* your CWD this is straightforward. But what if you need to refer to a relative path *above* your CWD? For this BASH includes two special characters for relative references:

- `.` character: a single dot means *this directory*
- `..` characters: a double dot means *up one directory*

We will discuss the use of the *this directory* character (``.``) soon. For now consider an example about the **up directory** characters. Imagine the following scenario:

.. sourcecode:: bash

   /home/student
      /Downloads
         /album
      /Media <-- your target
         /Videos <-- your CWD

If you want to move to the `Media` directory *relative* to `Videos` you need to go *up one directory* level:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student/Media/Videos

   $ cd ../

   # for going up one directory only you can leave off the trailing '/'
   $ cd ..
   
   $ pwd
   /home/student/Media

What if you again start inside ``Videos`` and you want to switch to the ``album`` directory? 

.. sourcecode:: bash

   /home/student
      /Downloads
         /album <-- your target
      /Media
         /Videos <-- your CWD

Relative to where you are, you need to:

- go up one level where ``Media`` and ``Downloads`` are: ``../``
- down a level into ``Downloads``: ``../Downloads``
- then down another level into ``album``: ``../Downloads/album``

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student/Media/Videos

   $ cd ../Downloads/album

   $ pwd
   /home/student/Downloads/album

This process can be repeated for going up (``../``) or down (``/``) as many times as needed to create the proper relative path. When in doubt check your CWD!

There are also two useful shorthands for quickly navigating around:

- ``~``: the tilda (next to the ``1`` key) is a shorthand for the home directory of the logged in user (relies on the ``$HOME`` environment variable) 
- ``-``: the dash character (next to the ``0`` key) is a shorthand for returning to the *previous* CWD (thanks to the ``$OLDPWD`` environment variable)

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student/Media

   $ cd ~
   $ pwd
   /home/student

   $ cd -
   $ pwd
   /home/student/Media

The ``~`` shorthand can also be used as a base *relative to HOME* path:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student/Media

   $ cd ~/Downloads/album
   $ pwd
   /home/student/Downloads/album


List the CWD contents
^^^^^^^^^^^^^^^^^^^^^

Our final essential command is ``ls`` (list contents). As mentioned previously ``ls`` can be used with no arguments to view the contents of the CWD:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   $ ls
   # contents of CWD ("empty" for a new user)

But ``ls`` can also be used to view the contents of another directory via a relative or absolute path:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   # absolute path
   $ ls /usr/bin
   # contents of the user binaries directory

   # relative path
   $ ls ../../usr/bin

You can also provide options to ``ls`` to change the output. The ``-a`` option means *all* and shows both regular and **hidden files**. Hidden files are special configuration files that are hidden to prevent accidental changes to them.

While the home directory appeared empty earlier it actually contained several hidden files:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   $ ls -a
   # hidden files like .bashrc, .profile

The ``-l`` option outputs in *long form* which shows additional details about the contents. In the following example it is combined with ``-a`` to see detailed information about the hidden files in the home directory:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   # or shorthand: ls -al
   $ ls -a -l

In this output you can view details like the `file type and access mode <http://linuxcommand.org/lc3_lts0090.php>`_ as well as the `user and group <https://www.linode.com/docs/tools-reference/linux-users-and-groups/>`_ that owns the file. We will not go into permission modes and ownership in this class. However, it is worth knowing that regular files are denoted by a ``-`` character and directory files by the ``d`` character (on the far left of each file's information).

.. admonition:: fun fact

   Notice how the ``.`` and ``..`` are actually listed as *directory files* (the first ``d`` in the long output). The ``.`` and ``..`` are actually treated as *files* (because *everything is a file*). They refer to the *current directory file* and *up directory file* respectively.

Directory Operations
--------------------

Now that we have the navigating essentials let's practice some common directory operations. We will learn these through a simple example. While the example is silly, the concepts and commands will apply to all of the directory work you do in the future.

Create
^^^^^^

The ``mkdir`` (make directory) command creates directories using a relative or absolute path argument. If just the name of a directory is given then it is created *relative to* the CWD. If the absolute path is provided the directory is created at that *exact* location.

By convention Linux directories do not use spaces in them. Space characters (`` ``) can conflict with the spaces between command arguments so they are avoided. In order to create a multi-word directory name the convention uses dashes (``-``) to separate the words. 

Let's create a ``parent-dir`` and ``child-dir`` using ``mkdir``:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   # relative to the CWD
   $ mkdir parent-dir

   # an absolute path in the /tmp (temporary) directory
   $ mkdir /tmp/child-dir

   # mkdir can create multiple (space-separated) dirs at once
   $ mkdir parent-dir /tmp/child-dir

View contents
^^^^^^^^^^^^^

Now if we list the contents of the CWD (home dir) and the ``/tmp`` dir we should see our new directories:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   $ ls
   parent-dir

   $ ls /tmp
   # trimmed output
   child-dir

We can also see that both the new directories themselves are empty:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   # relative path
   $ ls parent-dir
   # empty contents

   # absolute path
   $ ls /tmp/child-dir
   # empty contents

Move
^^^^

We can move a directory to a new location using the ``mv`` command. Once again, its arguments accept relative or absolute paths. The ``mv`` command takes a target and destination path as its first and second arguments:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ mv <path to target> <path to destination>

Let's move the ``child-dir`` from its current parent directory (``/tmp``) to the new one we made:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   # from absolute path (target) to relative path (destination)
   $ mv /tmp/child-dir parent-dir/child-dir
   
   $ ls /tmp
   # the child-dir no longer exists at this location

   $ ls parent-dir
   child-dir



.. admonition:: warning

   There is no *rename* command in BASH. Instead the act of moving a file (remember directories are files) defines its new name in the destination path. 

   When renaming files you **must be careful**. If a file of the same name exists at the destination path you provide **the existing file will be overwritten permanently**.

   For example if we create another directory called ``child-dir`` and want to move it into ``parent-dir`` we can *rename it during the move* to not overwrite the existing directory file with the same name:

   .. sourcecode:: bash
      :caption: Linux/BASH

      $ pwd
      /home/student

      $ mkdir /tmp/child-dir
      
      $ ls parent-dir
      child-dir

      # rename in the new destination path
      $ mv /tmp/child-dir parent-dir/child-dir-2

      $ ls parent-dir
      child-dir
      child-dir-2

Copy
^^^^

Copying files uses the ``cp`` command. The ``cp`` command behaves nearly identically to the ``mv`` command except it *copies* instead of *moving* the file(s). Just like the move command you can copy *any file* whether it is a regular or directory file.

However, to copy a directory is not as simple as copying a single file. A directory inherently can contain contents including other directories and regular files. For this reason the ``-r`` (recursive) option is used.

The recursive option instructs the ``cp`` command to copy the directory *recursively*. It does this by recursing into each nested directory and copying its contents as well.

Let's move our ``parent-dir`` to the ``/tmp`` dir:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   $ ls
   parent-dir
   
   $ ls parent-dir
   child-dir
   child-dir-2

   $ cp -r parent-dir /tmp/parent-dir

Now let's confirm the move by checking the ``/tmp`` dir:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ ls /tmp
   parent-dir

   $ ls /tmp/parent-dir
   child-dir
   child-dir-2

Notice how it copied the ``parent-dir`` and *recursed* into it to copy all of the sub-directories as well.

Delete
^^^^^^

.. admonition:: warning

   The command to delete files is **not to be taken lightly**. When you delete a file or directory through the GUI it will conveniently store the deleted contents in a recycling bin where they can be recovered.

   In the Shell a **deletion is permanent** and nearly **instantaneous**. For this reason it is imperative that the command **always use an absolute path** to be explicit and prevent mistakes.
   
   While we stressed being cautious before we will repeat in bold this time:

   **DO NOT STRAY FROM THE FOLLOWING COMMAND DIRECTIONS**

The command for deleting, or *removing*, files is ``rm``. When deleting a directory, just like ``cp``, the ``-r`` option will instruct it to do so *recursively*.

Let's clean up the directories we created using the remove command. We will use the ``rm`` command with the default prompt option enabled. This will force you to explicitly confirm before each file is deleted if its contents are not empty.

In our case the directories are all empty and will be deleted immediately:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ ls /tmp/parent-dir
   child-dir
   child-dir-2

   $ rm -r /tmp/parent-dir

   $ ls /tmp/parent-dir
   ls: cannot access '/tmp/parent-dir': No such file or directory
   
File Operations
---------------

As we move from directory to file operations consider one of the core tenants of Linux:

   **Everything is a file**

Why is this valuable to consider? Because most of the commands used for directory operations are identical for regular files! When dealing with regular files the ``-r`` (recursive) option is no longer needed since it is an *individual file* rather than a container like a directory:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ mv path/to/target/file path/to/destination/file

   $ cp path/to/target/file path/to/destination/file

   $ rm path/to/target/file

Create
^^^^^^

In BASH you can create a file in several different ways. BASH and Linux users are accustomed to using **CLI text editors** `like VIM <https://www.vim.org/>`_ for creating and modifying files. Whereas on Windows the preference is for using a GUI based editor like ``notepad``.

BASH also includes `redirection operators <https://www.guru99.com/linux-redirection.html>`_ which can be used to *redirect* the output of a command into a new location -- like a new file or new lines on an existing file.

Unfortunately, due to the scope of this class, we will not be covering CLI editors or the redirect operators but you can use the links above to learn more about them. Instead, we will introduce a much simpler command.

The ``touch`` command can be used to create an empty file. It takes a relative or absolute path ending in the file's name as an argument:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ touch path/to/file-name

.. admonition:: fun fact

   Technically the ``touch`` command is used for updating the last time the file was *touched* (the last-accessed or modified timestamp). But most of the time it is used for its *side-effect* of creating the file if it doesn't already exist to be touched!

Let's create a file called ``my-file`` in a directory called ``my-files``:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   $ mkdir my-files
   $ touch my-files/my-file

   $ ls my-files
   my-file

View contents
^^^^^^^^^^^^^

Although *everything is a file* not every file can be *interpreted the same way*. Directories, as container files, naturally need a mechanism for listing their contents -- the ``ls`` command. But regular files are just collections of characters. Listing those out would be a mess!

When viewing the contents of a file we can use the ``cat`` command. The ``cat`` command stands for *concatenate* and serves to combine strings of characters. Just like ``touch`` it is often used for the side effect of printing out the contents of a file. In other words it is concatenating the contents of the file with *nothing* resulting in just the contents being displayed.

You can use the ``cat`` command to print the contents of a file by providing the absolute or relative path to that file. Let's try viewing the contents of the hidden file ``.bash_history`` which shows a history of all the commands you have entered recently:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   $ cat .bash_history
   # your command history!

Sometimes printing the *entire contents* to the Terminal is too verbose. This would be like viewing a 50 page book all at once. Instead we can use the ``less`` command to show *less* at one time -- similar to scrolling through pages instead. 

The ``less`` command works the same way, by providing it an absolute or relative path. Once the program opens you can navigate using the following keyboard keys. Some terminals also allow scrolling with the mouse wheel:

- ``J``: scroll down one line
- ``K``: scroll up one line
- ``Q``: quit the ``less`` program and return to the Shell

Let's try viewing the ``.bashrc`` file this time. If the contents of this file look terrifying don't worry! You won't need to write or edit any of it. But it serves as a lengthy file to practice scrolling with ``less``:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   $ less .bashrc
   # less program opens the file, use J and K to scroll and Q to quit

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
