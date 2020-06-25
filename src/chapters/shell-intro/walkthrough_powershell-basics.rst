=====================================
Walkthrough: Hands-On With PowerShell
=====================================

By now you have experienced that after learning a programming language it is easier to learn others. The same is true for Shell languages but with the added overhead of a new mental model for working from the command-line. Now that you have learned some fundamental Shell and BASH syntax you are ready to learn about PowerShell. Because many PowerShell features and behaviors were inspired by BASH you will find that much of the knowledge you gained will be applicable to this new material.

Working with PowerShell
=======================

Although BASH and PowerShell share many similarities there are some key distinctions between them. Just as before we will establish the core aspects of PowerShell and Windows to help rationalize the *why* behind their behavior. 

Core Tenets
-----------

File System Paths
^^^^^^^^^^^^^^^^^

Windows treats each of its **drives** (devices managed by the OS) as independent file system trees. Each drive has a name and ends with a ``:`` character, like ``C:`` or ``D:``. The ``C:`` drive is your disk drive and serves as the default installation location of the Windows OS. For this reason the ``C:`` drive is typically considered the root directory.

- paths are separated by back-slashes (``\``)
- the ``C:\`` directory is used as the root directory for absolute paths 

Framework Interpretation
^^^^^^^^^^^^^^^^^^^^^^^^

The .NET framework is used to interpret and translate PowerShell commands for the OS instead of the direct communication channel seen between BASH and Linux. The object-oriented *power* of PowerShell comes from this layer of abstraction between itself and the Windows OS. 

Everything is an object
^^^^^^^^^^^^^^^^^^^^^^^

Since Windows NT the Windows OS releases have all followed an object-oriented design. By extension, PowerShell treats all of its **inputs and outputs as distinct types of objects**. This departure from the string-based approach of BASH makes working with PowerShell a more *tangible* Shell experience. While PowerShell is still a CLI 

PowerShell commands and scripts are able to work with a wide range of objects from those provided by the underlying .NET framework to custom-developed types. Like other object-oriented languages PowerShell objects contain properties and methods that make them intuitive to work with.

File extensions matter
^^^^^^^^^^^^^^^^^^^^^^

File extensions are an integral aspect of how Windows works. There are thousands of file extensions built into the Windows OS but `there are only 10 common types <https://support.microsoft.com/en-us/help/4479981/windows-10-common-file-name-extensions>`_ that you will typically encounter. Every file is bound to one of these extensions that enforces what program will be used to interpret it. 

You can think of a file in Windows like an object whose type is specified by its file extension. This file type, like an object type, defines the properties and methods used by programs that interact with it.

Cmdlets, Functions & Modules
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In PowerShell the commands you use are categorized as either a **cmdlet** or a **function**. Cmdlets are written in C#/.NET and as such must be compiled before they can be used. Functions on the other hand are written in PowerShell itself within a script file. 

**Modules** are collections of cmdlets and functions that share a common theme of use. They are used to bundle together related functionality into a single package that can be shared.   

File System
===========

- describe aliases
- cover cmdlet analogs

diffs
- ~ and - for quick nav?
- ..\ and .?
- creating files (notepad?)
- viewing files (less, cat?)

Getting Help
------------

- --help
- man equiv
- updating help docs

CLI Tools
=========

Package Manager
---------------

- no sudo, must open as admin
- adding sources https://chocolatey.org/docs/commands-sources

Course Tools Installation
-------------------------

- dotnet
- az
- git

Piping
======

- much more time in this section

show
- convert to / from json
- convert between common DTs
- grep equiv
- sed / awk equiv

Scripting
=========

diffs
- implicit vs explicit? (is it all implicit because of file exts?)
- file extension differences (ps, ps1, psm etc)
- environment variables as a dict
- variable scoping 
- do we need to set path at all?

show
- piping examples
- functions
- variables

out of scope (get links)
- interacting with C# / .NET objects
- writing cmdlets
- writing manifests
- custom objs











