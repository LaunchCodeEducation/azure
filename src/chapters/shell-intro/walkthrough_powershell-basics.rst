=====================================
Walkthrough: Hands-On With PowerShell
=====================================

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