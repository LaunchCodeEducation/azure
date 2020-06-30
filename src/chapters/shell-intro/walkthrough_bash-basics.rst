===============================
Walkthrough: Hands-On With Bash
===============================

.. cut from this course but keep for later

.. Piping
.. ======

.. Recall that piping is the mechanism for taking the output of one command and using it as the input of the second command. It involves two or more commands separated by the pipe operator symbol (``|``, under the ``backspace`` key). In a general sense this is how piping works:

.. .. sourcecode:: bash

..    a-command -> a-command output | -> b-command <a-command output as argument> -> b-command output ...   

.. Grep
.. ----

.. Because all of the inputs and outputs of Bash commands are strings it follows that a tools for working with these strings would be developed. Grep is part of a suite of tools that are pre-installed on most Linux Distributions. The suite includes ``grep``, ``awk`` and ``sed``. The former of which is designed for *searching* while the latter two are used for *processing*, or transforming, text strings. They work on the text contents of files but really shine when used in piping.

.. While ``sed`` and ``awk`` are powerful and worth learning they fall well outside of the scope of this course. However, searching with ``grep`` is a valuable tool whose basic behaviors are simple to understand. 

.. In its simplest form ``grep`` uses two arguments -- a search term and a text input source. The text input can be an absolute or relative path to a file you want to search the contents of. Grep will search line-by-line and output any lines that have a match for the search term. If there are no matches the output of ``grep`` will be an empty line:

.. .. sourcecode:: bash
..    :caption: Linux/Bash

..    $ grep '<search term>' path/to/file

.. For example what if we wanted to see all of the conditional statements in the ``.bashrc`` file we looked at earlier? We could have ``grep`` search that file for ``if`` and output the search results to us. 

.. .. sourcecode:: bash
..    :caption: Linux/Bash

..    $ grep 'if' ~/.bashrc
..    # all of the lines that include 'if' in them

..    # recall ~ is a shorthand for /home/<username of logged in user>
..    # the following command is identical in behavior
..    $ grep 'if' /home/student/.bashrc

.. We will cover ``grep`` behavior when used in piping next. For more detailed information you can always check the help or manual outputs:

.. .. sourcecode:: bash
..    :caption: Linux/Bash

..    # concise help output (usually available)
..    $ grep --help

..    # manual for a command (not always available)
..    $ man grep 
   
..    # opens in the "less" program
..    # use the J and K keys to scroll and Q to quit

.. Filtering with grep
.. -------------------

.. Consider a scenario where you want to *search for* one file out of many within a directory. You could ``ls`` the contents and search through it by hand. Or even use a GUI File Explorer to visualize the files. But what if there were dozens, hundreds or thousands of files? Clearly it is impractical to do this work by hand.

.. What if instead of letting the contents output of ``ls`` be sent to the Terminal we used it as an input to a tool designed for performing searches? This is what piping and ``grep`` are made for!

.. When only a search term argument is given to ``grep`` (when used in piping) it will use the output of the previous command as the text to search. Essentially it treats the output the same as the contents of a file when given a file path argument. You can picture it like this:

.. .. sourcecode:: bash
..    :caption: Linux/Bash

..    $ <command> | grep '<search term>' <output from command>

.. We can *pipe* the output of ``ls`` (directory contents as a string) as the string input used by ``grep`` to filter just the results we need. Our pipeline would look like this:

.. .. sourcecode:: bash

..    $ ls --> dir contents string | --> grep 'search term' <dir contents string> --> search results string

.. What if we wanted to check for details about the ``dotnet`` program by using the long form ``ls`` output:

.. .. sourcecode:: bash
..    :caption: Linux/Bash

..    $ ls -l /usr/bin | grep 'dotnet'
..    lrwxrwxrwx 1 root   root           22 May 20 15:37 dotnet -> ../share/dotnet/dotnet

.. You can pipe to and from many CLI programs thanks to the standard use of strings as outputs and inputs. As a final example let's search through the help output of ``dotnet``. If you were to view the help output directly you would end up scrolling through many lines.

.. What if you just want to know how to publish a project (something we will soon cover)? We can use piping to automate the process of searching through the lines manually:

.. .. sourcecode:: bash
..    :caption: Linux/Bash

..    $ dotnet --help | grep 'publish'
..    publish           Publish a .NET project for deployment.


.. todo:: consider splitting scripting to own article 

Scripting
=========

Shell scripting is the process of automating a series of commands. The key to automation is to understand the logical steps needed to perform a task manually. In this course we will use scripting to automate operational tasks like provisioning and managing cloud resources on Azure. 

Early in the course we will provide you with scripts that you will be encouraged to read but not expected to write. After getting comfortable with the manual steps you will learn how to write and use your own scripts. 

Essentials
----------

Commands
^^^^^^^^

You can use any command in a script that you are able to issue manually in the Shell REPL. Unlike the REPL which will prompt you for the next command, scripts are written in a file with each independent command or statement occupying a single line.

A statement, like other languages, is an independent instruction like defining a variable or constructing a loop. We distinguish these from commands which refer to actual CLI programs like those you would call from the Shell REPL.

.. admonition:: note

   When providing code samples for scripts we will remove the ``$`` character used in REPL examples. Each separate line is its own command or statement.

Script File Extensions
^^^^^^^^^^^^^^^^^^^^^^

Because file extensions are arbitrary in Linux, a script file can have any extension (or none at all). However, it is customary to use the ``.sh`` extension as a note to signify that the script should be interpreted as Bash commands.

Comments
^^^^^^^^

As you have seen throughout the previous examples, comments can be used to annotate your scripts. In a Bash script you can write comments by preceding them with a ``#`` symbol. Anything after ``#`` is ignored by the Bash interpreter. Comments are a valuable addition to any script, especially when they get complex. Remember that comments should serve to explain the *why* not to dictate the *how* which the code already describes.

Executing a script
^^^^^^^^^^^^^^^^^^

The act of executing a script is the same evaluating a command entered into the REPL. An interpreter is needed to understand and execute the contents. In the REPL the interpreter is implied by the Shell -- Bash in our case. The Shell is actually a Bash REPL process that is listening for, interpreting and executing commands.

Recall that files in Linux are just strings of characters. It is **up to the program that interprets it** to decide what to do with its contents. When executing a script we have to define what program, like Bash or Python, that will interpret it. This can be done explicitly or implicitly. 

Explicit execution is when we use the interpreter program (``bash``) as a command and provide it with the path to the script file as an argument. For example if we had a Bash script file in our home (``~``) directory we can execute it like this:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ bash ~/my-script.sh

In other words when we want to execute a script explicitly we (the user) define the program we want to interpret it -- one of the core tenets covered earlier. As another example if we had a Python script we would naturally use the ``python`` interpreter to execute it:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ python ~/my-python-script.py

If we try to execute a script with the wrong interpreter it will fail. It would be like handing an English-speaking person a book in Japanese and asking them to interpret it!

.. admonition:: note

   Implicit execution is when the interpreter is defined inside the script using a special line at the top of the script file called a `shebang <https://linuxize.com/post/bash-shebang/>`_. 
   
   Implicit execution is more advanced but is the standard approach when working with scripts professionally. We will not be covering implicit execution at this time as it involves some other steps that are best covered when you are more comfortable with scripting and Bash in general.

The Executing User
^^^^^^^^^^^^^^^^^^

Commands in scripts are executed by the *user who executes the script*. While this might seem intuitive it does have an important implication. 

This means that if you (``student``) run a script then all of those commands will be issued by the ``student`` user and be *subject to the permissions of that user*. If you need to run privileged commands you must run it using a super user account. 

However, if you try to use ``sudo`` in the script a prompt would require you to authenticate as soon as it is executed -- a manual step that would defeat the purpose! 

.. admonition:: fun fact

   In the cloud the scripts we execute will run as ``root`` automatically and will not require the use of ``sudo``. 

Variables
---------

Earlier we discussed environment variables -- variables that affect every command and script executed in the Shell. You can also have variables that are only available within a script. In relatable programming terms, script variables are scoped to the script, whereas environment variables are globally scoped to the whole Shell.

Defining variables
^^^^^^^^^^^^^^^^^^

When defining variables in a script the convention is to use lowercase letters and separate words with underscores (``_``). Environment variables are written in all capital letters so they are easy to distinguish from script variables. 

Because Bash does not have any data types a variable is simple to declare and assign. First you define the name of the variable followed by an assignment symbol (``=``) and the string value of it on the right side.

.. admonition:: note

   Spaces are use to delimit, or distinguish, different parts of a command called **tokens**. Token splitting is what allows Bash to see a command along with its arguments and options as individual units to be evaluated -- each separated by a space. 

When defining a variable **there can be no spaces between the variable declaration and assignment**:

.. sourcecode:: bash
   :caption: Linux/Bash
   
   # correct: no spaces
   variable_name=value

   # wrong: spaces between declaration and assignment
   variable_name = value

When the value of a variable does not have any spaces it can be written as shown above. When you need to have spaces you can put single-quotes (`''`) around the value. These serve to group the whole string value together including the spaces:

.. sourcecode:: bash
   :caption: Linux/Bash

   variable_name='a longer value'

Substituting variables
^^^^^^^^^^^^^^^^^^^^^^

Once a variable has been defined (either in the script or a global environment variable) it can be referenced by prefixing a ``$`` symbol before it:

.. sourcecode:: bash
   :caption: Linux/Bash

   # define the variable
   my_variable='hello world'

   # reference the script variable
   $my_variable

   # reference a global variable
   $PATH

Variable Substitution
^^^^^^^^^^^^^^^^^^^^^

Referencing a variable is straightforward. But in most cases this process is done *inside* of a command, referencing in the open as we have done above has no effect. For this behavior Bash has a mechanism called **variable substitution**.

For example, consider this simple script that creates and moves a directory using variables to hold the paths. Above each command is a comment showing what the command looks like when its variables have been substituted.

Create a directory called ``bash-examples`` in your home (``~``) directory and open a new file called ``variable-substitution.sh`` within it. You can use any editor you would like to paste in the contents below.

.. sourcecode:: bash
   :caption:  ~/bash-examples/variable-substitution.sh

   target_path=/tmp/dir-name

   # ~ is a shorthand for /home/<username>
   destination_path=~/dir-name

   # mkdir /tmp/dirname
   mkdir "$target_path"

   # mv /tmp/dir-name ~/dir-name
   mv "$target_path" "$destination_path"

   # $HOME is an environment variable with a value of /home/<username>
   # ls /home/<username>
   ls "$HOME" 

You should now have a file with the path ``~/bash-examples/variable-substitution.sh`` that you can execute using ``bash`` as the interpreter:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ bash ~/bash-examples/variable-substitution.sh

You likely noticed that the variables are contained in double-quotes (``""``) when used in commands. This is a best practice when working with substitutions as it can prevent unintended behavior caused by spaces or special characters. This is especially true when scripts receive user input which, as you now know, should never be trusted!

.. admonition:: note

   You can read more about the behavior of `escape characters and single and double quotes <https://linux.101hacks.com/bash-scripting/quotes-inside-shell-script/>`_ in this article. If it goes over your head it's okay, just follow the best practice to stay safe and come back to understanding the *why* later.

Command Substitution
--------------------

**Command substitution**, as the name implies, is just like variable substitution but for commands. It allows you to execute a command within another command. We will see many examples of its usage throughout this course but for now consider the basic aspects of it.

We will refer to command substitutions interchangeably with **in-line evaluations** as they are evaluations performed *in the line* of a command being executed. An in-line evaluation allows you to *embed* a command within another like this:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ command $(sub-command)

In this example the ``sub-command`` will first be evaluated (in-line), then the main ``command`` will be evaluated. When the ``command`` is evaluated the output of ``$(sub-command)`` will *substituted in* as its argument. 

You can treat in-line evaluations as you would any other command, with arguments and options. The only difference is that, like all programming languages, commands are evaluated from the inside out. Any in-line evaluations will first be evaluated before stepping outwards and substituting their output.

Consider a more complicated example to understand how it works:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ command $(sub-command $(sub-sub-command))

This command would be evaluated in the following order:

#. innermost level: ``$(sub-sub-command)``
#. next level: ``$(sub-command <output of sub-sub-command>)``
#. outermost level: ``command <output of sub-command>``

This is particularly useful in scripts when you want to capture the output of a command in a variable. Because in-line evaluation is a more advanced topic we will return to it later in a context that necessitates it. For now consider the following contrived example where we store our "history" of working directories (WD) in variables to navigate around.

In your ``bash-examples`` directory create another file called ``command-substitution.sh`` and paste in the following contents. We will use the ``echo`` command to print out our CWD throughout the script:

.. sourcecode:: bash
   :caption: ~/bash-examples/command-substitution.sh

   # in-line evaluation in a string message
   echo "CWD is: $(pwd)"

   # in-line evaluation to assign the value
   first_wd=$(pwd)

   cd /tmp
   echo "CWD is: $(pwd)"

   second_wd=$(pwd)

   cd /usr/bin
   echo "CWD is: $(pwd)"

   third_wd=$(pwd)

   # return to the first
   echo "returning to first WD"
   cd "$first_wd"
   echo "CWD is: $(pwd)"

   # jump to the second
   echo "jumping to second WD"
   cd "$second_wd"
   echo "CWD is: $(pwd)"

Then execute the script the same way as before:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ bash ~/bash-examples/command-substitution.sh

.. admonition:: note

   As a good programmer you are likely miffed by the copy and pasting of an identical statement. Although we won't be getting into Bash functions you should be able to make sense of it. Here is a cleaner approach to help you sleep at night!

   .. sourcecode:: bash
      :caption: ~/bash-examples/command-substitution.sh
   
      print_cwd() {
         echo "CWD is: $(pwd)"
      }

      print_cwd

      first_wd=$(pwd)

      cd /tmp
      print_cwd

      second_wd=$(pwd)

      cd /usr/bin
      print_cwd

      third_wd=$(pwd)

      # return to the first
      echo "returning to first WD"
      cd "$first_wd"
      print_cwd

      # jump to the second
      echo "jumping to second WD"
      cd "$second_wd"
      print_cwd

Learn More
==========

This has been an introduction to the practical fundamentals of Bash. You are *not expected to have memorized any of it* by any means. Feel free to refer back to this article throughout the course to refresh your memory. Learning Bash takes a lot of time. We covered a lot of ground today and will be revisiting the fundamentals regularly until they become second nature.

If you want to learn more advanced usage this `Bash cheat-sheet from DevHints <https://devhints.io/bash>`_ will get you up to speed quickly. DevHints is an open source site filled with quick-reference guides for many languages and frameworks written by the open source community.
