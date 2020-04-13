<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    Version    : 1.0
    File Name  : buildcronux.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-06-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    Cronux buildcronux  ./commands/ ./dist/build/
    
.EXAMPLE
    
#>

Param(
    [Parameter(mandatory=$true)]
    [string]$cronux_path,
    [Parameter(mandatory=$true)]
    [string]$output_folder_path
)

$cronux_path = [System.IO.Path]::GetFullPath($cronux_path)
$output_folder_path = [System.IO.Path]::GetFullPath($output_folder_path)
$wrapcommand_script_path = "$cronux_path\wrapcommand.ps1"
$batforps_script_path = "$cronux_path\batforps.ps1"
$export_list_path = "$cronux_path\ExportList.txt"

Function Iterate-Folder {
    Param([string]$foldername)
    
    Get-ChildItem $foldername | Foreach-Object {
        If ( -not $_.PSIsContainer) {
            If ( -not $_.Name.EndsWith(".ps1")) {
                Return
            }
            "Copying and Generating Batch wrapper for $($_.Name)"
            If ( -not [System.IO.File]::Exists("$output_folder_path\$($_.Name)")) {
                [System.IO.File]::Copy($_.FullName, "$output_folder_path\$($_.Name)", $true)
            }
        } Else {
            Iterate-Folder $_.FullName
        }
    }
}

If ( -not [System.IO.Directory]::Exists($cronux_path)) {
    Write-Error "Specified Cronux path '$cronux_path' does not exist"
    Return
}
If ( -not [System.IO.File]::Exists($batforps_script_path)) {
    Write-Error "batforps.ps1 script not found in Specified Cronux path '$cronux_path'"
    Return
}
If ( -not [System.IO.File]::Exists($wrapcommand_script_path)) {
    Write-Error "wrapcommand.ps1 script not found in Specified Cronux path '$cronux_path'"
    Return
}
If ( -not [System.IO.File]::Exists($export_list_path)) {
    Write-Error "ExportList.txt not found in Specified Cronux path '$cronux_path'"
    Return
}
If ( -not [System.IO.Directory]::Exists($output_folder_path)) {
    [System.IO.Directory]::CreateDirectory($output_folder_path) > $null
    If ( -not $?) {
        Return
    }
}
Iterate-Folder $cronux_path

Get-ChildItem $output_folder_path | Foreach-Object {
    If ( -not $_.PSIsContainer) {
        If ( -not $_.Name.EndsWith(".ps1")) {
            Return
        }
        iex "$batforps_script_path $($_.FullName) $output_folder_path"
    } 
}
iex "$wrapcommand_script_path -File $export_list_path $output_folder_path"

