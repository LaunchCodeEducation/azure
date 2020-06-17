==================
Shell Fundamentals
==================

Working with Shells like PowerShell and BASH revolves around interactive REPL usage and scripting. We will begin by learning about individual commands that are entered one at a time in the Terminal. Then we will discuss how multiple commands can be composed into automated scripts. This lesson is an overview of Shell usage as a whole. In the following lessons we will explore the Shell-specific syntax used by BASH and PowerShell.

The File System
===============

The most fundamental aspect of working with a Shell is the **file system**. Up until now you likely know the files of your machine through a File Explorer program. These programs expose the file system in a GUI with folders and files. Navigating through the file system of a machine is a process of clicking around to reach and interact with a file or folder.

In the Shell the file system is accessible in a much more direct and concise way. The way a file system is organized is based on the OS design but all of them share the concepts of **directories** (folders) and **files**. We describe the location of files and directories based on their **path**. 

Paths
-----

Imagine a stranger at the street corner you are walking on asks for directions. How would you begin to provide them? You need a **reference point** to start from. In that context you would give directions *relative to* the corner you are both on. We can see that giving directions must be based on a reference, or starting, point. 

A path is like the directions of how to reach a location in the file system. It can be described in two ways:

- **relative path**: the directions relative to the *current directory*  you are in as a starting point
- **absolute path**: the directions relative to a fixed, or *absolute*, starting point

Relative Paths
^^^^^^^^^^^^^^

When you open your File Explorer program it defaults to a *starting point* of your user **home directory**:

.. sourcecode:: bash

   # Windows file system separates directories with a '\'
   C:\Users\YourUsername

   # Linux file system separates directories with a '/'
   /home/YourUsername

We call the directory you are currently in the **current working directory (CWD)**. The CWD changes depending on which directory you navigate to, whether you do that by clicking around in the File Explorer or by *changing directories* in the Shell.

Imagine you wanted to provide directions to a file called ``notes.txt`` that you downloaded to your user's``Downloads`` directory. You could say that your CWD is the home directory. From *this particular* CWD you could describe the relative path to the file as:

.. sourcecode:: bash

   # Windows
   Downloads\notes.txt

   # Linux
   Downloads/notes.txt

While this is a convenient shorthand it does have an issue. These relative paths are **only valid relative to the CWD they were referenced from**. What would happen if your CWD was your ``Pictures`` directory instead of your home directory. Your directions would no longer make any sense because there is no ``Downloads`` directory inside of ``Pictures``. 

The relative path would be like providing directions to the stranger relative to a corner on the other side of town. Not of much use! We need a more *absolute* way of describing paths that can provide directions independent of the CWD. 

Absolute Paths
^^^^^^^^^^^^^^

Absolute paths are based on a fixed starting point, called the **root directory**, instead of the CWD. They allow you to describe paths that remain valid no matter what CWD you are in.

On Linux machines the root directory is simply ``/``. Whereas on Windows machines the root directory (in most cases) is the C drive, ``C:``. Within each of these root directories exists the rest of the file system made up of sub-directories, sub-sub-directories and so on.

.. admonition:: tip

   An absolute path is just a relative path from a constant starting point instead of the variable CWD.

Let's consider how we could describe the ``notes.txt`` location using an absolute path this time. We begin with the fixed starting point of the root directory. From the root as a reference we provide the relative directions through all the directories that lead to the ``notes.txt`` file location:

.. sourcecode:: bash

   # Windows
   C:\Users\YourUsername\Downloads\notes.txt

   # Linux
   /home/YourUsername/Downloads/notes.txt

Absolute paths are verbose but precise. They may take longer to write out but they offer a *guaranteed* path that will work no matter the CWD you start from. Most of the time you will use relative paths when using the Shell as a human. But when you get into automating tasks with scripts the consistent nature of absolute paths becomes invaluable.

Basic Navigation
----------------

In the File Explorer program you used sidebars and your mouse to navigate through directories. In the Shell we use a concept called **changing directories** to change our CWD from one location to another. There are three important commands to learn when navigating the file system. We will show their basic usage here before learning more details about Shell commands:

- ``pwd``: print the CWD to see where you are currently
- ``ls``: list the contents of a directory
- ``cd``: change directories

.. admonition:: note

   These commands originated in BASH but were included in PowerShell as aliases (like a nick-name) for their native PowerShell cmdlet names.

When you enter the ``pwd`` command into your Terminal it will print the absolute path of your CWD. Just like the File Explorer the Shell will by default open to your home directory:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > pwd
   # C:\Users\YourUsername

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   # /home/YourUsername

If you wanted to view the contents of the CWD you can use the ``ls`` command:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ls
   # contents of home directory

.. sourcecode:: bash
   :caption: Linux/BASH

   $ ls
   # contents of home directory 

Finally you can use ``cd`` to change directories. Say you wanted to go from your home directory to the ``Downloads`` directory like our previous example. You can provide the relative path to the ``cd`` command to get there:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > cd Downloads
   > pwd
   # C:\Users\YourUsername\Downloads

.. sourcecode:: bash
   :caption: Linux/BASH

   $ cd Downloads
   $ pwd
   # /home/YourUsername/Downloads 

You can also provide the absolute path if you were starting from a different CWD and didn't know the relative path:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > cd C:\Users\YourUsername\Downloads
   > pwd
   # C:\Users\YourUsername\Downloads

.. sourcecode:: bash
   :caption: Linux/BASH

   $ cd /home/YourUsername/Downloads 
   $ pwd
   # /home/YourUsername/Downloads

File System Operations
------------------------

Remember that the Shell CLI can do anything a GUI offers and more. There are many other commands available for interacting with the file system like you have grown accustomed to in a File Explorer. We will cover all of the file system operations in the BASH and PowerShell syntax lessons. As a preview, these commands include creating, reading, moving, copying and deleting files and directories.  

Commands
========

When using the Shell REPL in a Terminal the first step is to type a **command** into the prompt. After hitting the ``enter`` key the REPL process of Reading, Evaluating, and Printing begins. Commands are Evaluated by executing a CLI program that either comes included with the Shell or is installed later.

Calling Commands
----------------

Shell commands are similar to functions. They have a name, input arguments and a behavior they perform. But unlike functions their behavior can be range from a simple text output to direct control over the OS or other programs. Calling, or executing, a command begins with the name of a **program** (function) followed by **parameters** and **options** (arguments).

.. admonition:: note

   We will use the terms **command**, **program** and **command program** interchangeably in the context of working with a Shell.

BASH Builtins
--------------

Earlier you saw examples of 

PowerShell Cmdlets
------------------

Getting Help
------------

- bash ``help`` and ``man``
- posh ``Get-Help`` ``Update-Help`` or (cmdlet only) ``<cmdlet> -?``

CLI Tools
=========

General CLI Tool Usage
----------------------

- program arguments options option-arguments
- use git examples for something they can relate to
- use dotnet examples for preview of what they will see the next day

Package Managers
----------------

- manage downloading, installing/building and configuring tools for easy updates and cleanup relative to manual approach
- ubuntu: apt
- windows: chocolatey

Cross-Platform Tools
--------------------

- tools used in this course
   - dotnet
   - az
   - git
   - mysql

Environment Variables
=====================

System Variables
----------------

- shell profile files
- affects all Shell sessions

The PATH
--------

- where to look and in what order to look for CLI programs
- draw parallel with .exe applications. show screenshot of where they are installed and called from
- tip: when "command not found" check PATH
- how to view and set the PATH explained more detail in individual Shell lessons


The big difference between the functions you are familiar with and commands in a Shell is how they are referenced. Instead of a being able to reference a function defined in your source code, command programs are **executable** files that are installed on your machine. Commands programs exist in standard locations depending on the OS and Shell(built-in commands), or customized by the user during installation. 

Because commands can be installed in different locations in your machine the Shell needs to know where to find it before it can execute it. We call this location the **file path**, or **path**, to the program file. On Linux the BASH built-in commands are installed by default at the path ``/usr/bin/<program name>``. Whereas on Windows you could find built-in PowerShell programs, called **cmdlets**, at the ``C:\Windows\System32\WindowsPowerShell\<cmdlet name>`` path.

The *unique name* of a program, like that of a function, is its full path. The full path is referred to as an **absolute path** and in some cases can be verbose. Working from the command-line is supposed to be concise and direct. It would be inefficient to have to type out the absolute path every time you want to issue a command. For this reason Shells have a mechanism for registering base paths (like ``/usr/bin/`` or ``C:\Windows\System32\WindowsPowerShell\``)

Piping
======

- feeding output of one command as the input into the next
- data pipeline for transformation
- pipe ``|`` operator

Scripting
=========

- shortcuts for automating common tasks
- automated configuration of machines
- fundamentals of programming available (vars [local], DS, loops, conditionals, functions)

