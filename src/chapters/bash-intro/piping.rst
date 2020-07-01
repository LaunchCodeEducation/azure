.. cut from this course but keep for later

==============
Piping in Bash
==============

Recall that piping is the mechanism for taking the output of one command and using it as the input of the second command. It involves two or more commands separated by the pipe operator symbol (``|``, under the ``backspace`` key). In a general sense this is how piping works:

.. sourcecode:: bash

   a-command -> a-command output | -> b-command <a-command output as argument> -> b-command output ...   

Grep
----

Because all of the inputs and outputs of Bash commands are strings it follows that a tools for working with these strings would be developed. Grep is part of a suite of tools that are pre-installed on most Linux Distributions. The suite includes ``grep``, ``awk`` and ``sed``. The former of which is designed for *searching* while the latter two are used for *processing*, or transforming, text strings. They work on the text contents of files but really shine when used in piping.

While ``sed`` and ``awk`` are powerful and worth learning they fall well outside of the scope of this course. However, searching with ``grep`` is a valuable tool whose basic behaviors are simple to understand. 

In its simplest form ``grep`` uses two arguments -- a search term and a text input source. The text input can be an absolute or relative path to a file you want to search the contents of. Grep will search line-by-line and output any lines that have a match for the search term. If there are no matches the output of ``grep`` will be an empty line:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ grep '<search term>' path/to/file

For example what if we wanted to see all of the conditional statements in the ``.bashrc`` file we looked at earlier? We could have ``grep`` search that file for ``if`` and output the search results to us. 

.. sourcecode:: bash
   :caption: Linux/Bash

   $ grep 'if' ~/.bashrc
   # all of the lines that include 'if' in them

   # recall ~ is a shorthand for /home/<username of logged in user>
   # the following command is identical in behavior
   $ grep 'if' /home/student/.bashrc

We will cover ``grep`` behavior when used in piping next. For more detailed information you can always check the help or manual outputs:

.. sourcecode:: bash
   :caption: Linux/Bash

   # concise help output (usually available)
   $ grep --help

   # manual for a command (not always available)
   $ man grep 
   
   # opens in the "less" program
   # use the J and K keys to scroll and Q to quit

Filtering with grep
-------------------

Consider a scenario where you want to *search for* one file out of many within a directory. You could ``ls`` the contents and search through it by hand. Or even use a GUI File Explorer to visualize the files. But what if there were dozens, hundreds or thousands of files? Clearly it is impractical to do this work by hand.

What if instead of letting the contents output of ``ls`` be sent to the Terminal we used it as an input to a tool designed for performing searches? This is what piping and ``grep`` are made for!

When only a search term argument is given to ``grep`` (when used in piping) it will use the output of the previous command as the text to search. Essentially it treats the output the same as the contents of a file when given a file path argument. You can picture it like this:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ <command> | grep '<search term>' <output from command>

We can *pipe* the output of ``ls`` (directory contents as a string) as the string input used by ``grep`` to filter just the results we need. Our pipeline would look like this:

.. sourcecode:: bash

   $ ls --> dir contents string | --> grep 'search term' <dir contents string> --> search results string

What if we wanted to check for details about the ``dotnet`` program by using the long form ``ls`` output:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ ls -l /usr/bin | grep 'dotnet'
   lrwxrwxrwx 1 root   root           22 May 20 15:37 dotnet -> ../share/dotnet/dotnet

You can pipe to and from many CLI programs thanks to the standard use of strings as outputs and inputs. As a final example let's search through the help output of ``dotnet``. If you were to view the help output directly you would end up scrolling through many lines.

What if you just want to know how to publish a project (something we will soon cover)? We can use piping to automate the process of searching through the lines manually:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ dotnet --help | grep 'publish'
   publish           Publish a .NET project for deployment.