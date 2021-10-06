<#
.SYNOPSIS
    Add and commit all the edited file to git with the 
    commit message as the variadic arguments without quotes,
    pull from specific branch and pull again
.DESCRIPTION
    A short compact command to quickly add all edited files 
    to a commit with the commit messages and push the changes 
    to the currently active branch. 

    After pushing your update, it pull the specified branch, then 
    push again, the branch to pull is specify by the -Branch 
    flag.
    
    This command does not force push to remote, to force a 
    push to remote regardless of remote changes, use the 
    'gitfpush' command.
.INPUTS 
    System.String[]
.OUTPUTS 
    some text and analysis
.NOTES
    File Name  : gitpush.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Oct-06-2021
.LINK
    https://thecarisma.github.io/Cronux
    https://git-scm.com/docs/git-add
    https://git-scm.com/docs/git-commit
    https://git-scm.com/docs/git-push
    https://git-scm.com/docs/git-pull
.EXAMPLE
    gitpush from here is the commit message
    your changes will be commit with the message 
    "from here is the commit message". The command is 
    equivalent to 
    git add .; git commit -m "from here is the commit message"; git push origin HEAD
.EXAMPLE
    gitpush
    This will commit your changes without any messages. 
    git add .; git commit -m ""; git push origin HEAD
#>

Param(
	[string]$Branch,
    [parameter(ValueFromRemainingArguments = $true)]
    [string[]]$args
)

If ($Branch -ne $null -and $args -eq $null) {
    $args = $Branch
    $Branch = "HEAD"
}

gitpush $args
gitpull $Branch
gitpush $args