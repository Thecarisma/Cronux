<#
.SYNOPSIS
    Check the status of a repository.
.DESCRIPTION
    Print out the status infomation of a git 
    repository.
.INPUTS 
    System.String[]
.OUTPUTS 
    git pull INFO
.NOTES
    File Name  : gitstatus.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Mar-09-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://git-scm.com/docs/git-status
.EXAMPLE
    gitstatus
    Check the status update of the current git branch
    The command is equivalent to 
    git status
#>

git status
