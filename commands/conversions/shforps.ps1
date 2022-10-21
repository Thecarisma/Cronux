<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    Version    : 1.0
    File Name  : shforps.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : May-03-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    shforps ./commands/printhead.ps1 ./dist/
    
.EXAMPLE
    shforps -Command Set-Location ./dist/
    The commands above creates a shell script wrapper for 
    the powershell `Set-Location` command
    
#>

[CmdletBinding()]
Param(
    [switch]$Command,
    [Parameter(Position=0,mandatory=$true)]
    [string]$powershell_script_path,
    [Parameter(Position=1,mandatory=$true)]
    [string]$output_folder_path,
    [switch]$Absolute
)

$output_folder_path = [System.IO.Path]::GetFullPath($output_folder_path)
If ( -not $Command) {
    $powershell_script_path = [System.IO.Path]::GetFullPath($powershell_script_path)
    $script_name = [System.IO.Path]::GetFileName($powershell_script_path)
    $name_only = [System.IO.Path]::GetFileNameWithoutExtension($powershell_script_path)
    If ( -not [System.IO.File]::Exists($powershell_script_path)) {
        Write-Error "$powershell_script_path does not exist"
        Return
    }
}

If ( -not [System.IO.Directory]::Exists($output_folder_path)) {
    [System.IO.Directory]::CreateDirectory($output_folder_path) > $null
    If ( -not $?) {
        Return
    }
}
If ($Absolute) {
    $powershell_script_path_write = $powershell_script_path
} else {
    $powershell_script_path_write = "`$DIR/" + [System.IO.Path]::GetFileName($powershell_script_path)
}

If ($Command) {
    "Creating the caller batch file '$powershell_script_path' in $output_folder_path"
    [System.IO.File]::WriteAllLines("$output_folder_path/$powershell_script_path", 
    "#!/bin/bash
WD=`$(pwd)
DIR=`"`$( cd `"`$( dirname `"`${BASH_SOURCE[0]}`" )`" `>/dev/null 2`>`&1 && pwd )`"
if [ `"`$1`" = `"help`" ]; then
    powershell -noprofile -executionpolicy bypass help $powershell_script_path -full
else
    powershell -noprofile -executionpolicy bypass $powershell_script_path $*
fi")
    chmod +x "$output_folder_path/$powershell_script_path"
} Else {
    If (-not (Test-Path "$output_folder_path/$script_name")) {
        "Copying the Powershell Script '$script_name' to $output_folder_path"
        Copy-Item -Path $powershell_script_path -Destination "$output_folder_path/$script_name" -Force
    }
    "Creating the caller batch file '$name_only' in $output_folder_path"
    [System.IO.File]::WriteAllLines("$output_folder_path/$name_only", 
    "#!/bin/bash
WD=`$(pwd)
DIR=`"`$( cd `"`$( dirname `"`${BASH_SOURCE[0]}`" )`" `>/dev/null 2`>&1 && pwd )`"
if [ `"`$1`" = `"help`" ]; then
    powershell -noprofile -executionpolicy bypass help `"$powershell_script_path_write`"` -full
else
    powershell -noprofile -executionpolicy bypass -file `"$powershell_script_path_write`" $*
fi")
    chmod +x "$output_folder_path/$name_only"
}

