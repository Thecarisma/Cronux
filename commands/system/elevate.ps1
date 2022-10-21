<#
.SYNOPSIS
    Start an application as Administrator
.DESCRIPTION
    Start an application as Administrator, the first 
    argument is the name of the app to run. The following 
    arguments are sent to the application. 
.INPUTS 
    System.String
.OUTPUTS 
    [System.String]
.NOTES
    Version    : 1.0
    File Name  : elevate.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : April-01-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    elevate notepad
    Start the notepad app as Administrator
.EXAMPLE
    elevate cmd /k dir
    Start Windows command prompt as Administrator 
    and run the command 'dir'. 
#>

[CmdletBinding()]
Param(
    # The application to run as Administrator
    [string]$App,
    # The arguments to pass to the application
    [Parameter(Mandatory=$false, ValueFromRemainingArguments = $true)]
    [string[]]$ExtraArguments
)

if ($ExtraArguments) {
    Start-Process $App "$ExtraArguments" -Verb RunAs
} else {
    Start-Process $App -Verb RunAs
}