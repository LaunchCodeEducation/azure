===============
Studio Solution
===============

auto-committing-setup.ps1
===================

Students create this file themselves, and have to move it to the proper directory.

.. sourcecode:: powershell
   :caption: auto-committing-setup.ps1
      
   # declare variables
   $GitHubUsername=''
   $StudioRepoDir=''
   $CommitMessage='auto committed from auto-committing-setup.ps1!'

   # fork and clone this repo into the powershell-studio directory
   git clone "https://github.com/$GitHubUsername/powershell-practice" "$StudioRepoDir"

   # move this script into the powershell-studio directory
   Copy-Item "$PSCommandPath" "$StudioRepoDir"

   # change into the powershell-studio directory
   Set-Location "$StudioRepoDir"

   # stage the new file in git
   git add .

   # commit the staged script file
   git commit -m $CommitMessage

   # push to their forked repo
   git push

Students would then execute the script. Proof of its success would be be to share a link to the new file in their forked repo.

bonus solution

.. sourcecode:: powershell
   :caption: auto-committing-setup.ps1
   
   # declare variables
   $GitHubUsername = Read-Host -Prompt 'GitHub username'
   $StudioRepoDir = Read-Host -Prompt 'Path (rel or abs) where the repo will be cloned'

   # remaining script ...