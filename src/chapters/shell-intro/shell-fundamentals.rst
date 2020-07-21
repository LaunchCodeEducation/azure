==================
Shell Fundamentals
==================

Working with Shells like PowerShell and Bash revolves around interactive REPL usage and scripting. We will begin by learning about using the REPL for issuing individual commands in the Terminal. Then we will discuss how multiple commands can be composed into automated scripts. This lesson is an overview of Shell usage as a whole. In the following lessons we will explore the Shell-specific syntax used by Bash and PowerShell.

The File System
===============

The most fundamental aspect of working with a Shell is the **file system**. Up until now you likely know the files of your machine through a File Explorer program. These programs expose the file system in a GUI with folders and files. Navigating through the file system of a machine is a process of clicking around to reach and interact with a file or folder.

In the Shell the file system is accessible in a much more direct manner. The way a file system is organized is based on the OS design but all of them share the concept of a tree-like hierarchy made up of **directories** (folders) and **files**. In the Shell we can describe the directions to the location of files and directories through text rather than graphics. 

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

   These commands originated in Bash but were included in PowerShell as aliases (like a nick-name) for their native PowerShell cmdlet names. We will explore what cmdlets are later, but you should be able to understand them based on how declarative their names are:

   - ``pwd``: alias for ``Get-Location`` cmdlet
   - ``ls``: alias for ``Get-ChildItem`` cmdlet
   - ``cd``: alias for ``Set-Location`` cmdlet

When you enter the ``pwd`` command into your Terminal it will print the absolute path of your CWD. Just like the File Explorer the Shell will open to your home directory by default:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > pwd
   C:\Users\YourUsername

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/YourUsername

If you want to view the contents of the CWD you are in you can use the ``ls`` command:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ls
   # contents of home directory

.. sourcecode:: bash
   :caption: Linux/Bash

   $ ls
   # contents of home directory 

Finally you can use ``cd`` to change directories to a new working directory which becomes the CWD. Say you wanted to go from your home directory to the ``Downloads`` directory like our previous example. You can provide the relative path to the ``cd`` command to get there:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > cd Downloads

   > pwd
   C:\Users\YourUsername\Downloads

   > ls
   notes.txt

.. sourcecode:: bash
   :caption: Linux/Bash

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
   :caption: Linux/Bash

   $ cd /home/YourUsername/Downloads

   $ pwd
   /home/YourUsername/Downloads

File System Operations
------------------------

All of the operations you have grown accustomed to using in a File Explorer are available from the command-line. We will cover creating, reading, moving, copying and deleting files and directories in the Bash and PowerShell syntax lessons. 

Commands
========

We saw a preview of how to use some fundamental file system commands. Let's break down how commands work in more detail. When using the Shell REPL in a Terminal the first step is to type a **command** into the prompt. After hitting the ``enter`` key the REPL process of Reading, Evaluating, and Printing begins. Commands are Evaluated by executing a CLI program that either comes included with the Shell or is installed later.

Calling Commands
----------------

Shell commands are similar to functions. They have a name, input arguments and behavior they perform. But unlike functions their behavior can range from a simple text output to direct control over the OS, file system or even other programs.

Calling, or executing, a command begins with the name of a CLI **program** followed by **positional arguments** and **options** (modifiers) used by the program.

.. admonition:: note

   In general terms executing a command looks like this:

   .. sourcecode:: bash
      :caption: Linux/Bash

      $ program <argument(s)> [--option]

   In command documentation required parameters are listed inside of ``<>`` symbols while optional parameters are shown inside of ``[]`` symbols. The term parameter here is used to describe arguments and options in a broader sense.


For example let's consider the ``pwd`` or ``ls`` commands we saw. Both of these only needed the program name to be called:

.. sourcecode:: bash

   $ pwd
   $ ls

   # in general terms
   $ program

Arguments
^^^^^^^^^

Arguments are positional values used to define the main behavior of a command. Like JavaScript or C# the arguments have a specific order they must be provided in. While some commands like ``pwd`` or ``ls`` have *default arguments*, most will require some additional input from you. The command documentation will describe what arguments, their order and any default values that apply to them.

Let's consider the ``cd`` command we saw that was used to change directories. This time we did provide a positional argument, the relative or absolute path to the directory we wanted to switch to:

.. sourcecode:: bash

   $ cd Downloads

   # in general terms
   $ program <argument>

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
- ``-o``: a single ``-`` dash with the first option letter ``o`` as a shorthand

The most common option you can expect across CLI programs is access to the help documentation. Traditionally this is available using either the long ``--help`` or shorthand ``-h`` option after the command name. If available, the output lists details about the command and how to use its arguments and options.

Some options can have their own arguments. For example you will soon begin using the ``dotnet CLI`` tool to manage your .NET projects from the Terminal. Without having seen the following command before you may be able to understand what it is doing based on its arguments and options:

.. sourcecode:: bash

   $ dotnet new webapp --name MyApp

If you are stumped don't worry. While this may look complex it can be broken down methodically:

- **program**: ``dotnet``
- **first argument**: ``new`` (the argument for creating new projects)
- **second argument**: ``webapp`` (a sub-argument of ``new`` for defining what type of project to create)
- **option**: ``--name`` (option to define the name of the new project)
- **option argument**: ``MyApp`` (the value for the ``name`` option)

Here is another view to see how everything aligns:

.. sourcecode:: bash

   # program [argument] [argument sub-argument] --[option] [option argument]
   $ dotnet     new            webapp             --name         MyApp

CLI Tools
=========

The built-in commands of Bash and PowerShell are like the GUI applications that come installed on your OS. They are a set of tools for the essentials of interacting with your machine. For handling more specific tasks you can install 3rd party tools -- or even write your own! While the market for GUI applications is primarily designed for consumers, the world of CLI tools is tailored for users that need greater control over their machine.

Shell programs can be installed in a variety of ways. Some developers prefer to *build from source* which involves manually assembling the dependencies and source code of a tool. While this process provides you with the greatest control and security over the programs on your machine it can be a lengthy process. 

The next alternative involves installing the pre-built **binaries** (executable files that don't need to be interpreted). This is similar to installing a desktop application from a website using a downloaded installer program. The downside of this approach is that it requires you to move the program files to the correct location for your Shell to recognize them.

Most developers turn to special tools specifically designed for downloading and managing the installation process automatically.

Package Managers
----------------

**Package managers** are the CLI equivalent of an App Store. They allow you to search for and install custom CLI programs that extend the behavior of the Shell. On Linux machines the package managers are even capable of extending the GUI Shell. While we will use Shell package managers in this class the same term applies to language-based package managers like ``npm`` (for JavaScript) and ``pip`` (for Python).

.. admonition:: note

   CLI **packages** (installed commands) can range from simple tools to more complex programs like compilers, interpreters and even full-fledged Web Servers.

Windows packages are handled by the `Chocolatey package manager <https://chocolatey.org/>`_ or ``choco`` as it is called when used in PowerShell. On OSX the `HomeBrew <https://brew.sh/>`_ (``brew``) package manager has cornered the market. In the Linux space there are many package managers that the different Linux Distributions (OS variants over the core Linux Kernel) are built around. In this class we will use the `Advanced Package Tool <https://linuxhint.com/apt_package_manager_ubuntu/>`_ (``apt``) that is the default package manager on Debian-based Distributions like Ubuntu. 

Package managers automate the entire process of downloading, installing, configuring and updating the Shell programs you use. These tools are stored in **package repositories** that host the packages on the web for searching and downloading. Package managers come with some default repository packages from trusted package maintainers that contain metadata for sourcing the hosted packages. But unlike the App Stores on your phone or PC the repositories list can be updated to add additional public or private sources. 

We will learn how to install and use these tools in the Bash and PowerShell syntax lessons. As a developer you can use them for configuring your development machines. Later we will learn how to write scripts that use package managers to set up our own Servers in the cloud!

Tools used in this class
------------------------

In this class we will spend the majority of our time working in the Terminal. In addition to getting comfortable using the Shell built-ins we will learn how to use many other tools including:

- ``dotnet``: used to create, manage and run .NET projects
- ``az``: the Azure CLI for provisioning and managing resources in the cloud
- ``git``: the version control CLI tool

The PATH
========

The big difference between the functions you are familiar with and commands in a Shell is how they are referenced. Think about how you reference functions in your projects. They can either be referenced by their name (if in the same file) or they must be imported from another file in your code.

A command can be installed anywhere in your file system rather than just your codebase. The Shell needs to know where to find it before it can execute it. In other words the Shell needs to know the absolute path to the executable file in order to use it. 

How does the Shell know where to find the executable program files when we call a command by just its program name rather than its absolute path?

Shell Environment Variables
---------------------------

All Shells share the concept of a **Shell environment**. The environment holds **environment variables** that configure aspects of the Shell's behavior. They apply to every new Shell process that is started. Many variables are set by default but others can be customized by the user.

Bash and PowerShell each handle environment variables differently. Managing the environment is outside of the scope of this class but is important to understand. Interactions with Shell environments are conceptually very similar. But because Linux and Bash are inherently simpler to understand, compared to the more modern and complex Windows and PowerShell, we will provide examples from the Bash perspective.

The HOME Variable
^^^^^^^^^^^^^^^^^

For example, consider the default behavior we discussed earlier that causes a Shell to set the CWD to the home directory when first starting up. How does the Shell know what the home directory path is? An environment variable called ``$HOME`` (Linux/Bash) or ``$Env:HOMEPATH`` (Windows/PowerShell) holds the value that the Shell uses.

By default this value will be the path to the user directory for the logged in user. You can view them using the ``echo`` (print output) command:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > echo "$Env:HOMEPATH"
   C:\Users\YourUsername

.. sourcecode:: bash
   :caption: Linux/Bash

   $ echo "$HOME"
   /home/YourUsername

The PATH Variable
^^^^^^^^^^^^^^^^^

So how do environment variables relate to calling programs by their name rather than their absolute path? There is a special variable called ``$PATH`` (Linux/Bash) or ``$Env:Path`` (Windows/PowerShell) which holds the answer. We will refer to these using the general term PATH variable.

The PATH variable holds a collection of base paths that the Shell should look in when evaluating a command. When a command is called the Shell will look in each of the base paths until it finds an executable file with the same name. Then it combines the matching base path with the command name to form the absolute path of the file to execute.

For example, in Bash the base directory that the built-in commands are stored in is ``/usr/bin``. Bash includes this base directory in its PATH variable by default. When we call the ``ls`` command it is actually referencing the executable program file at the ``/usr/bin/ls`` path. 

Let's assume a PATH variable with 4 base directories in its list (separated by ``:`` characters):

.. sourcecode:: bash

   /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

The process looks something like:

#. read the program name (``ls``)
#. recognize that it is a program name and not a path to an executable
#. check each directory in the PATH list for a file with the name of the command (``ls``)

It first checks ``/usr/local/sbin`` but is unable to find the ``ls`` program file. It then checks ``/usr/local/bin`` and ``/usr/sbin`` but still fails to find it. Finally it finds the ``ls`` file in ``/usr/bin`` directory.

The command is then executed by combining the matching base path (``/usr/bin``) with the command name (``ls``) into the absolute path ``/usr/bin/cd``. If it reaches the end of the PATH list then it will output a *command not found* error. 

.. admonition:: note

   One of the most common issues beginners face when working with a Shell is encountering a *command not found* error. Assuming the command is not misspelled, this indicates that the command's file is in a directory that is not registered in the PATH list. 

   If you are able to call the command by providing its absolute path then all you need to do is add the base path of the file to the PATH variable.

You will likely not need to update the PATH yourself unless you install CLI programs *manually* in locations that are not already on the PATH. Fortunately, package managers use a consistent installation directory and add that directory to the PATH automatically!

Piping
======

**Piping**, or **pipelining**, is the process of chaining together multiple commands by using the output of one as the input to the next. The term comes from the idea of a **data pipeline** which is used to transform or operate on data in a concise way. You can think of it as a *stream of data* flowing through a *pipe of commands* from the first to the last. 

The idea behind piping is simple but its capability is powerful. The first command in the pipeline is executed and produces an output. But rather than printing the command's output to the Terminal it is instead used as an input to the next command in the pipeline. This process repeats until reaching the end of the pipeline and outputting the final result.

We will get into the syntax of piping in the Bash and PowerShell specific lessons. In general terms piping involves 2 or more commands each separated by the ``|`` pipe character (just above the ``enter`` key on your keyboard).

.. admonition:: note

   In a general sense this is what piping between two commands looks like. The output of the first command is used as the input (argument) to the second command in the pipeline. 

   .. sourcecode:: bash
      :caption: Linux/Bash

      $ first-command | next-command <first-command output>


.. todo:: too heavy to give example. leave it light

.. Imagine you have a file where each line contains a name, a number and an email address each separated by a comma (``name,number,email``). This is called a CSV (comma-separated values) file.

.. You have been given the task of creating a new file that has the name and email for all the contacts with a ``@microsoft.com`` address. In pseudocode your steps would look like this:

.. #. print the contents of the original file
.. #. filter the addresses ending in ``@microsoft.com``
.. #. take the first value (``name``) and last value (``email``) of the CSV line
.. #. write the ``name: email`` pair into a new file

.. Your pipeline would then look like this:

.. #. start: print command -> output contents
.. #. input contents -> filter command -> output filtered contents
.. #. input filtered contents -> extract valu

Scripting
=========

Scripting is the end goal of working with Shells. In simple terms it is the process of composing multiple commands together in a single file to complete a larger task. Instead of entering the commands individually the script file can be executed to automate the behavior.

Script files can be written in many scripting languages like Python and JavaScript. However, these scripting languages require an interpreter program and runtime that must be installed on the machine executing the script. 

The benefit of writing scripts in a native Shell like Bash or PowerShell is that they come pre-installed as the default Shells for many Linux Distributions and Windows. Learning how to create and use scripts is an integral part of working in operations. We will cover how to read, write and execute Bash and PowerShell scripts in later lessons. 

