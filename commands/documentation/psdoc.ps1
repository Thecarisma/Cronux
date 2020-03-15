<#
.SYNOPSIS
   
.DESCRIPTION
    Add the -Verbose switch to see more output in the 
    shell
.INPUTS 
    None
.OUTPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : psdoc.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : March-12-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    psdoc .\ .\dist\cronux_doc\ -Recurse 
.EXAMPLE
    
#>

[CmdletBinding()]
Param(
    # The path to the powershell scri[t to extract documentation
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Path,
    # the folder to put generated exported documenation
    [Parameter(Mandatory=$true, Position=1)]
    [string]$OutputFolder,
    # whether to print anything to the console
    [switch]$Silent,
    # generate psdoc in subfolders?
    [switch]$Recurse
)

"-2"
$Path = [System.IO.Path]::GetFullPath($Path)
$OutputFolder = [System.IO.Path]::GetFullPath($OutputFolder)
$CHelpPath = "$PSScriptRoot\chelp.ps1"
$Global:count = 0

"-1"
If ( -not [System.IO.File]::Exists($CHelpPath)) {
    "0"
    $CHelpPath = "$PSScriptRoot\..\chelp.ps1"
}

Function Create-Directory {
    Param(
        [string]$folderpath
    )
    
    If ( -not [System.IO.Directory]::Exists($folderpath)) {
        [System.IO.Directory]::CreateDirectory($folderpath) > $null
        If ( -not $?) {
            Return
        }
    }
}

Function Iterate-Folder {
    Param(
        [string]$FolderName
    )
    "2"
    if (($FolderName + '\') -eq $OutputFolder) {
        return
    }
    "3"
    $RelName = $FolderName.SubString($Path.Length, $FolderName.Length - $Path.Length)
    $OutputName = $OutputFolder + $RelName
    Create-Directory $OutputName
    $Global:count = 0
    
    "4"
    Get-ChildItem $FolderName | Foreach-Object {
        If ( -not $_.PSIsContainer) {
            If ( $_.Name.EndsWith(".ps1")) {
                $NameOnly = $_.Name.SubString(0, $_.Name.LastIndexOf('.'))
                & $CHelpPath $_.FullName | Out-File "$OutputName\$NameOnly.psdoc"
                if ($Verbose) {
                    "Exported $RelName\$NameOnly documentation to $OutputName\$NameOnly.psdoc"
                }
                $Global:count += 1
            }
        } Else {
            if ($Recurse) {
                Iterate-Folder $_.FullName
            }
        }
    }
    if (-not $Silent) {
        Write-Host "$Global:count scripts documented in $RelName"
    }
}
if (-not $Silent) {
    Write-Host "Preparing to extract documenations in $Path" 
}

"1"
Iterate-Folder $Path

