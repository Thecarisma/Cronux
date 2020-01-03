<#
.SYNOPSIS
    Add and commit all the edited file to git with the commit 
    message as the variadic arguments without quotes 
.DESCRIPTION
    A more in depth description of the script
    Should give script developer more things to talk about
    Hopefully this can help the community too
    Becomes: "DETAILED DESCRIPTION"
    Appears in basic, -full and -detailed
.NOTES
    File Name  : gitpush.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-03-2019
.LINK
    https://thecarisma.github.io/Cronux
    https://git-scm.com/docs/git-add
    https://git-scm.com/docs/git-commit
    https://git-scm.com/docs/git-push
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
    [parameter(ValueFromRemainingArguments = $true)]
    [string[]]$args
)
git add .
git commit -m "$args"
git push origin HEAD