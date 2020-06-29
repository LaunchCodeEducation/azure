====================
Working With Objects
====================

The outputs of the FS cmdlets looked just like the strings we saw in BASH. However, recall that *everything is an object* in Windows and PowerShell. Although the Shell may format the way they are displayed, all of the outputs from PowerShell commands are in fact objects! 

For example, when working with many of the FS commands, most of the outputs will be `Directory <https://docs.microsoft.com/en-us/dotnet/api/system.io.directory?view=netcore-3.1>`_, `File <https://docs.microsoft.com/en-us/dotnet/api/system.io.file?view=netcore-3.1>`_ or `String (File contents) <https://docs.microsoft.com/en-us/dotnet/api/system.string?view=netcore-3.1>`_ object types.
 
Objects are more *tangible* than a flat string of characters and bring a new level of depth and efficiency when working from the command-line with PowerShell. They hold properties for quick-access to metadata and expose methods for common tasks that would require a pipeline of commands to perform in BASH. 

Properties & Methods
--------------------

PowerShell is part of the .NET family of `CLS-compliant languages <https://docs.microsoft.com/en-us/dotnet/standard/common-type-system>`_. As a member of the Common Language System PowerShell is able to access the full suite of .NET `class libraries <https://docs.microsoft.com/en-us/dotnet/standard/class-library-overview>`_. 

The .NET standard library is separated into different **namespaces** which are like modules of related classes.  The root namespace called the `System namespace <https://docs.microsoft.com/en-us/dotnet/api/system?view=netcore-3.1>`_ contains the base class definitions for fundamental object types like ``Strings`` or ``Arrays``.

Because PowerShell and C# are both CLS-compliant languages you will find a lot of cross-over between how they are used. Despite some syntactical differences, in both languages properties and methods can be accessed in the same way you are familiar with -- using dot notation.

Accessing a property
--------------------

Let's consider one of the simplest object types, those belonging to the ``String`` `class <https://docs.microsoft.com/en-us/dotnet/api/system.string?view=netcore-3.1>`_. Strings have a ``Length`` property that can be accessed like this:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > "dot notation works!".length
   19

The equivalent in BASH requires piping through multiple commands:

.. sourcecode:: bash
   :caption: Linux/BASH

   $ echo "dot notation works!" | wc -l

Calling a method
----------------

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
----------------------------------

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