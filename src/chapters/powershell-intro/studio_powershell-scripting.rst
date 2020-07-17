============================
Studio: PowerShell Scripting
============================

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

Submitting your work
--------------------

After completing and pushing:

- ``auto-committing-setup.ps1``
- ``launchcode-repos.ps1``
- ``powershell-repo.ps1``

notify your TA. With any remaining time in the class continue exploring with PowerShell by looking into more of the URLs returned in the various GitHub API endpoints we visited. A huge amount of data is now accessible at your fingertips!

Finished Early?
---------------

If you finish early pair with another student that has finished and compare your script files. Work together to come up with a one line powershell command for each prompt.