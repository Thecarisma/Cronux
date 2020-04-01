<#
.SYNOPSIS
    Get the folder where Cronux is installed.
.DESCRIPTION
    Get the folder where Cronux is installed. The folder 
    returned depends on the Host OS.
.INPUTS 
    [System.String]
.OUTPUTS 
    [System.String]
.NOTES
    Version    : 1.0
    File Name  : installfolderx.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : April-01-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    installfolderx
    Returns the folder where Cronux is installed.
#>

Function Install-Folder-X {
    if ($Env:OS.StartsWith("Windows")) {
        return $env:ProgramData + "\Cronux\"
    } else {
        return "/bin/Cronux/"
    }
}

Install-Folder-X