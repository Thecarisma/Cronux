$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path  = "C:\Users\adewale.azeez\Documents\OPEN_SOURCE\THECARISMA\Cronux\dist\test"

  Register-ObjectEvent -InputObject $FileSystemWatcher  -EventName Created  -Action {

  $Object  = "{0} was  {1} at {2}" -f $Event.SourceEventArgs.FullPath,

  $Event.SourceEventArgs.ChangeType,

  $Event.TimeGenerated

  $WriteHostParams  = @{

  ForegroundColor = 'Green'

  BackgroundColor =  'Black'

  Object =  $Object

  }

  Write-Host @WriteHostParams

} 

#dirwatcher C:\Users\azeez\Documents\OPEN_SOURCE\THECARISMA\Cronux Creates,Delete 'git commit -m "${0}ed ${1}: fix low fortify issues '