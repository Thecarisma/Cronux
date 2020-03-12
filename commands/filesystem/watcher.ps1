<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    System.String[]
.OUTPUTS 
    git clone INFO
.NOTES
    File Name  : watcher.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Mar-11-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://git-scm.com/docs/git-clone
.EXAMPLE
    
.EXAMPLE
    
#>

[CmdletBinding()]
Param(
    # the folder to monitor
    [Parameter(mandatory=$true)]
    [string]$FolderPath,
    # the command to execute when an event occur
    # the command accepted is powershell for batch 
    # command watcher call 'watcherb'
    # you following variables index are set for the command 
    # 
    [Parameter(mandatory=$true)]
    [string]$CommandToExecute,
    #The swicth that indicate whether to fire the command on create
    [switch]$Create,
    #The swicth that indicate whether to fire the command on delete
    [switch]$Delete,
    #The swicth that indicate whether to fire the command on change
    [switch]$Change,
    #The swicth that indicate whether to fire the command on rename
    [switch]$Rename
)

Set-Location -Path $FolderPath
$CreateBlock = {}
$DeleteBlock = {}
$ChangeBlock = {}
$RenameBlock = {}
if ($Create) {
    $CreateBlock = {
        $NameOnly = $e.Name -replace '.*\\'
        $Object = $CommandToExecute -f $NameOnly, $e.ChangeType, $(Get-Date -format 'yyyy-MM-dd HH:mm:ss'), $e.Name, $e.FullPath
        iex $Object
    }
} 
if ($Delete) {
    $DeleteBlock = {
        $NameOnly = $e.Name -replace '.*\\'
        $Object = $CommandToExecute -f $NameOnly, $e.ChangeType, $(Get-Date -format 'yyyy-MM-dd HH:mm:ss'), $e.Name, $e.FullPath
        iex $Object
    }
} 
if ($Change) {
    $ChangeBlock = {
        $NameOnly = $e.Name -replace '.*\\'
        $Object = $CommandToExecute -f $NameOnly, $e.ChangeType, $(Get-Date -format 'yyyy-MM-dd HH:mm:ss'), $e.Name, $e.FullPath
        iex $Object
    }
} 
if ($Rename) {
    $RenameBlock = { 
        $NameOnly = $e.Name -replace '.*\\'
        $Object = $CommandToExecute -f $NameOnly, $e.ChangeType, $(Get-Date -format 'yyyy-MM-dd HH:mm:ss'), $e.Name, $e.FullPath
        iex $Object
    }
} 

& "$PSScriptRoot\superwatcher.ps1" $FolderPath -Recurse -SkipHiddenFolder -CreatedAction $CreateBlock -DeletedAction $DeleteBlock -ChangedAction $ChangeBlock -RenamedAction $RenameBlock
  