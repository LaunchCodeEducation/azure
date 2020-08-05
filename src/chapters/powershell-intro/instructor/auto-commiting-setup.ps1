# declare variables
$GitHubUsername='[student-github-username]'
$PracticeRepoDir='[student-local-directory]'
$CommitMessage='auto committed from auto-committing-setup.ps1!'

## WARNING: students must fork https://github.com/launchcodeeducation/powershell-practice to their account before they can successfully clone!

# fork and clone this repo into the powershell-studio directory
git clone "https://github.com/$GitHubUsername/powershell-practice" "$PracticeRepoDir"

# TODO: complete steps 5-9

Move-Item ./auto-committing-setup.ps1 $PracticeRepoDir

Set-Location $PracticeRepoDir

git add .

git commit -m $CommitMessage

git push origin master