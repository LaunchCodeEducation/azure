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

File System
===========

- describe aliases for the essentials
   - cant use options because of aliases
- cover cmdlet analogs and options
   - cd: Set-Path
- write to file?

diffs
- ~ and - for quick nav? -> only ~ is valid
- cmdlets are Verb-Noun
   - not case-sensitive
- ..\ and .? -> both valid
- creating files (notepad?)
- viewing files (less, cat?)

Getting Help
------------

- --help -> not always available, prefer Get-Help
- man equiv -> Get-Help
- Get-Help
   - `-Online`
- updating help docs
   - Update-Help

CLI Tools
=========

Package Manager
---------------

- no sudo, must open as admin
- unofficial but recognized by microsoft
   - MS docs link?
   - must be installed
- install and set up choco
   - https://chocolatey.org/install
- basic choco commands
   - install
   - prompt options (-Force?)
   - update?
- adding sources https://chocolatey.org/docs/commands-sources

Course Tools Installation
-------------------------

- dotnet
- az
- git

Objects
=======

- everything is an object
- .NET https://docs.microsoft.com/en-us/dotnet/standard/class-library-overview
- custom

show
- dot notation access
   - properties
   - methods
   - with inline evaluation
- types
   - json
   - strings
- Cmdlet input / output types
   - view
   - configure

out of scope (get links)
- interacting with .NET objects
- custom objs

Piping
======

- much more time in this section

show
- convert to / from json
- convert between common DTs
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











