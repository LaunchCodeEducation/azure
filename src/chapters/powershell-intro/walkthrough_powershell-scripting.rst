=================================
Walkthrough: PowerShell Scripting
=================================

Understanding a **scripting language is an important part** of the Operations toolkit. We have covered the basics, however to continue building skills with PowerShell you must continue researching and practicing. 

You can learn new scripting concepts, best practices, tips and tricks in many different ways, however one of the most effective ways is by using the documentation. 
   
   Learning to use the documentation for any tool is the difference between memorizing a few basic commands, and being able to learn what is necessary to solve practical problems.

The walkthrough & studio for this chapter will contain tasks that will provide you with an opportunity to practice PowerShell. You will be able to complete almost every task by simply using what you have learned throughout this chapter. However, we will also provide lots of references to the PowerShell documentation. Challenge yourself to look into these references as a chance to learn **and practice** new things.

.. admonition:: note

   To start things off the majority of the references will be specific links to cmdlets in:

   - `PowerShell Documentation <https://docs.microsoft.com/en-us/powershell/scripting/how-to-use-docs?view=powershell-7>`_
   - `PowerShell Utility Module <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/?view=powershell-7>`_
   - `PowerShell formatting examples <https://docs.microsoft.com/en-us/powershell/scripting/samples>`_

Running PowerShell Scripts
==========================

Allow script execution
----------------------

This walkthrough will require you to create and execute a PowerShell script. As a security measure Windows does not allow the execution of *unsigned*, or untrusted scripts by default. You will need to grant your PowerShell session an elevated `execution policy <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-5.1&redirectedfrom=MSDN>`_ to run your own scripts. 

.. admonition:: note

   As a best practice, this execution policy will only be applied to the *scope* of the PowerShell process that executes the command. If you end that process (by exiting or closing the PowerShell Terminal) you will have to call the cmdlet again.

We will be using the *least privileged access* necessary to run our scripts which corresponds to the ``RemoteSigned`` execution policy. 

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned

You can learn more about ``Set-ExecutionPolicy`` in its `cmdlet documentation <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7>`_.

Executing your first script
---------------------------

.. simple example showing variable and cmdlet usage
.. warning / reminder about file extensions importance in windows
.. provide script and blocks showing how to do implicit execution
.. link to quoting article to understand differences
.. link / ref back to sub-expressions article
.. ask them to try evaluating it in their head first before executing (get used to reading and parsing)

- `variables <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_variables?view=powershell-7#types-of-variables>`_ 
- `scopes <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scopes?view=powershell-7#powershell-scopes>`_ 
- `quoting <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7>`_

.. sourcecode:: powershell
   :caption: ~/hello-world.ps1

   $Name = 'Your Name'

   Write-Message "Hello $Name!"

   Write-Message "Can you let me out of here? I am stuck inside $(Get-Location)!!"

.. sourcecode:: powershell
   :caption: execute hello-world script

   # general form
   > .\path\to\script.ps1

   # execute the script
   > .\hello-world.ps1

Tips for writing scripts
------------------------

.. think about / try manual steps first
.. scripts as a way to compose the manual steps
.. look up documentation and understand the inputs / outputs / parameters of CLI programs and cmdlets
.. when modifying / moving / deleting files ALWAYS create a backup first 
   .. .bak extension common in bash, equiv in posh?
.. with these tips in mind here is how the studio will work
   .. a task, a breakdown, limited guidance and command banks

The Auto-Committing-Setup Script
================================

   A script that clones the forked studio repository, then *moves, adds, commits and pushes itself* back to GitHub automatically!

Before you can accomplish your first task you will need to `fork the studio repository <https://github.com/LaunchCodeEducation/powershell-practice>`_. This is the repo you will be working in for the remaining exercises.

This challenge will require you to create a PowerShell script named ``auto-committing-setup.ps1``. You can create this file anywhere and, if written correctly, it will still execute successfully. 

Let's consider the individual steps, or commands, that we need to compose in this script:

#. declare a ``$GitHubUsername`` variable with your username (this will be used to clone your forked repo)
#. declare a ``$CommitMessage`` variable with the value ``auto committed from auto-committing-setup.ps1!``
#. declare a ``$StudioRepoDir`` variable with the value of the path where the repo will be cloned
#. clone your forked repo into a directory at the ``$StudioRepoDir`` path
#. copy the ``auto-committing-setup.ps1`` script (**by its absolute path**) into the cloned repo directory
#. change into the cloned directory (``$StudioRepoDir``)
#. add the new script file in the cloned directory to ``git`` staging
#. commit the changes to the repo using the message variable (``$CommitMessage``)
#. push the local ``git`` history back to your forked repo

Limited Guidance
-----------------

Jump Start
^^^^^^^^^^

In order to jump start your script here are steps 1-4:

.. sourcecode:: powershell
   :caption: auto-committing-setup.ps1
      
   # declare variables
   $GitHubUsername=''
   $StudioRepoDir=''
   $CommitMessage='auto committed from auto-committing-setup.ps1!'

   # fork and clone this repo into the powershell-studio directory
   git clone "https://github.com/$GitHubUsername/powershell-practice" "$StudioRepoDir"

   # TODO: complete steps 5-9

Referencing the script path
^^^^^^^^^^^^^^^^^^^^^^^^^^^

To reference **the absolute path of the script** from inside the script itself you can use the ``$PSCommandPath`` `variable <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7#myinvocation>`_.

Setting a commit message
^^^^^^^^^^^^^^^^^^^^^^^^

When committing from the command-line you can use the ``-m`` option to attach a message:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > git commit -m "<message in here>"

Command Bank
------------

For this script you will use the following ``git`` and PowerShell commands.

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

.. admonition:: note

   As a bonus try capturing the ``$GitHubUsername`` and ``$StudioRepoDir`` variables from user input using the `Read-Host cmdlet <>`_. This `short article <https://www.itprotoday.com/powershell/prompting-user-input-powershell>`_ is a great primer.

Deliverable
-----------

Upon completing and executing the script it will automatically be pushed to your GitHub repository.

You will know you have completed this task correctly when your remote forked repository contains:

- a file named: ``auto-committing-setup.ps1``.
- a new commit with the message ``auto committed from auto-committing-setup.ps1!``

After it succeeds you can send the repo link to your TA for review.

Command-Line REST
=================

At various points through this class we have used Postman as a way for making requests to a RESTful API. Postman offers a GUI that is a very pleasant interface to work with, however a GUI is not always the best interface for a given job. 

PowerShell offers multiple cmdlets for making HTTP requests from the CLI. A benefit of making requests from the CLI is that you can combine as many requests as you want and run them in a single script. This gives you the power to test a RESTful API in a very quick manner. 

In this studio we will be using `Invoke-RestMethod <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7>`_, a cmdlet that allows you to make requests to a RESTful API. In a similar vein to Postman, ``Invoke-RestMethod`` allows you to set the request: URI, HTTP method, headers, body, and more. 

The ``Invoke-RestMethod`` cmdlet returns a JSON object so with PowerShell we can easily access any attached properties or sub-collections from the response body using the familiar dot-notation and collection index selection syntax ([0]). In addition many PowerShell cmdlets can take the JSON response object returned from ``Invoke-RestMethod`` as an argument when using pipes (|) and sub-expressions ($()).

Using ``Invoke-RestMethod`` we will be consuming the `GitHub Developers API <https://developer.github.com/v3/>`_. We will be analyzing API data around the `LaunchCodeEducation organization <https://github.com/launchcodeeducation/>`_, and the `PowerShell repository <https://github.com/powershell/powershell>`_.

Command Bank
------------

PowerShell Cmdlets
^^^^^^^^^^^^^^^^^^

- `Invoke-RestMethod <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7>`_
- `Select-Object <https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Select-Object?view=powershell-7>`_
- `Format-Table <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7>`_
- `Export-Csv <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-csv?view=powershell-7>`_
- `ConvertTo-Csv <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertto-csv?view=powershell-7>`_: pipe CSV object into `Add-Content <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/add-content?view=powershell-7>`_
- `Sort-Object <https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Sort-Object?view=powershell-7>`_

.. :: 

   command banks (distribute in each script that needs them)
      - `Invoke-RestMethod <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7>`_
      - `Select-Object <https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Select-Object?view=powershell-7`_
      - `Format-Table <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7>`_
      - `Export-Csv <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-csv?view=powershell-7>`_
      - `ConvertTo-Csv <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertto-csv?view=powershell-7>`_: pipe CSV object into `Add-Content <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/add-content?view=powershell-7>_
      - `Sort-Object <https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Sort-Object?view=powershell-7>`_
      - `Add-Content <https://education.launchcode.org/azure/chapters/powershell-intro/piping.html#adding-contents-to-a-file>`_
      - `Get-Member <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-member?view=powershell-7>`_: easily find a property or method of an object

To get your feet wet with ``Invoke-RestMethod`` we have provided some basic examples that work with the `Open Notify API <http://api.open-notify.org/>`_.

Invoke-RestMethod Examples
--------------------------

To start we will make a request for the astros.json file:

.. sourcecode:: powershell

   > Invoke-RestMethod -URI http://api.open-notify.org/astros.json

   message number people
   ------- ------ ------
   success      5 {@{craft=ISS; name=Chris Cassidy}, @{craft=ISS; name=Anatoly Iv…

Invoke-RestMethod returns a Custom Object that contains a message, and the payload of the request. The request was successful and the payload contains a string representation of JSON containing the number of people in space, and a collection of their names, and the space craft they are currently on.

Following is an example of how we could access just the ``people`` property of the Custom Object:

.. sourcecode:: powershell

   > (Invoke-RestMethod -URI http://api.open-notify.org/astros.json).people

   craft name
   ----- ----
   ISS   Chris Cassidy
   ISS   Anatoly Ivanishin
   ISS   Ivan Vagner
   ISS   Doug Hurley
   ISS   Bob Behnken

In this case we are simply looking at one field associated with the Custom Object, in this case all the astronauts currently in space.

If we want to filter it down further we can use a pipe and the ``Select-Object`` cmdlet:

.. sourcecode:: powershell

   > (Invoke-RestMethod -URI http://api.open-notify.org/astros.json).people | Select-Object -Property name

   name
   ----
   Chris Cassidy
   Anatoly Ivanishin
   Ivan Vagner
   Doug Hurley
   Bob Behnken

Storing the result in a variable becomes useful so we don't have to keep making the same request to access it's data:

.. sourcecode:: powershell

   > $webRequest = Invoke-RestMethod -URI http://api.open-notify.org/astros.json 

Then accessing the variable:

.. sourcecode:: powershell

   > $webRequest.people[0].name

   Chris Cassidy

.. sourcecode:: powershell

   > $webRequest.people

   craft name
   ----- ----
   ISS   Chris Cassidy
   ISS   Anatoly Ivanishin
   ISS   Ivan Vagner
   ISS   Doug Hurley
   ISS   Bob Behnken

We can even use our variable to determine how the data is sorted (``Sort-Object``):

.. sourcecode:: powershell

   > $webRequest.people | Sort-Object -Property name

   craft name
   ----- ----
   ISS   Anatoly Ivanishin
   ISS   Bob Behnken
   ISS   Chris Cassidy
   ISS   Doug Hurley
   ISS   Ivan Vagner

Combining everything so far we can convert our response to CSV:

.. sourcecode:: powershell

   > $webRequest.people | Sort-Object -Property name | ConvertTo-Csv
   
   "craft","name"
   "ISS","Anatoly Ivanishin"
   "ISS","Bob Behnken"
   "ISS","Chris Cassidy"
   "ISS","Doug Hurley"
   "ISS","Ivan Vagner"

And finally writing this data to a CSV file:

.. sourcecode:: powershell

   > $webRequest.people | Sort-Object -Property name | Export-Csv "people.csv"


.. sourcecode:: powershell

   > Get-Content people.csv
   
   "craft","name"
   "ISS","Anatoly Ivanishin"
   "ISS","Bob Behnken"
   "ISS","Chris Cassidy"
   "ISS","Doug Hurley"
   "ISS","Ivan Vagner"

The ``Invoke-RestMethod`` cmdlet is a powerful tool for working with APIs. When combined with our knowledge of PowerShell we have a huge toolbox of things we can do with the data. 

Continue exploring ``Invoke-RestMethod`` and the `Open Notify API <http://api.open-notify.org/>`_. The following studio will require you to use the same PowerShell tools to gather, organize, and write data from the `GitHub Developers API <https://developer.github.com/v3/>`_.

