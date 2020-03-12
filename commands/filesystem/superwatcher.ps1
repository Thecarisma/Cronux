<#
.SYNOPSIS
    A PowerShell Script Server. Basically, it monitors a folder and 
    when files appear in it, it takes some action on them.
.DESCRIPTION
    A PowerShell Script Server. Basically, it monitors a folder and 
    when files appear in it, it takes some action on them, in this 
    case: execute them. I've written servers like that before, 
    but always in C#, using the System.IO.FileSystemWatcher class. 
    Once again, it's not rocket science: the main challenge is in 
    error handling and logging. The heavy lifting is done by the 
    FileSystemWatcher, which lives up to its name: it watches a 
    (single) folder, with or without it subfolders, and raises 
    event when files are Created, Changed, Deleted or Renamed. 
    (Those are also the names of the events). Each event gets an 
    argument specifying which file was afffected; the Renamed event 
    also receives the previous name of the file. So after setting up 
    the FileSystemWatcher, all there's left to do is to implement 
    the event handlers.
    
    Start-FileSystemWatcher.ps1 - File System Watcher in Powershell.
    Brought to you by MOBZystems, Home of Tools
    https://www.mobzystems.com/code/using-a-filesystemwatcher-from-powershell/
.INPUTS 
    System.String[]
.OUTPUTS 
    Events Script Blocks
.NOTES
    File Name  : superwatcher.ps1
    Author     : MOBZystems
    Date       : Jul-15-2017
.LINK
    https://www.mobzystems.com/code/using-a-filesystemwatcher-from-powershell/
    https://thecarisma.github.io/Cronux
    https://thecarisma.github.io/Cronux/commands/filesystem/superwatcher.html
.EXAMPLE
    superwatcher.ps1 C:\test\ -Recurse -CreatedAction {
        Write-Output "$(Get-Date -format 'yyyy-MM-dd HH:mm:ss') File '$($e.FullPath)' was created"
    } -ChangedAction {
        Write-Output "$(Get-Date -format 'yyyy-MM-dd HH:mm:ss') File '$($e.FullPath)' was changed"
    } -DeletedAction {
        Write-Output "$(Get-Date -format 'yyyy-MM-dd HH:mm:ss') File '$($e.FullPath)' was deleted"
    } -RenamedAction {
        Write-Output "$(Get-Date -format 'yyyy-MM-dd HH:mm:ss') File '$($e.OldFullPath)' was renamed to '$($e.FullPath)'"
    }
    The command will prints out the date and file name 
    anytime a file get deleted, created, changes or renamed 
    in the folder C:\test\
.EXAMPLE
    superwatcher.ps1 C:\test\ -Recurse -DeletedAction {
        Write-Output "$(Get-Date -format 'yyyy-MM-dd HH:mm:ss') File '$($e.FullPath)' was deleted"
    }
    The command will prints out the date and file name 
    anytime a file get deleted in the folder C:\test\
#>

[CmdletBinding()]
Param(
    # The path to monitor
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Path,
    # Monitor these files (a wildcard)
    [Parameter(Position=1)]
    [string]$Filter = "*.*",
    # Monitor subdirectories?
    [switch]$Recurse,
    # Monitor hidden folder, true by default
    [switch]$SkipHiddenFolder,
    # Execute ths block on Created
    [scriptblock]$CreatedAction,
    # Execute ths block on Deleted
    [scriptblock]$DeletedAction,
    # Execute ths block on Changed
    [scriptblock]$ChangedAction,
    # Execute ths block on Renamed
    [scriptblock]$RenamedAction,
    # Check for ESC every ... seconds
    [int]$KeyboardTimeout = -1
)

# In cases where on change occur a file keep updating itself
# like a index database, git.lock file, this will causes endless
# call to the DoAction scriptblock, hence we cache the last 
# action and file name so we simply ignore the second call with 
# the same action and file name.
$Global:last_event_name = $ChangedAction
$Global:last_file_name = ""

# Helper function to set up variables $_, $eventArgs and $e
Function DoAction(
    # The name of the even that occur 
    [string]$event_name,
    # The action to execute. Is one of the script arguments $ChangedAction, $CreateAction, etc.
    [scriptblock]$action,
    # The name of the file, local to the path being watched
    [string]$_,
    # The [PSEventsArgs] object returned from Wait-Event
    [System.Management.Automation.PSEventArgs]$eventArgs,
    # For Renamed this is a RenamedEventArgs object, for the others a FileSystemEventArgs
    # FileSystemEventArgs has ChangeType, FullPath and Name;
    # RenamedEventArgs adds OldFullPath and OldName
    $e
)
{
    # "Old=$Global:last_file_name,New=$_,Event=$event_name,StartsWith=$($Global:last_file_name.StartsWith($_) -and $event_name -ne `"Renamed`")"
    if ($Global:last_event_name -eq $event_name -and $Global:last_file_name -eq $_ -or 
        ($Global:last_file_name.StartsWith($_) -and $event_name -ne "Renamed")) {
        return
    }
    $Global:last_event_name = $event_name
    $Global:last_file_name = $_
    
    # event action get called over 20 times for just a file name change
    # Execute the action and catch its output
    
    if ($output) { 
        $output = & $action       
    
        # Write to output
        Write-Output $output
        # And to log file if we have to
        if ($LogFile -ne '') {
            Write-Output $output >> $LogFile
        }
    } else {
        & $action 
    }
}

# Sanity check: you have to provide at least one action
if (!$CreatedAction -and !$DeletedAction -and !$ChangedAction -and !$RenamedAction) {
    Write-error "Specify at least one of -CreatedAction, -DeletedAction, -ChangedAction or -RenamedAction"
    return
}

# Remove all event handlers and events
@( "FileCreated", "FileDeleted", "FileChanged", "FileRenamed" ) | ForEach-Object {
    Unregister-Event -SourceIdentifier $_ -ErrorAction SilentlyContinue
    Remove-Event -SourceIdentifier $_ -ErrorAction SilentlyContinue
}

# Do the file watching on the $Path argument's full path
[string]$fullPath = (Convert-Path $Path)

# Set up the file system watcher with the full path name of the supplied path
[System.IO.FileSystemWatcher]$fsw = New-Object System.IO.FileSystemWatcher $fullPath, $Filter -Property @{IncludeSubdirectories = $Recurse;NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite, DirectoryName'}

# Register an event handler for all actions, if provided:
if ($CreatedAction) {
    Register-ObjectEvent $fsw Created -SourceIdentifier "FileCreated"
}
if ($DeletedAction) {
    Register-ObjectEvent $fsw Deleted -SourceIdentifier "FileDeleted"
}
if ($ChangedAction) {
    Register-ObjectEvent $fsw Changed -SourceIdentifier "FileChanged"
}
if ($RenamedAction) {
    Register-ObjectEvent $fsw Renamed -SourceIdentifier "FileRenamed"
}

[string]$recurseMessage = ''
if ($Recurse) {
    $recurseMessage = " and subdirectories"
}
[string]$pathWithFilter = Join-Path $fullPath $Filter

if ($KeyboardTimeout -eq -1) {
    Write-Host "Monitoring '$pathWithFilter'$recurseMessage. Press Ctrl+C to stop."
} else {
    Write-Host "Monitoring '$pathWithFilter'$recurseMessage. Press ESC to cancel in at most $KeyboardTimeout seconds, or Ctrl+C to abort."
}

# Start monitoring
$fsw.EnableRaisingEvents = $true

[bool]$exitRequested = $false

do {
    # Wait for an event
    [System.Management.Automation.PSEventArgs]$e = Wait-Event -Timeout $KeyboardTimeout

    if ($e -eq $null) {
        # No evet? Then this is a timeout. Check for ESC
        while ($host.UI.RawUI.KeyAvailable) {
            $k = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp,IncludeKeyDown")
            if (($k.Character -eq 27) -and !$exitRequested) {
                Write-Host "ESC pressed. Exiting..."
                $exitRequested = $true
            }
        }
    } else {        
        # A real event! Handle it:
        # Get the name of the file
        [string]$name = $e.SourceEventArgs.Name
        # The type of change
        [System.IO.WatcherChangeTypes]$changeType = $e.SourceEventArgs.ChangeType
        # The time and date of the event
        [string]$timeStamp = $e.TimeGenerated.ToString("yyyy-MM-dd HH:mm:ss")

        Write-Verbose "--- START [$($e.EventIdentifier)] $changeType $name $timeStamp"

        switch ($changeType) {
            Changed { DoAction "Changed" $ChangedAction $name $e $($e.SourceEventArgs) }
            Deleted { DoAction "Deleted" $DeletedAction $name $e $($e.SourceEventArgs) }
            Created { DoAction "Created" $CreatedAction $name $e $($e.SourceEventArgs) }
            Renamed { DoAction "Renamed" $RenamedAction $name $e $($e.SourceEventArgs) }
        }

        # Remove the event because we handled it
        Remove-Event -EventIdentifier $($e.EventIdentifier)

        Write-Verbose "--- END [$($e.EventIdentifier)] $changeType $name $timeStamp"
    }
} while (!$exitRequested)

if ($CreatedAction) {
    Unregister-Event FileCreated
}
if ($DeletedAction) {
    Unregister-Event FileDeleted
}
if ($ChangedAction) {
    Unregister-Event FileChanged
}
if ($RenamedAction) {
    Unregister-Event FileRenamed
}

Write-Host "Exited."


