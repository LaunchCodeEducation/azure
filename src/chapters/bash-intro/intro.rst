=================
Bash Fundamentals
=================

From this point forward all of the commands and examples will be in Bash and need to be entered into the Ubuntu Terminal. As mentioned previously, we will distinguish Bash commands from PowerShell commands by using the ``$`` symbol instead of ``>``. 

This chapter covers the fundamental aspects of working with Bash. Like other programming languages Bash has more depth than can be covered as an introduction. The topics covered here will give you a foundation to build the rest of your learning on top of. 

.. admonition:: Note

   Because PowerShell was inspired by Bash they share many commonalities. This chapter will lay the foundation of working with Shells through the lens of Bash and Linux. In the PowerShell chapter we will focus more on PowerShell syntax rather than explaining the mental model of working from the command-line. 

Core Tenets
===========

While learning Bash and Linux some commands and behaviors will seem foreign to you if you come from a Windows background. Keep in mind the following aspects of Linux and Bash to help you understand why things work the way they do:

File System Paths
-----------------

The Linux File System (FS) has the following design:

- file paths are separated by forward slashes (``/``)
- there is a single root directory, absolute paths are written relative to **root** with the path ``/``

Everything is a file*
---------------------

In Linux *everything is a file descriptor*. This means that everything including regular text files, directories, devices and even processes are all treated as files. There are 7 `types of files <https://linuxconfig.org/identifying-file-types-in-linux>`_ in Linux and they *don't refer to file extensions*.

The majority of the time you will be working with:

- **regular files**: individual text files (denoted by ``-``)
- **directory files**: container files (denoted by ``d``)

Everything is a string
----------------------

There are **no data types** in Bash. All of the inputs and outputs of Bash commands are strings of characters. By extension, the contents of files in Linux are also treated as strings of characters (in a `character encoding <https://en.wikipedia.org/wiki/Character_encoding>`_). 

File extensions are arbitrary
-----------------------------

It is up to the consumer of a file (a program) to decide how to interpret the characters in it. In other words, *the Linux OS is not opinionated about how a file is used*.

In Linux-land a file extension is not required and only serves as a note for the user to choose a program that will interpret its contents.