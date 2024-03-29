<#
.SYNOPSIS
    Execute Windows Command prompt command when an event occur in 
    a directory.
.DESCRIPTION
    Execute Windows Command prompt command when an event occur in a 
    directory. The command is called with the name of 
    the event that occur and the attribute of the file 
    that changes. 
    
    The command accept four swicth to indicate the type of 
    event that should trigger the Windows Command prompt command. 
    The events switch are: 
    -Create : triggers the command when a file/folder is created
    -Delete : triggers the command when a file/folder id deleted
    -Change : triggers the command when a file/folder changes
    -Rename : triggers the command when a file/folder name changes
    
    One or the combination or all the of the event switch can be 
    specified. 
    
    The CommandToExecute parameter must be a valid Windows Command prompt 
    command and not batch. To execute powershell command call the **watcher** 
    command. Execute helpx watcherb to view all the positional variable 
    available for the command. Specifying the CommandToExecute as argument 
    will require escaping the command for command prompt.
    
    The command is executed in the monitored folder.
    
.INPUTS 
    System.String[]
.OUTPUTS 
    $CommandToExecute execution result
.NOTES
    File Name  : watcherb.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : Mar-12-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://www.mobzystems.com/code/using-a-filesystemwatcher-from-powershell/
    https://thecarisma.github.io/Cronux/commands/filesystem/superwatcher.html
    https://thecarisma.github.io/Cronux/commands/filesystem/watcher.html
    https://thecarisma.github.io/Cronux/commands/filesystem/watcherb.html
.EXAMPLE
    watcherb "." "echo {0}" -Rename -Delete -Change -Create
    The command above monitor the current folder and prints 
    the name of the file that changes. If a file or folder is 
    renamed, deleted, changed or created the name of the file or 
    folder will be printed in the terminal.
.EXAMPLE 
    watcherb "." "git add . && git commit -m \"\"{0} was {1}, writing watcherb command\"\"" -Rename -Delete -Change -Create
    Executing this command in Windows Command prompt will add the changed 
    files and commit then in the git repository. Everytime a file 
    or folder status changed, the changes is automatically commited. 
    e.g. if a file Test.txt is saved the command will be executed 
    
    'git add .; git commit -m "Test.txt was Changed, fixing issues"'
    String index of {0} and {1} has been substituted with the respective 
    values 
.EXAMPLE
    watcherb -Rename -Delete -Change -Create
    The command above is best executed in all cases as the FolderPath and 
    CommandToExecute parameters will be requested and there will be no need 
    to escape the CommandToExecute.   
#>

[CmdletBinding()]
Param(
    # the folder to monitor
    [Parameter(mandatory=$true)]
    [string]$FolderPath,
    # the command to execute when an event occur
    # the command accepted is Windows Command prompt for 
    # powershell command call 'watcher'
    # you following variables index are set for the command 
    # 0 - file name only
    # 1 - the event name
    # 2 - formated date
    # 3 - the file path relative to the monitored folder
    # 4 - the full file path
    #
    # e.g to print out the name of the file that change
    # Write-Output {0}
    # e.g to print out the name and date of the file that change
    # Write-Output Name={0}, Date={2}
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
        cmd.exe /c $Object
    }
} 
if ($Delete) {
    $DeleteBlock = {
        $NameOnly = $e.Name -replace '.*\\'
        $Object = $CommandToExecute -f $NameOnly, $e.ChangeType, $(Get-Date -format 'yyyy-MM-dd HH:mm:ss'), $e.Name, $e.FullPath
        cmd.exe /c $Object
    }
} 
if ($Change) {
    $ChangeBlock = {
        $NameOnly = $e.Name -replace '.*\\'
        $Object = $CommandToExecute -f $NameOnly, $e.ChangeType, $(Get-Date -format 'yyyy-MM-dd HH:mm:ss'), $e.Name, $e.FullPath
        cmd.exe /c $Object
    }
} 
if ($Rename) {
    $RenameBlock = { 
        $NameOnly = $e.Name -replace '.*\\'
        $Object = $CommandToExecute -f $NameOnly, $e.ChangeType, $(Get-Date -format 'yyyy-MM-dd HH:mm:ss'), $e.Name, $e.FullPath
        cmd.exe /c $Object
    }
} 

& "$PSScriptRoot\superwatcher.ps1" $FolderPath -Recurse -SkipHiddenFolder -CreatedAction $CreateBlock -DeletedAction $DeleteBlock -ChangedAction $ChangeBlock -RenamedAction $RenameBlock
  