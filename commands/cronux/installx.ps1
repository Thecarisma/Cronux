#-Requires -RunAsAdministrator
#Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://thecarisma.github.io/Cronux/installx.ps1'))

Function Install-Folder-X {
    if ($Env:OS.StartsWith("Windows")) {
        return $env:ProgramData + "\Cronux\"
    } else {
        return "~/Cronux/"
    }
}

if ($Env:OS -eq $NULL) {
    $Env:OS = "unix" 
    $env:SystemDrive = "/tmp/"
}

$AppName = "Cronux"
$Version = "latest"
$AppArchiveUrl = "https://github.com/Thecarisma/Cronux/archive/main.zip"
$InstallationPath = Install-Folder-X
$PathEnvironment = "User"
$BeforeScript = ""
$AfterScript = " 
    Move-Item -Path ./Cronux-main/commands/archive/*.ps1 -Destination $InstallationPath -Force
    Move-Item -Path ./Cronux-main/commands/conversions/*.ps1 -Destination $InstallationPath -Force
    Move-Item -Path ./Cronux-main/commands/cronux/*.ps1 -Destination $InstallationPath -Force
    Move-Item -Path ./Cronux-main/*.bat -Destination $InstallationPath -Force
    Move-Item -Path ./Cronux-main/*.sh -Destination $InstallationPath -Force
    Move-Item -Path ./Cronux-main/LICENSE -Destination $InstallationPath -Force
    powershell -noprofile -executionpolicy bypass -file ./extractx.ps1 ./ExportList.txt
    powershell -noprofile -executionpolicy bypass -file ./buildcronux.ps1  ./ ./
    Remove-Item -path ./Cronux-main -Recurse -ErrorAction Ignore
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

    If (-not (Test-Path $folder)) {
        New-Item -Path $folder -ItemType Directory > $null
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

    if ($Env:OS.StartsWith("Windows")) {
        "Adding $folder to $PathEnvironment Path variable"
        $NewPath = ""
        ForEach ($_path in $Path.Split(";")) {
            If ($_path -ne $InstallationPath -and $_path -ne "") {
                $NewPath += "$_path;"
            }
        }
        [Environment]::SetEnvironmentVariable("Path", "$NewPath$folder", "$PathEnvironment")

    } else {
        "Adding $folder to ~/.bashrc Path variable"
        echo "export PATH=`"$folder`":`$PATH">>~/.bashrc
    }
}

Function Iterate-Folder {
    Param([string]$foldername)

    Get-ChildItem $foldername | Foreach-Object {
        If ( -not $_.PSIsContainer) {
            If ( -not $_.Name.EndsWith(".ps1")) {
                Return
            }
            Copy-Item -Path $_.FullName -Destination $InstallationPath -Force
        } Else {
            Iterate-Folder $_.FullName
        }
    }
}

"Preparing to install $AppName $Version"
If ([System.IO.Directory]::Exists("$InstallationPath")) {
    Remove-Item -path "$InstallationPath\*.ps1" -Recurse -ErrorAction Ignore
    Remove-Item -path "$InstallationPath\*.bat" -Recurse -ErrorAction Ignore
}
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
    Extract-App-Archive "$TEMP/installx_package_.zip" "$InstallationPath"
    Set-Location -Path $InstallationPath
    If ($AfterScript -ne "") {
        "Executing the AfterScript..."
        iex "$AfterScript"
    }
    "Installtion completes."
} else {
    Check-Create-Directory $InstallationPath
    Iterate-Folder $CommandsFolder
    Set-Location -Path $InstallationPath
    powershell -noprofile -executionpolicy bypass -file ./extractx.ps1 ./ExportList.txt
    powershell -noprofile -executionpolicy bypass -file ./buildcronux.ps1  ./ ./
    If (Test-Path "./Cronux-main") {
        Remove-Item -path "./Cronux-main" -recurse -ErrorAction Ignore
    }
}

If ($AddPath -eq $true) {
    Add-Folder-To-Path "$InstallationPath"
}


