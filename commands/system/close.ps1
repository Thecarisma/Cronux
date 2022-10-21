<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    Version    : 1.0
    File Name  : close.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : Jan-08-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    close
    
.EXAMPLE
    
#>

$ParentProcessIds = Get-CimInstance -Class Win32_Process -Filter "ProcessId = $PID"
$ParentProcessIds = Get-CimInstance -Class Win32_Process -Filter "ProcessId = $($ParentProcessIds[0].ParentProcessId)"
Stop-Process $ParentProcessIds[0].ProcessId