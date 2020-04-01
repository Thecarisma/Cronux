<#
.SYNOPSIS
    Allow powershell to execute safe .ps1 files 
.DESCRIPTION
    Allow powershell to execute only safe and signed .ps1 files

        Set-ExecutionPolicy Restricted
        
    Also this command should be run as Administrator.
.INPUTS 
    System.String
.OUTPUTS 
    [System.String]
.NOTES
    Version    : 1.0
    File Name  : makepssafeagain.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : April-01-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    makepssafeagain
    Allow powershell to execute safe .ps1
#>

Set-ExecutionPolicy Restricted