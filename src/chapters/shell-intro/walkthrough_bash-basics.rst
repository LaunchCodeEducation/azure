===============================
Walkthrough: Hands-On With BASH
===============================
   
Working with BASH
=================

From this point forward all of the commands and examples will be in BASH and need to be entered into the Ubuntu Terminal. As mentioned previously, we will distinguish BASH commands from PowerShell commands by using the ``$`` symbol instead of ``>``. 

This article is a guide for the fundamentals of working with BASH. Like other programming languages BASH has more depth than can be covered as an introduction. The topics covered here will give you a foundation to build the rest of your learning on top of. 

Core Tenets
-----------

While learning BASH and Linux some commands and behaviors will seem foreign to you if you come from a Windows background. Keep in mind the following aspects of Linux and BASH to help you understand why things work the way they do:

File System Paths
^^^^^^^^^^^^^^^^^

The Linux File System (FS) has the following design:

- file paths are separated by forward slashes (``/``)
- there is a single root directory, absolute paths are written relative to **root** with the path ``/``

Everything is a file*
^^^^^^^^^^^^^^^^^^^^

In Linux *everything is a file descriptor*. This means that everything including regular text files, directories, devices and even processes are all treated as files. There are 7 `types of files <https://linuxconfig.org/identifying-file-types-in-linux>`_ in Linux and they *don't refer to file extensions*. The majority of the time you will be working with:

- **regular files**: individual text files (denoted by ``-``)
- **directory files**: container files (denoted by ``d``)

Everything is a string
^^^^^^^^^^^^^^^^^^^^^^

There are **no data types** in BASH. All of the inputs and outputs of BASH commands are strings of characters. This concept also applies to the contents of files. 

File extensions are arbitrary
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

All regular files in Linux are treated the same -- just a string of characters (in a `character encoding <https://en.wikipedia.org/wiki/Character_encoding>`_). It is up to the consumer of a file (a program) to decide how to interpret the characters in it. 

In other words, *the Linux OS is not opinionated about how a file is used*. In Linux-land a file extension is not required and only serves as a note for the user to choose a program that will interpret its contents.

File System
===========

Everything in the File System (FS) and commands that affect it are based around relative and absolute paths. Refer to the previous article for a more detailed explanation. Below is a practical refresher:

- **relative path**: relative to a variable location, your current working directory (CWD)
- **absolute path**: relative to a constant location, the root directory (``/``)

You will notice that most of the FS related commands make use of path arguments that can be written as relative or absolute paths.

Navigation Essentials
---------------------

Let's begin by reviewing the essential commands for navigating the FS from the command-line. Take some time to practice using these to navigate around your machine.

Getting Help
^^^^^^^^^^^^

Most commands will provide documentation through the ``--help`` option or a ``man`` (manual) entry. When you are unsure about a command or want to learn more about how it is used you can use get help like this:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ command --help
   # prints help documentation

   $ man <command name>
   # enters a documentation viewer
   # scroll up with J key, down with K key
   # quit with Q key

Show the CWD
^^^^^^^^^^^^

The ``pwd`` (print working directory) command will give you the absolute path of your current working directory (CWD) in the FS:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

If you are in a new Shell session it will default to a CWD of ``/home/<username>``.

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

We will discuss the use of the *this directory* character (``.``) soon. Consider an example about using the **up directory** characters in the following scenario:

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

Our final navigation command is ``ls`` (list contents). As mentioned previously ``ls`` can be used with no arguments to view the contents of the CWD:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   $ ls
   # contents of CWD ("empty" for a new user)

But ``ls`` can also be used view the contents of another directory using a relative or absolute path as its argument:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/student

   # absolute path
   $ ls /usr/bin
   # contents of the user binaries directory

   # relative path
   $ ls ../../usr/bin

You can also provide options to ``ls`` to change the output. The ``-a`` option means *all* and shows both regular and **hidden files**. Hidden files are special configuration files that are hidden to prevent accidental changes to them from consumers. However, when working with CLI tools you will often use these **dot files** as a way of configuring the way your tools behave on your machine.

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

   Notice how the ``.`` and ``..`` are actually listed as *directory files* (the first ``d`` in the long output). The ``.`` and ``..`` are actually treated as *files* (because *everything is a file* in Linux). They refer to the *current directory file* and *up directory file* respectively.

Directory Operations
--------------------

Now that we have the navigating essentials let's practice some common directory operations. We will learn these through a simple example. The concepts and commands will apply to all of the directory work you do in the future.

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

We can also see that both the new directories are empty:

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

Let's move the ``child-dir`` from its current parent directory (``/tmp``) into the new one we made:

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

   The act of moving a file (remember directories are files) can be used to define a new name for it in the destination path. 

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
   
   While we stressed being cautious before it is imperative to be **extra cautious** when deleting files using BASH:

   **DO NOT STRAY FROM THE FOLLOWING COMMAND DIRECTIONS**

The command for deleting, or *removing*, files is ``rm``. When deleting a directory, just like ``cp``, the ``-r`` option will instruct it to do so *recursively*.

Let's clean up the directories we created using the remove command. We will also include the ``-i`` (interactive) option as a safety measure. This will require us to explicitly confirm the removal of each file before it is deleted by entering the ``y`` character at each prompt:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ ls /tmp/parent-dir
   child-dir
   child-dir-2

   $ rm -i -r /tmp/parent-dir
   # for each prompt type y and hit enter (for yes)

   $ ls /tmp/parent-dir
   ls: cannot access '/tmp/parent-dir': No such file or directory
   
File Operations
---------------

As we move from directory to file operations consider one of the core tenets of Linux -- **everything is a file**.

Why is this valuable to consider? Because most of the commands used for directory operations are identical for regular files! When dealing with regular files the ``-r`` (recursive) option is no longer needed since it is an *individual file* rather than a container like a directory:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ mv path/to/target/file path/to/destination/file

   $ cp path/to/target/file path/to/destination/file

   $ rm -i path/to/target/file

Create
^^^^^^

In BASH you can create a file in several different ways. BASH and Linux users are accustomed to using **CLI text editors** for creating and modifying files. Whereas on Windows the preference is for using a GUI based editor like ``notepad``.

BASH also includes `redirection operators <https://www.guru99.com/linux-redirection.html>`_ which can be used to *redirect* the output of a command into a new location -- like a new file or new lines on an existing file.

Due to the scope of this class, we will not be covering CLI editors or the redirect operators but you can use the links above to learn more about them. Instead, we will introduce a much simpler command.

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

.. cut for now, intro to 'less'  

.. Sometimes printing the *entire contents* to the Terminal is too verbose. This would be like viewing a 50 page book all at once. Instead we can use the ``less`` command to show *less* at one time -- similar to scrolling through pages instead. 

.. The ``less`` command works the same way, by providing it an absolute or relative path. Once the program opens you can navigate using the following keyboard keys. Some terminals also allow scrolling with the mouse wheel:

.. - ``J``: scroll down one line
.. - ``K``: scroll up one line
.. - ``Q``: quit the ``less`` program and return to the Shell

.. Let's try viewing the ``.bashrc`` file this time. If the contents of this file look terrifying don't worry! You won't need to write or edit any of it. But it serves as a lengthy file to practice scrolling with ``less``:

.. .. sourcecode:: bash
..    :caption: Linux/BASH

..    $ pwd
..    /home/student

..    $ less .bashrc
..    # less program opens the file, use J and K to scroll and Q to quit

CLI Tools
=========

Package Manager
---------------

The Ubuntu Distribution comes pre-installed with the Advanced Packaging Tool (``apt``) program for managing packages. We will focus on the commands that are used most frequently. Like most CLI programs you can view more details about how to use ``apt`` by using the ``--help`` option.

You will typically see ``apt`` used with the ``-y`` option added to the command. This option skips the confirmation prompt for the actions you are taking to speed up the process. 

.. sourcecode:: bash
   :caption: Linux/BASH

   $ apt <action argument> -y

SUDO
^^^^

Recall that APT, like all system-wide package managers, must have control over your machine to download, install and configure the packages you need. Because it operates on packages stored above the ``/home/<username>`` directory (closer to the root dir) it is considered *outside of the user space* and requires the use of admin privileges:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ sudo apt <action argument> -y

The ``sudo`` command is the equivalent of opening the PowerShell Terminal in admin mode. It is an acronym for **S**\ubstitute **U**\ser to **DO** the command to the right of it. When used without specifying *which user to substitute* it will default to running the command to the right as the ``root`` user -- a special super user account type. The first time you use ``sudo`` *per Shell session* you will be prompted for the admin password of your account (``launchcode`` in our case). 

This means that once you have authenticated you will not have to re-authenticate unless you close the Shell (ending the session) or you open a new Shell in a different Terminal window (a new session). You can liken this behavior to how PowerShell requires you to right-click and open as an admin for each Shell that requires elevated privileges.

Updating repository sources
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Any time you are going to use ``apt`` you should begin by updating the metadata in the repository sources. An ``apt update`` will download information about installed packages (like pending upgrades) as well as refresh the package source lists. The latter half  of the update ensures that when you search and install packages you are always getting the latest additions and versions from your package source repositories.

Below you can see the most ubiquitous ``apt`` command in use:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ sudo apt update -y
   # information about repository source updates

.. admonition:: note

   Updating the repository sources **only updates the metadata about packages**. The actual installed packages can be **upgraded to the latest version** using the ``apt upgrade`` command. 


Installing Tools
----------------

After you have updated you can search for and install package tools on your machine. The ``search`` argument can be used to scan the source repositories for a package. It accepts a search term as a sub-argument which it will use to search the title and descriptions of all the available packages within your group of sources.

.. sourcecode:: bash
   :caption: Linux/BASH

   # always run apt update before searching or installing!
   $ sudo apt search <search term>

If the search results contains your package you can install it using the ``install`` argument. The sub-argument is the **exact package name** of the tool you want to install. The installation prompts (like confirmation dialog boxes in a GUI) can be automatically accepted using the ``-y`` option:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ sudo apt install <package name> -y

Let's practice by searching for the amusing little tool called Cow Say. First let's search for the package by its name, ``cowsay``. This package is available within the default set of source repositories and should show up as the first result:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ sudo apt update -y

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

The package that we want is the first one, ``cowsay``. Notice that the search will check both the package name and description. Let's install it:

.. sourcecode:: bash
   :caption: Linux/BASH

   # installing controls your machine and requires sudo
   $ sudo apt install cowsay -y

In the command output you can see that ``apt`` downloads, unpacks and installs the package automatically . You can now try out the newly installed tool! Use the command program ``cowsay`` and enter a message as its arguments:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ cowsay Hello World!

It is okay to leave ``cowsay`` installed. But if you would like to remove it you can use ``apt`` to cleanly uninstall it:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ sudo apt uninstall cowsay -y

Adding Sources
--------------

The default list of package repositories provides access to a large collection of open-source tools from package hosts trusted by the open source community. But in many cases you will need to install additional sources to download packages from. Additional sources can range from private repositories hosted by a company, for internal use, to independently-hosted repositories like the Microsoft packages repository. 

These custom repositories often require both the repository and a **signing key** to be installed. Anyone is able to host a repository of packages. This is why it is important to only install source repositories, and packages from those repositories, from trusted sources. As an additional security measure, trusted repositories include a signing key to check that downloaded packages are authentic (from a trusted source) before being installed. 

.. admonition:: note

   The topics of Public Key Infrastructure (PKI), which includes signing keys, and custom repositories extends outside the scope of this course. You can read more about how these work `in this repository article <https://wiki.debian.org/DebianRepository>`_ and `this repository signing key article <https://wiki.debian.org/SecureApt>`_. Both of these articles offer an overview of the mechanisms involved from a relatively high level.

Installing .NET
^^^^^^^^^^^^^^^

Let's see what this process looks like using the ``dotnet CLI`` installation as an example. 

.. admonition:: tip

   Like other 3rd party tool installations you can find the instructions on the package maintainer's site. For example, we will be following the instructions from this `Microsoft installation article <https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#1804->`_. 

The first step is to install the official Microsoft package repository. This installation includes both the repository and the signing key. This is a one-time process and future installations of Microsoft tools will be available and trusted automatically:

.. sourcecode:: bash
   :caption: Linux/BASH

   # install the repository source package (includes the repo and signing key)
   $ sudo wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

   # unpack and install the repository and trust the signing key
   $ sudo dpkg -i packages-microsoft-prod.deb

Now we will install a utility called ``apt-transport-https`` which, as the name implies, is used to download over HTTPS. Microsoft only serves their packages over secure connections:

.. sourcecode:: bash
   :caption: Linux/BASH

   # always update before other commands
   $ sudo apt update -y

   $ sudo apt install apt-transport-https -y
   
Finally with the repository, signing key, and HTTPS tooling installed we can install the ``dotnet`` package we were after. We will install the .NET Core SDK which includes both the SDK (standard library, compiler and runtime) as well as the ``dotnet`` CLI tool itself:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ sudo apt update -y
   $ sudo apt install dotnet-sdk-3.1 -y

From the output you can see all of the work that ``apt`` does automatically. Imagine doing all of that downloading, unpacking and configuration manually!

You can confirm the installation was successful by viewing the ``--help`` output of ``dotnet``. Viewing the help output of a command program is an easy way to get acquainted with it right from the command-line. We will work with this tool in later lessons but feel free to poke around with it in the mean time.

.. sourcecode:: bash
   :caption: Linux/BASH

   $ dotnet --help

.. cut from this course but keep for later

.. Piping
.. ======

.. Recall that piping is the mechanism for taking the output of one command and using it as the input of the second command. It involves two or more commands separated by the pipe operator symbol (``|``, under the ``backspace`` key). In a general sense this is how piping works:

.. .. sourcecode:: bash

..    a-command -> a-command output | -> b-command <a-command output as argument> -> b-command output ...   

.. Grep
.. ----

.. Because all of the inputs and outputs of BASH commands are strings it follows that a tools for working with these strings would be developed. Grep is part of a suite of tools that are pre-installed on most Linux Distributions. The suite includes ``grep``, ``awk`` and ``sed``. The former of which is designed for *searching* while the latter two are used for *processing*, or transforming, text strings. They work on the text contents of files but really shine when used in piping.

.. While ``sed`` and ``awk`` are powerful and worth learning they fall well outside of the scope of this course. However, searching with ``grep`` is a valuable tool whose basic behaviors are simple to understand. 

.. In its simplest form ``grep`` uses two arguments -- a search term and a text input source. The text input can be an absolute or relative path to a file you want to search the contents of. Grep will search line-by-line and output any lines that have a match for the search term. If there are no matches the output of ``grep`` will be an empty line:

.. .. sourcecode:: bash
..    :caption: Linux/BASH

..    $ grep '<search term>' path/to/file

.. For example what if we wanted to see all of the conditional statements in the ``.bashrc`` file we looked at earlier? We could have ``grep`` search that file for ``if`` and output the search results to us. 

.. .. sourcecode:: bash
..    :caption: Linux/BASH

..    $ grep 'if' ~/.bashrc
..    # all of the lines that include 'if' in them

..    # recall ~ is a shorthand for /home/<username of logged in user>
..    # the following command is identical in behavior
..    $ grep 'if' /home/student/.bashrc

.. We will cover ``grep`` behavior when used in piping next. For more detailed information you can always check the help or manual outputs:

.. .. sourcecode:: bash
..    :caption: Linux/BASH

..    # concise help output (usually available)
..    $ grep --help

..    # manual for a command (not always available)
..    $ man grep 
   
..    # opens in the "less" program
..    # use the J and K keys to scroll and Q to quit

.. Filtering with grep
.. -------------------

.. Consider a scenario where you want to *search for* one file out of many within a directory. You could ``ls`` the contents and search through it by hand. Or even use a GUI File Explorer to visualize the files. But what if there were dozens, hundreds or thousands of files? Clearly it is impractical to do this work by hand.

.. What if instead of letting the contents output of ``ls`` be sent to the Terminal we used it as an input to a tool designed for performing searches? This is what piping and ``grep`` are made for!

.. When only a search term argument is given to ``grep`` (when used in piping) it will use the output of the previous command as the text to search. Essentially it treats the output the same as the contents of a file when given a file path argument. You can picture it like this:

.. .. sourcecode:: bash
..    :caption: Linux/BASH

..    $ <command> | grep '<search term>' <output from command>

.. We can *pipe* the output of ``ls`` (directory contents as a string) as the string input used by ``grep`` to filter just the results we need. Our pipeline would look like this:

.. .. sourcecode:: bash

..    $ ls --> dir contents string | --> grep 'search term' <dir contents string> --> search results string

.. What if we wanted to check for details about the ``dotnet`` program by using the long form ``ls`` output:

.. .. sourcecode:: bash
..    :caption: Linux/BASH

..    $ ls -l /usr/bin | grep 'dotnet'
..    lrwxrwxrwx 1 root   root           22 May 20 15:37 dotnet -> ../share/dotnet/dotnet

.. You can pipe to and from many CLI programs thanks to the standard use of strings as outputs and inputs. As a final example let's search through the help output of ``dotnet``. If you were to view the help output directly you would end up scrolling through many lines.

.. What if you just want to know how to publish a project (something we will soon cover)? We can use piping to automate the process of searching through the lines manually:

.. .. sourcecode:: bash
..    :caption: Linux/BASH

..    $ dotnet --help | grep 'publish'
..    publish           Publish a .NET project for deployment.


.. todo:: consider splitting scripting to own article 

Scripting
=========

Shell scripting is the process of automating a series of commands. The key to automation is to understand the logical steps needed to perform a task manually. In this course we will use scripting to automate operational tasks like provisioning and managing cloud resources on Azure. 

Early in the course we will provide you with scripts that you will be encouraged to read but not expected to write. After getting comfortable with the manual steps you will learn how to write and use your own scripts. 

Essentials
----------

Commands
^^^^^^^^

You can use any command in a script that you are able to issue manually in the Shell REPL. Unlike the REPL which will prompt you for the next command, scripts are written in a file with each independent command or statement occupying a single line.

A statement, like other languages, is an independent instruction like defining a variable or constructing a loop. We distinguish these from commands which refer to actual CLI programs like those you would call from the Shell REPL.

.. admonition:: note

   When providing code samples for scripts we will remove the ``$`` character used in REPL examples. Each separate line is its own command or statement.

Script File Extensions
^^^^^^^^^^^^^^^^^^^^^^

Because file extensions are arbitrary in Linux, a script file can have any extension (or none at all). However, it is customary to use the ``.sh`` extension as a note to signify that the script should be interpreted as BASH commands.

Comments
^^^^^^^^

As you have seen throughout the previous examples, comments can be used to annotate your scripts. In a BASH script you can write comments by preceding them with a ``#`` symbol. Anything after ``#`` is ignored by the BASH interpreter. Comments are a valuable addition to any script, especially when they get complex. Remember that comments should serve to explain the *why* not to dictate the *how* which the code already describes.

Executing a script
^^^^^^^^^^^^^^^^^^

The act of executing a script is the same evaluating a command entered into the REPL. An interpreter is needed to understand and execute the contents. In the REPL the interpreter is implied by the Shell -- BASH in our case. The Shell is actually a BASH REPL process that is listening for, interpreting and executing commands.

Recall that files in Linux are just strings of characters. It is **up to the program that interprets it** to decide what to do with its contents. When executing a script we have to define what program, like BASH or Python, that will interpret it. This can be done explicitly or implicitly. 

Explicit execution is when we use the interpreter program (``bash``) as a command and provide it with the path to the script file as an argument. For example if we had a BASH script file in our home (``~``) directory we can execute it like this:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ bash ~/my-script.sh

In other words when we want to execute a script explicitly we (the user) define the program we want to interpret it -- one of the core tenets covered earlier. As another example if we had a Python script we would naturally use the ``python`` interpreter to execute it:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ python ~/my-python-script.py

If we try to execute a script with the wrong interpreter it will fail. It would be like handing an English-speaking person a book in Japanese and asking them to interpret it!

.. admonition:: note

   Implicit execution is when the interpreter is defined inside the script using a special line at the top of the script file called a `shebang <https://linuxize.com/post/bash-shebang/>`_. 
   
   Implicit execution is more advanced but is the standard approach when working with scripts professionally. We will not be covering implicit execution at this time as it involves some other steps that are best covered when you are more comfortable with scripting and BASH in general.

The Executing User
^^^^^^^^^^^^^^^^^^

Commands in scripts are executed by the *user who executes the script*. While this might seem intuitive it does have an important implication. 

This means that if you (``student``) run a script then all of those commands will be issued by the ``student`` user and be *subject to the permissions of that user*. If you need to run privileged commands you must run it using a super user account. 

However, if you try to use ``sudo`` in the script a prompt would require you to authenticate as soon as it is executed -- a manual step that would defeat the purpose! 

.. admonition:: fun fact

   In the cloud the scripts we execute will run as ``root`` automatically and will not require the use of ``sudo``. 

Variables
---------

Earlier we discussed environment variables -- variables that affect every command and script executed in the Shell. You can also have variables that are only available within a script. In relatable programming terms, script variables are scoped to the script, whereas environment variables are globally scoped to the whole Shell.

Defining variables
^^^^^^^^^^^^^^^^^^

When defining variables in a script the convention is to use lowercase letters and separate words with underscores (``_``). Environment variables are written in all capital letters so they are easy to distinguish from script variables. 

Because BASH does not have any data types a variable is simple to declare and assign. First you define the name of the variable followed by an assignment symbol (``=``) and the string value of it on the right side.

.. admonition:: note

   Spaces are use to delimit, or distinguish, different parts of a command called **tokens**. Token splitting is what allows BASH to see a command along with its arguments and options as individual units to be evaluated -- each separated by a space. 

When defining a variable **there can be no spaces between the variable declaration and assignment**:

.. sourcecode:: bash
   :caption: Linux/BASH
   
   # correct: no spaces
   variable_name=value

   # wrong: spaces between declaration and assignment
   variable_name = value

When the value of a variable does not have any spaces it can be written as shown above. When you need to have spaces you can put single-quotes (`''`) around the value. These serve to group the whole string value together including the spaces:

.. sourcecode:: bash
   :caption: Linux/BASH

   variable_name='a longer value'

Substituting variables
^^^^^^^^^^^^^^^^^^^^^^

Once a variable has been defined (either in the script or a global environment variable) it can be referenced by prefixing a ``$`` symbol before it:

.. sourcecode:: bash
   :caption: Linux/BASH

   # define the variable
   my_variable='hello world'

   # reference the script variable
   $my_variable

   # reference a global variable
   $PATH

Variable Substitution
^^^^^^^^^^^^^^^^^^^^^

Referencing a variable is straightforward. But in most cases this process is done *inside* of a command, referencing in the open as we have done above has no effect. For this behavior BASH has a mechanism called **variable substitution**.

For example, consider this simple script that creates and moves a directory using variables to hold the paths. Above each command is a comment showing what the command looks like when its variables have been substituted.

Create a directory called ``bash-examples`` in your home (``~``) directory and open a new file called ``variable-substitution.sh`` within it. You can use any editor you would like to paste in the contents below.

.. sourcecode:: bash
   :caption:  ~/bash-examples/variable-substitution.sh

   target_path=/tmp/dir-name

   # ~ is a shorthand for /home/<username>
   destination_path=~/dir-name

   # mkdir /tmp/dirname
   mkdir "$target_path"

   # mv /tmp/dir-name ~/dir-name
   mv "$target_path" "$destination_path"

   # $HOME is an environment variable with a value of /home/<username>
   # ls /home/<username>
   ls "$HOME" 

You should now have a file with the path ``~/bash-examples/variable-substitution.sh`` that you can execute using ``bash`` as the interpreter:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ bash ~/bash-examples/variable-substitution.sh

You likely noticed that the variables are contained in double-quotes (``""``) when used in commands. This is a best practice when working with substitutions as it can prevent unintended behavior caused by spaces or special characters. This is especially true when scripts receive user input which, as you now know, should never be trusted!

.. admonition:: note

   You can read more about the behavior of `escape characters and single and double quotes <https://linux.101hacks.com/bash-scripting/quotes-inside-shell-script/>`_ in this article. If it goes over your head it's okay, just follow the best practice to stay safe and come back to understanding the *why* later.

Command Substitution
--------------------

**Command substitution**, as the name implies, is just like variable substitution but for commands. It allows you to execute a command within another command. We will see many examples of its usage throughout this course but for now consider the basic aspects of it.

We will refer to command substitutions interchangeably with **in-line evaluations** as they are evaluations performed *in the line* of a command being executed. An in-line evaluation allows you to *embed* a command within another like this:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ command $(sub-command)

In this example the ``sub-command`` will first be evaluated (in-line), then the main ``command`` will be evaluated. When the ``command`` is evaluated the output of ``$(sub-command)`` will *substituted in* as its argument. 

You can treat in-line evaluations as you would any other command, with arguments and options. The only difference is that, like all programming languages, commands are evaluated from the inside out. Any in-line evaluations will first be evaluated before stepping outwards and substituting their output.

Consider a more complicated example to understand how it works:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ command $(sub-command $(sub-sub-command))

This command would be evaluated in the following order:

#. innermost level: ``$(sub-sub-command)``
#. next level: ``$(sub-command <output of sub-sub-command>)``
#. outermost level: ``command <output of sub-command>``

This is particularly useful in scripts when you want to capture the output of a command in a variable. Because in-line evaluation is a more advanced topic we will return to it later in a context that necessitates it. For now consider the following contrived example where we store our "history" of working directories (WD) in variables to navigate around.

In your ``bash-examples`` directory create another file called ``command-substitution.sh`` and paste in the following contents. We will use the ``echo`` command to print out our CWD throughout the script:

.. sourcecode:: bash
   :caption: ~/bash-examples/command-substitution.sh

   # in-line evaluation in a string message
   echo "CWD is: $(pwd)"

   # in-line evaluation to assign the value
   first_wd=$(pwd)

   cd /tmp
   echo "CWD is: $(pwd)"

   second_wd=$(pwd)

   cd /usr/bin
   echo "CWD is: $(pwd)"

   third_wd=$(pwd)

   # return to the first
   echo "returning to first WD"
   cd "$first_wd"
   echo "CWD is: $(pwd)"

   # jump to the second
   echo "jumping to second WD"
   cd "$second_wd"
   echo "CWD is: $(pwd)"

Then execute the script the same way as before:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ bash ~/bash-examples/command-substitution.sh

.. admonition:: note

   As a good programmer you are likely miffed by the copy and pasting of an identical statement. Although we won't be getting into BASH functions you should be able to make sense of it. Here is a cleaner approach to help you sleep at night!

   .. sourcecode:: bash
      :caption: ~/bash-examples/command-substitution.sh
   
      print_cwd() {
         echo "CWD is: $(pwd)"
      }

      print_cwd

      first_wd=$(pwd)

      cd /tmp
      print_cwd

      second_wd=$(pwd)

      cd /usr/bin
      print_cwd

      third_wd=$(pwd)

      # return to the first
      echo "returning to first WD"
      cd "$first_wd"
      print_cwd

      # jump to the second
      echo "jumping to second WD"
      cd "$second_wd"
      print_cwd

Learn More
==========

This has been an introduction to the practical fundamentals of BASH. You are *not expected to have memorized any of it* by any means. Feel free to refer back to this article throughout the course to refresh your memory. Learning BASH takes a lot of time. We covered a lot of ground today and will be revisiting the fundamentals regularly until they become second nature.

If you want to learn more advanced usage this `BASH cheat-sheet from DevHints <https://devhints.io/bash>`_ will get you up to speed quickly. DevHints is an open source site filled with quick-reference guides for many languages and frameworks written by the open source community.
