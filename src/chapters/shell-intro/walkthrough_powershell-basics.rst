=====================================
Walkthrough: Hands-On With PowerShell
=====================================

Now that you have learned some fundamental Shell and BASH syntax you are ready to learn about PowerShell. Because many PowerShell features and behaviors were inspired by BASH you will find that much of the knowledge you gained will be applicable to this new material.

Working with PowerShell
=======================

Although BASH and PowerShell share many similarities there are some key distinctions between them. Just as before we will establish the core aspects of PowerShell and Windows to help rationalize the *why* behind their behavior. 

Core Tenets
-----------

File System Paths
^^^^^^^^^^^^^^^^^

Windows treats each of its **drives** (devices managed by the OS) as independent file system trees. Each drive has a name and ends with a ``:`` character, like ``C:`` or ``D:``. The ``C:`` drive is your disk drive and serves as the default installation location of the Windows OS. For this reason the ``C:`` drive is typically considered the root directory.

- paths are separated by back-slashes (``\``)
- file and directory names are not case-sensitive
- the ``C:\`` directory is used as the root directory for absolute paths 

Framework Interpretation
^^^^^^^^^^^^^^^^^^^^^^^^

The .NET framework is used to interpret and translate PowerShell commands for the OS instead of the direct communication channel seen between BASH and Linux. The object-oriented *power* of PowerShell comes from this layer of abstraction between itself and the Windows OS. 

Everything is an object
^^^^^^^^^^^^^^^^^^^^^^^

Since Windows NT the Windows OS releases have all followed an object-oriented design. By extension, PowerShell treats all of its **inputs and outputs as distinct types of objects**. This departure from the string-based approach of BASH makes working with PowerShell a more *tangible* Shell experience.

PowerShell commands and scripts are able to work with a wide range of objects from those provided by the underlying .NET framework to custom-developed types. Like other object-oriented languages PowerShell objects contain properties and methods that make them intuitive to work with.

File extensions matter
^^^^^^^^^^^^^^^^^^^^^^

File extensions are an integral aspect of how Windows works. There are thousands of file extensions built into the Windows OS but `there are only 10 common types <https://support.microsoft.com/en-us/help/4479981/windows-10-common-file-name-extensions>`_ that you will typically encounter. Every file is bound to one of these extensions that enforces what program will be used to interpret it. 

You can think of a file in Windows like an object whose type is specified by its file extension. This file type, like an object type, defines the properties and methods used by programs that interact with it.

Cmdlets, Functions & Modules
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In PowerShell the commands you use are categorized as either a **cmdlet** or a **function**. Cmdlets are written in a .NET supported language (like C#) and as such must be compiled before they can be used. Functions on the other hand are written in PowerShell within a script file. 

**Modules** are collections of cmdlets and functions that share a common theme of use. They are used to bundle together related functionality into a single package that can be shared. 

Using Cmdlets
=============

PowerShell cmdlets behave similarly to BASH commands. They begin with their name and follow with arguments and options. PowerShell cmdlets follow a **Verb-Noun** pattern. 

Many of the cmdlets begin with the **Verbs** ``Get-`` and ``Set-`` followed by the **Noun** that the verb is reading or modifying. This declarative naming approach makes reading and writing PowerShell easier to understand.

For example the cmdlets ``Get-Location`` and ``Set-Location`` both operate on your ``Location`` in the FS. The former to view your CWD and the latter to change directories.

.. admonition:: note

   Cmdlets, like the rest of the Windows FS, are **not** case-sensitive. Neither are there arguments or options. Take ``Get-Location`` for example, you can use it just the same ``get-location``.
   
One notable difference from BASH commands is that **options** are all written in long form (no single-letter shorthands) and use a single dash (``-``). For example the ``Get-Help`` cmdlet has an ``-Online`` option that will open the help documentation in your browser:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Help <cmdlet to get help for> -Online

File System
===========

Because PowerShell was created after BASH it adopted many of the essential BASH FS commands and behaviors. However, because the *real* BASH commands are incompatible with Windows they were brought over as **aliases**. 

An alias is like a nickname for a command. The BASH FS commands, like ``cd`` or ``ls``, are aliases for underlying PowerShell FS cmdlets, like ``Set-Location`` and ``Get-Content``.

Because these aliases are not *the real BASH command* not all of their arguments and options are the same in PowerShell. Let's explore the essential cmdlets and the common arguments and options used with them.

.. admonition:: note

   Some of the navigation shorthands from BASH have changed:

   - ``~``: shorthand for the home directory still works
   - ``-``: shorthand for returning to the *previous* working directory **does not**
   
   The *this directory* and *up directory* characters are the same with the exception of a back-slash (``\``):

   - ``.``: *this directory* shorthand
   - ``.\``: relative to *this directory* shorthand
   - ``..\``: *up directory* level shorthand

PowerShell Cmdlet Equivalents
-----------------------------

Get CWD
^^^^^^^

In PowerShell you can either use the BASH alias:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > pwd
   # C:\Users\<username>

Or its underlying cmdlet, ``Get-Location``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Location
   # C:\Users\<username>

Change directory
^^^^^^^^^^^^^^^^

The BASH command ``cd`` can still be used with an absolute or relative path:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > cd relative/path

   > cd C:\absolute\path

It is an alias for the PowerShell cmdlet ``Set-Location`` which uses the same arguments:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Set-Location relative/path

   > Set-Location C:\absolute\path

List directory contents
^^^^^^^^^^^^^^^^^^^^^^^

In BASH we used the ``ls`` command with or without a path to list the contents of a directory:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ls
   # contents of CWD

   > ls relative\path
   # contents of dir at relative path to CWD

   > ls C:\absolute\path
   # contents of dir from absolute path

The ``Get-ChildItem`` cmdlet has the following options:

- ``-Path``: allows you to add a path argument which will display the contents of the provided path
- ``-Recurse``: will display the sub-contents of any directories found

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-ChildItem
   # contents of CWD

   > Get-ChildItem -Path relative\path
   # contents of dir at relative path to CWD

   > Get-ChildItem -Path C:\absolute\path
   # contents of dir from absolute path

Move a directory or file
^^^^^^^^^^^^^^^^^^^^^^^^

The ``mv`` command can be used in BASH or PowerShell with an absolute or relative path for either of its arguments:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > mv path\to\target C:\absolute\path\to\destination

The PowerShell cmdlet behind ``mv`` is the more declaratively named``Move-Item``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Move-Item path\to\target C:\absolute\path\to\destination

Copy a directory or file
^^^^^^^^^^^^^^^^^^^^^^^^

In PowerShell copying an Item can be done using the BASH ``cp``. Recall that we used the ``-r`` (recursive) option when copying a directory with its contents. Whereas for a file we could just use ``cp`` directly:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # copy a directory recursively
   > cp -r path\to\target path\to\destination

   # copy a file
   > cp path\to\target\file path\to\destination\file

Its cmdlet equivalent ``Copy-Item`` can also be used for files or directories. When copying a directory the ``-Recurse`` option can be used like the BASH ``-r``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # copy a directory recursively
   > Copy-Item -Recurse path\to\target path\to\destination

   # copy a file
   > Copy-Item path\to\target\file path\to\destination\file

Delete a directory or file
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. admonition:: warning

   Be **very careful** when removing (deleting) items in PowerShell. Always use the interactive mode (``-Confirm`` option) to confirm each deletion!

Previously we used the BASH ``rm`` command with the ``-i`` (interactive) option to remove files and directories. Just like ``cp`` we added the ``-r`` (recursive) option when deleting a directory and its contents. 

However, in PowerShell these options can not be used. Instead we will use the PowerShell ``Remove-Item`` cmdlet with the following options:

- ``-Confirm``: confirm each item before being deleted (like ``-i`` interactive mode in BASH)
- ``-Recurse``: when removing a directory and its contents recursively

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # delete a directory and contents recursively
   > Remove-Item -Confirm -Recurse path\to\dir-name

   # delete a file item
   > Remove-Item -Confirm path\to\file-name.ext

Create a directory or file
^^^^^^^^^^^^^^^^^^^^^^^^^^

In BASH we used the ``mkdir`` command to create new directories. This alias is still available in PowerShell but its underlying cmdlet is much more powerful:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > mkdir relative\path

   > mkdir C:\absolute\path

Recall that in BASH we used a side-effect of the ``touch`` command to create a new file. The ``touch`` alias **does not exist** in PowerShell.

Instead of using a side-effect, PowerShell has a dedicated cmdlet for creating **Items** of any type -- be it a file or directory.

The ``New-Item`` cmdlet has the following options:

- ``-Name "<item name>"``: the name of the Item to create
- ``-Path <path of new item>``: will create the Item (of the given ``Name``) at the absolute or relative path
- ``-ItemType "<file type>"``: will create the item with a specific type (like ``file`` or ``directory``)

For example to create a directory:

.. sourcecode:: powershell
   :caption: Windows/PowerShell
   
   > New-Item -Name "dir-name" -ItemType "directory" -Path relative\path
   # creates relative\path\dir-name directory Item

   > New-Item -Name "dir-name" -ItemType "directory" -Path C:\absolute\path
   # creates C:\absolute\path\dir-name directory Item


When creating a file you can use the ``-Value`` option to write content to the file in one command! Remember that extensions matter in Windows. You **must provide the file extension** in the ``-Name`` option:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > New-Item -Name "my-file.txt" -ItemType "file" -Path relative\path -Value "contents of the file"
   # creates relative\path\my-file.txt with "contents of the file" written to it

   > New-Item -Name "my-file.txt" -ItemType "file" -Path C:\absolute\path -Value "contents of the file"
   # creates C:\absolute\path\my-file.txt with "contents of the file" written to it

.. admonition:: tip

   For creating the contents of files that are more than a single line take a look at this ``here-string tutorial article <https://riptutorial.com/powershell/example/20569/here-string>`_.

Reading file contents
^^^^^^^^^^^^^^^^^^^^^

In BASH we learned about the ``cat`` (concatenate) command. We used the side-effect of ``cat`` to print the contents of a file to the Terminal. We *can* use ``cat`` in PowerShell as well:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > cat relative\path\to\file

   > cat C:\absolute\path\to\file

The PowerShell equivalent to ``cat`` is ``Get-Content``. Notice how declarative the naming is -- you are *getting* the *contents* of the directory *path argument*:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Content
   # contents of CWD

   > Get-Content relative\path
   # contents of dir at relative path to CWD

   > Get-Content C:\absolute\path
   # contents of dir from absolute path

The ``Get-Content`` cmdlet will output an object based on the content in the file. Most of the time this will be a single ``String`` object for each line in the file. 

.. admonition:: note

   The ``Get-Content`` cmdlet has a number of options that can be used to get certain lines of a file's contents or even filter the output. You can read more about the options `in this documentation article <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content?view=powershell-7>`_ 

Getting Help
------------

PowerShell have many options -- we have only covered the most commonly used ones here. Many of the tasks that would require piping together multiple commands together in BASH can be accomplished using a single cmdlet and its associated options. 

While the ``--help`` option is available for *some* CLI tools that we will use in the class, the primary mode of viewing documentation uses the ``Get-Help`` cmdlet. The ``Get-Help`` cmdlet uses a cmdlet name as its argument:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Help <cmdlet name to get help for>

Get-Help by default will display the documentation for the given cmdlet directly in the PowerShell Terminal. However, using the ``-Online`` option will automatically open your browser to the online documentation:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-help <cmdlet name> -Online

Another useful option for ``Get-Help`` is ``-Examples`` which will provide practical examples of using the cmdlet:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-help <cmdlet name> -Examples

PowerShell keeps commonly used documentation locally on your machine so it can be accessed more quickly and even offline. In some cases you will need to update your *local* documentation cache. You can update the local help documentation using the ``Update-Help`` cmdlet. 

You can append the ``-Confirm`` option to auto-confirm the download and skip the prompt:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Update-Help -Confirm

CLI Tools
=========

Package Manager
---------------

Windows has a pre-installed manager of Features and Services (native Windows applications and tools) which can be accessed through PowerShell. However, for third-party CLI tools we will need to install ``Chocolatey``, an open-source package manager for Windows. ``Chocolatey`` is not a native package manager like Ubuntu's pre-installed ``apt``, but is `recognized by Microsoft in as an industry standard <https://devblogs.microsoft.com/commandline/join-us-for-a-hot-cup-o-chocolatey/>`_. 

Install Chocolatey
^^^^^^^^^^^^^^^^^^

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
^^^^^^^^^^^^

After installing ``Chocolatey`` you can access help with the ``--help`` option.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco --help

An advantage of ``choco`` being open-source is that you can find a lot of assistance in online forums and the crowd-sourced `Chocolatey documentation <https://chocolatey.org/docs>`_.

Install a package
^^^^^^^^^^^^^^^^^

``Chocolatey`` is modeled after many popular Linux package managers like ``apt``. For this reason the syntax for chocolatey should look familiar:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco install <package name> -y

``Chocolatey`` also supports a number of options like ``--yes`` or ``-y`` which, like the ``apt`` option, skips confirmation prompts, automatically downloads and installs the package. To view more options view the `Chocolatey install command documentation <https://chocolatey.org/docs/commands-install>`_.

Upgrade a package
^^^^^^^^^^^^^^^^^

Upgrading packages in ``Chocolatey`` is again a simple command named ``choco upgrade``.

To upgrade the ``dotnetcore-sdk``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco upgrade <package name> -y

``Chocolatey`` also supports upgrading all of the packages it downloaded and installed.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco upgrade all -y

Updating sources
^^^^^^^^^^^^^^^^

The ``Chocolatey`` package manager is also responsible for keeping track of package repository sources. When you download ``Chocolatey`` for the first time it automatically loads the ``Chocolatey`` trusted sources which host common packages. In some instances you may need to install a package that is not a part of the ``Chocolatey`` hosted sources, in this case you would need to add a custom source.

We will not be adding any sources beyond the default ``Chocolatey`` sources, but an example of the usage would follow this pattern:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco add source <source target>

You can find more information about adding ``Chocolatey`` repository by viewing the `Chocolatey sources documentation <https://chocolatey.org/docs/commands-sources>`_.

Course Tools Installation
-------------------------

Two of the CLI tools we will begin using this week are the ``dotnet CLI`` and the ``git`` version control system (VCS). Let's install them now before learning how to use them in the coming days.

.. admonition:: note

   Whenever you install a new CLI tool using ``choco`` you **must exit all PowerShell sessions** before they can be used. You can exit a PowerShell session by entering the ``exit`` command or by closing **all** of the open PowerShell Terminal windows.

Install .NET SDK
^^^^^^^^^^^^^^^^

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco install dotnetcore-sdk-3.1 -y

Don't forget to close and re-open PowerShell before entering the following command to test the installation:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > dotnet --version
   # dotnet version output

Install Git VCS
^^^^^^^^^^^^^^^

You likely have been using the **Git BASH** program to access ``git`` and GitHub. What you may not have realized is that Git BASH is a Terminal that emulates basic BASH commands and ``git``. However, now that we are comfortable working from the command-line we can use ``git`` natively within PowerShell and BASH. Let's install ``git`` in PowerShell using ``choco``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > choco install git -y

After **closing and re-opening** PowerShell you can confirm the installation with the following command:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > git --version
   # git version output

Objects
=======

The outputs of the FS cmdlets looked just like the strings we saw in BASH. However, recall that *everything is an object* in Windows and PowerShell. All of the outputs from PowerShell commands are in fact objects! 

For example, when working with many of the FS commands, most of the outputs will be `Directory <https://docs.microsoft.com/en-us/dotnet/api/system.io.directory?view=netcore-3.1>`_ or `File <https://docs.microsoft.com/en-us/dotnet/api/system.io.file?view=netcore-3.1>`_ object types.
 
Objects are more *tangible* than a flat string of characters and bring a new level of depth and efficiency when working from the command-line. They hold properties for quick-access to metadata and expose methods for common tasks that would require a pipeline of commands to perform in BASH. 

Properties & Methods
--------------------

PowerShell is part of the .NET family of `CLS-compliant languages <https://docs.microsoft.com/en-us/dotnet/standard/common-type-system>`_. As a member of the Common Language System PowerShell is able to access the full suite of .NET `class libraries <https://docs.microsoft.com/en-us/dotnet/standard/class-library-overview>`_. 

The .NET standard library is separated into different **namespaces** which are like modules of related classes.  The root namespace called the `System namespace <https://docs.microsoft.com/en-us/dotnet/api/system?view=netcore-3.1>`_ contains the base class definitions for fundamental object types like ``Strings`` or ``Arrays``.

Because PowerShell and C# are both CLS-compliant languages you will find a lot of cross-over between how they are used. Despite some syntactical differences, in both languages properties and methods can be accessed in the same way you are familiar with -- using dot notation.

Access a property
^^^^^^^^^^^^^^^^^

Let's consider one of the simplest object types, those belonging to the ``String`` `class <https://docs.microsoft.com/en-us/dotnet/api/system.string?view=netcore-3.1>`_. Strings have a ``Length`` property that can be accessed like this:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > "dot notation works!".length
   19

The equivalent in BASH requires piping through multiple commands:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ echo "dot notation works!" | wc -l

Grouping Expression Operator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The **grouping expression operator** is a pair of parenthesis that wrap around a PowerShell expression. It behaves the same as parenthesis that group parts of a mathematical equation. Expressions are evaluated from the innermost groups outwards. 

For example, ``(10 + 10) * 2`` would result in ``40``, while ``10 + 10 * 2`` would result in ``30``. Because the parenthesis group together an expression they are evaluated first before the outer expression of multiplying by ``2``.

Consider a more complex example, ``((10 + 10) * 2) + 5`` would be evaluated in the following steps:

- innermost grouping: ``(10 + 10) = 20``
- moving outwards to the next grouping: the inner group's value ``(20)`` is substituted to evaluate the next grouping ``((20) * 2) = 40``
- outermost level: once again the grouping's value ``(40)`` is substituted for the final calculation ``(40) + 5 = 45`` 

The same principle applies to a PowerShell expression within the grouping operators. However, instead of evaluating to *numeric values* what is substituted is *the object output* by the grouped expression. 

Essentially the group is treated as the resultant object where dot notation can be used on the closing parenthesis ``)``. In the following example our grouped expression *adds* (concatenates) two strings together and then evaluates the length of the resultant string output:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ("hello " + "world").length
   11

Call a method
^^^^^^^^^^^^^

- getType()
- specific to each object type
- can discover through online documentation...or

Discovering methods and properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

While a property like 

- sometimes properties / methods are intutitive
- other times you need to look them up per object
- can look at online or Get-Help docs
- or can get list of props and methods using Get-Member

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Member -InputObject <object>

Chaining Methods & Properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- (Get-Location).getType().Name -> PathInfo object type
- .GetType()

Working with JSON
-----------------



Common Data Types
-----------------

- link to common data types
- Get-Member to view type

Strings
^^^^^^^

- single quote (literal)
- double quote (substitution)

JSON
^^^^

.Net Objects
^^^^^^^^^^^^
- .NET https://docs.microsoft.com/en-us/dotnet/standard/class-library-overview

Custom Objects
^^^^^^^^^^^^^^

Cmdlet Input & Output Types
---------------------------
- view
- configure
- segue to piping
- cmdlets and objects
   - https://docs.microsoft.com/en-us/dotnet/api/microsoft.powershell.commands?view=powershellsdk-1.1.0 
- Get-Member with grouping expression

Piping
======

- much more time in this section

Expressions
-----------

- grouping
- sub-expression
- https://ss64.com/ps/syntax-operators.html

Converting Types
----------------

- convert to / from json
- convert between common DTs

show
- filter (grep equiv)
- mutate (sed / awk equiv)
- read / write file

Scripting
=========

diffs
- implicit vs explicit? (is it all implicit because of file exts?)
   - file extension differences (ps, ps1, psm etc)
- environment variables as a dict
   - HomePath
   - Path
- variable scoping
   - environment (system)
   - user (profile)
   - process (session)
      - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-7#changing-environment-variables

show
- variables
   - declare and use
   - variable substitution
   - command substitution
- exercise from gist
   - csv to json
   - parse logs?

out of scope (get links)
- writing functions
- writing cmdlets
- writing manifests

Learning More
=============

- link to devhints cheatsheet
- discuss custom objects








