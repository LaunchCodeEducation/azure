=====================================
Walkthrough: Hands-On With PowerShell
=====================================

Objects
=======

The outputs of the FS cmdlets looked just like the strings we saw in BASH. However, recall that *everything is an object* in Windows and PowerShell. All of the outputs from PowerShell commands are in fact objects! 

For example, when working with many of the FS commands, most of the outputs will be `Directory <https://docs.microsoft.com/en-us/dotnet/api/system.io.directory?view=netcore-3.1>`_ or `File <https://docs.microsoft.com/en-us/dotnet/api/system.io.file?view=netcore-3.1>`_ object types.
 
Objects are more *tangible* than a flat string of characters and bring a new level of depth and efficiency when working from the command-line. They hold properties for quick-access to metadata and expose methods for common tasks that would require a pipeline of commands to perform in BASH. 

Properties & Methods
--------------------

PowerShell is part of the .NET family of `CLS-compliant languages <https://docs.microsoft.com/en-us/dotnet/standard/common-type-system>`_. As a member of the Common Language System PowerShell is able to access the full suite of .NET `class libraries <https://docs.microsoft.com/en-us/dotnet/standard/class-library-overview>`_. 

The .NET standard library is separated into different **namespaces** which are like modules of related classes.  The root namespace called the `System namespace <https://docs.microsoft.com/en-us/dotnet/api/system?view=netcore-3.1>`_ contains the base class definitions for fundamental object types like ``Strings`` or ``Arrays``.

Because PowerShell and C# are both CLS-compliant languages you will find a lot of cross-over between how they are used. Despite some syntactical differences, in both languages properties and methods can be accessed in the same way you are familiar with -- using dot notation.

Access a property
^^^^^^^^^^^^^^^^^

Let's consider one of the simplest object types, those belonging to the ``String`` `class <https://docs.microsoft.com/en-us/dotnet/api/system.string?view=netcore-3.1>`_. Strings have a ``Length`` property that can be accessed like this:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > "dot notation works!".length
   19

The equivalent in BASH requires piping through multiple commands:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ echo "dot notation works!" | wc -l

Call a method
^^^^^^^^^^^^^

We can invoke an object's method in PowerShell the same way as we would in C#. 

In the following example we will access the ``getType()`` method attached to a ``String`` object. The ``getType()`` method shows details about the object it is called on.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > "hello world".getType()

   IsPublic IsSerial Name                                     BaseType
   -------- -------- ----                                     --------
   True     True     String                                   System.Object

.. admonition:: note

   You can call ``getType()`` on any object in PowerShell. Like in C# every object extends the .NET ``System.Object`` class that provides the base implementation of ``getType()``. 

While ``getType()`` can give you the type of an object how can we discover the other type-specific methods and properties that an object has? There is another useful tool built into PowerShell for just this use case.

Discovering methods and properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In the following example we use the ``Get-Member`` cmdlet to access the properties and methods of any given object in PowerShell.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Member -InputObject <object>

Let's use this pattern to view the available properties and methods of a common ``String`` object.

.. sourcecode:: powershell
   :caption: Windows/Powershell

   > Get-Member -InputObject "a-string"

   TypeName: System.String

   Name                 MemberType            Definition
   ----                 ----------            ----------
   # ...trimmed
   CopyTo               Method                void CopyTo(int sourceIndex, char[] destination, int destinationIndex, int count)
   # ...trimmed
   TrimStart            Method                string TrimStart(), string TrimStart(char trimChar), string TrimStart(Params char[] trimChars)
   Chars                ParameterizedProperty char Chars(int index) {get;}
   Length               Property              int Length {get;}


Looking at the output we can see many things including a property name ``Length`` and the handy ``String`` methods ``Split()``, ``Substring()``, ``IndexOf()`` among the others.

.. todo:: too deep for now, keep for later if needed

.. Let's use ``Get-Member`` to discover the properties and methods of the object outputted by ``getType()``:

.. .. sourcecode:: powershell
..    :caption: Windows/PowerShell

..    > Get-Member -InputObject ("hello world".getType())
   
..    TypeName: System.RuntimeType

..    Name                           MemberType Definition
..    ----                           ---------- ----------
..    AsType                         Method     type AsType()
..    Clone                          Method     System.Object Clone(), System.Object ICloneable.Clone()
..    Equals                         Method     bool Equals(System.Object obj), bool Equals(type o)
..    # ...trimmed
..    ToString                       Method     string ToString()
..    Assembly                       Property   System.Reflection.Assembly Assembly {get;}
..    AssemblyQualifiedName          Property   string AssemblyQualifiedName {get;}
..    Attributes                     Property   System.Reflection.TypeAttributes Attributes {get;}
..    BaseType                       Property   type BaseType {get;}
..    # ...trimmed

.. We can see that the object outputted by a ``getType()`` method call is a special type of object called ``System.RuntimeType``. Its purpose is to manage metadata about the object it belongs to (the ``"hello world"`` ``String`` in this case).

.. admonition:: tip

   Between the object ``getType()`` method and the ``Get-Member`` cmdlet you can discover all of the details about the objects you are working with. Knowing the type and capabilities of an object that cmdlets accept as inputs and produce as outputs will help you when writing more advanced commands and scripts.
   
   For someone new to PowerShell these are invaluable tools that you should use regularly to familiarize 

.. Chaining Methods & Properties
.. ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. While methods and properties can be accessed one at a time they can also be chained together like you have seen in C# and JavaScript. 

.. Recall that chaining is the process of using dot notation to access the property or method of the previous object outputted from each part of the chain. Method chaining is similar to piping where the **output object** of the previous method or property is used as the **source object** for the next dot notation access.

.. For example consider the following chain consisting of:

.. #. a grouping expression
.. #. a method call
.. #. a property access

.. .. todo:: can a better example be fit in (more practical / realistic)

.. .. sourcecode:: powershell
..    :caption: Windows/PowerShell

..    > (Get-Location).getType().Name
..    PathInfo
   

.. Let's break down these steps to understand how chaining works:

.. .. sourcecode:: powershell
..    :caption: Windows/PowerShell

..    > (Get-Location).getType().Name

..    (Get-Location) # -output-> (directory object)
..       .getType() # -output-> (RuntimeType object)
..          .Name # -output-> (string object)
..             "PathInfo"

.. .. admonition:: tip
   
..    In a lot of ways chaining is similar to using multiple group expressions. If group expressions clicked with you you can think of the chain above as being evaluated like this:

..    .. sourcecode:: powershell
..       :caption: Windows/PowerShell
   
..       > ((Get-Location).getType()).Name

.. As another more complex example consider the output of ``Get-ChildItem`` which lists the contents of a directory. The output of this cmdlet is an ``Array`` object filled with directory content objects. Here is how we could discover the proper ``Name`` of one of these directory content objects:

.. .. todo:: better example man

.. .. sourcecode:: powershell
..    :caption: Windows/PowerShell

..    > (Get-ChildItem)[0].getType().Name
..    DirectoryInfo

.. Remember no matter how complex an expression looks it can be broken down methodically:

.. .. sourcecode:: powershell
..    :caption: Windows/PowerShell

..    > (Get-ChildItem)[0].getType().Name

..    (Get-ChildItem)[0] # -output-> (first element of the contents Array)
..       .getType() # -output-> (RunTime object)
..          .Name # -output-> (string object)
..             "DirectoryInfo"

Expression Evaluation
=====================

Expressions are the general term for syntactical instructions that must be **evaluated** to a **value**. Expressions can be anything from a simple variable assignment to a more complex command like executing a cmdlet.

Programming languages are made up of rules for how different types of expressions are evaluated. In general, expressions are evaluated from left to right. But depending on the *operations used in an expression* there may be more specific rules that cause it to be evaluated differently.

In the following sections we will explore two **operators** (symbols with special meaning) that are integral to working with PowerShell.

Grouping Expression Operator
----------------------------

Understanding how grouping expressions works is best discovered through an example. Let's consider the following *arithmetic (math) expression*. 

These types of expressions are evaluated from left to right unless some math operators (like ``+`` and ``*``) are used. Arithmetic expressions are evaluated following the mathematical rules defined in the `PEMDAS order of operations <https://www.purplemath.com/modules/orderops.htm>`_.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > 5 + 5
   10

On its own this is an expression (a set of instructions), not a value. It must first be evaluated (interpreted and computed) to its value of ``10``. 

In the following example we want to add ``5 + 5`` and multiply *the resulting value* by ``2`` to make ``20``. The overall expression contains two expressions that need to be evaluated -- addition and multiplication.

Would this expression evaluate to our goal of ``20``?:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > 5 + 5 * 2
   15

Expressions are evaluated with rules that depend on their context. For arithmetic expressions the PEMDAS rules cause ``5 * 2`` to be evaluated first with the resulting value of ``10`` then being added to ``5``. 

However, we can control the **order of evaluation** by **grouping expressions** that we want to be evaluated first. In PowerShell the **Grouping Expression Operator** is a pair of parenthesis that wrap around any PowerShell expression. Just like in math, grouped expressions are evaluated from **the innermost group** to the **outermost (overall) expression**. 

If we were to group the addition expression it would be evaluated first *then* its resulting value would be multiplied by ``2``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > (5 + 5) * 2
   20

We can see that ``(5 + 5)`` was evaluated first, **then the group was replaced with the resulting value** of ``10`` before continuing evaluating the overall expression.

Consider a more complex example with *nested* groups (a grouped expression inside another):

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ((10 + 10) * 2) + 5

The outermost (overall) expression would be evaluated in the following steps. From the inside out:

#. innermost grouping: ``(10 + 10)``, a resulting value of ``20``
#. moving outwards to the next grouping: the resulting value ``(20)`` is substituted and evaluated to ``((20) * 2)) = 40``
#. outermost level: once again the grouping's value ``(40)`` is substituted for the final evaluation ``(40) + 5 = 45`` 

The same principle applies to any PowerShell expression within the grouping operators. But PowerShell expressions go well beyond basic arithmetic! Instead of evaluating to just *numeric values* what is substituted for each grouped expression can be a *result object* of any type.

Consider a simple scenario with string objects rather than numbers. Our goal is to combine (concatenate) two strings together and determine the length of the new string that is formed. *Without grouping* this would be our result:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > "hello" + "world".length
   hello5

The string ``"hello"`` is concatenated with the result of ``"world".length`` into the unexpected string ``"hello5"``. PowerShell tries to evaluate from left to right but can't combine a string (``"hello"``) with an *expression* (``"world".length``). It first evaluates the length to a value of ``5`` *and then* evaluates ``"hello" + 5"``.

We can use grouping to enforce ``"hello" + "world"`` being evaluated first *and then* checking the ``length`` property of the resulting ``string`` object:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ("hello" + "world").length
   10

In other words the evaluation and substitution looked like this:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > (string object).length

Grouping expressions allows you to evaluate the group and then treat the group, on its closing ``)``, as an object. The object can then be used to access properties and methods directly from the group using dot notation. The group is first evaluated to its resulting object *then* dot notation access is evaluated.

Subexpression Operator
----------------------

Recall that in BASH we used the command substitution syntax ``$(command list)`` to perform in-line evaluations. In PowerShell same syntax is used but is referred to as a **subexpression operator**. 

While the grouping operator is used to **group an expression** a subexpression can be used to **execute commands within an expression**. For example, if we wanted to print a string like this:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # the BASH 'echo' command can be used as an alias for Write-Output
   > Write-Output "The length of the concatenated strings is: ("hello" + "world").length"
   The length of the concatenated strings is: (
   hello + world).length

Notice that it printed the literal text inside the grouped expression rather than executing it. In addition, the quotes caused some unexpected line breaks. 

Let's try using a subexpression instead:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Write-Output "The length of the concatenated strings is: $(("hello" + "world").length)"
   The length of the concatenated strings is: 10

This time the subexpression ``("hello" + "world").length`` is **executed** before its resulting value is substituted back in.

We will see more examples of subexpressions and grouped expressions later in this course. They are valuable tools to understand for writing "one-liner" commands in the REPL. But they are even more useful when employed in pipelines and scripts.

.. admonition:: tip

   Use **grouping expressions** when you want to **control the order of evaluation** (from the inside out).

   Use **subexpressions** when you need to **execute an expression** inside of another. In addition, only subexpressions `allow you to <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7#subexpression-operator-->`_:

   - use **keywords** like ``for`` (for loops) and ``if`` (for conditional logic)
   - execute **multiple commands** as a single unit

Piping
======

Chaining allows us to perform multiple steps by working **directly on an object**. Every step in the chain is dictated by the source object the dot notation is used on. 

Piping differs from chaining in that it allows you to perform multiple steps **by transferring an object** between cmdlets. Recall that in a general sense piping allows you to transfer the output of one command to the input of the next step in the pipeline.

Just as in BASH 

Recall that piping is a mechanism for performing multiple steps in a single expression. 

key points
- mechanism for multiple steps in a single expression
- uses output of previous step as input to next step
- primary argument to cmdlets is the piping input
   - will not work for other arguments or options
      - need to use grouped expressions / sub-expressions
- note: not all cmdlets are compatible

header for this section: piping in the file system


Piping to sort directory contents
---------------------------------

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   Get-ChildItem | Sort-Object -Property Name

This expression has three steps:

- ``Get-ChildItem``: an array of *DirectoryInfo* and *FileInfo* objects
- ``|``: transfers the array to the next statement
- ``Sort-Object -Property Name``: Sorts the array alphabetically by their *Name* property

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


Learning More
=============

links

- devhints cheatsheet
- 
- custom objects