===========================
Bash Scripting Fundamentals
===========================

Shell scripting is the process of automating a series of commands. The key to automation is to understand the logical steps needed to perform a task manually. In this course we will use scripting to automate operational tasks like provisioning and managing cloud resources on Azure. 

Early in the course we will provide you with scripts that you will be encouraged to read but not expected to write. After getting comfortable with the manual steps you will learn how to write and use your own scripts. 

Commands
========

You can use any command in a script that you are able to issue manually in the Shell REPL. Unlike the REPL which will prompt you for the next command, scripts are written in a file with each independent command or statement occupying a single line.

A statement, like other languages, is an independent instruction like defining a variable or constructing a loop. We distinguish these from commands which refer to actual CLI programs like those you would call from the Shell REPL.

.. admonition:: Note

   When providing code samples for scripts we will remove the ``$`` character used in REPL examples. Each separate line is its own command or statement.

Script File Extensions
======================

Because file extensions are arbitrary in Linux, a script file can have any extension (or none at all). However, it is customary to use the ``.sh`` extension as a note to signify that the script should be interpreted as Bash commands.

Comments
========

As you have seen throughout the previous examples, comments can be used to annotate your scripts. In a Bash script you can write comments by preceding them with a ``#`` symbol. Anything after ``#`` is ignored by the Bash interpreter. 

Comments are a valuable addition to any script, especially when they get complex. Remember that comments should serve to explain the *why* not to dictate the *how* which the code already describes.

Executing a script
==================

The act of executing a script is practically the same as executing a command entered into the REPL. An interpreter is needed to understand and execute the contents. In the REPL the interpreter is implied by the Shell -- Bash in our case. In interactive (REPL) mode the Shell is actually a Bash REPL process that is listening for, interpreting and executing commands.

Recall that files in Linux are just strings of characters. It is **up to the program that interprets a file** to decide what to do with its contents. When executing a script we have to define what program, like Bash or Python, will be used to interpret it. This can be done explicitly or implicitly. 

Explicit execution is when we use the interpreter program (``bash``) as a command and provide it with the path to the script file as an argument. For example if we had a Bash script file in our home (``~``) directory we can execute it like this:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ bash ~/my-script.sh

In other words when we want to execute a script explicitly we (the user) define the program we want to interpret it -- one of the core tenets covered earlier. As another example if we had a Python script we would naturally use the ``python`` interpreter to execute it:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ python ~/my-python-script.py

If we try to execute a script with the wrong interpreter it will fail. It would be like handing an English-speaking person a book in Japanese and asking them to interpret it!

.. admonition:: Note

   Implicit execution is when the interpreter is defined inside the script using a special line at the top of the script file called a `shebang <https://linuxize.com/post/bash-shebang/>`_. 
   
   Implicit execution is more advanced but is the standard approach when working with scripts professionally. We will not be covering implicit execution at this time as it involves some other steps that are best covered when you are more comfortable with scripting and Bash in general.

The Executing User
==================

Commands in scripts are executed by the *user who executes the script*. While this might seem intuitive it does have an important implication. 

This means that if you (``student``) run a script then all of those commands will be issued by the ``student`` user and be *subject to the permissions of that user*. If you need to run privileged commands you must run it using a super user account. 

However, if you try to use ``sudo`` in the script a prompt would require you to authenticate as soon as it is executed -- a manual step that would likely defeat the purpose! 

.. admonition:: Fun Fact

   In the cloud the scripts we execute will run as ``root`` automatically and will not require the use of ``sudo``.
