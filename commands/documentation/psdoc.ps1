<#
.SYNOPSIS
    A robust command delegate for Windows Command Prompt
.DESCRIPTION
    Support inline execution, command history
.INPUTS 
    None
.OUTPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : aboutx.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-08-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    psdoc .\ .\dist\cronux_doc\ -Recurse 
.EXAMPLE
    
#>

Param(
    # The path to the powershell scri[t to extract documentation
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Path,
    # the folder to put generated exported documenation
    [Parameter(Mandatory=$true, Position=1)]
    [string]$OutputFolder,
    # generate psdoc in subfolders?
    [switch]$Recurse
)

$Path = [System.IO.Path]::GetFullPath($Path)
$OutputFolder = [System.IO.Path]::GetFullPath($OutputFolder)
$CHelpPath = "$PSScriptRoot\chelp.ps1"
$Global:count = 0

If ( -not [System.IO.File]::Exists($CHelpPath)) {
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
    if (($FolderName + '\') -eq $OutputFolder) {
        return
    }
    $RelName = $FolderName.SubString($Path.Length, $FolderName.Length - $Path.Length)
    $OutputName = $OutputFolder + $RelName
    Create-Directory $OutputName
    $Global:count = 0
    
    Get-ChildItem $FolderName | Foreach-Object {
        If ( -not $_.PSIsContainer) {
            If ( $_.Name.EndsWith(".ps1")) {
                $NameOnly = $_.Name.SubString(0, $_.Name.LastIndexOf('.'))
                & $CHelpPath $_.FullName | Out-File "$OutputName\$NameOnly.psdoc"
                $Global:count += 1
            }
        } Else {
            Iterate-Folder $_.FullName
        }
    }
    Write-Host "$Global:count scripts documented in $RelName"
}
Write-Host "Preparing to extract documenations in $Path" 

Iterate-Folder $Path
