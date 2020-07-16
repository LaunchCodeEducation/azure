==================
Studio: PowerShell
==================

.. ::

   tools students will need

   - `PowerShell documentation root <https://docs.microsoft.com/en-us/powershell/scripting/how-to-use-docs?view=powershell-7>`_
   - `PowerShell Utility Module <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/?view=powershell-7>`_
   - `PowerShell formatting examples <https://docs.microsoft.com/en-us/powershell/scripting/samples/using-format-commands-to-change-output-view?view=powershell-7>`_
   - `git clone <https://www.git-scm.com/docs/git-clone>`_
   - `git add <https://www.git-scm.com/docs/git-add>`_
   - `git commit <https://www.git-scm.com/docs/git-commit>`_
   - `git push <https://www.git-scm.com/docs/git-push>`_
   - `Move-Item <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/move-item?view=powershell-7>`_
   - `$PSCommandPath <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7#myinvocation>`_
   - `Set-Location <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-location?view=powershell-7>`_
   - `Invoke-RestMethod <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7>`_
   - `Select-Object <https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Select-Object?view=powershell-7`_
   - `Format-Table <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7>`_
   - `Export-Csv <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-csv?view=powershell-7>`_
   - `ConvertTo-Csv <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertto-csv?view=powershell-7>`_: pipe CSV object into `Add-Content <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/add-content?view=powershell-7>_
   - `Sort-Object <https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Sort-Object?view=powershell-7>`_
   - `add content <https://education.launchcode.org/azure/chapters/powershell-intro/piping.html#adding-contents-to-a-file>`_
   - 
   - `Get-Member <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-member?view=powershell-7>`_: easily find a property or method of an object

This article will give you a few tasks that you should accomplish using what you have learned about PowerShell from this chapter. There is no better substitute than practice to learn a tool. When working through the tasks of this article try out different processes to solve the problems.

.. admonition:: note

   A great way to bolster your understanding of PowerShell is to read more and practice what you have learned. We recommend looking over the following articles and using what you learn throughout this studio:

   - `variables <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_variables?view=powershell-7#types-of-variables>`_ 
   - `scopes <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scopes?view=powershell-7#powershell-scopes>`_ 
   - `quoting <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7>`_
 

.. example of creating and running a hello world script file


Setup PowerShell
================

This studio will require you to create and execute a PowerShell script. By default Windows does not let just any user run scripts. You will need to grant your PowerShell session an elevated `execution policy <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-5.1&redirectedfrom=MSDN>`_ to run scripts. This execution policy will only be enabled for the PowerShell session that executes the command.

We will be using the *least privileged access* necessary to run our scripts which is the ``RemoteSigned`` execution policy.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned

.. admonition:: note

   You can learn more about by reading the `Microsoft Set-ExecutionPolicy cmdlet <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7>`_ documentation

Setup Task
==========

Before you can accomplish your first task you will need to `fork the studio repository <https://github.com/LaunchCodeEducation/powershell-practice>`_.

To complete this first task you will need to create a PowerShell script named ``setup-repository.ps1`` that accomplishes the following tasks:

- declare a commit message variable with the value ``auto committed from setup-repository.ps1!``
- declare a directory variable where the repo will be cloned
- clone your forked repo into a directory named: directory variable
- move the ``setup-repository.ps1`` script into the cloned directory
- change into the cloned directory (directory variable)
- add everything in the cloned directory to staging
- commit with the message variable (commit message variable)
- push to your forked repo

.. comment:: tip: here are the commands you will likely be using

.. admonition:: tip

   To reference a script from inside the script itself you can use the $PSCommandPath variable.

Upon completing and running the script it will automatically be pushed to your GitHub repository.

You will know you have completed this task correctly when your remote forked repository contains a new commit with the message ``committed from setup-repository!`` and contains a file named: ``setup-repository.ps1``. There will also be two additional ``.ps1`` files that you will work with in the next two tasks.

Studio Tasks
============

Using the ``Invoke-RestMethod`` cmdlet you will need to write various scripts to gather information from the `GitHub Developers API <https://developer.github.com/v3/>`_.

``Invoke-RestMethod`` was a bonus cmdlet from a previous article, so we will show you how to work with by using the simple `Open Notify API <http://api.open-notify.org/>`_.

Invoke-RestMethod Examples
--------------------------

The most simple example is making a request to the Open Notify API ``astros.json`` endpoint:

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

We can even use our variable to determine how the data is stored (``Sort-Object``):

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

Continue exploring ``Invoke-RestMethod`` and the `Open Notify API <http://api.open-notify.org/>`_. The next sections will require you to use the same PowerShell tools to gather, organize, and write data from the `GitHub Developers API <https://developer.github.com/v3/>`_.

LaunchCodeEducation Repositories
--------------------------------

In the repository you cloned you will find a file named ``launchcode-repos.ps1``. This script file has prompts for you to solve using PowerShell. After using PowerShell to answer the prompt copy your command underneath the prompt in the file.

The prompts in the file are:

- how many repositories are returned when making a GET request to ``https://api.github.com/orgs/launchcodeeducation/repos``?
- what are the names of the repositories returned by a GET request to ``https://api.github.com/orgs/launchcodeeducation/repos``?
- save all the names of the repositories in alphabetical order as a CSV file named ``launchcode-education-repo-names.csv``
- are there any issues attached to the first repository in the list?
- what is the issues_url for the first repository in the list?
- make a new request to that issues_url
- how many issues are found
- how would you access the 5th issues of this list
- what is the id, title, and URL for the fifth issues in this list?


Upon completing this file push it to your GitHub repository don't forget to push the ``launchcode-education-repo-names.csv`` file you created in one step as well.

PowerShell Repository
---------------------

You also need to answer the prompts in the ``powershell-repo.ps1`` file:

- Invoke-RestMethod -URI https://api.github.com/repos/powershell/powershell
- how many github users are watching the powershell repo and how many users have subscribed to the powershell repo
- when was the repo created
- what is the subscribers URL
- how many users are returned when you make a request to the subscribers url?
- what are the login usernames of the subscribers found at that URL in alphabetical order
- what was the login name of the most recent commit?
- when was the most recent pull request created and has it been merged?
- what was the login name of the user that made the most recent pull request, and what is the URL to their profile


After completing the prompts push your changes to GitHub.

Submitting your work
--------------------

After completing and pushing:

- ``setup.ps1``
- ``launchcode-repos.ps1``
- ``powershell-repo.ps1``

notify your TA. With any remaining time in the class continue exploring with PowerShell by looking into more of the URLs returned in the various GitHub API endpoints we visited. A huge amount of data is now accessible at your fingertips!

Finished Early?
---------------

If you finish early pair with another student that has finished and compare your script files. Work together to come up with a one line powershell command for each prompt.