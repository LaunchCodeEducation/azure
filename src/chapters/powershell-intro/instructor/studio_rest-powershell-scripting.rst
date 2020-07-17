
.. ::

   $subscribersCount = (Invoke-RestMethod -URI https://api.github.com/repos/powershell/powershell).subscribers_count
   (Invoke-RestMethod -URI 'https://api.github.com/repos/powershell/powershell/subscribers?page=1&per_page=100').Length
   (Invoke-RestMethod -URI 'https://api.github.com/repos/powershell/powershell/subscribers?page=1&per_page=100').Length


   create a CSV that has the URL of the PR, a message tagging the user by their login name and thanking them

   of the last 100 PRs if it has been merged you need to record their login username, URL/name of PR, merged_at

   thank you PR merge bot (login username, messages their name, when the PR was created, when it was merged)

   100 PRs check if they have been merged, if so grab this info and add to a CSV (needs a CSV of merged PRs)

   bots that close stale issues (go through the last 1000 issues, mark down login username, issue url, last_updated)

   created_at vs updated_at (issues that are stale)

   issue_url, user login, created_at, updated_at; give them logic for if updated_at > 

   determine stale after so many days (make the days a variable so it can be changed in script very easily) 10 days

   generate message for bot based on how long the last updated_at is

   "Hey USERNAME it has been DAYS days since the last update to ISSUE_URL."

   "10 days it will remain open"

   "20 days we will close in 10 days"

   "30 days we are closing this issue"

   .. $three_months = $past.AddMonths(3)

   .. $ten_days = $past.addDays(10)

.. [datetime]$CreatedAt = $Issue.created_at

launchcode-repos.ps1
===================

The starter script is given to the students, but they are responsible for coming up with PS commands that will solve the prompts.

.. sourcecode:: powershell
   :caption: launchcode-repos.ps1

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


powershell-repo.ps1
==================

The starter script is given to the students, but they are responsible for coming up with PS commands that will solve the prompts.

.. sourcecode:: powershell
   :caption: powershell-repo.ps1

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