#-Requires -RunAsAdministrator
#Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://thecarisma.github.io/installx.ps1'))

$AppName = "Cronux"
$Version = & "$PSScriptRoot\versionx.ps1"
$AppArchiveUrl = "https://github.com/Thecarisma/Cronux/archive/master.zip"
$InstallationPath = & "$PSScriptRoot\installfolderx.ps1"
$PathEnvironment = "User"
$BeforeScript = ""
$AfterScript = "
    cp ./Cronux-master/commands/filefolder/extractx.ps1 $InstallationPath
    cp ./Cronux-master/commands/cronux/buildcronux.ps1 $InstallationPath
    cp ./Cronux-master/commands/conversions/batforps.ps1 $InstallationPath
    cp ./Cronux-master/commands/conversions/wrapcommand.ps1 $InstallationPath
    cp ./Cronux-master/*.bat $InstallationPath
    cp ./Cronux-master/*.sh $InstallationPath
    cp ./Cronux-master/LICENSE $InstallationPath
    powershell -noprofile -executionpolicy bypass -file ./extractx.ps1 ./ExportList.txt
    powershell -noprofile -executionpolicy bypass -file ./buildcronux.ps1  ./ ./
    Remove-Item -path ./Cronux-master -recurse
"
$CommandsFolder = $PSScriptRoot
If ( -not [System.IO.File]::Exists("$CommandsFolder\Cronux.ps1")) {
    $CommandsFolder = "$PSScriptRoot\..\"
    If ( -not [System.IO.File]::Exists("$CommandsFolder\Cronux.ps1")) {
        $CommandsFolder = "$PSScriptRoot\..\..\"
        If ( -not [System.IO.File]::Exists("$CommandsFolder\Cronux.ps1")) {
            $CommandsFolder = "$PSScriptRoot\..\..\..\"
        }
    }
}

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
    Expand-Archive $archive_path -DestinationPath $extact_folder -Force
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

Function Iterate-Folder {
    Param([string]$foldername)
    
    Get-ChildItem $foldername | Foreach-Object {
        If ( -not $_.PSIsContainer) {
            If ( -not $_.Name.EndsWith(".ps1")) {
                Return
            }
            cp $_.FullName $InstallationPath
        } Else {
            Iterate-Folder $_.FullName
        }
    }
}

"Preparing to install $AppName $Version"
If (-not [System.IO.File]::Exists("$PSScriptRoot/../net/ipof.ps1")) {
    Check-Create-Directory $TEMP
    If ($BeforeScript -ne "") {
        "Executing the BeforeScript..."
        iex "$BeforeScript"
    }
    "Downloading the program archive..."
    Download-App-Archive
    Check-Create-Directory $InstallationPath
    "Installing $AppName $Version in $InstallationPath"
    Extract-App-Archive "$TEMP\installx_package_.zip" "$InstallationPath"
    Set-Location -Path $InstallationPath
    If ($AfterScript -ne "") {
        "Executing the AfterScript..."
        iex "$AfterScript"
    }
    "Installtion completes."
} else {
    Check-Create-Directory $InstallationPath
    $CommandsFolder
    Iterate-Folder $CommandsFolder
    Set-Location -Path $InstallationPath
    powershell -noprofile -executionpolicy bypass -file ./extractx.ps1 ./ExportList.txt
    powershell -noprofile -executionpolicy bypass -file ./buildcronux.ps1  ./ ./
    If ([System.IO.Directory]::Exists("./Cronux-master")) {
        Remove-Item -path "./Cronux-master" -recurse
    }
}

If ($AddPath -eq $true) { 
    "Adding $InstallationPath to $PathEnvironment Path variable"
    Add-Folder-To-Path "$InstallationPath" 
}

