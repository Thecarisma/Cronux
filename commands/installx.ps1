#Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('http://localhost:8020/remoterun.ps1'))

$Path = [Environment]::GetEnvironmentVariable('Path')
$TEMP = Join-Path $env:SystemDrive 'temp\installx'
$ArchiveUrl = "cronux.zip"

$Path
$TEMP