<#
.SYNOPSIS
    Add and commit all the edited file to git with the 
    commit message as the variadic arguments without quotes 
    and forcefully push the update to remote
.DESCRIPTION
    A short compact command to quickly add all edited files 
    to a commit with the commit messages and forcefully push 
    the changes to the currently active branch. 
    
    If your push is rejected you should merge or do what is 
    right. Force push to wreck havoc.
.INPUTS 
    System.String[]
.OUTPUTS 
    some text and analysis I don't need
.NOTES
    File Name  : gitfpush.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Mar-01-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://git-scm.com/docs/git-add
    https://git-scm.com/docs/git-commit
    https://git-scm.com/docs/git-push
.EXAMPLE
    gitfpush from here is the commit message
    your changes will be commit with the message 
    "from here is the commit message". The command is 
    equivalent to 
    git add .; git commit -m "from here is the commit message"; git push origin HEAD
.EXAMPLE
    gitfpush
    This will commit your changes without any messages. 
    git add .; git commit -m ""; git push origin HEAD
#>

Param(
    [parameter(ValueFromRemainingArguments = $true)]
    [string[]]$args
)
git add .
if ($args) {
    git commit -m "$args"
}
git push origin HEAD --force