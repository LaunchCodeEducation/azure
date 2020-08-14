==============================================
Walkthrough: Substitutions & Scripting in Bash
==============================================

In this walkthrough we will explore the concept of **substitution**. In Bash, and PowerShell, substitution is one of the most common features used when working from the command-line or writing scripts.

A substitution, as the name implies, will substitute a value into another expression. The substituted value can be a reference to a variable or an embedded command that will be executed before substituting its output.

Variables
=========

Earlier we discussed environment variables -- variables that affect every command and script executed in the Shell. You can also have variables that are only available within a script.

In relatable programming terms, **script variables are scoped to the script** whereas **environment variables are globally scoped** to the whole Shell.

Defining variables
------------------

When defining variables in a script the convention is to use lowercase letters and separate words with underscores (``_``). Environment variables are written in all capital letters so they are easy to distinguish from script variables. 

Because Bash does not have any data types a variable is simple to declare and assign. First you define the name of the variable followed by an assignment symbol (``=``) and the value of it on the right side.

.. admonition:: Note

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

Referencing variables
---------------------

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
=====================

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

Quoting syntax
--------------

You likely noticed that the variables are contained in double-quotes (``""``) when used in commands. This is a best practice when working with substitutions as it can prevent unintended behavior caused by spaces or special characters. This is especially true when scripts receive user input which, as you now know, should never be trusted!

.. admonition:: Note

   You can read more about the behavior of `escape characters and single and double quotes <https://linux.101hacks.com/bash-scripting/quotes-inside-shell-script/>`_ in this article. If it goes over your head it's okay, just follow the best practice to stay safe and come back to understanding the *why* later.

Command Substitution
====================

**Command substitution**, as the name implies, is just like variable substitution but for commands. It allows you to execute a command within another command. We will see many examples of its usage throughout this course but for now consider the basic aspects of it.

We will refer to command substitutions interchangeably with **in-line executions** as they are evaluations performed *in the line* of a command being executed. An in-line execution allows you to *embed* a command within another like this:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ command $(sub-command)

In this example the ``sub-command`` will first be evaluated (in-line), then the main ``command`` will be evaluated. When the ``command`` is evaluated the output of ``$(sub-command)`` will *substituted in* as its argument. 

You can treat in-line executions as you would any other command, with arguments and options. The only difference is that, like all programming languages, commands are evaluated from the inside out. Any in-line executions will first be evaluated before stepping outwards and substituting their output.

Consider a more complicated example to understand how it works:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ command $(sub-command $(sub-sub-command))

This command would be evaluated in the following order:

#. innermost level: ``$(sub-sub-command)``
#. next level: ``$(sub-command <output of sub-sub-command>)``
#. outermost level: ``command <output of sub-command>``

This is particularly useful in scripts when you want to capture the output of a command in a variable for reuse elsewhere in a script. 

Substitutions Practice in a Script
==================================

Because substitution is a more advanced topic we will return to it later in a context that necessitates it. For now consider the following contrived example where we store our "history" of working directories (WD) in variables to navigate around them.

In your ``bash-examples`` directory create another file called ``command-substitution.sh`` and paste in the following contents. We will use the ``echo`` command to print out our CWD throughout the script:

.. sourcecode:: bash
   :caption: ~/bash-examples/command-substitution.sh

   # in-line execution in a string message
   echo "CWD is: $(pwd)"

   # in-line execution to assign the value
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

.. admonition:: Note

   As a good programmer you are likely miffed by the copy and pasting of an identical statement. Although we won't be getting into `Bash functions <https://linuxize.com/post/bash-functions/>`_ you should be able to make sense of them. 
   
   Here is a cleaner approach to help you sleep at night!

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

This has been an introduction to the practical fundamentals of Bash. You are *not expected to have memorized any of it* by any means. Feel free to refer back to this article throughout the course to refresh your memory.

Learning Bash takes a lot of time. We covered a lot of ground today and will be revisiting the fundamentals regularly until they become second nature.

If you want to learn more advanced usage this `Bash cheat-sheet from DevHints <https://devhints.io/bash>`_ will get you up to speed quickly. DevHints is an open source site filled with quick-reference guides for many languages and frameworks. All of their guides are written and edited through contributions from the open source community.