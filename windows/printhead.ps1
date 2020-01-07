<#
.SYNOPSIS
    Add and commit all the edited file to git with the commit 
    message as the variadic arguments without quotes 
.DESCRIPTION
    A short compact command to quickly add all edited files to a 
    commit with the commit messages and push the changes to the 
    currently active branch. 
    
    This command does not force push to remote, to force a push to 
    remote regardless of remote changes, use the 'gitfpush' command.
.INPUTS 
    System.String[]
.OUTPUTS 
    git status
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
  
$ad = "$args"  
$lines = $ad.Split("`n")
$length = 0
ForEach ($line in $lines) {
    If ($line.length -gt $length - 2) {
        $length = $line.length + 2
    }
}
$i = $length
While (--$i -gt 0) {
    Write-Host -NoNewline  "=" 
}
""
$ad
While (++$i -lt $length) {
    Write-Host -NoNewline  "=" 
}
""