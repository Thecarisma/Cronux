<#
.SYNOPSIS
    Uninstall Cronux from the system.
.NOTES
    Version    : 1.0
    File Name  : uninstallx.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : April-01-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    uninstallx
    Uninstall Cronux from the system
#>

$AppName = "Cronux"
$Version = & "$PSScriptRoot\versionx.ps1"

"Uninstalling $AppName $Version"
#use removefrompath to remove from path
$InstallationPath = & "$PSScriptRoot\installfolderx.ps1"
If ([System.IO.Directory]::Exists($InstallationPath)) {
    Remove-Item -path $InstallationPath -recurse
}