<#
.SYNOPSIS
    Add and commit all the edited file to git with the 
    commit message as the variadic arguments without quotes 
.DESCRIPTION
    A short compact command to quickly add all edited files 
    to a commit with the commit messages.
    
.INPUTS 
    [System.String[]]
.OUTPUTS 
    [System.String[]]
.NOTES
    File Name  : gitcommit.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : Mar-30-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://git-scm.com/docs/git-add
    https://git-scm.com/docs/git-commit
.EXAMPLE
    gitcommit from here is the commit message
    your changes will be commit with the message 
    "from here is the commit message". The command is 
    equivalent to 
    git add .; git commit -m "from here is the commit message";
#>

Param(
    [Parameter(Mandatory=$true, ValueFromRemainingArguments = $true)]
    [string[]]$args
)
git add .
if ($args) {
    git commit -m "$args"
}