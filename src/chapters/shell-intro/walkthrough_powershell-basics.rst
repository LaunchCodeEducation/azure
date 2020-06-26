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

Output Objects
--------------

Although the outputs look similar to the BASH strings, all of the outputs from PowerShell commands are objects. When working with FS commands the outputs will (most of the time) be `Directory <https://docs.microsoft.com/en-us/dotnet/api/system.io.directory?view=netcore-3.1>`_ or `File <https://docs.microsoft.com/en-us/dotnet/api/system.io.file?view=netcore-3.1>`_ object types. We will discuss working with objects later in this walkthrough.

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

- unofficial but recognized by microsoft
   - MS docs link?
   - must be installed

Install Chocolatey
^^^^^^^^^^^^^^^^^^

- install and set up choco
   - no sudo, must open as admin
   - https://chocolatey.org/install

.. Need Package Choco?!

Install a package
^^^^^^^^^^^^^^^^^

- prompt options (-Force?)

Upgrade a package
^^^^^^^^^^^^^^^^^

- choco upgrade <package> all
note
- adding sources https://chocolatey.org/docs/commands-sources

Course Tools Installation
-------------------------

- dotnet
   - should have
   - if not: dotnetcore-sdk
- git
   - choco

Objects
=======

- everything is an object

Properties & Methods
--------------------

- dot notation access

Access a property
^^^^^^^^^^^^^^^^^

Call a method
^^^^^^^^^^^^^

Grouping Expression Operator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Chaining Methods & Properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Properties
----------

Methods
-------

- .GetType()

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











