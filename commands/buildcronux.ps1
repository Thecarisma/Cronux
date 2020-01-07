<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    File Name  : buildcronux.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-06-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    
    
.EXAMPLE
    
#>

Param(
    [Parameter(mandatory=$true)]
    [string]$version,
    [Parameter(mandatory=$true)]
    [string]$cronux_path,
    [Parameter(mandatory=$true)]
    [string]$output_folder_path
)

$cronux_path = [System.IO.Path]::GetFullPath($cronux_path)
$output_folder_path = [System.IO.Path]::GetFullPath($output_folder_path) + "\$version\"

Function Iterate-Folder {
    Param([string]$foldername)
    
    Get-ChildItem $foldername | Foreach-Object {
        If ( -not $_.PSIsContainer) {
            If ( -not $_.Name.EndsWith(".ps1")) {
                Return
            }
            $_.FullName
        } Else {
            Iterate-Folder $_.FullName
        }
    }
}

If ( -not [System.IO.Directory]::Exists($cronux_path)) {
    Write-Error "Specified Cronux path '$cronux_path' does not exist"
    Return
}
If ( -not [System.IO.Directory]::Exists($output_folder_path)) {
    [System.IO.Directory]::CreateDirectory($output_folder_path) > $null
    If ( -not $?) {
        Return
    }
}
Iterate-Folder $cronux_path

