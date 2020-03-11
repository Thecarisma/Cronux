<#
.SYNOPSIS
    a
.DESCRIPTION
    b
.INPUTS 
    System.String[]
.OUTPUTS 
    git clone INFO
.NOTES
    File Name  : superwatcher.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Mar-11-2020
.LINK
    https://www.mobzystems.com/code/using-a-filesystemwatcher-from-powershell/
    https://thecarisma.github.io/Cronux
    https://thecarisma.github.io/Cronux/commands/filesystem/superwatcher.html
.EXAMPLE
    c
.EXAMPLE
    d
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Path,
    [Parameter(Position=1)]
    [string]$Filter = "*.*",
    [switch]$Recurse,
    [scriptblock]$CreatedAction,
    [scriptblock]$DeletedAction,
    [scriptblock]$ChangedAction,
    [scriptblock]$RenamedAction,
    # Check for ESC every ... seconds
    [int]$KeyboardTimeout = -1,
)

Function Iterate-Folder {
    Param([string]$foldername)
    $_.FullName
    
    Get-ChildItem $foldername | Foreach-Object {
        If ( -not $_.PSIsContainer) {
            $NameOnly = $_.Name.Substring(0, $_.Name.LastIndexOf("."))
            $_.FullName
        } Else {
            Iterate-Folder $_.FullName
        }
    }
}

Function Watch-Path {
    Param(
        [string]$_Path,
        [string]$_EventNames
    )
    $FileSystemWatcher = New-Object System.IO.FileSystemWatcher
    $FileSystemWatcher.Path  = $_Path
    Register-ObjectEvent -InputObject $FileSystemWatcher  -EventName Created  -Action {
        $Object  =  $CommandToExecute -f 
                    $Event.SourceEventArgs.FullPath,
                    $Event.SourceEventArgs.ChangeType,
                    $Event.TimeGenerated
        
        iex $Object
    } 
}

$Path

#Iterate-Folder $FolderPath

return;


$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path  = $FolderPath

  




#dirwatcher C:\Users\azeez\Documents\OPEN_SOURCE\THECARISMA\Cronux Creates,Delete 'git commit -m "${0}ed ${1}: fix low fortify issues '

