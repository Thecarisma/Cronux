<#
.SYNOPSIS
    About Cronux
.DESCRIPTION
    Show information about the currently installed version of Cronux. 
    This includes the Author, Licence, version e.t.c
    
    Most importantly this script holds the actual version of Cronux.
.INPUTS 
    None
.OUTPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : aboutx.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-08-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    aboutx 
    Show about the Cronux application
.EXAMPLE
    
#>

Param(
    [switch]$Version,
    [switch]$Year,
    [switch]$Author,
    [switch]$Licence
)

$version_value = & "$PSScriptRoot\versionx.ps1"
$author_value = "Adewale Azeez"
$licence_value = "MIT License"
$year_value = "2020"

if ($Version) {
    $version_value
    Return
}
if ($Year) {
    $year_value
    Return
}
if ($Author) {
    $author_value
    Return
}
if ($Licence) {
    $licence_value
    Return
}

"Cronux v$version_value"
"Powershell $($Host.Version)"
"$([System.Environment]::OSVersion)"
"The $licence_value Copyright (c) $year_value $author_value"
