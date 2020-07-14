==================
Studio: PowerShell
==================

PowerShell like most languages and tools, requires practice to facilitate learning and memory.

This article will give you a few tasks that you should accomplish using what you have learned about PowerShell from this chapter.

.. admonition:: tip

   There may be multiple ways to achieve the following tasks. Talk with your fellow classmates about how you solved the tasks.

Invoke-RestMethod Example
-------------------------

.. sourcecode:: powershell

   > Invoke-RestMethod -URI http://api.open-notify.org/astros.json

   message number people
   ------- ------ ------
   success      5 {@{craft=ISS; name=Chris Cassidy}, @{craft=ISS; name=Anatoly Iv…

.. sourcecode:: powershell

   > (Invoke-RestMethod -URI http://api.open-notify.org/astros.json).people

   craft name
   ----- ----
   ISS   Chris Cassidy
   ISS   Anatoly Ivanishin
   ISS   Ivan Vagner
   ISS   Doug Hurley
   ISS   Bob Behnken

.. sourcecode:: powershell

   > (Invoke-RestMethod -URI http://api.open-notify.org/astros.json) | Select-Object -Property people

   people
   ------
   {@{craft=ISS; name=Chris Cassidy}, @{craft=ISS; name=Anatoly Ivanishin}, @{cra…


.. sourcecode:: powershell

   > (Invoke-RestMethod -URI http://api.open-notify.org/astros.json).people | Select-Object -Property name

   name
   ----
   Chris Cassidy
   Anatoly Ivanishin
   Ivan Vagner
   Doug Hurley
   Bob Behnken

.. sourcecode:: powershell

   > $webRequest = Invoke-RestMethod -URI http://api.open-notify.org/astros.json 

.. sourcecode:: powershell

   > $webRequest.people

   craft name
   ----- ----
   ISS   Chris Cassidy
   ISS   Anatoly Ivanishin
   ISS   Ivan Vagner
   ISS   Doug Hurley
   ISS   Bob Behnken

.. sourcecode:: powershell

   > $webRequest.people[0].name

   Chris Cassidy

if we wanted to write the astronauts to a file

.. sourcecode:: powershell

   > New-Item -Type file -Name space-residents.txt -Value ($webRequest.people)


Setup Task
----------

As a part of this studio you will need to upload the scripts you write to GitHub.

The first script (``setup-repository.ps``) accomplishes the following tasks:

- create a script for this set of tasks named ``setup-repository.ps``
- create a project directory named ``powershell-studio`` in your home directory
- fork this repository
- clone the project repository into the ``powershell-studio``

admonition:: note

   As a bonus task you can automate the final steps of this task within your script by completing the following in your script:

   - move the ``setup-repository.ps`` script into the ``powershell-studio`` directory
   - from the ``powershell-studio`` directory add and commit the changes to git

After running the script successfully, push the script to GitHub.

Example Script
--------------

Submitting your work
--------------------

To submit your work you will 




.. :: comment: make a REST request to GitHub

.. :: comment: get all the repos of the LaunchCodeEducation

.. :: format: the top five in a table

.. :: write it in a script

.. :: can you do this in a pipe

.. :: comment: extension of that is to make a studio where they just do a scripted deployment with the AZ CLI

- create a repo

- setup a directory

- as a starter -- have them fork write a little script that will clone their forked repo (add a file to it ``name.txt``, stage, commit, and push all in one script)

script
   - clones
   - adds name.txt file
   - 

start with the solution write the thing first and then work backwards
   - make a web request


- how many total issues are there on the PowerShellCore repo?


- display to Table
- convert the JSON to a CSV
- put a bonus hit another API give (different CMDlets to use, and different Open Public API) (Convert-Tos) not bonus, but a requirement (min requirement -- must have an output file after doing some PS operations)
- hidden directory with solutions (for the TAs) (Create a directory in the project folder, but put it under /instructor)