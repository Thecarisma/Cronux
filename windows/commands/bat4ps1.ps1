<#
.SYNOPSIS
    Add and commit all the edited file to git with the commit 
    message as the variadic arguments without quotes 
.DESCRIPTION
    A short compact command to quickly add all edited files to a 
    commit with the commit messages and push the changes to the 
    currently active branch. 
    
    This command does not force push to remote, to force a push to 
    remote regardless of remote changes, use the 'gitfpush' command.
.INPUTS 
    System.String[]
.OUTPUTS 
    git status
.NOTES
    File Name  : gitpush.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-03-2019
.LINK
    https://thecarisma.github.io/Cronux
    https://git-scm.com/docs/git-add
    https://git-scm.com/docs/git-commit
    https://git-scm.com/docs/git-push
.EXAMPLE
    gitpush from here is the commit message
    your changes will be commit with the message 
    "from here is the commit message". The command is 
    equivalent to 
    git add .; git commit -m "from here is the commit message"; git push origin HEAD
.EXAMPLE
    gitpush
    This will commit your changes without any messages. 
    git add .; git commit -m ""; git push origin HEAD
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

[System.IO.File]::Copy($powershell_script_path, "$output_folder_path\$script_name", $true)
[System.IO.File]::WriteAllLines("$output_folder_path\$name_only.bat", 
"@echo off
if `"%1`" == `"help`" (
    powershell -noprofile -executionpolicy bypass help `"$powershell_script_path_write`"`
) else (
    powershell -noprofile -executionpolicy bypass -file `"$powershell_script_path_write`"
)")

