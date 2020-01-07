<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    Version    : 1.0
    File Name  : chelp.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-03-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    
.EXAMPLE
    
#>

$command_folder = "./"
$Global:found_help = $false

Function main {
    ForEach ($arg in $args[0]) {
        Iterate-Folder $command_folder $arg
        If ($Global:found_help -eq $false) {
            powershell help $arg -full
        }
        $Global:found_help = $false
    }  
}

Function Iterate-Folder {
    Param([string]$foldername, $param)
    
    Get-ChildItem $foldername | Foreach-Object {
        If ( -not $_.PSIsContainer) {
            If ( -not $_.Name.EndsWith(".ps1")) {
                Return
            }
            $NameOnly = $_.Name.Substring(0, $_.Name.LastIndexOf("."))
            If ($NameOnly -eq $param) {
                powershell help $_.FullName -full
                $Global:found_help = $true
                Return
            }
        } Else {
            Iterate-Folder $_.FullName $param
        }
    }
    if ($Global:found_help -ne $true) {
        $Global:found_help = $false
    }
}

main $args