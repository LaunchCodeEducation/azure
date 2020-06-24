=====================================
Walkthrough: Hands-On With PowerShell
=====================================

After learning a programming language it is easier to learn others. The same is true for Shell languages with the addition of a new mental model of working from the command-line. Now that you have learned some fundamental Shell and BASH syntax you are ready to learn about PowerShell. Because many PowerShell features and behaviors were inspired by BASH you will find that much of the knowledge you gained can be directly applied to PowerShell.

Working with PowerShell
=======================

Although BASH and PowerShell share many similarities there are some key distinctions between them. Just as before we will establish the core aspects of PowerShell and Windows to help rationalize the *why* behind their behavior. 

Core Tenets
-----------

File System Paths
^^^^^^^^^^^^^^^^^

- C: as root
- drive mounts
- backslashes \ as path delimiters

Everything is an object
^^^^^^^^^^^^^^^^^^^^^^^

- OO OS
- data types
- PS objects (C#, built-ins, custom)

File extensions matter
^^^^^^^^^^^^^^^^^^^^^^

- thousands of file types / exts
- common windows file types https://support.microsoft.com/en-us/help/4479981/windows-10-common-file-name-extensions
- every file is bound to a registered file extension that enforces which program will interpret it
- think of files as types of objects with specific properties / methods tied to an extension

Framework Interpretation
^^^^^^^^^^^^^^^^^^^^^^^^

- review points made in fundamentals article

Cmdlets, Functions & Modules
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- file extension differences
- cmdlet: C#/.NET compiled binary (equiv /usr/bin) 
- function: PowerShell 
- module: manifest for bundling / exporting cmdlets and functions. just metadata pointing at bins and scripts 

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











