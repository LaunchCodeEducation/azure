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