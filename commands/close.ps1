<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    Version    : 1.0
    File Name  : close.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-08-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    close
    
.EXAMPLE
    
#>

$ParentProcessIds = Get-CimInstance -Class Win32_Process -Filter "ProcessId = $PID"
$ParentProcessIds[0].Name
#Stop-Process $ParentProcessIds[0].ParentProcessId