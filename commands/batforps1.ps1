<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    File Name  : batforps1.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-06-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    batforps1 ./commands/printhead.ps1 ./dist/
    
.EXAMPLE
    batforps1 ./dist/ls.ps1 ./dist/
    
#>

Param(
    [Parameter(Position=0,mandatory=$true)]
    [string]$powershell_script_path,
    [Parameter(Position=1,mandatory=$true)]
    [string]$output_folder_path,
    [switch]$Absolute
)

$powershell_script_path = [System.IO.Path]::GetFullPath($powershell_script_path)
$output_folder_path = [System.IO.Path]::GetFullPath($output_folder_path)
$script_name = [System.IO.Path]::GetFileName($powershell_script_path)
$name_only = [System.IO.Path]::GetFileNameWithoutExtension($powershell_script_path)

If ( -not [System.IO.File]::Exists($powershell_script_path)) {
    Write-Error "$powershell_script_path does not exist"
    Return
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
    $powershell_script_path_write = "%~dp0\" + [System.IO.Path]::GetFileName($powershell_script_path)
}

If ( -not [System.IO.File]::Exists("$output_folder_path\$script_name")) {
    "Copying the Powershell Script '$script_name' to $output_folder_path"
    [System.IO.File]::Copy($powershell_script_path, "$output_folder_path\$script_name", $true)
}
"Creating the caller batch file '$name_only.bat' in $output_folder_path"
[System.IO.File]::WriteAllLines("$output_folder_path\$name_only.bat", 
"@echo off
if `"%1`" == `"help`" (
    powershell -noprofile -executionpolicy bypass help `"$powershell_script_path_write`"` -full
) else (
    powershell -noprofile -executionpolicy bypass -file `"$powershell_script_path_write`" %*
)")

