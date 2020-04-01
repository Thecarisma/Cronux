<#
.SYNOPSIS
    Remove a command from Cronux
.DESCRIPTION
    Remove a command from Cronux. The command batch 
    file and it powershell script are deleted also.
.INPUTS 
    System.String
.OUTPUTS 
    [System.String]
.NOTES
    Version    : 1.0
    File Name  : removecommand.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : April-01-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    removecommand ls
    Remove the ls.bat and ls.ps1 command.
.EXAMPLE
    removecommand ls ipof base64
    Remove the ls.bat, ls.ps1, ipof.bat, ipof.ps1, 
    base64.bat and base64.ps1 commands.
#>

[CmdletBinding()]
Param(
    # The command to remove 
    [string]$CommandsToRemove
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