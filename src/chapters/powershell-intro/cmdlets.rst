==============
Cmdlet Basics
==============

PowerShell cmdlets behave similarly to Bash commands. They begin with their name and are followed by arguments and options. PowerShell cmdlets follow a *verb/noun* pattern. 

The Verb-Noun Pattern
=====================

.. index:: ! verb, ! noun

Cmdlets begin with **verbs** like ``Get-`` and ``Set-`` followed by the **noun** that the Verb is acting on. This declarative naming approach makes reading and writing PowerShell easy to understand.

For example, the cmdlets ``Get-Location`` and ``Set-Location`` both operate on your ``Location`` in the file system. The former returns your current working directory (equivalent to ``pwd`` in Bash) while the latter changes this directory (equivalent to ``cd``).

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Location
   # absolute path of your CWD

   > Set-Location /path/to/destination
   # changes CWD to destination path

While a bit more verbose than Bash commands, they are often more intuitive, and can read like a sentence. Every command you enter is telling the shell a statement of instructions for it to perform.

In general terms, there is a verb, a noun being acted on, and a subject.

   [do] verb [to the] noun [of] subject

In the commands above, the subject is *implied* as the Shell process that is managing your current working directory, or Location in the file system. For example, ``Get-Location``:

   Get [the] Location [of] (this shell process)

In the ``Set-Location`` example, an additional term is added to the sentence, the path argument:

   Set [the] Location [of] (this shell process) to (the path)

The analogy of commands and sentences can not be generalized to a single formula, but can be useful when learning PowerShell. 

.. admonition:: Tip

   You can view the full list of built-in cmdlets and functions using the ``Get-Command`` cmdlet:

   .. sourcecode:: powershell
      :caption: Windows/PowerShell
   
      > Get-Command
      # list of all built-ins available on the machine

Options & Arguments
===================
   
PowerShell refers to the many types of inputs to cmdlets as `parameters <https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-parameters?view=powershell-7>`_. As with Bash commands, some of the parameters are positional, or may even have default values. Options, or named parameters, are all written in long form (no single-letter shorthands) and use a single dash (``-``).

For example, the ``Get-Command`` cmdlet has a ``-Type`` option for filtering the results list by types like ``Cmdlet`` and ``Function``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Command -Type Cmdlet
   # list of built-in cmdlets only

Autocompletion
==============

PowerShell cmdlets and functions allow for expansion using the ``tab``  key. This can be helpful to autocomplete command names and options. The ``tab`` key will either complete a partially written name (if it is unique) or list the possible choices.

For example, let's explore the named parameters of ``Get-Command``. If we enter a ``-`` (start of a named parameter) and hit ``tab`` it will show us a list of options available on ``Get-Command``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Command -
   Name                      CommandType               All                       UseAbbreviationExpansion  InformationAction         OutBuffer                 
   Verb                      TotalCount                ListImported              Verbose                   ErrorVariable             PipelineVariable          
   Noun                      Syntax                    ParameterName             Debug                     WarningVariable           
   Module                    ShowCommandInfo           ParameterType             ErrorAction               InformationVariable       
   FullyQualifiedModule      ArgumentList              UseFuzzyMatching          WarningAction             OutVariable 

If we add a few qualifying characters, it can narrow the list down for us:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Command -Out         
   OutVariable  OutBuffer

Whenever enough characters are available to uniquely identify a name it will autocomplete it:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Command -OutV
   # after tab
   > Get-Command -OutVariable 

You can use this feature to automatically fill in command names, named parameters, and even paths! 

Getting Help
============

While the ``--help`` option is available for *some* CLI tools that we will use in the class, the primary mode of viewing command documentation uses the ``Get-Help`` cmdlet. 

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Help <cmdlet name>

``Get-Help``, by default, will display the *summary documentation* for the given cmdlet directly in the PowerShell terminal. To view the *full documentation* for a cmdlet you can add the ``-Full`` option:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Help <cmdlet name> -Full

Another useful option for ``Get-Help`` is ``-Examples`` which will provide practical examples of using the cmdlet:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Help <cmdlet name> -Examples

.. admonition:: Note

   If you prefer to use the browser, using the ``-Online`` option will automatically open your browser to the *full documentation*:

   .. sourcecode:: powershell
      :caption: Windows/PowerShell

      > Get-Help <cmdlet name> -Online

Updating Help Documentation
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. index::
   :single: PowerShell;documentation

PowerShell keeps commonly used documentation locally on your machine, so that it can be accessed more quickly and offline. In some cases, you will need to update your *local* documentation cache. You can update the local help documentation using the ``Update-Help`` cmdlet. 

You can append the ``-Confirm`` option to auto-confirm the download and skip the prompt:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Update-Help -Confirm