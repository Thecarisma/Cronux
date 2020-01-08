<#
.SYNOPSIS
    List all the commands exported through Cronux 
.DESCRIPTION
    List all the commands exported through Cronux in no 
    order. This include built in powershell commands exported 
    into ExportList.txt
.INPUTS 
    None
.OUTPUTS 
    All Cronux commands
.NOTES
    Version    : 1.0
    File Name  : listx.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-08-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    listx 
    List all the commands excluding exported powershell built in  
    commands
.EXAMPLE
    listx -All
    List all the commands over 2000 commands 
#>

Param(
    [switch]$All
)

$command_folder = [System.IO.Path]::GetFullPath($PSScriptRoot)
$export_list_path = "$command_folder\ExportList.txt"
$Global:count = 0

Function Iterate-Folder {
    Param([string]$foldername)
    
    Get-ChildItem $foldername | Foreach-Object {
        If ( -not $_.PSIsContainer) {
            If ( $_.Name.EndsWith(".ps1")) {
                Write-Host -NoNewline "$($_.Name.SubString(0, $_.Name.LastIndexOf(`".ps1`"))), "
                if ($Global:count -ge 100) {
                    $Global:count = 0
                    ""
                }
                $Global:count += 1
            }
        } Else {
            Iterate-Folder $_.FullName
        }
    }
}

Iterate-Folder $command_folder

If ($All) {
    foreach($line in Get-Content $export_list_path) {
        if( -not $line.StartsWith("//") -and $line.Trim() -ne ""){
            Write-Host -NoNewline "$line, "
            if ($Global:count -ge 100) {
                $Global:count = 0
                ""
            }
            $Global:count += 1
        }
    }
}

"Bye."