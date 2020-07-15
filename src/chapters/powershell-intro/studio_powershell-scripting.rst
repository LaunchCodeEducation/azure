==================
Studio: PowerShell
==================

PowerShell like most languages and tools requires practice to facilitate learning and memory.

This article will give you a few tasks that you should accomplish using what you have learned about PowerShell from this chapter.

Setup Task
==========

.. repo they will clone https://github.com/LaunchCodeEducation/powershell-practice

.. repo has 2 files: ``launchcode-repos.ps`` and ``powershell-repo.ps`` they have prompts in the file for how the student can complete the tasks

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

Studio Tasks
============

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

In the repository you cloned you will find a file named ``launchcode-repos.ps``. This script file has prompts for you to solve using PowerShell. After using PowerShell to answer the prompt copy your command underneath the prompt in the file.

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

You also need to answer the prompts in the ``powershell-repo.ps`` file:

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

Upon completing and pushing:

- ``setup.ps``
- ``launchcode-repos.ps``
- ``powershell-repo.ps``

Notify your TA of your completion. With any remaining time in the class continue exploring with PowerShell by looking into more of the URLs returned in the various GitHub API endpoints we visited. A huge amount of data is now accessible at your fingertips!