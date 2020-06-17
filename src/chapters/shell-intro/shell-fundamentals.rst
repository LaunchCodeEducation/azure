==================
Shell Fundamentals
==================

Working with Shells like PowerShell and BASH revolves around interactive REPL usage and scripting. We will begin by learning about using the REPL for issuing individual commands in Terminal. Then we will discuss how multiple commands can be composed into automated scripts. This lesson is an overview of Shell usage as a whole. In the following lessons we will explore the Shell-specific syntax used by BASH and PowerShell.

The File System
===============

The most fundamental aspect of working with a Shell is the **file system**. Up until now you likely know the files of your machine through a File Explorer program. These programs expose the file system in a GUI with folders and files. Navigating through the file system of a machine is a process of clicking around to reach and interact with a file or folder.

In the Shell the file system is accessible in a much more direct manner. The way a file system is organized is based on the OS design but all of them share the concepts of **directories** (folders) and **files**. In the Shell we can describe the directions to the location of files and directories through text rather than graphics. 

Paths
-----

Imagine a stranger at the street corner you are walking on asks for directions. How would you begin to provide them? You need a **reference point** to start from. It would make the most sense to give the directions *relative to* the corner you are both on. Without a reference, or starting point, it is not possible to provide useful directions.

A **path** is how we describe the directions to a location in the file system using the Shell. There are two types of paths:

- **relative path**: the directions *relative to the current directory* as a starting point
- **absolute path**: the directions from a fixed, or *absolute*, starting point

Relative Paths
^^^^^^^^^^^^^^

When you open your File Explorer program it defaults to a *starting point* of your user **home directory**. The same is true when you open your Shell in the Terminal. The home directory can be described by the following paths:

.. sourcecode:: powershell

   # Windows file system separates directories with a '\'
   C:\Users\YourUsername

   # Linux file system separates directories with a '/'
   /home/YourUsername

We call the directory you are currently in the **current working directory (CWD)**. The CWD changes depending on which directory you navigate to, whether you do that by clicking around in the File Explorer or by *changing directories* in the Shell.

Imagine you wanted to provide directions to a file called ``notes.txt`` that you downloaded to your user's ``Downloads`` directory. If you have just opened your Terminal then your CWD is the home directory. From *this particular* CWD you could describe the relative path to the file as:

.. sourcecode:: powershell

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

   An absolute path is just a relative path from a **constant starting point** instead of a variable CWD.

Let's consider how we could describe the ``notes.txt`` location using an absolute path this time. We begin with the fixed starting point of the root directory. From the root as a reference we provide the relative directions through all the directories that lead to the ``notes.txt`` file location:

.. sourcecode:: powershell

   # Windows
   C:\Users\YourUsername\Downloads\notes.txt

   # Linux
   /home/YourUsername/Downloads/notes.txt

Absolute paths are verbose but precise. They may take longer to write out but they offer a *guaranteed* path that will work no matter the CWD you start from. Most of the time you will use relative paths when using the Shell as a human. But when you get into automating tasks with scripts the consistent nature of absolute paths becomes invaluable.

Basic Navigation
----------------

In the File Explorer program you used sidebars and your mouse to navigate through directories. In the Shell we use a concept called **changing directories** to change our CWD from one location to another. There are three fundamental commands needed to navigate the file system from a Shell. We will show their basic usage here before digging into Shell commands in greater detail:

- ``pwd``: print the CWD to see where you are currently
- ``ls``: list the contents of a directory
- ``cd``: change directories

.. admonition:: note

   These commands originated in BASH but were included in PowerShell as aliases (like a nick-name) for their native PowerShell cmdlet names. We will explore what cmdlets are later, but you should be able to understand them based on how declarative their names are:

   - ``pwd``: alias for ``Get-Location`` cmdlet
   - ``ls``: alias for ``Get-ChildItem`` cmdlet
   - ``cd``: alias for ``Set-Location`` cmdlet

When you enter the ``pwd`` command into your Terminal it will print the absolute path of your CWD. Just like the File Explorer the Shell will open to your home directory by default:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > pwd
   C:\Users\YourUsername

.. sourcecode:: bash
   :caption: Linux/BASH

   $ pwd
   /home/YourUsername

If you want to view the contents of the CWD you are in you can use the ``ls`` command:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ls
   # contents of home directory

.. sourcecode:: bash
   :caption: Linux/BASH

   $ ls
   # contents of home directory 

Finally you can use ``cd`` to change directories to a new CWD. Say you wanted to go from your home directory to the ``Downloads`` directory like our previous example. You can provide the relative path to the ``cd`` command to get there:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > cd Downloads

   > pwd
   C:\Users\YourUsername\Downloads

   > ls
   notes.txt

.. sourcecode:: bash
   :caption: Linux/BASH

   $ cd Downloads

   $ pwd
   /home/YourUsername/Downloads 
  
   $ ls
   notes.txt

You can also provide the absolute path to reach the directory from any CWD:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > cd C:\Users\YourUsername\Downloads

   > pwd
   C:\Users\YourUsername\Downloads

.. sourcecode:: bash
   :caption: Linux/BASH

   $ cd /home/YourUsername/Downloads

   $ pwd
   /home/YourUsername/Downloads

File System Operations
------------------------

Remember that the Shell can do everything the GUI of an OS offers and more. There are many other commands available for interacting with the file system just like those you have grown accustomed to using in a File Explorer. We will cover creating, reading, moving, copying and deleting files and directories in the BASH and PowerShell syntax lessons.  

Commands
========

We saw a preview of how to use some fundamental file system commands. Let's break down how commands work in more detail. When using the Shell REPL in a Terminal the first step is to type a **command** into the prompt. After hitting the ``enter`` key the REPL process of Reading, Evaluating, and Printing begins. Commands are Evaluated by executing a CLI program that either comes included with the Shell or is installed later.

Calling Commands
----------------

Shell commands are similar to functions. They have a name, input arguments and behavior they perform. But unlike functions their behavior can be range from a simple text output to direct control over the OS, file system or even other programs.

Calling, or executing, a command begins with the name of a CLI **program** followed by **positional arguments** and **options** (modifiers) used by the program. 

For example let's consider the ``pwd`` or ``ls`` commands we saw. Both of these only needed their name to be called:

.. sourcecode:: bash

   $ pwd
   $ ls

   # in general terms
   $ program

Arguments
^^^^^^^^^

What about the ``cd`` command to change directories? This time we did provide a positional argument, the relative or absolute path to the directory we wanted to switch to:

.. sourcecode:: bash

   $ cd Downloads

   # in general terms
   $ program [Argument]

We saw that the ``ls`` command, when called without arguments, will default to listing the contents of the CWD. But if we provide it with a path as an argument we can list the contents of a different directory:

.. sourcecode:: bash

   # a relative path
   $ ls Downloads
   notes.txt

   # an absolute path
   $ ls /home/YourUsername/Downloads
   notes.txt

Options
^^^^^^^

Options allow you to fine-tune the behavior of a command. While it is not enforced in third party CLI programs, the convention for using options is:

- ``--option``: a double ``--`` dash with the full name of the option
- ``-x``: a single ``-`` dash with a single ``x`` letter as a shorthand

The most common option you can expect across CLI programs is access to the help documentation. Traditionally this is available using either the long ``--help`` or shorthand ``-h`` option after the command name. The output from using this option should list details about the command and how to use its arguments and options.

Some options can have their own arguments. For example you will soon begin using the ``dotnet`` CLI tool to manage your .NET projects. Without having seen the following command before you may be able to understand what it is doing based on its arguments and options:

.. sourcecode:: bash

   $ dotnet new webapp --name MyApp --output /home/YourUsername/projects/MyApp

If you are stumped don't worry. While this looks complex it can be broken down methodically to make sense of it:

- **program**: ``dotnet``
- **first argument**: ``new`` (the argument for creating new projects)
- **second argument**: ``webapp`` (a sub-argument for defining what type of project to create)
- **first option**: ``--name`` (option to define the name of the new project)
- **first option argument**: ``MyApp`` (the value for the name option)
- **second option**: ``--output`` (option to define the path where the project files should be created)
- **second option argument**: ``/home/YourUsername/projects/MyApp`` (the path value for the output option)

Here is another view to see how everything aligns:

.. sourcecode:: bash

   # program [argument 1] [argument 1 sub-argument] --[option 1] [option 1 argument] --[option 2] [option 2 argument]
   $ dotnet new webapp --name MyApp --output /home/YourUsername/projects/MyApp
   

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

