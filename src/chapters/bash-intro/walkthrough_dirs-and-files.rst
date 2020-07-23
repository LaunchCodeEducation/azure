=====================================================
Walkthrough: Working With Directories & Files in Bash
=====================================================

Now that we have learned some essential FS commands we can learn more about working with directories and files. For simplicity we will refer to **regular files** as just files from this point forward. Distinguishing them from the other Linux file types is not necessary for the scope of our learning.

Directory Operations
====================

Let's practice some common directory operations. We will learn these through simple examples but the concepts and commands will apply to all of the directory work you do in the future.

Create a directory
------------------

The ``mkdir`` (make directory) command creates directories using a relative or absolute path argument. If just the name of a directory is given then it is created *relative to* the CWD. If the absolute path is provided the directory is created at that *exact* location.

By convention Linux directories do not use spaces in them. Space characters can conflict with the spaces between command arguments so they are avoided. In order to create a multi-word directory name the convention uses dashes (``-``) to separate the words. 

Let's create a ``parent-dir`` and ``child-dir`` using ``mkdir``:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

   # relative to the CWD
   $ mkdir parent-dir

   # an absolute path in the /tmp (temporary) directory
   $ mkdir /tmp/child-dir

   # mkdir can create multiple (space-separated) dirs at once
   $ mkdir parent-dir /tmp/child-dir

View directory contents
-----------------------

Now if we list the contents of the CWD (home dir) and the ``/tmp`` dir we should see our new directories:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

   $ ls
   parent-dir

   $ ls /tmp
   # trimmed output
   child-dir

We can also see that both the new directories are empty:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

   # relative path
   $ ls parent-dir
   # empty contents

   # absolute path
   $ ls /tmp/child-dir
   # empty contents

Move a directory
----------------

We can move a directory to a new location using the ``mv`` command. Once again, its arguments accept relative or absolute paths. The ``mv`` command takes a target and destination path as its first and second arguments:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ mv <path to target> <path to destination>

Let's move the ``child-dir`` from its current parent directory (``/tmp``) into the new one we made:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

   # from absolute path (target) to relative path (destination)
   $ mv /tmp/child-dir parent-dir/child-dir
   
   $ ls /tmp
   # the child-dir no longer exists at this location

   $ ls parent-dir
   child-dir

Copy a directory
----------------

Copying files uses the ``cp`` command. The ``cp`` command behaves nearly identically to the ``mv`` command except it *copies* instead of *moving* the file(s). Just like the move command you can copy *any file* whether it is a regular or directory file.

However, to copy a directory is not as simple as copying a single file. A directory inherently can contain contents including other directories and regular files. For this reason the ``-r`` (recursive) option is used.

The recursive option instructs the ``cp`` command to copy the directory *recursively*. It does this by recursing into each nested directory and copying its contents as well.

Let's move our ``parent-dir`` to the ``/tmp`` dir:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

   $ ls
   parent-dir
   
   $ ls parent-dir
   child-dir

   $ cp -r parent-dir /tmp/parent-dir

Now let's confirm the move by checking the ``/tmp`` dir:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ ls /tmp
   parent-dir

   $ ls /tmp/parent-dir
   child-dir

Notice how it copied the ``parent-dir`` and *recursed* into it to copy all of the sub-directories as well.

Delete a directory
------------------

.. admonition:: Warning

   The command to delete files is **not to be taken lightly**. When you delete a file or directory through the GUI it will conveniently store the deleted contents in a recycling bin where they can be recovered.

   In the Shell a **deletion is permanent** and nearly **instantaneous**. For this reason it is imperative that any delete commands you enter **always use an absolute path** to be explicit and prevent mistakes.
   
   While we stressed being cautious before it is imperative to be **extra cautious** when deleting files using Bash:

   **DO NOT STRAY FROM THE FOLLOWING COMMAND DIRECTIONS**

The command for deleting, or *removing*, files is ``rm``. When deleting a directory, just like ``cp``, the ``-r`` option will instruct it to do so *recursively*.

Let's clean up the directories we created using the remove command. 

We will also include the ``-i`` (interactive) option as a safety measure. This will require us to explicitly confirm the removal of each file before it is deleted. For each prompt you can confirm the deletion by entering the ``y`` character:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ ls /tmp/parent-dir
   child-dir

   $ rm -i -r /tmp/parent-dir
   # for each prompt type y and hit enter (for yes)

   $ ls /tmp/parent-dir
   ls: cannot access '/tmp/parent-dir': No such file or directory
   
File Operations
===============

As we move from directory to file operations consider one of the core tenets of Linux -- **everything is a file**.

Why is this valuable to consider? Because most of the commands used for directory operations are identical for regular files! When dealing with regular files the ``-r`` (recursive) option is no longer needed since it is an *individual file* rather than a container like a directory:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ mv path/to/target/file path/to/destination/file

   $ cp path/to/target/file path/to/destination/file

   $ rm -i path/to/target/file

Create a file
-------------

In Bash you can create a file in several different ways. Bash and Linux users are accustomed to using **CLI text editors** for creating and modifying files. Whereas on Windows the preference is for using a GUI based editor like ``notepad``.

Bash also includes `redirection operators <https://www.guru99.com/linux-redirection.html>`_ which can be used to *redirect* the output of a command into a new location -- like a new file or new lines on an existing file.

Due to the scope of this class, we will not be covering CLI editors or the redirect operators but you can use the links above to learn more about them. Instead, we will introduce a much simpler command.

The ``touch`` command can be used to create an empty file. It takes a relative or absolute path ending in the file's name as an argument:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ touch path/to/file-name

.. admonition:: Fun Fact

   Technically the ``touch`` command is used for updating the last time the file was *touched* (the last-accessed or modified timestamp). But most of the time it is used for its *side-effect* of creating the file if it doesn't already exist to be touched!

Let's create a file called ``my-file`` in a directory called ``my-files``:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

   $ mkdir my-files
   $ touch my-files/my-file

   $ ls my-files
   my-file

View file contents
------------------

Although *everything is a file* not every file can be *interpreted the same way*. Directories, as container files, naturally need a mechanism for listing their contents -- the ``ls`` command. But regular files are just collections of characters. Listing those out would be a mess!

When viewing the contents of a file we can use the ``cat`` command. The ``cat`` command stands for *concatenate* and serves to combine strings of characters. Just like ``touch`` it is often used for the side effect of printing out the contents of a file.

In other words it is concatenating the contents of the file with *nothing* resulting in just the contents being printed to the Terminal.

You can use the ``cat`` command to print the contents of a file by providing the absolute or relative path to that file. Let's try viewing the contents of the hidden file ``.bash_history`` which shows a history of all the commands you have entered recently:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

   $ cat .bash_history
   # your command history!

Sometimes printing the *entire contents* to the Terminal is too verbose. This would be like viewing a 50 page book all at once. Instead we can use the ``less`` command to show *less* at one time -- similar to scrolling through the pages instead. 

The ``less`` command works the same way as ``cat``, by providing it an absolute or relative path. 

Once the program opens you can navigate using the following keyboard keys. Some terminals also allow scrolling with the mouse wheel:

- ``J``: scroll down one line
- ``K``: scroll up one line
- ``Q``: quit the ``less`` program and return to the Shell

Let's try viewing the ``.bashrc`` file this time. If the contents of this file look terrifying don't worry! You won't need to write or edit any of it. But it serves as a lengthy file to practice scrolling with ``less``:

.. sourcecode:: bash
   :caption: Linux/Bash

   $ pwd
   /home/student

   $ less .bashrc
   # less program opens the file, use J and K to scroll and Q to quit