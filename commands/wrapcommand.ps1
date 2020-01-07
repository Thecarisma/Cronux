<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    File Name  : wrapcommand.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-06-2019
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
    "Wrapping the installed command '$command' to '$output_folder_path\$command.ps1'"
    [System.IO.File]::WriteAllLines("$output_folder_path\$command.ps1", 
    "$command `$args")
}

If ($File) {
    $command_list_file_path = [System.IO.Path]::GetFullPath($command_list_file_path) 
    foreach($line in Get-Content $command_list_file_path) {
        if( -not $line.StartsWith("//")){
            Generate-Command-Wrapper $line
        }
    }
} else {
    Generate-Command-Wrapper $command_list_file_path
}
