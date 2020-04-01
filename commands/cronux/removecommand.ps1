<#
.SYNOPSIS
   List the ip addresses of a url
.DESCRIPTION
    List all the host addresses of a particular url.
    Internet connection is required to fetch the ip 
    addresses.
.INPUTS 
    System.String
.OUTPUTS 
    [System.String]
.NOTES
    Version    : 1.0
    File Name  : ipof.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : March-25-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    ipof google.com
    List all the ip addresses of Google url 
.EXAMPLE
    ipof https://www.github.com
    List all the ip addresses of Github
#>

[CmdletBinding()]
Param(
    # The command to remove 
    [string]$CommandToRemove
)

$AppName = "Cronux"
$InstallationPath = & "$PSScriptRoot\installfolderx.ps1"

"Removing the command '$CommandToRemove'"
If ([System.IO.File]::Exists("$InstallationPath\$CommandToRemove.bat")) {
    Remove-Item -path "$InstallationPath\$CommandToRemove.bat"
}
If ([System.IO.File]::Exists("$InstallationPath\$CommandToRemove.ps1")) {
    Remove-Item -path "$InstallationPath\$CommandToRemove.ps1"
}
"done removing '$CommandToRemove'"