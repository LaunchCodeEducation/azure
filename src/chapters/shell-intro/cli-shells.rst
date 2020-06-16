==========================
Introduction to CLI Shells
==========================

What is a Shell?
================

Computers are made up of hardware and layers of software designed to interact with it. It isn't practical for a human to control the electrical signals needed to operate the hardware. Instead, we use these software layers to translate actions that a human understands into signal instructions the hardware understands. 

Every software layer above the hardware is an abstraction to make working with it more natural to humans. An **Operating System** (OS) is the main layer of software used for a human to interact with a computer. At the center of the OS is a **Kernel** which translates user commands into the lowest-level machine instructions for the hardware to perform the requested tasks.

Around the OS is another layer of software known as the **Shell**. We broadly refer to these Shell programs as **User Interfaces** (UI) because they are used as an *interface* for a *user* of a computer. Shells are what humans actually interact with to make the computer perform tasks for them.

A Shell is responsible for translating high-level user inputs into commands for the OS. The OS then translates them further away from human-understandable instructions for the Kernel. Finally the Kernel translates them to machine code that drive the lowest-level electrical signal instructions understood by the hardware.

GUI Shells
----------

The type of Shell you are most familiar with is a **GUI Shell**. A Graphical User Interface (GUI) is an interface for humans that consists of graphical components like windows and buttons. The GUI Shell is what most people refer to when talking about the differences between OS choices.

In a GUI Shell commands are issued from the user to the computer using a mouse and keyboard. These days it is natural for us to use a mouse pointer to navigate and interact with the computer. GUI Shells, or **window managers** as they are referred to in the Linux world, have become the natural standard for *consumer interactions* with computers.

GUI Shells are *not a requirement* for an OS to be used by a human. Their visual abstraction is more intuitive than the text-based alternative. But this abstraction comes at a tradeoff of more direct control over the machine.

CLI Shells
----------

Before computers reached the consumer market they were used by engineers and developers. At that time the idea of the modern mouse-based GUI was years away. Instead, they used a text-based Shell. A simple GUI called a **Terminal** was used to enter commands as text using just a keyboard. The term **Command Line Interface** (CLI) Shell was used to describe this mechanism of entering commands into the computer one line at a time. 

Because humans want simpler and *tangible* ways of interacting with their computers the GUI Shell became the standard interface for the consumer. But the abstraction that makes them simple to use comes at a cost of complexity to create. Every window, button and icon as well as the actions they correspond to need to be developed before someone can use them.

The time it takes to develop a GUI element restricts them to only being written for tasks the common user would need. There are thousands of features that are simply not accessible 
via GUI because the average user won't need to access them. 

For computer users who require greater control over the OS the CLI Shell is king. For this reason CLI Shells are still widely used but by more technically savvy users like developers.

Shell Command Languages
========================

In the context software development the term Shell is used as a shorthand for CLI Shells. From this point forward we will refer to CLI Shells as just Shells. 

Shells use **Command Languages** to interpret text-based commands at runtime. Command Languages are interpreted like other scripting languages. They share the same need for dynamic execution rather than pre-compiled instructions. While Command Languages are similar to scripting languages such as JavaScript or Python they are specialized for sending commands directly to the OS. 

These days there are hundreds languages available for use as a Shell. But the two most popular Shells used in modern development are **BASH** (Linux) and **PowerShell** (Windows).

BASH
----

BASH is an acronym for the **B**\ourne **A**\gain **SH**\ell language. It was the successor of the Bourne Shell (``sh``) that it was extended from. On Linux machines BASH is used as the **Login Shell** for most distributions. A Login Shell is the default Shell that is started when the machine boots up its OS. Using BASH developers can interact with nearly every aspect of the machine. 

Because BASH is designed to integrate with the GNU/Linux OS it follows the Linux *everything is a file* `design pattern <https://opensource.com/life/15/9/everything-is-a-file>`_. In the same vein of design the BASH built-in and extended tools do not have a concept of different data types like ``string``, ``number`` and ``boolean``. 

Instead, **all inputs and outputs are treated as strings of characters**. While this can seem foreign at times, especially when coming from other languages, it is an integral aspect of its flexibility. This design is one of the most fundamental differences between BASH and PowerShell.

PowerShell
----------

PowerShell is a more recent development in the Microsoft ecosystem. 

Terminal Emulators
===================

I/O Streams
-----------

STDIN
^^^^^

STDOUT
^^^^^^

STDERR
^^^^^^

Shell REPL
----------

Gnome Terminal
--------------

PowerShell Terminal
--------------------

Shell Fundamentals
==================

Commands
--------

CLI Tools
---------

File System navigation
----------------------

Piping
------

Scripting
---------
