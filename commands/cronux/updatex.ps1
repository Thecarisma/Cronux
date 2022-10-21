<#
.SYNOPSIS
    Update Cronux installation.
.DESCRIPTION
    Update the installed Cronux to the latest version 
    on the system.
.INPUTS 
    System.String[]
.OUTPUTS 
    System.String
.NOTES
    File Name  : updatex.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : Mar-09-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://thecarisma.github.io/Cronux/commands/updatex.html
.EXAMPLE
    updatex
    The command updates the installed Cronux to the 
    latest version
#>

Set-ExecutionPolicy Bypass -Scope Process -Force 
iex ((New-Object System.Net.WebClient).DownloadString('https://thecarisma.github.io/Cronux/installx.ps1'))
