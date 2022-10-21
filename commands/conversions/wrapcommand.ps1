<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    Version    : 1.0
    File Name  : wrapcommand.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : Jan-06-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    wrapcommand -File ./commands/ExportList.txt ./dist/
    
.EXAMPLE
    
#>

Param(
    [switch]$File,
    [Parameter(mandatory=$true)]
    [string]$command_list_file_path,
    [Parameter(mandatory=$true)]
    [string]$output_folder_path
)

$output_folder_path = [System.IO.Path]::GetFullPath($output_folder_path)
If ( -not [System.IO.Directory]::Exists($output_folder_path)) {
    [System.IO.Directory]::CreateDirectory($output_folder_path) > $null
    If ( -not $?) {
        Return
    }
}

Function Generate-Command-Wrapper {
    Param (
        [string]$command
    )
    "Wrapping the command '$command' into '$output_folder_path\$command.bat'"
    If ($Env:OS.StartsWith("Windows")) {
        [System.IO.File]::WriteAllLines("$output_folder_path\$command.bat", 
    "@echo off
if `"%1`" == `"help`" (
    powershell -noprofile -executionpolicy bypass help $command -full
) else (
    powershell -noprofile -executionpolicy bypass $command %*
)")
    } else {
        [System.IO.File]::WriteAllLines("$output_folder_path/$command", 
    "#!/bin/bash
WD=`$(pwd)
DIR=`"`$( cd `"`$( dirname `"`${BASH_SOURCE[0]}`" )`" `>/dev/null 2`>`&1 && pwd )`"
if [ `"`$1`" = `"help`" ]; then
    powershell -noprofile -executionpolicy bypass help $command -full
else
    powershell -noprofile -executionpolicy bypass -Command $command $*
fi".Replace("`r", ""))
        chmod +x "$output_folder_path/$command"
    }
}

If ($File) {
    $command_list_file_path = [System.IO.Path]::GetFullPath($command_list_file_path) 
    foreach($line in Get-Content $command_list_file_path) {
        if( -not $line.StartsWith("//") -and $line.Trim() -ne ""){
            Generate-Command-Wrapper $line
        }
    }
} else {
    Generate-Command-Wrapper $command_list_file_path
}
