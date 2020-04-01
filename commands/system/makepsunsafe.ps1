<#
.SYNOPSIS
    Allow powershell to execute unsigned .ps1 files without 
    any warning
.DESCRIPTION
    Allow powershell to execute unsigned .ps1 files without 
    any warning. This is equivalent to executing the command:

        Set-ExecutionPolicy Bypass
        
    To execute the command call 'makepsunsafe.bat' instead of 
    'makepsunsafe' or 'makepsunsafe.ps1' as the Execution 
    policy might be restricted at the moment.
    
    Also this command should be run as Administrator.
.INPUTS 
    System.String
.OUTPUTS 
    [System.String]
.NOTES
    Version    : 1.0
    File Name  : makepsunsafe.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : April-01-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    makepsunsafe
    Allow powershell to execute unsigned .ps1
#>

Set-ExecutionPolicy Bypass