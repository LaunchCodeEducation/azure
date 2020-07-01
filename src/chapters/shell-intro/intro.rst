==========================
Introduction to CLI Shells
==========================

What is a Shell?
================

Computers are made up of hardware and layers of software designed to interact with it. It isn't practical for a human to control the electrical signals needed to operate the hardware. Instead, we use these software layers to translate actions that a human understands into signal instructions the hardware understands. 

Every software layer above the hardware is an abstraction to make working with it more natural to humans. An **Operating System** (OS) is the main layer of software used for a human to interact with a computer. At the center of the OS is a **Kernel** which translates user commands into the lowest-level machine instructions for the hardware to compute.

Around the OS is another layer of software known as the **Shell**. We broadly refer to these Shell programs as **User Interfaces** (UI) because they are used as an *interface* for a *user* of a computer. Shells are what humans actually interact with to make the computer perform tasks for them. 

A Shell is responsible for translating high-level user inputs into commands for the OS. The OS then translates them further away from human-understandable instructions for the Kernel. Finally the Kernel translates them to machine code that drives the lowest-level electrical signal instructions understood by the hardware.

GUI Shells
----------

The type of Shell you are most familiar with is a **GUI Shell**. A Graphical User Interface (GUI) is an interface for humans that consists of graphical components like windows and buttons.

In a GUI Shell commands are issued from the user to the computer using a mouse and keyboard. GUI Shells have become the natural standard for *consumer interactions* with computers.

.. admonition:: fun fact

   In the Linux world GUI Shells are called **window managers** or **desktop environments**.

GUI Shells are *not a requirement* for an OS to be used by a human. Their visual abstraction is more intuitive than the text-based alternative. But this abstraction comes at a tradeoff of more direct control over the machine.

CLI Shells
----------

Before computers reached the consumer market they were used by engineers and early developers. At that time the idea of the modern mouse-based GUI was years away. Instead, they used a text-based Shell. A rudimentary GUI called a **Terminal** was used to enter commands as text using just a keyboard. The term **Command Line Interface** (CLI) Shell was used to describe this mechanism of entering commands into the computer one line at a time. 

Because consumers want simpler and *tangible* ways of interacting with their computers the GUI Shell became the standard interface for them. But the abstraction that makes them simple to use comes at a cost of complexity to create. Every window, button and icon as well as the actions they correspond to need to be developed before someone can use them.

The time it takes to develop a GUI element restricts them to only being written for tasks the common user would need. There are thousands of features that are simply not accessible via GUI because the average user won't need to access them. 

For computer users who require greater control over the OS the CLI Shell is unmatched. For this reason CLI Shells are still widely used by more technically savvy users like developers.

Shell Command Languages
========================

In the context of software development the term Shell is used as a shorthand for CLI Shells. From this point forward we will refer to CLI Shells as just Shells. 

Shells use **Command Languages** to interpret text-based commands at runtime. Command Languages are interpreted like other scripting languages. They share the same need for dynamic execution rather than pre-compiled instructions. While Command Languages are similar to scripting languages such as JavaScript or Python they are specialized for communicating directly with the OS. 

These days there are hundreds of languages available for use as a Shell. But the two most popular Shells used in modern development are **Bash** (Linux) and **PowerShell** (Windows).

Bash
----

Bash is an acronym for the **B**\ourne **A**\gain **SH**\ell language. On Linux machines Bash is used as the **Login Shell** for most distributions. A Login Shell is the default Shell that is started when the machine boots up its OS.

Every aspect of Linux is designed around minimalism and modularity to support its open-source nature. Because Bash is designed to integrate with the Linux OS and Kernel it aligns with the Linux *everything is a file descriptor* `design <https://opensource.com/life/15/9/everything-is-a-file>`_.  Following this philosophy the Bash built-in and extended tools do not have a concept of different data types like ``string``, ``number`` and ``boolean``. 

Instead, **all inputs and outputs are treated as strings of characters**. While this can seem foreign at times, especially when coming from other languages, it is an integral aspect of its flexibility. This design is one of the most fundamental differences between Bash and PowerShell.

PowerShell
----------

PowerShell is a more recent Shell offering created by Microsoft. Whereas Bash was released over 30 years ago, PowerShell was made available in 2006. Because of its more recent development it blended many of the features of Bash with power and modern conveniences. 

However, PowerShell is more of a scripting language than a Command Language because it does not communicate directly with the OS like Bash does.PowerShell commands are interpreted by the .NET Framework which operates as an additional layer of abstraction `between the Shell commands and the OS <https://dotnet.microsoft.com/learn/dotnet/what-is-dotnet-framework#architecture>`_. 

In contrast with Linux, Windows is a more complex and object-oriented operating system. As a result the design of PowerShell is itself object-oriented and **treats all inputs and outputs as objects of distinct types**. PowerShell can access any of the .NET `class libraries <https://docs.microsoft.com/en-us/dotnet/standard/class-library-overview>`_. In addition, PowerShell allows you to extend these classes or implement your own for deeply customizable development.

Although it was originally designed just for machines running Windows, the latest release called PowerShell Core is a cross-platform tool. PowerShell Core is built on the .NET Core Framework which allows it to integrate 
with all of the modern OS choices like Windows, Linux and OSX. 

Bash vs. PowerShell
-------------------

We will not be entertaining the strict allegiance and *near-religious battles* that some developers have when discussing the choice of OS or Shell. Instead we encourage an understanding and appreciation for how each of them are designed and the areas they sometimes specialize in.

Throughout this course we will explore both Linux with Bash and Windows with PowerShell. Although PowerShell *can be used* on Linux machines and Bash *can be used* on Windows machines (through the Linux subsystem) we will defer to the default Shells for each of them depending on which machine OS we are working with.

Terminal Emulators
===================

Years ago humans interacted with computers using Terminal screens which translated keyboard input signals into commands and displayed output as plain text. Today the CLI uses programs called **Terminal Emulators** which *emulate* the behavior of the original Terminals. 

Terminal Emulators are GUI applications that are used to interact with the CLI Shell of the machine. Because they are emulated in a GUI window they allow some limited use of the mouse for things like copying, pasting and other conveniences.

.. admonition:: note

   We will refer to the Terminal Emulator programs as Terminals going forward for brevity.

Shell REPL
----------

A REPL is a **R**\ead **E**\valuate **P**\rint and **L**\oop environment for interacting with a Shell.

A REPL environment first presents a **prompt** for the user to input a command. It then **R**\eads the command that is entered. Once it has parsed the input it **E**\valuates the command to compute or perform the requested task. Any output from the command (a response from the OS or another program) is then **P**\rinted out in the Terminal. Finally, the process repeats itself by **L**\ooping back to the prompt for the next command to be entered.

When you open a Terminal application a REPL of the Login Shell will begin automatically. While we will primarily be working with the Bash and PowerShell REPLs, but they also exist for other languages like MySQL, JavaScript (NodeJS) and Python.

CLI Documentation
-----------------

CLI documentation traditionally uses the ``$`` and ``>`` characters to represent the input prompt for Bash and PowerShell respectively. Every line that begins with one of these characters **should be treated as an individual command** to be entered into the Terminal. 

Some commands will be the same in both Shells. For others we will make it clear which OS and Shell we are referring to.

Linux and Bash examples will be labeled as ``Linux/Bash`` and use the ``$`` symbol:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ command

Windows and PowerShell examples will be labeled as ``Windows/PowerShell`` and use the ``>`` symbol:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > command
