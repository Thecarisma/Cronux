#Requires -RunAsAdministrator
#Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('http://localhost:8020/remoterun.ps1'))

$AppName = "Cronux"
$Version = "2.0"
$AppArchiveUrl = "https://github.com/Thecarisma/Cronux/releases/download/v1.2/Cronux.zip"
$InstallationPath = $env:ProgramData + "\$AppName\"
$PathEnvironment = "User"

$AddPath = $true

$Path = [Environment]::GetEnvironmentVariable('Path', "$PathEnvironment")
$TEMP = Join-Path $env:SystemDrive "temp\installx\$AppName"

Function Check-Create-Directory {
    Param([string]$folder)
    
    If ( -not [System.IO.Directory]::Exists($folder)) {
        [System.IO.Directory]::CreateDirectory($folder) > $null
        If ( -not $?) {
            Return
        }
    }
}

Function Download-App-Archive {
    Invoke-WebRequest $AppArchiveUrl -OutFile "$TEMP\installx_package_.zip"
}

Function Extract-App-Archive {
    Param([string]$archive_path, [string]$extact_folder)
    
    If ( -not [System.IO.File]::Exists($archive_path)) {
        Write-Error "Cannot find the downloaded archive, stopping installation"
        Return
    }
    Check-Create-Directory $extact_folder
    Expand-Archive $archive_path -DestinationPath $extact_folder
}

Function Add-Folder-To-Path {
    Param([string]$folder)
    
    $NewPath = ""    
    ForEach ($_path in $Path.Split(";")) {
        If ($_path -ne $InstallationPath -and $_path -ne "") {
            $NewPath += "$_path;"
        }
    }
    [Environment]::SetEnvironmentVariable("Path", "$NewPath$folder", "$PathEnvironment")
}

Check-Create-Directory $TEMP
"Downloading the app archive..."
Download-App-Archive
Check-Create-Directory $InstallationPath
"Installing $AppName $Version in $InstallationPath"
Extract-App-Archive "$TEMP\installx_package_.zip" "$InstallationPath"
If ($AddPath -eq $true) { Add-Folder-To-Path "$InstallationPath" }