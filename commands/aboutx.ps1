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
    Date       : Jan-08-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    aboutx 
    Show about the Cronux application
.EXAMPLE
    
#>

Param(
    [switch]$Version
)

$version = 2.0

if ($Version) {
    $version
    Return
}
