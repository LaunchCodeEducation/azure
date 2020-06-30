============================
Working With the File System
============================

PowerShell brought over many of the essential Bash File System (FS) commands and behaviors. While several of the Bash commands are available in PowerShell they are incompatible with Windows and were brought over as **aliases**. 

An alias is like a nickname for a command. The Bash FS commands, like ``pwd`` or ``cd``, are aliases for underlying PowerShell FS cmdlets, like ``Get-Location`` and ``Set-Location``.

Because these aliases are not *the real Bash command* not all of their parameters are the same in PowerShell. Let's explore the underlying cmdlets and the common arguments used with them.

.. admonition:: note

   Some of the navigation shorthands from Bash have changed:

   - ``~``: shorthand for the home directory still works
   - ``-``: shorthand for returning to the *previous* working directory **does not**
   
   The *this directory* and *up directory* characters are the same but use the Windows path separator of a back-slash (``\``):

   - ``.``: *this directory* shorthand
   - ``.\``: relative to *this directory* shorthand
   - ``..\``: *up directory* level shorthand

Get the CWD
===========

In PowerShell you can either use the Bash alias:

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
================

The Bash command ``cd`` can still be used with an absolute or relative path:

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
=======================

In Bash we used the ``ls`` command with or without a path to list the contents of a directory:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ls
   # contents of CWD

   > ls relative\path
   # contents of dir at relative path to CWD

   > ls C:\absolute\path
   # contents of dir from absolute path

The ``Get-ChildItem`` cmdlet also uses an absolute or relative path of a directory to list the contents of:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-ChildItem
   # contents of CWD

   > Get-ChildItem -Path relative\path
   # contents of dir at relative path to CWD

   > Get-ChildItem -Path C:\absolute\path
   # contents of dir from absolute path

Move a directory or file
========================

The ``mv`` command can be used in Bash or PowerShell with an absolute or relative path for either of its arguments:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > mv path\to\target C:\absolute\path\to\destination

The PowerShell cmdlet behind ``mv`` is the more declaratively named``Move-Item``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Move-Item path\to\target C:\absolute\path\to\destination

Copy a directory or file
========================

In PowerShell copying an Item can be done using the Bash ``cp``. Recall that we used the ``-r`` (recursive) option when copying a directory with its contents. Whereas for a file we could just use ``cp`` directly:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # copy a directory recursively
   > cp -r path\to\target path\to\destination

   # copy a file
   > cp path\to\target\file path\to\destination\file

Its cmdlet equivalent ``Copy-Item`` can also be used for files or directories. When copying a directory the ``-Recurse`` option can be used like the Bash ``-r``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # copy a directory recursively
   > Copy-Item -Recurse path\to\target path\to\destination

   # copy a file
   > Copy-Item path\to\target\file path\to\destination\file

Delete a directory or file
==========================

.. admonition:: warning

   Be **very careful** when removing (deleting) items in PowerShell. Always use the interactive mode (``-Confirm`` option) to confirm each deletion!

Previously we used the Bash ``rm`` command with the ``-i`` (interactive) option to remove files and directories. Just like ``cp`` we added the ``-r`` (recursive) option when deleting a directory and its contents. 

However, in PowerShell these options can not be used. Instead we will use the PowerShell ``Remove-Item`` cmdlet with the following options:

- ``-Confirm``: confirm each item before being deleted (like ``-i`` interactive mode in Bash)
- ``-Recurse``: when removing a directory and its contents recursively

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # delete a directory and contents recursively
   > Remove-Item -Confirm -Recurse path\to\dir-name

   # delete a file item
   > Remove-Item -Confirm path\to\file-name.ext

Create a directory or file
==========================

In Bash we used the ``mkdir`` command to create new directories. This alias is still available in PowerShell but its underlying cmdlet is much more powerful:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > mkdir relative\path

   > mkdir C:\absolute\path

Recall that in Bash we used a side-effect of the ``touch`` command to create a new file. The ``touch`` alias **does not exist** in PowerShell.

Instead of using a side-effect, PowerShell has a dedicated cmdlet for creating **Items** of any type -- such as a file or directory.

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

   For creating the contents of files that are more than a single line take a look at this `here-string tutorial article <https://riptutorial.com/powershell/example/20569/here-string>`_.

Reading file contents
=====================

In Bash we learned about the ``cat`` (concatenate) command. We used the side-effect of ``cat`` to print the contents of a file to the Terminal. We *can* use ``cat`` in PowerShell as well:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > cat relative\path\to\file

   > cat C:\absolute\path\to\file

The PowerShell equivalent to ``cat`` is ``Get-Content``. Notice how declarative the naming is -- you are *getting* the *contents* of the *file*:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Content relative\path
   # contents of file at relative path to CWD

   > Get-Content C:\absolute\path
   # contents of file from absolute path

The ``Get-Content`` cmdlet will output an object based on the content in the file. Most of the time this will be a single ``String`` object for each line in the file. 

.. admonition:: note

   The ``Get-Content`` cmdlet has a number of options that can be used to get certain lines of a file's contents or even filter the output. You can read more about the options `in this documentation article <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content?view=powershell-7>`_ 

