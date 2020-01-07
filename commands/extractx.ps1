<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    File Name  : extractx.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-06-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    Cronux buildcronux  1.0 ./commands/ ./dist/
    
.EXAMPLE
    
#>

Param(
    [Parameter(mandatory=$true)]
    [string]$export_list_path
)

$export_list_path = [System.IO.Path]::GetFullPath($export_list_path)
$export_list_path_dir = [System.IO.Path]::GetDirectoryName($export_list_path)

If ( -not [System.IO.Directory]::Exists($export_list_path_dir)) {
    [System.IO.Directory]::CreateDirectory($export_list_path_dir) > $null
    If ( -not $?) {
        Return
    }
}
$export_list_path
$export_list_path_dir