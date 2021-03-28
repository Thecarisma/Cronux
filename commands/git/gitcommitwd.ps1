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
    Author     : Adewale Azeez - azeezadewale98@gmail.com
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
    [int]$Day,
    [switch]$Amend,
    [Parameter(Mandatory=$true, ValueFromRemainingArguments = $true)]
    [string[]]$args
)
if ($Day) {
	$DateStr = [DateTime]::Today.AddDays($Day).ToString("ddd MMM dd hh:mm:ss yyyy -0400")
	$Day = -$Day
	SET GIT_AUTHOR_DATE=$DateStr
	SET GIT_COMMITTER_DATE=$DateStr
}

git add .
if ($args) {
	If ($Amend) {
		bash -c "GIT_AUTHOR_DATE=\`"$DateStr\`" GIT_COMMITTER_DATE=\`"$DateStr\`" git commit --amend --date=\`"$Day days ago\`" -m \`"$args\`""
	} else {
		bash -c "GIT_AUTHOR_DATE=\`"$DateStr\`" GIT_COMMITTER_DATE=\`"$DateStr\`" git commit --date=\`"$Day days ago\`" -m \`"$args\`""
	}
}