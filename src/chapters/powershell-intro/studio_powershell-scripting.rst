==================
Studio: PowerShell
==================

PowerShell like most languages and tools requires practice to facilitate learning and memory.

This article will give you a few tasks that you should accomplish using what you have learned about PowerShell from this chapter.

Setup Task
==========

As a part of this studio you will need to upload the scripts you write to GitHub.

The first script (``setup-repository.ps``) accomplishes the following tasks:

- create a script for this set of tasks named ``setup-repository.ps``
- create a project directory named ``powershell-studio`` in your home directory
- fork this repository
- clone the project repository into the ``powershell-studio``

.. admonition:: note

   As a bonus task you can automate the final steps of this task within your ``setup-repository.ps`` script by completing the following in your script:

   - move the ``setup-repository.ps`` script into the ``powershell-studio`` directory
   - from the ``powershell-studio`` directory add and commit the changes to git

After running the script successfully, push the script to GitHub.

Studio Task
===========

Using the ``Invoke-RestMethod`` cmdlet you will need to write various scripts to gather information from the `GitHub Developers API <https://developer.github.com/v3/>`_.

``Invoke-RestMethod`` was a bonus cmdlet from a previous article, so we will show you how to work with by using the simple `Open Notify API <http://api.open-notify.org/>`_.

Invoke-RestMethod Examples
--------------------------

The most simple example is making a GET request to the ``astros.json`` endpoint:

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

Continue exploring ``Invoke-RestMethod`` and the `Open Notify API <http://api.open-notify.org/>`_. The next section will require you to use the same PowerShell tools to gather, organize, and write data from the `GitHub Developers API <https://developer.github.com/v3/>`_.

LaunchCodeEducation Repositories
--------------------------------

Your first set of ``Invoke-RestMethod`` tasks will be accessing ``https://api.github.com/orgs/launchcodeeducation/repos``.

- create a file named ``launchcode-repos.ps`` to serve as a container for your following work
- how many repositories are returned when making a GET request to ``https://api.github.com/orgs/launchcodeeducation/repos``?
- what are the names of the repositories returned by a GET request to ``https://api.github.com/orgs/launchcodeeducation/repos``?
- save all the names of the repositories in alphabetical order as a CSV file named ``launchcode-education-repo-names.csv``
- are there any issues attached to the first repository in the list, if so how many?
- save the 

PowerShell Repository
---------------------

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


.. (Invoke-RestMethod -URI https://api.github.com/orgs/launchcodeeducation/repos)

- display to Table
- convert the JSON to a CSV
- put a bonus hit another API give (different CMDlets to use, and different Open Public API) (Convert-Tos) not bonus, but a requirement (min requirement -- must have an output file after doing some PS operations)
- hidden directory with solutions (for the TAs) (Create a directory in the project folder, but put it under /instructor)