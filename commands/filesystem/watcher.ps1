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
    [Parameter(mandatory=$true)]
    [string]$FolderPath,
    [switch]$Create,
    [switch]$Delete,
    [switch]$Changed,
    [switch]$Rename,
    [Parameter(mandatory=$true)]
    [string]$CommandToExecute
)

Set-Location -Path $FolderPath
$Object  =  $CommandToExecute -f $e.Name, $e.ChangeType, $(Get-Date -format 'yyyy-MM-dd HH:mm:ss'), $e.FullPath
$CreateBlock = {}
if ($Create) {
    $CreateBlock = {
        iex $Object
    }
} 

& "$PSScriptRoot\superwatcher.ps1" $FolderPath -Recurse -SkipHiddenFolder -CreatedAction $CreateBlock
    
 # -ChangedAction {
    # Write-Output "$(Get-Date -format 'yyyy-MM-dd HH:mm:ss') File '$($e.FullPath)' was changed"
# } -DeletedAction {
    # Write-Output "$(Get-Date -format 'yyyy-MM-dd HH:mm:ss') File '$($e.FullPath)' was deleted"
# } -RenamedAction {
    # Write-Output "$(Get-Date -format 'yyyy-MM-dd HH:mm:ss') File '$($e.OldFullPath)' was renamed to '$($e.FullPath)'"
# }

  




#dirwatcher C:\Users\azeez\Documents\OPEN_SOURCE\THECARISMA\Cronux Creates,Delete 'git commit -m "${0}ed ${1}: fix low fortify issues '

