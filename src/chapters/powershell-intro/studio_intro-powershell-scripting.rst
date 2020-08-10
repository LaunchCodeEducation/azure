============================================
Studio: Introduction to PowerShell Scripting
============================================

Understanding a scripting language is an important part of the operations toolkit. We have covered the basics of *individual commands*. However, to use any shell language at a professional level you must delve into scripting.

You can learn new scripting concepts, best practices, and tips and tricks in many different ways. One of the most effective ways to accelerate your learning is by using documentation. 
   
.. admonition:: Tip

   Learning to use the documentation of your tools is the difference between memorizing a few basic commands and being able to compose solutions to solve practical problems.

In this and the following studio, we will reference documentation for the tools used in accomplishing the tasks. The majority of the references will be specific links in the `PowerShell Utility Module <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/?view=powershell-7>`_

.. admonition:: Tip

   The `PowerShell Documentation <https://docs.microsoft.com/en-us/powershell/scripting/how-to-use-docs?view=powershell-7>`_ is extensive and easy to navigate. Every cmdlet documentation includes practical examples to help you with common tasks.

Running PowerShell Scripts
==========================

Allow script execution
----------------------

This walkthrough will require you to create and execute PowerShell scripts. As a security measure, Windows does not allow the execution of *unsigned*, or untrusted scripts by default. You will need to grant your PowerShell session an elevated `execution policy <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-5.1&redirectedfrom=MSDN>`_ to run your own scripts. 

.. admonition:: Note

   As a best practice, this execution policy will only be applied to the *scope* of the PowerShell process that executes the command. If you end that process (by exiting or closing the PowerShell Terminal) you will have to call the cmdlet again.

We will be using the *least privileged access* necessary to run our scripts, which corresponds to the ``RemoteSigned`` execution policy. 

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned

Executing your first script
---------------------------

As a reminder, one of the core tenets of Windows is that all files must have a specific extension. The ``.ps1`` extension indicates that the file should be executed by PowerShell. You can create PowerShell scripts using any editor such as VS Code or even ``notepad``.

.. admonition:: Tip

   You can open a file in ``notepad`` from the command-line using an absolute or relative path to the file:

   .. sourcecode:: powershell
      :caption: Windows/PowerShell
   
      > notepad path/to/file.ext

   If the file does not yet exist, it will create it for you.

Creating a PowerShell Script
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The first script we will write will make use of the variable and sub-expression substitutions covered in the previous articles. You can use the following links to learn more about using `variables <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_variables?view=powershell-7#types-of-variables>`_ and variable `scopes <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scopes?view=powershell-7#powershell-scopes>`_.

Using the editor of your choice, create the ``hello-world.ps1`` file in your home (``~``) directory:

.. sourcecode:: powershell
   :caption: ~/hello-world.ps1

   $Name = 'Your Name'

   Write-Output "Hello $Name!"

   Write-Output "Can you let me out of here? I am stuck inside $(Get-Location)!!"

.. admonition:: Note

   Notice how *literal* strings (those that do not go under substitution), such as the ``$Name`` variable, use single quotes. Strings that *do undergo* substitution, like those printed by ``Write-Output``, use double-quotes. 
   
   You can read more about the effect of quoting in the `About Quoting documentation <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7>`_

Along with learning how to *write* scripts it is equally important to learn how to *read* them. Before we execute the script, try parsing it in your head. What do you expect to be printed to the PowerShell Terminal? 

Executing a PowerShell Script
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Recall in the Bash chapter that *implicit execution* of scripts required us to `define the script interpreter <https://linuxize.com/post/bash-shebang/>`_ at the top of the script file. Otherwise we needed to *explicitly execute* a script by providing the file path as input to its interpreter program, like ``bash`` or ``python``. 

In PowerShell, the Windows standard for file extensions means that every file's interpreter is pre-defined. This means they can be executed implicitly by referencing the script's filename.

Try executing the ``hello-world.ps1`` script:

.. sourcecode:: powershell
   :caption: execute ~/hello-world.ps1 script

   # general form
   > .\path\to\script.ps1

   # execute the script
   > .\hello-world.ps1

.. admonition:: Note

   Did the output match what you expected when reading the script? If not, then ask your TA or instructor to guide you in correcting your understanding.

.. Tips for writing scripts
.. ------------------------

.. think about / try manual steps first
.. scripts as a way to compose the manual steps
.. look up documentation and understand the inputs / outputs / parameters of CLI programs and cmdlets
.. when modifying / moving / deleting files ALWAYS create a backup first 
   .. .bak extension common in bash, equiv in posh?
.. with these tips in mind here is how the studio will work
   .. a task, a breakdown, limited guidance and command banks

The Auto-Committing-Setup Script
================================

In this section, you will write a more complex script that clones the forked practice repository, then *moves, adds, commits, and pushes itself* back to GitHub automatically!

You will need to `fork the practice repository <https://github.com/LaunchCodeEducation/powershell-practice>`_ before continuing. This is the repo you will be working in for the remaining studio exercises.

This challenge will require you to create a PowerShell script named ``auto-committing-setup.ps1``. You can create this file *anywhere in your file system* and, if written correctly, it will still execute successfully. 

Requirements
------------

Let's consider the individual steps, or commands, that we need to compose in this script:

#. Declare a ``$GitHubUsername`` variable with your username (this will be used to clone your forked repo)
#. Declare a ``$CommitMessage`` variable with the value ``auto committed from auto-committing-setup.ps1!``
#. Declare a ``$PracticeRepoDir`` variable with the value of the path where the repo will be cloned
#. Clone your forked repo into a directory at the ``$PracticeRepoDir`` path
#. Copy the ``auto-committing-setup.ps1`` script (**by its absolute path**) into the cloned repo directory
#. Change into the cloned directory (``$PracticeRepoDir``)
#. Add the new script file in the cloned directory to ``git`` staging
#. Commit the changes to the repo using the message variable (``$CommitMessage``)
#. Push the local ``git`` history back to your forked repo

Limited Guidance
-----------------

Jump Start
^^^^^^^^^^

In order to jump start your script, here are steps 1-4:

.. sourcecode:: powershell
   :caption: auto-committing-setup.ps1
      
   # declare variables
   $GitHubUsername=''
   $PracticeRepoDir=''
   $CommitMessage='auto committed from auto-committing-setup.ps1!'

   # fork and clone this repo into the powershell-studio directory
   git clone "https://github.com/$GitHubUsername/powershell-practice" "$PracticeRepoDir"

   # TODO: complete steps 5-9

Referencing the Script Path
^^^^^^^^^^^^^^^^^^^^^^^^^^^

To reference *the absolute path of the script* from inside the script itself you can use the ``$PSCommandPath`` `variable <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7#myinvocation>`_.

For example, if you have a script located at the filepath ``~/scripts/my-script.ps1`` that prints the ``$PSCommandPath`` variable:

.. sourcecode:: powershell
   :caption: ~/scripts/my-script.ps1

   Write-Output "PSCommandPath is: $PSCommandPath"

Executing this script from the home directory would print the following output:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > .\scripts\my-script.ps1

   PSCommandPath is: C:\Users\<username>\scripts\my-script.ps1

Setting a Commit Message
^^^^^^^^^^^^^^^^^^^^^^^^

When committing from the command-line, you can use the ``-m`` option to attach a message:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > git commit -m "<message in here>"

Command Bank
------------

For this script, you will use the following ``git`` and PowerShell commands.

Git Commands
^^^^^^^^^^^^

- `git clone <https://www.git-scm.com/docs/git-clone>`_
- `git add <https://www.git-scm.com/docs/git-add>`_
- `git commit <https://www.git-scm.com/docs/git-commit>`_
- `git push <https://www.git-scm.com/docs/git-push>`_

PowerShell Cmdlets
^^^^^^^^^^^^^^^^^^

- `Copy-Item <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/copy-item?view=powershell-7>`_
- `Set-Location <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-location?view=powershell-7>`_

.. admonition:: Note

   As a bonus, try capturing the ``$GitHubUsername`` and ``$PracticeRepoDir`` variables from user input using the `Read-Host cmdlet <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/read-host?view=powershell-7>`_. This `short article <https://www.itprotoday.com/powershell/prompting-user-input-powershell>`_ is a great primer.

Submitting your work
--------------------

Upon completing and executing the script, it will automatically be pushed to your GitHub repository. You will know you have completed this task correctly when your remote forked repository contains:

- A file named: ``auto-committing-setup.ps1``.
- A new commit with the message ``auto committed from auto-committing-setup.ps1!``

After it succeeds, you can send the repo link to your TA for review.

.. Bonus
.. =====
