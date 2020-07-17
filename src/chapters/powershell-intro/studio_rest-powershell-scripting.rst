============================
Studio: PowerShell Scripting
============================

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


Command-Line REST
=================

At various points through this class we have used Postman as a way for making requests to a RESTful API. Postman offers a GUI that is a very pleasant interface to work with, however a GUI is not always the best interface for a given job. 

PowerShell offers multiple cmdlets for making HTTP requests from the CLI. A benefit of making requests from the CLI is that you can combine as many requests as you want and run them in a single script. This gives you the power to script interactions with a RESTful API to automate tasks. 

In this studio we will be using `Invoke-RestMethod <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7>`_, a cmdlet that allows you to make requests to a RESTful API. In a similar vein to Postman, ``Invoke-RestMethod`` allows you to set the request: URI, HTTP method, headers, body, and more. 

The ``Invoke-RestMethod`` cmdlet returns a JSON object that is seamless to interact with using PowerShell. We can easily access any attached properties or sub-collections from the response body using the familiar dot-notation and collection index selection syntax ([0]). In addition many PowerShell cmdlets can take the JSON response object returned from ``Invoke-RestMethod`` as an argument when using pipes (|) and sub-expressions ($()).

Using ``Invoke-RestMethod`` we will be consuming the `GitHub Developers API <https://developer.github.com/v3/>`_. We will be analyzing API data around the `LaunchCodeEducation organization <https://github.com/launchcodeeducation/>`_, and the `PowerShell repository <https://github.com/powershell/powershell>`_.

Command Bank
------------

PowerShell Cmdlets
^^^^^^^^^^^^^^^^^^

- `Invoke-RestMethod <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7>`_: 
- `Select-Object <https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Select-Object?view=powershell-7>`_
- `Export-Csv <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-csv?view=powershell-7>`_
- `ConvertTo-Csv <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertto-csv?view=powershell-7>`_: pipe CSV object into `Add-Content <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/add-content?view=powershell-7>`_
- `Sort-Object <https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Sort-Object?view=powershell-7>`_

To get your feet wet with ``Invoke-RestMethod`` we have provided some basic examples that work with the `Open Notify API <http://api.open-notify.org/>`_.

Invoke-RestMethod Examples
--------------------------

To start we will make a request for the ``astros.json`` file:

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

Generating Repo-Bot Data
========================

.. show https://developer.github.com/v3/#pagination

Discovery
---------

.. instructions for discovery of the individual fields / data they will be accessing in bulk in the script


.. pick one of the options below (LC org or PS repo)

Submitting your work
^^^^^^^^^^^^^^^^^^^^

.. have them gather in a file, commit and push then send to TA for review before moving to scripting

LC Org 
------

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

- starter code
   - if (has_issues)
- a script that outputs the name, link, issues count, across all the repos


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

Scripting
---------

   describe the scripting task in 1-2 sentences

hard requirements list

#.
#.
#. after generating the CSV use ``git`` to stage, commit and push to the forked practice repo

Submitting your work
^^^^^^^^^^^^^^^^^^^^

Upon completing and executing the script it will automatically be pushed to the forked GitHub repository. You will know you have completed this task correctly when your remote forked repository contains:

- a file named: ``auto-committing-setup.ps1``.
- a new commit with the message ``auto committed from auto-committing-setup.ps1!``

After it succeeds you can send the repo link to your TA for review.

Bonus
=====

With any remaining time in the class continue exploring with PowerShell by looking into more of the URLs returned in the various GitHub API endpoints we visited. A huge amount of data is now accessible at your fingertips!

If you finish early pair with another student that has finished and compare your script files. Work together to come up with a one line powershell command for each prompt.