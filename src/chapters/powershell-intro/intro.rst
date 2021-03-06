=======================
PowerShell Fundamentals
=======================

.. index:: ! PowerShell

Now that you have learned some fundamental shell and Bash syntax, you are ready to learn about PowerShell. Because many PowerShell features and behaviors were inspired by Bash, you will find that much of the knowledge you have already gained will be applicable to this new tool.

Core Tenets
===========

Although Bash and PowerShell share many similarities, there are some key distinctions between them. Just as before, we will establish some core concepts behind PowerShell and Windows to help rationalize the *why* of their behavior.

File System Paths
-----------------

Windows treats each of its **drives** (devices managed by the operating system) as independent file system trees. Each drive has a name and ends with a ``:`` character, such as ``C:`` or ``D:``. The ``C:`` drive is your primary disk drive and serves as the default installation location of the Windows OS. For this reason, the ``C:`` drive is typically considered the root directory.

Some other characteristics are:

- Paths are separated by back-slashes (``\``)
- File and directory names are not case-sensitive
- The ``C:\`` directory is used as the root directory for absolute paths 

Framework Interpretation
------------------------

The .NET framework is used to interpret and translate PowerShell commands for the OS. This is different from the direct communication channel seen between Bash and Linux. The object-oriented *power* of PowerShell comes from this layer of abstraction between itself and the Windows OS. 

Everything Is An Object
-----------------------

Since Windows NT, the Windows OS releases have all followed an object-oriented design. By extension, PowerShell treats all of its *inputs and outputs as distinct types of objects*. This departure from the string-based approach of Bash makes working with PowerShell a more *tangible* shell experience.

PowerShell commands and scripts are able to work with a wide range of objects, ranging from those provided by the underlying .NET framework to custom-developed types. Like other object-oriented languages, PowerShell objects contain properties and methods that make them intuitive to work with.

File Extensions Matter
----------------------

File extensions are an integral aspect of how Windows works. There are thousands of file extensions built into the Windows OS, but `there are only 10 common types <https://support.microsoft.com/en-us/help/4479981/windows-10-common-file-name-extensions>`_ that you will typically encounter. Every file is bound to one of these extensions that enforces which program will be used to interpret it. 

You can think of a file in Windows as an object whose type is specified by its file extension. This file type, like an object type, defines the properties and methods used by programs that interact with it.

Cmdlets, Functions, and Modules
-------------------------------

.. index:: ! cmdlet, function

In PowerShell, the commands you use are categorized as either a **cmdlet** or a **function**. Cmdlets are written in a .NET supported language (like C#) and as such must be compiled before they can be used. Functions, on the other hand, are written in PowerShell syntax within a script file. 

Functions are used to group a set of cmdlet instructions together as a single utility for performing custom tasks. Functions and cmdlets are used in mostly the same way (with arguments and options) and can be called at the PowerShell terminal prompt or in scripts.

.. index:: ! single responsibility principle

Functions satisfy the **single responsibility principle**---a core philosophy of PowerShell---by enabling cmdlets to remain simple and focused on a single purpose. If you need a cmdlet to do something *extra* you are encouraged to create a function that *wraps the cmdlet* to expose new options and behavior.

.. index:: ! module

**Modules** are collections of cmdlets and functions that share a common theme of use. They are used to bundle together related functionality into a single package that can be shared. The .NET framework provides the essential modules that include utilities, powershell modifiers, and system access.

.. admonition:: Note

   We won't get into the grittier details between functions, advanced functions, and cmdlets. This `PowerShell article <https://letsautomate.it/article/powershell-scripts-functions-modules-cmdlets-oh-my/>`_ offers a great high-level overview. 
   
   You can find even more detail in the official Microsoft documentation `about simple functions <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7>`_ and `advanced functions <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced?view=powershell-7>`_ .