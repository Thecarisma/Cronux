<#
.SYNOPSIS
    Check the branch of a repository.
.DESCRIPTION
    Print out the branch infomation of a git 
    repository.
.INPUTS 
    System.String[]
.OUTPUTS 
    git branch INFO
.NOTES
    File Name  : gitbranch.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Sep-06-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://git-scm.com/docs/git-branch
.EXAMPLE
    gitbranch
    Print out the branch of the repository
#>

git branch $args
