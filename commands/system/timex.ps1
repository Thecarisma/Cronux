<#
.SYNOPSIS
	Print the time taken to execute a program, similar to 
	linux time command. 
.DESCRIPTION
    Print the time taken to execute a program, similar to 
	linux time command. 
.INPUTS 
    [System.String]
.OUTPUTS 
    [System.String]
.NOTES
    Version    : 1.0
    File Name  : timex.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : August-28-2021
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    timex dir 
    28-Aug-21  07:56 PM    <DIR>          .
	28-Aug-21  07:53 PM    <DIR>          ..
	28-Aug-21  07:56 PM                 9 .gitattributes
	28-Aug-21  07:56 PM                60 .gitignore
				2 File(s)            69 bytes
               4 Dir(s)  56,581,320,704 bytes free

	real: 0m0.902s
	user: 0m0.864s
	sys:  0m0.032s
#>

Param(
    # the commands to execute or the file to execute
    [Parameter(Mandatory=$false, ValueFromRemainingArguments = $true)]
    [string[]]$Commands
)

Function Main {
	$sw = [Diagnostics.Stopwatch]::StartNew()
    If ($Commands) {
		$env:Path += ";$([Environment]::CurrentDirectory)"
        iex "$Commands"
    }
	$sw.Stop()
	$Verbose
	If ($Verbose) {
		$sw.Elapsed
	} Else {
		$elpase = "$([math]::round($sw.Elapsed.TotalMinutes, 0))m$([math]::round($sw.Elapsed.TotalSeconds, 3))s"
		If ($sw.Elapsed.TotalHours -ge 1) {
			$elpase = "$([math]::round($sw.Elapsed.TotalHours, 0))h$elpase"
		}
		Write-Output ""
		Write-Output "real: $($elpase)"
	}
}

Main
