<#
.SYNOPSIS
    A shorthand script to clone a repository default or 
    specified branch
.DESCRIPTION
    A short compact command to quickly clone a repository. 
    To clone a specific branch add the branch name as 
    the second parameter. The default branch is clone by 
    default if the branch name is not specified.
.INPUTS 
    System.String[]
.OUTPUTS 
    git clone INFO
.NOTES
    File Name  : gitclone.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : Mar-01-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://git-scm.com/docs/git-clone
.EXAMPLE
    gitclone https://github.com/Thecarisma/Cronux.git
    clone the Cronux repository
    The command is equivalent to 
    git clone https://github.com/Thecarisma/Cronux.git
.EXAMPLE
    gitclone https://github.com/Thecarisma/Cronux.git gh-pages
    clone the Cronux repository branch 'gh-pages'
    The command is equivalent to 
    git clone -b gh-pages https://github.com/Thecarisma/Cronux.git
#>

[CmdletBinding()]
Param(
    [Parameter(mandatory=$true)]
    [string]$RepoUrl,
    [string]$Branch
)

if ($Branch) {
    git clone -b $Branch $RepoUrl
} else {
    git clone $RepoUrl
}