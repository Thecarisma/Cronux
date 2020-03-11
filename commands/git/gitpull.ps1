<#
.SYNOPSIS
    Pull the latest update from the remote repository 
    into your local repository.
.DESCRIPTION
    Pull the latest update from the remote repository 
    into your local repository. This command requires 
    you to be in a valig git folder. 
    
    If no argument is specified the remote update on the 
    active branch will be pulled but if a branch is 
    specified the update from the branch will be pulled.
.INPUTS 
    System.String[]
.OUTPUTS 
    git pull INFO
.NOTES
    File Name  : gitpull.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Mar-02-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://git-scm.com/docs/git-pull
.EXAMPLE
    gitpull
    pull a repository update from remote
    The command is equivalent to 
    git pull HEAD
.EXAMPLE
    gitpull gh-pages
    clone the Cronux repository branch 'gh-pages'
    The command is equivalent to 
    git clone -b gh-pages https://github.com/Thecarisma/Cronux.git
#>

[CmdletBinding()]
Param(
    # The optional branch to pull from 
    [string]$Branch
)

if ($Branch) {
    git pull origin $Branch
} else {
    git pull origin HEAD
}