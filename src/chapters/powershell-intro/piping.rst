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

Piping to sort directory contents
---------------------------------

Before entering the following pipeline into your PowerShell Terminal take a moment to read it out loud:

   Get the ChildItem list from (the current directory) **then** take that list and sort it by each item's Name Property 

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-ChildItem | Sort-Object -Property Name
   # sorted directory contents

This expression has three steps:

- ``Get-ChildItem``: outputs an ``Array`` of ``DirectoryInfo`` and ``FileInfo`` objects
- ``|``: transfers the ``Array`` to the next command
- ``Sort-Object -Property Name``: Sorts the input ``Array`` alphabetically by **each element's** ``Name`` property

When the ``Get-ChildItem`` cmdlet is executed it evaluates to an ``Array`` object. However, as you noticed the sorting step (``Sort-Object``) operated on **each element** that is *inside*, not the ``Array`` itself. This is a key aspect of how piping works when working with collections of objects, like an ``Array``. 

.. admonition:: tip

   When a collection of objects is piped from a command **the next command receives and processes each object in the collection one at a time**. 
   
   You can see more detailed examples of this behavior in this `Microsoft pipelining article <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pipelines?view=powershell-7#one-at-a-time-processing>`_.

Adding contents to a file
---------------------------

In this example we will add the contents of a string to a file using the ``Add-Content`` cmdlet. The ``Add-Content`` cmdlet will either add the content to the end of an existing file or create a new one and put the contents in it.

First let's look at a traditional execution of the single command. Here we *explicitly* assign, or bind, the values for the ``-Value`` and ``-Path`` options:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Add-Content -Value "You found me!" -Path "find-me.txt"

   # confirm addition
   > Get-Content .\find-me.txt
   You found me!

   # remove the file
   > Remove-Item .\find-me.txt

Now let's see how this can be accomplished with a simple pipeline:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > "You found me!" | Add-Content -Path "find-me.txt"
   > Get-Content .\find-me.txt
   You found me!

In this pipeline the string ``"You found me!"`` was *piped*, or carried over to, the ``Add-Content`` cmdlet. Notice, unlike the traditional execution, that the ``-Value`` parameter is **implicitly** bound to the string object, ``"You found me!"``.

.. Replacing file contents
-----------------------

.. Piping Output Destinations
.. ==========================

.. Terminal
.. --------

.. `the standard output stream <https://devblogs.microsoft.com/scripting/understanding-streams-redirection-and-write-host-in-powershell/>`_

.. File
.. ----

.. Program
.. -------

Pipeline Parameter Binding
==========================

In Bash, because everything is a string, piping can be performed between any two commands. However, the *format* of those strings is often massaged through additional steps in the pipeline. 

Because PowerShell is object-oriented the command compatibility is shifted from string formats to the types of objects used as inputs and outputs. In PowerShell, piping between commands is a mechanism that requires, *at minimum*, for the next command to have parameters that **accept pipeline input**. 

Before we discuss the mechanism in detail let's explore the example we saw earlier:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > "You found me!" | Add-Content -Path "find-me.txt"

In this pipeline the string ``"You found me!"`` was *piped*, or carried over to, the ``Add-Content`` cmdlet. As mentioned earlier the ``-Value`` option was assigned **implicitly** as a piped input.

When a command receives piped input it goes through the process of **parameter binding**. 

Parameter binding is PowerShell's mechanism of aligning the output object (by its type) or its properties (by their names) with the parameters of the cmdlet receiving it. This process is performed automatically but *how it binds* is controlled by the **binding type** of each parameter.

There are two binding types available in piping, ``ByValue`` and ``ByPropertyName``. In the previous example the piped string object was successfully bound to the ``-Value`` option because it **accepts piped input** through the ``ByValue`` mechanism.

.. admonition:: note

   ``ByValue`` does not mean the option name must be ``-Value``, in fact it means just the opposite! This is just an coincidence of this simplistic example.

Binding ByValue
---------------

When a cmdlet's parameter accepts input ``ByValue`` it will bind **based on the type** of the piped object. 

PowerShell will only attempt parameter binding for parameters that haven't been assigned yet. Unassigned here means the positional or named parameters that haven't been explicitly set in the command or from previous binding process. 

The following steps are a simplified description of the ``ByValue`` binding process:

#. check the **type of the piped object**
#. check the next **unassigned** cmdlet **parameter** that **accepts piped input ByValue**
#. check if this parameter **accepts the same type of object** (or can be easily converted to it, like a number to a string)
#. **bind the piped object** to the matched parameter

Binding ByPropertyName
----------------------

Before we discuss ``ByPropertyName`` let's consider an example that shows its difference from ``ByValue`` binding. Here we attempt to assign the ``-Value`` option explicitly and pass the ``-Path`` as a piped input instead:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ".\find-me.txt" | Add-Content -Value "You found me!"
   Add-Content: The input object cannot be bound to any parameters for the command either
   because the command does not take pipeline input or the input and its properties
   do not match any of the parameters that take pipeline input.

In this case the command error message gives us clues as to what went wrong, ``...the input and its properties do not match any of the parameters...``. 

The ``-Path`` option does accept input binding, but it does so ``ByPropertyName`` not ``ByValue``. Given this information and clues from the error message can you think of how ``ByPropertyName`` binding works? It must have something to do with the **properties** of the piped object.

``ByPropertyName`` binding **binds the property of the piped object** to the parameter with the same name. 

PowerShell will first try to bind ``ByValue`` before going through the following simplified steps:

#. check the next **unassigned** cmdlet **parameter** that **accepts piped input ByPropertyName**
#. check the names for each property of the piped object
#. **bind the piped object's property** with the same name as the parameter

The error message from before indicated that the piped object could not satisfy a binding to the **required** parameter (like ``-Path``) of the next command. Our piped string does not have a property called ``Path`` that aligns with the named parameter ``-Path`` so the binding fails.

Parameter Discovery
-------------------

Before you can pipe between commands you need to check for compatibility between the piped object and next command's input parameters. The ``Get-Member`` cmdlet and the ``getType()`` method are two tools you have learned about for discovery of a command's output object. For understanding the requirements of the next command's inputs we can use the ``Get-Help`` cmdlet with an additional filtering option.

The ``Get-Help`` cmdlet includes an option called ``-Parameter`` which will list the details about the parameter of the target cmdlet. 

Let's look at the ``-Value`` and ``-Path`` parameters in particular. In the parameter output you want to check first line, for its input type, and the **Accept pipeline input?** line, for its binding type(s):

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

.. admonition:: tip
  
   When the ``Get-Help`` option ``-Parameter`` is given a wildcard character (``*``) it will list the details for all the parameters of the cmdlet.

   .. sourcecode:: powershell
      :caption: Windows/PowerShell

      > Get-Help Add-Content -Parameter *
      # details of all parameters

Using pipelines to learn about pipelines!
=========================================

Searching file contents for a matching search term is a common operational task. For example, you may need to search through Server logs or other files for terms of interest. In this example we will introduce another utility cmdlet -- ``Where-Object``. As its name implies it is used to filter a collection **where [each] object** satisfies some criteria.

When discovering the parameters of a cmdlet it is a tedious process to *manually search through* the results of all the parameters. To plan your pipeline you are most concerned with the parameters that accept pipeline input. We can use the ``Where-Object`` cmdlet to filter the list of parameters down to only those that can be piped to.

Let's use ``Where-Object`` and piping to learn about the ``Where-Object`` cmdlet!

First we need to see what properties are of the parameter help objects that the ``Get-Help`` command outputs. For this task we can pipe them into ``Get-Member`` and view the available properties and methods on the object:

.. sourcecode:: powershell
   :caption: Windows/PowerShell
   :emphasize-lines: 

   > Get-Help Where-Object -Parameter * | Get-Member

   TypeName: MamlCommandHelpInfo#parameter

   Name           MemberType   Definition
   ----           ----------   ----------
   # ...trimmed output
   name           NoteProperty System.String name=CContains
   pipelineInput  NoteProperty string pipelineInput=False
   required       NoteProperty string required=true

These are the property names that correspond to the table output you saw in the previous section. Our goal is to filter out all of the parameters that have a ``pipelineInput`` property with a value of ``true (Binding Type,...)``. Recall that the the ``(Binding Type,...)`` can be one or both of ``ByValue`` and ``ByPropertyName``. 

We can generalize our search term to the string ``true`` followed by any other text to account for the 3 scenarios that could come after it. This is another use case for a wildcard. The expression ``true*`` matches the loose pattern of our search criteria. 

When we are searching for something that is *like* a string we can use the ``-Like`` option of ``Where-Object``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Help Where-Object -Parameters * | Where-Object -Property pipelineInput -Like "true*"

   -InputObject <PSObject>
      Specifies the objects to be filtered. You can also pipe the objects to `Where-Object`.

      When you use the InputObject parameter with `Where-Object`, instead of piping command results to `Where-Object`, the InputObject value is treated as a single object. 
      This is true even if the value is a collection that is the result of a command, such as `-InputObject (Get-Process)`. Because InputObject cannot return individual 
      properties from an array or collection of objects, we recommend that, if you use `Where-Object` to filter a collection of objects for those objects that have specific 
      values in defined properties, you use `Where-Object` in the pipeline, as shown in the examples in this topic.

      Required?                    false
      Position?                    named
      Default value                None
      Accept pipeline input?       True (ByValue)
      Accept wildcard characters?  false

.. admonition:: tip
   
   You can read more about ``Where-Object`` and providing search criteria through **script blocks** `in its Microsoft documentation <https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Core/Where-Object?view=powershell-7#description>`_. 

Pipeline Planning
=================

When designing a pipeline it can help to organize the commands and the path the objects will take. Over time you will grow comfortable using common cmdlets. But in the beginning you can use this checklist to help plan your approach:

#. what command is first and what is its output type?
#. what is the final output type and where should it go (Terminal, file, program input)?
#. what logical steps (Verbs and Nouns) do you need to get from the first output to the last?
#. how do the command steps need to be ordered for the parameters to bind properly?

.. admonition:: tip

   The cmdlets ``Where-Object`` and ``Sort-Object`` that you saw in the examples are utility cmdlets. They can be used as transitions, or interjections between steps, to coordinate the behavior of a pipeline. 
   
   They make up a small part of the `PowerShell Utilities module <https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/?view=powershell-7>`_. This module is a goldmine for piping with other utilities to help with steps like formatting, converting and mutating objects.

.. Complementary Verbs & Nouns
.. ---------------------------

.. The final step can sometimes be the most challenging. Fortunately, PowerShell is designed to support **complementary verbs** that act on the same **noun**. Complementary here means that one verb will perform an action, like ``Get``, while another will perform an action that naturally *flows* from the first, like ``Set``.

.. If you find that the same Noun is being used in a pipeline your complementary Verbs will work well together. For example,

.. .. todo:: complete examples or cut from article (too long..)