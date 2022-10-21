<#
.SYNOPSIS
    Create a new file in the current directory
.DESCRIPTION
    Creates an empty file in the current working 
    directory.
.INPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : touch.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : March-26-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    touch file.txt
    Creates the file file.txt in the current folder
#>

[CmdletBinding()]
Param(
    # the name of the file to create
    [string]$FileName
)

New-Item -Name $FileName -ItemType File