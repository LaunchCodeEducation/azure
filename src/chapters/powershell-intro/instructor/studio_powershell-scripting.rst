===============
Studio Solution
===============

setup-repository.ps
===================

Students create this file themselves, and have to move it to the proper directory.

.. sourcecode:: powershell
   :caption: setup-repository.ps
   
   # declare variables
   $StudioRepoDir='~/powershell-studio'
   $CommitMessage=''

   # BONUS: capture these variables from user input

   # fork and clone this repo into the powershell-studio directory
   git clone https://github.com/launchcodeeducation/{studio-repo-name} "$StudioRepoDir"

   # PUT IN EXTERNAL NOTE
   # PSCommandPath is a Script-scoped variable (only exists within the script)
   # it holds the absolute path to the script file itself when it is executed

   # move this script into the powershell-studio directory
   Move-Item "$PSCommandPath" "$StudioRepoDir"

   # change into the powershell-studio directory
   Set-Location "$StudioRepoDir"

   # stage the new file in git
   git add .

   # commit the staged script file
   git commit -m $CommitMessage

   # push to their forked repo
   git push

Students would then execute the script. Proof of its success would be be to share a link to the new file in their forked repo.

launchcode-repos.ps
===================

The starter script is given to the students, but they are responsible for coming up with PS commands that will solve the prompts.

.. sourcecode:: powershell
   :caption: launchcode-repos.ps

   # how many repositories are returned when making a GET request to ``https://api.github.com/orgs/launchcodeeducation/repos``?
   # the answer is 30
   (Invoke-RestMethod -URI https://api.github.com/orgs/launchcodeeducation/repos).Length

   # what are the names of the repositories returned by a GET request to ``https://api.github.com/orgs/launchcodeeducation/repos``?
   (Invoke-RestMethod -URI https://api.github.com/orgs/launchcodeeducation/repos) | Select-Object -Property name

   # save all the names of the repositories in alphabetical order as a CSV file named ``launchcode-education-repo-names.csv``
   (Invoke-RestMethod -URI https://api.github.com/orgs/launchcodeeducation/repos) | Select-Object -Property Name | Sort-Object -Property Name | Export-Csv launchcode-education-repo-names.csv

   # are there any issues attached to the first repository in the list?
   (Invoke-RestMethod -URI https://api.github.com/orgs/launchcodeeducation/repos)[0].has_issues

   # what is the issues_url for the first repository in the list?
   # the answer is https://api.github.com/repos/LaunchCodeEducation/cs50x-live/issues
   (Invoke-RestMethod -URI https://api.github.com/orgs/launchcodeeducation/repos)[0].issues_url

   # make a new request to that issues_url
   Invoke-RestMethod -URI https://api.github.com/repos/LaunchCodeEducation/cs50x-live/issues

   # how many issues are found # the answer is 27
   (Invoke-RestMethod -URI https://api.github.com/repos/LaunchCodeEducation/cs50x-live/issues).Length

   # how would you access the 5th issues of this list
   (Invoke-RestMethod -URI https://api.github.com/repos/LaunchCodeEducation/cs50x-live/issues)[4]

   # what is the id, title, and URL for the fifth issues in this list?
   (Invoke-RestMethod -URI https://api.github.com/repos/LaunchCodeEducation/cs50x-live/issues)[4] | Format-Table -Property id,title,url

   # can also just fire 3 separate requests to solve the last prompt
   (Invoke-RestMethod -URI https://api.github.com/repos/LaunchCodeEducation/cs50x-live/issues)[4].id
   (Invoke-RestMethod -URI https://api.github.com/repos/LaunchCodeEducation/cs50x-live/issues)[4].title
   (Invoke-RestMethod -URI https://api.github.com/repos/LaunchCodeEducation/cs50x-live/issues)[4].url

   # upon answering all the questions students should save their results in a script and push it to GitHub


powershell-repo.ps
==================

The starter script is given to the students, but they are responsible for coming up with PS commands that will solve the prompts.

.. sourcecode:: powershell
   :caption: powershell-repo.ps

   # powershell/powershell
   # https://api.github.com/repos/powershell/powershell

   # Invoke-RestMethod -URI https://api.github.com/repos/powershell/powershell

   # how many github users are watching the powershell repo and how many users have subscribed to the powershell repo
   (Invoke-RestMethod -URI https://api.github.com/repos/powershell/powershell).watchers_count 
   (Invoke-RestMethod -URI https://api.github.com/repos/powershell/powershell).subscribers_count

   (Invoke-RestMethod -URI https://api.github.com/repos/powershell/powershell) | Format-Table -Property watchers_count,subscribers_count

   # when was the repo created
   (Invoke-RestMethod -URI https://api.github.com/repos/powershell/powershell).created_at

   # what is the subscribers URL
   (Invoke-RestMethod -URI https://api.github.com/repos/powershell/powershell).subscribers_url

   # how many users are returned when you make a request to the subscribers url?
   (Invoke-RestMethod -URI https://api.github.com/repos/PowerShell/PowerShell/subscribers).Length

   # what are the login usernames of the subscribers found at that URL in alphabetical order
   (Invoke-RestMethod -URI https://api.github.com/repos/PowerShell/PowerShell/subscribers) | Select-Object -Property login | Sort-Object -Property login

   # what was the login name of the most recent commit?
   (Invoke-RestMethod -URI https://api.github.com/repos/PowerShell/PowerShell/commits)[0].author.login

   # when was the most recent pull request created and has it been merged?
   (Invoke-RestMethod -URI https://api.github.com/repos/PowerShell/PowerShell/pulls)[0] | Select-Object -Property created_at,merged_at

   # what was the login name of the user that made the most recent pull request, and what is the URL to their profile
   (Invoke-RestMethod -URI https://api.github.com/repos/PowerShell/PowerShell/pulls)[0].user.login
   (Invoke-RestMethod -URI https://api.github.com/repos/PowerShell/PowerShell/pulls)[0].user.url

   (Invoke-RestMethod -URI https://api.github.com/repos/PowerShell/PowerShell/pulls)[0].user | Select-Object -Property login,url