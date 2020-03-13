
# <p style="text-align: center;" align="center">watcher</p>

<p style="text-align: center;" align="center">Execute powershell command when an event occur in a directory.</p>

---

Execute powershell command when an event occur in a 
directory. The command is called with the name of 
the event that occur and the attribute of the file 
that changes. 

The command accept four swicth to indicate the type of 
event that should trigger the powershell command. The 
events switch are: 
 - -Create : triggers the command when a file/folder is created
 - -Delete : triggers the command when a file/folder id deleted
 - -Change : triggers the command when a file/folder changes
 - -Rename : triggers the command when a file/folder name changes

One or the combination or all the of the event switch can be 
specified. 

The CommandToExecute parameter must be a valid powershell command 
and not batch. To execute batch command call the **watcherb** 
command. Execute chelp watcher to view all the positional variable 
available for the command. Specifying the CommandToExecute as argument 
will require escaping the command for powershell.

The command is executed in the monitored folder.

## Syntax

```powershell
watcher [-FolderPath] <String> [-CommandToExecute] <String> [-Create] [-Delete] [-Change][-Rename] [<CommonParameters>]
```

## Parameters

### -FolderPath <String>

the folder to monitor
 
```powershell       
Required?                    true
Position?                    1
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```

### -CommandToExecute <String>

the command to execute when an event occur
the command accepted is powershell for batch 
command call 'watcherb'
you following variables index are set for the command 

 - 0 - file name only
 - 1 - the event name
 - 2 - formated date
 - 3 - the file path relative to the monitored folder
 - 4 - the full file path

e.g to print out the name of the file that change
Write-Output {0}
e.g to print out the name and date of the file that change
Write-Output Name={0}, Date={2}

```powershell
Required?                    true
Position?                    2
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```

## Input

System.String[]

## Output

$CommandToExecute execution result

## Examples

### Example 1

```powershell
watcher "." "Write-Output {0}" -Rename -Delete -Change -Create
```

The command above monitor the current folder and prints 
the name of the file that changes. If a file or folder is 
renamed, deleted, changed or created the name of the file or 
folder will be printed in the terminal.

### Example 2

```powershell
watcher "." "git add .; git commit -m `"{0} was {1}, fixing issues`"" -Rename -Delete -Change -Create
```

Executing this command in powershell will add the changed 
files and commit then in the git repository. Everytime a file 
or folder status changed, the changes is automatically commited. 
e.g. if a file Test.txt is saved the command will be executed 

'git add .; git commit -m "Test.txt was Changed, fixing issues"'
String index of {0} and {1} has been substituted with the respective 
values

## Related Links

 - [https://thecarisma.github.io/Cronux](https://thecarisma.github.io/Cronux)
 - [https://www.mobzystems.com/code/using-a-filesystemwatcher-from-powershell/](https://www.mobzystems.com/code/using-a-filesystemwatcher-from-powershell/)
 - [https://thecarisma.github.io/Cronux/commands/filesystem/superwatcher.html](https://thecarisma.github.io/Cronux/commands/filesystem/superwatcher.html)
 - [https://thecarisma.github.io/Cronux/commands/filesystem/watcher.html](https://thecarisma.github.io/Cronux/commands/filesystem/watcher.html)