<#
.SYNOPSIS
	Commit or ammend a commit with a custom date.
.DESCRIPTION
    Commit with a custom date. To commit in the past set the 
	day value to - number of days in past. E.g. to commit 
	3 days ago set the Day value to -3.
    Add and commit all the edited file to git with the 
    commit message as the variadic arguments without quotes 
    
.INPUTS 
	[int]
	[switch]
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
    gitcommit 0 -Amend from here is the commit message
    your last commit will be ammended with the message 
    "from here is the commit message" The command is 
    equivalent to 
    git add .; git commit --amend -m "from here is the commit message";
.EXAMPLE
    gitcommit -3 from here is the commit message
    your changes will be commit with the message 
    "from here is the commit message" plus the 
	author and commit date will be set to 3 days ago.
	The command is equivalent to 
    git add .; GIT_AUTHOR_DATE='Sun Feb 21 10:03:02 2021 -0400' GIT_COMMITTER_DATE='Sun Feb 21 10:03:02 2021 -0400' git commit -m "from here is the commit message";
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