==========================
Introduction to CLI Shells
==========================

What is a shell?
================

Computers are made up of hardware and software designed to interact with it. It isn't practical for a human to control the electrical signals needed to operate the hardware. Instead, we use software to translate actions that a human understands into signal instructions the hardware understands. 

Every software layer above the hardware is an abstraction to make working with it more natural to humans. An Operating System (OS) is the main layer of software used for a human to interact with a computer. At the center of the OS is a **Kernel** which translates user commands into the lowest-level machine instructions for the hardware to perform the requested tasks.

Around the OS is another layer of software known as the **Shell**. We broadly refer to these Shell programs as **User Interfaces** (UI) because they are used as an *interface* for a *user* of a computer. Shells are what humans actually interact with to make the computer perform tasks for them.

A Shell is responsible for translating high-level user inputs into commands for the OS. The OS then translates them further away from human-understandable instructions for the Kernel. Finally the Kernel translates them to the lowest-level electrical signal instructions understood by the hardware.

GUI Shells
----------

The first type of Shell you are most familiar with is a **GUI Shell**. A Graphical User Interface (GUI) is an interface for humans that consists of graphical components like windows and buttons. The GUI Shell is what most people refer to when talking about the differences between OS choices.

In a GUI Shell commands are issued to the computer using a mouse and keyboard. It is natural for us to use a mouse pointer to navigate and interact with the computer. But GUI Shells are *not a requirement* for an OS to be used by a human. They just happen to be a convenient standard for most people to use when compared to text-based interfaces.

CLI Shells
----------

Before the advent of modern GUIs and mouse pointers computers used a text-based Shell. A simple GUI called a **Terminal** was used to enter commands as text using just a keyboard. The term Command Line Interface (CLI) was used to describe this mechanism of entering commands into the computer one line at a time. 

Because humans want simpler and *tangible* ways of interacting with their computers the GUI Shell became the standard interface for the average person. But the abstraction that makes them simple to use comes at a cost of complexity to create. Every window, button and icon as well as the actions they correspond to need to be developed before someone can use them.

The time it takes to develop a GUI element restricts them to only being written for tasks the common user would need. There are thousands of features that are simply not accessible via GUI because the average user won't need to access them. For this reason CLI Shells are still widely used but by more technically savvy users like developers.

Shell Languages
===============

BASH
----

PowerShell
----------

Terminal Emulators
===================

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
