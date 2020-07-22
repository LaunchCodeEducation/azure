=================================================
Walkthrough: Navigating the File System With Bash
=================================================

Everything in the File System (FS) and commands that affect it are based around relative and absolute paths. Refer to the Shell introduction articles for a more detailed explanation. Below is a practical refresher:

- **relative path**: relative to a variable location, your current working directory (CWD)
- **absolute path**: relative to a constant location, the root directory (``/``)

You will notice that most of the FS related commands make use of path arguments that can be written as relative or absolute paths.

Navigation Essentials
=====================

Let's begin by reviewing the essential commands for navigating the FS from the command-line. If you have not already set up the Ubuntu VM with Bash refer to the installation walkthrough article before continuing.

.. admonition:: Note

   While you can simply read these commands and trust their outputs **it is important that you try them on your own machine**. The only way to integrate a new tool in your workflow is to practice with it!

Getting Help
------------

Most commands will provide documentation through the ``--help`` option or a ``man`` (manual) entry. When you are unsure about a command or want to learn more about how it is used you can use get help like this:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ command --help
   # prints help documentation

   $ man <command name>
   # enters a documentation viewer
   # scroll up with J key, down with K key
   # quit with Q key

.. admonition:: Note

   Like the ``man`` command you will find that many tools in Bash rely strictly on keyboard input rather than the use of a mouse. While this may seem foreign at first you will eventually get comfortable (and fast) at working without a mouse. Most of the CLI tools will follow the standard conventions for scrolling (``J`` and ``K``) and quitting (``Q``).
   
Show the CWD
------------

The ``pwd`` (print working directory) command will give you the absolute path of your current working directory (CWD) in the FS:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

If you are in a new Shell session it will default to a CWD of ``/home/<username>``.

Change directories
------------------

The ``cd`` (change directory) command takes one argument -- the relative or absolute path of where you want to go:

.. sourcecode:: bash
   :caption: Linux/Bash

   # relative paths begin with a './'
   $ cd ./path/name
   # or just the path name with no leading '/'
   $ cd path/name

   # absolute paths always begin from the root (/) directory
   cd /home/student/path/name

If you want to change to a directory using a relative path that is *under* your CWD this is straightforward. But what if you need to refer to a relative path *above* your CWD? For this Bash includes two special characters for relative references:

- `.` character: a single dot refers to *this directory*
- `..` characters: a double dot refers to the *parent directory* (up one directory)

We will discuss the use of the *this directory* character (``.``) soon. Consider the following example:

.. sourcecode:: bash

   /home/student
      /Downloads
         /album
      /Media <-- your target
         /Videos <-- your CWD

If you want to move to the `Media` directory *relative* to `Videos` you need to go *up one directory* level:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student/Media/Videos

   $ cd ../

   # for going up one directory only you can leave off the trailing '/'
   $ cd ..
   
   $ pwd
   /home/student/Media

What if you again start inside ``Videos`` and you want to switch to the ``album`` directory? 

.. sourcecode:: bash

   /home/student
      /Downloads
         /album <-- your target
      /Media
         /Videos <-- your CWD

Relative to where you are, you need to:

- go up one directory to the ``Media`` parent directory: ``../``
- go up one more level (home directory) where ``Media`` and ``Downloads`` are: ``../../``
- down a level into ``Downloads``: ``../Downloads``
- then down another level into ``album``: ``../Downloads/album``

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student/Media/Videos

   $ cd ../Downloads/album

   $ pwd
   /home/student/Downloads/album

This process can be repeated for going up (``../``) or down (``/``) as many times as needed to create the proper relative path. When in doubt check your CWD!

There are also two useful shorthands for quickly navigating around:

- ``~``: the tilda (next to the ``1`` key) is a shorthand for the home directory of the logged in user (relies on the ``$HOME`` environment variable) 
- ``-``: the dash character (next to the ``0`` key) is a shorthand for returning to the *previous* CWD (thanks to the ``$OLDPWD`` environment variable)

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student/Media

   $ cd ~
   $ pwd
   /home/student

   $ cd -
   $ pwd
   /home/student/Media

The ``~`` shorthand can also be used as a base *relative to HOME* path:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student/Media

   $ cd ~/Downloads/album
   $ pwd
   /home/student/Downloads/album

List directory contents
-----------------------

Our final navigation command is ``ls`` (list contents). As mentioned previously ``ls`` can be used with no arguments to view the contents of the CWD:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

   $ ls
   # contents of CWD ("empty" for a new user)

But ``ls`` can also be used view the contents of another directory using a relative or absolute path as its **argument**:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

   # absolute path
   $ ls /usr/bin
   # contents of the user binaries directory

   # relative path
   $ ls ../../usr/bin

Using command options
---------------------

You can provide options to ``ls`` to change the behavior of its output.

The ``-a`` option means *all* and modifies ``ls`` to show *all the files*, both visible and **hidden files**. 

.. admonition:: Tip

      Hidden files are special configuration files that are hidden to prevent accidental changes to them from consumers. However, when working with CLI tools you will often use these **dot files** as a way of configuring the way your tools behave on your machine.

While the home directory appeared empty earlier it actually contained several hidden files:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

   $ ls -a
   # hidden files like .bashrc, .profile

The ``-l`` option outputs in *long form* which shows additional details about the contents. 

In the following example it is combined with ``-a`` to see detailed information about the hidden files in the home directory:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

   # or shorthand: ls -al
   $ ls -a -l

In this output you can view details like the `file type and access mode <http://linuxcommand.org/lc3_lts0090.php>`_ as well as the `user and group <https://www.linode.com/docs/tools-reference/linux-users-and-groups/>`_ that owns the file. 

We will not go into permission modes and ownership in this class. However, it is worth knowing that regular files are denoted by a ``-`` character and directory files by the ``d`` character (on the far left of each file's information).

.. admonition:: Fun Fact

   Notice how the ``.`` and ``..`` are actually listed as *directory files* (the first ``d`` in the long output).
   
   The ``.`` and ``..`` are actually treated as *files* (because *everything is a file* in Linux). They refer to the *current directory file* and *parent (up) directory file* respectively.
