====================
Piping in PowerShell
====================

Recall that piping is a mechanism for performing multiple steps in a single expression. A pipe consists of 2 or more command steps separated by the pipe operator, ``|``. The output object from the previous command is *piped* to be used as an input in the next command.

A pipeline can be read from left to right as at least 3 steps:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > command | command ...

#. **first step**: command produces an output object
#. ``|``: carries the output object to the next step
#. **next step**: uses the output object as an input to the command

This process can be extended to any number of steps (using the ``|`` operator between them) needed to accomplish the goal of the pipeline.

We will start with some examples to get comfortable with the general *flow* of piping in PowerShell. Then we will dig into some of the details that enable this powerful feature.

Piping In Action
================

.. PIPES VS GROUP EXPRESSION PARAM SUBSTITUTION:

.. https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pipelines?view=powershell-7#one-at-a-time-processing

.. However, there's an important difference. When you pipe multiple objects to a command, PowerShell sends the objects to the command one at a time. When you use a command parameter, the objects are sent as a single array object. This minor difference has significant consequences

Piping to sort directory contents
---------------------------------

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   Get-ChildItem | Sort-Object -Property Name

This expression has three steps:

- ``Get-ChildItem``: an ``Array`` of ``DirectoryInfo`` and ``FileInfo`` objects
- ``|``: transfers the ``Array`` to the next statement
- ``Sort-Object -Property Name``: Sorts the ``Array`` alphabetically by their *Name* property

Finding a file
--------------

Searching file contents
-----------------------

Replacing file contents
-----------------------

Piping Output Destinations
--------------------------

Terminal
^^^^^^^^

`the standard output stream <https://devblogs.microsoft.com/scripting/understanding-streams-redirection-and-write-host-in-powershell/>`_

File
^^^^

Program
^^^^^^^

Pipeline Parameter Binding
==========================

In BASH, because everything is a string, piping can be performed between any two commands. However, the *format* of those strings is often massaged through additional steps in the pipeline. 

Because PowerShell is object-oriented the command compatibility is shifted from string formats to the types of objects used as inputs and outputs. In PowerShell, piping between commands is a mechanism that requires, *at minimum*, for the next command to have parameters that **accept pipeline input**. 

Before we discuss the mechanism in detail let's take look at two ways to write the contents of a string to a file using the ``Add-Content`` cmdlet. This cmdlet writes content to the end of an existing file or creates a new file and sets the content as its first line. 

First by traditional execution. Here we *explicitly* assign, or bind, the values for the ``-Value`` and ``-Path`` options:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Add-Content -Value "hello!" -Path "hello.txt"

   # confirm addition
   > Get-Content .\hello.txt
   hello!

   # remove the file
   > Remove-Item .\hello.txt

Now let's see how this can be accomplished with a simple pipeline. Notice that this time the ``-Value`` parameter is **implicitly** bound to the string object ``"hello!"``.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > "hello!" | Add-Content -Path "hello.txt"
   > Get-Content .\hello.txt
   hello!

   > Remove-Item .\hello.txt

In this pipeline the string ``"hello!"`` was *piped*, or carried over to, the ``Add-Content`` cmdlet. 

When a command receives piped input it goes through the process of **parameter binding**. Parameter binding is PowerShell's mechanism of aligning the output object (as a value) or its properties (by their names) with the parameter names of the cmdlet receiving the piped input. This process is performed automatically but *how it binds* is controlled by the **binding type** of each parameter.

There are two binding types available in piping, ``ByValue`` and ``ByPropertyName``. In the previous example the piped string input was successfully bound to the ``-Value`` option because it **accepts piped input** ``ByValue``

.. admonition:: note
   ``ByValue`` does not mean the option name must be ``-Value``, in fact it means just the opposite! This is just an coincidence of this simplistic example.

Binding ByValue
---------------

When a cmdlet's parameter accepts input ``ByValue`` it will bind based on the type of the piped object. PowerShell will only attempt parameter binding for parameters that haven't been assigned yet. Unassigned here means the positional or named parameters that haven't been explicitly set in the command or from previous binding process. 

The following steps are a simplified description of the ``ByValue`` binding process:

#. check the **type of the piped object**
#. check the next **unassigned** cmdlet **parameter** for a one that **accepts piped input ByValue**
#. check if this parameter **accepts the same type of object** (or can be easily converted to it, like a number to a string)
#. **bind the piped object** to the matched parameter

Binding ByPropertyName
----------------------

Before we discuss ``ByPropertyName`` let's consider an example that shows its difference from ``ByValue`` binding. Here we attempt to provide the ``-Value`` with direct assignment and pass the ``-Path` as a piped input instead:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ".\hello.txt" | Add-Content -Value "hello!"
   Add-Content: The input object cannot be bound to any parameters for the command either because the command does not take pipeline input or the input and its properties do not match any of the parameters that take pipeline input.

In this case the command fails because the ``-Path`` option only accepts input ``ByPropertyName``. A string does not have a property called ``Path`` that aligns with the named parameter ``-Path`` so it fails to bind.

Parameter Discovery
-------------------

Before you can pipe between commands you need to check for compatibility between the piped object and next command's input parameters. The ``Get-Member`` cmdlet and the ``getType()`` method are two tools you have learned about for discovery of a command's output object. For understanding the requirements of the next command's inputs we can use the ``Get-Help`` cmdlet with an additional filtering option.

The ``Get-Help`` cmdlet includes an option called ``-Parameter`` which will list the details about the parameter of the target cmdlet. When called without an argument (or ``*`` as a wildcard meaning *all*) it will list the details for all the parameters of the cmdlet.

Let's see the parameters of the ``Add-Content`` cmdlet:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Help Add-Content -Parameter
   # details of all parameters

Now let's look at the ``-Value`` and ``-Path`` parameters in particular. In the parameter output you want to check first line, for its input type, and the **Accept pipeline input?** line, for its binding type(s):

.. sourcecode:: powershell
   :caption: Windows/PowerShell
   :emphasize-lines: 3,7,12,16

   > Get-Help Add-Content -Parameter Value, Path

   -Value <Object[]>
      
      Required?                    true
      Position?                    1
      Accept pipeline input?       true (ByValue, ByPropertyName)
      Parameter set name           (All)
      Aliases                      None
      Dynamic?                     false

   -Path <string[]>
    
      Required?                    true
      Position?                    0
      Accept pipeline input?       true (ByPropertyName)
      Parameter set name           Path
      Aliases                      None
      Dynamic?                     false

Pipeline Planning
=================

When designing a pipeline it can help to organize the commands and the path the objects will take. Over time you will grow comfortable using common cmdlets. But in the beginning you can use this checklist to help plan your approach:

#. what command is first and what is its output type?
#. what is the final output type and where should it go (Terminal, file, program input)?
#. what logical steps (Verbs and Nouns) do you need to get from the first output to the last?
#. how do the command steps need to be ordered for the parameters to bind properly?

.. admonition:: tip

   The cmdlets ``Where-Object``, ``Sort-Object`` and ``Select-Object`` that you saw in the examples utility cmdlets. They have a broader surface of use and can be used as transitions, or interjections, between steps to coordinate the behavior of a pipeline. 
   
   They make up a small part of the `PowerShell Utilities module <https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/?view=powershell-7>`_. This module is a goldmine for piping with other utilities to help with steps like formatting, converting and mutating objects.

.. Complementary Verbs & Nouns
.. ---------------------------

.. The final step can sometimes be the most challenging. Fortunately, PowerShell is designed to support **complementary verbs** that act on the same **noun**. Complementary here means that one verb will perform an action, like ``Get``, while another will perform an action that naturally *flows* from the first, like ``Set``.

.. If you find that the same Noun is being used in a pipeline your complementary Verbs will work well together. For example,

.. .. todo:: complete examples or cut from article (too long..)

Piping to find a file
---------------------

Before we can see piping in action let's create a file in our home directory that we can search for with a pipe:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   new-item find-me.txt -Value "Hello.`nYou founxd me!"

From your home directory run the next command to watch our PowerShell pipe Find the file by searching all the files and folders in your home directory.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   Get-ChildItem | Where-Object -Property Name -eq "find-me.txt"

This expression has three steps:

#. ``Get-ChildItem``: an array of *DirectoryInfo* and *FileInfo* objects
#. ``|``: transfers the array to the next statement
#. ``Where-Object -Property Name -eq "find-me.txt"``: Searches the array of objects for the property *Name* that matches the value *find-me.txt*.

Piping to determine if a file contains a substring
--------------------------------------------------

- find a specific word in a file as an extension of what they just saw (filtering) where-object file object not a directory object -- conclusion all objects be used
   - get-childitem -recurse -> files | where-object -> file | get-contents -> lines | where-object -> filtered lines
   - find in file system
   - find in file
   - filter

   .. sourcecode:: powershell
      :caption: Windows/PowerShell

      (Get-ChildItem | Where-Object -Property Name -eq "find-me.txt" | Get-Content).contains("founxd")

Piping to preview fixing a misspelling in a file
------------------------------------------------

- fix all the misspellings of "get him do the dundees" in a file of 10000+ lines as an extension of what they just saw **FIND AND REPLACE IN STDOUT** as a preview
   - previous examples started with collection outputs
      - piping can be done on individual objects as well such as a file you want to edit
   - start with get-contents of file (single object) -> collection of line objects
   - iterate over lines collection with for-each
      - introduce $_ (current element)
      - replace
   - did not change the file itself
      - prove
      - printed as a preview
      - how can we actually edit the file?

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   (Get-Content -Path .\Notice.txt) |
      ForEach-Object {$_ -Replace 'Warning', 'Caution'} |
         Set-Content -Path .\Notice.txt
   Get-Content -Path .\Notice.txt

Piping Output Destinations
--------------------------

Terminal
^^^^^^^^

- all of previous commands printed to the Terminal
- note / link to STD streams

File
^^^^

- third example bad without modifying the file
- send destination to the file
- prove editing success

Final Example
^^^^^^^^^^^^^

request -> body | 