.. sourcecode:: powershell
   :caption: setup-repository.ps

   # force the location to be the home directory
   Set-Location

   # create a new directory named powershell-studio
   New-Item -Type directory -Name powershell-studio

   # fork and clone this repo into the powershell-studio directory
   git clone https://github.com/launchcodeeducation/{studio-repo-name} powershell-studio

   # BONUS

   # move setup-repository.ps into the powershell-studio directory
   Move-Item setup-repository.ps powershell-studio

   # change into the powershell-studio directory
   Set-Location powershell-studio

   # add files to staging
   git add .

   # commit staged files
   git commit -m "setup-repository.ps"

   # students would then need to execute this script
   # after the script executes successfully they will need to push up to GitHub

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



