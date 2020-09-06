<#
.SYNOPSIS
    Print the repository log.
.DESCRIPTION
    An alias for the git command to show the log in a git repository.
    
    Before executing the command you have to change directory to the 
    repository folder and you must have git installed on your Windows
.INPUTS 
    System.String[]
.OUTPUTS 
    git log
.NOTES
    File Name  : gitlog.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Sep-06-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://git-scm.com/docs/git-log
.EXAMPLE
    gitlog
    Print out the commit log of the repository
#>

git log $args
