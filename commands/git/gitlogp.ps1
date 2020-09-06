<#
.SYNOPSIS
    Print the repository log in pretty format.
.DESCRIPTION
    An alias for the git command to show the log in a git repository .
    
    Before executing the command you have to change directory to the 
    repository folder and you must have git installed on your Windows
.INPUTS 
    System.String[]
.OUTPUTS 
    git log
.NOTES
    File Name  : gitlogp.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Sep-06-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://git-scm.com/docs/git-log
.EXAMPLE
    gitlogp
    Print out the commit log of the repository
.EXAMPLE
    gitlogp "%s - %h"
    Print out the commit log of the repository in the 
    following format 
    
        change EOL to LF for Cronux.sh ab10ea1
        add logo to the project 1641e42
        update location of extractx 8cbcf38
#>

Param(
    [string]$Format = "%h - %an : %s",
    [string[]]$OtherArgs
)

git log --pretty=format:"$Format" $OtherArgs
