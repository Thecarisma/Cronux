<#
.SYNOPSIS
    Select of View list of available version of a programming language 
    on a system.
.DESCRIPTION
    View all the list of installed versions of a programming language
    on your system.
    
    Also allow selecting which version of the programming language to use 
    for the active shell session. 

    If the List switch and the version to select is not specified this 
    command will only print out the current version of the programming 
    language.

    Supported Languages:
        php
.INPUTS 
    System.String[]
.OUTPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : pvselect.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : Jun-05-2022
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    pvselect php -List
    List all the installed versions of php on the system
.EXAMPLE
    pvselect php 
    List all the installed versions of php on the system
.EXAMPLE
    pvselect php 5.6.40
    Change the php version in the active shell to php5.6.40
.EXAMPLE
    pvselect php 7.4.26
    Change the php version in the active shell to php7.4.26
    
#>

Param(
    # The programming language to slect the version for the active shell session
    [Parameter(Mandatory = $true)]
    [string]$Language,
    # The language version to use for the active shell session
    [string]$Version,
    # List all the available version of a language on the system
    [switch]$List
)

Function main {
    Write-Output "Language $Language, Version $Version, List $List"
    Treat-Language
}

Function Treat-Language {
    If ($Language -eq "php") { Resolve-Php }
    Else {
        Write-Error "The language '$Language' is currently not supported"
    }
}

Function Search-Into {
    Param(
        $SearchIntoPaths,
        $Filter = "*"
    )

    $SearchIntoResult = New-Object System.Collections.ArrayList
    ForEach ($SearchPath in $SearchIntoPaths) {
        Get-ChildItem -Directory $SearchPath -Include ($Filter) 2> $null | ForEach-Object {
            $SearchIntoResult.Add($_.FullName) > $null
        }
    }

    Return $SearchIntoResult

}

Function Resolve-Php {
    $SearchPaths = New-Object System.Collections.ArrayList
    $SearchPaths.Add("C:\wamp\bin\php") > $null
    $SearchPaths.Add("C:\wamp64\bin\php") > $null

    If ((-not $Version -or $Null -eq $Version -or $Version -eq "") -and -not $List) {
        php -v
        Return
    }

    $SearchPaths = Search-Into $SearchPaths
    If ($List) {
        ForEach ($SearchPath in $SearchPaths) {
            Write-Output $SearchPath.SubString($SearchPath.LastIndexOf("\") + 1)
        }
        Return
    }

    ForEach ($SearchPath in $SearchPaths) {
        If ($SearchPath.Contains($Version)) {
            $env:Path = $SearchPath + ';' + $env:Path
            $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
            [System.IO.File]::WriteAllLines("$([System.IO.Path]::GetTempPath())/cronux_temp.bat", "SET PATH=$SearchPath;%PATH%", $Utf8NoBomEncoding)
            Write-Output "$([System.IO.Path]::GetTempPath())/cronux_temp.bat"
            & "$([System.IO.Path]::GetTempPath())/cronux_temp.bat"
            $ "php -v"
            Return
            # Write-Output "SET PATH=$SearchPath;%PATH%" > New-TemporaryDirectory/cronux_temp.bat
            # call ~/cronux_temp.bat
            # $ParentProcessIds = Get-CimInstance -Class Win32_Process -Filter "ProcessId = $PID"
            # $ParentProcessIds
            # $ParentProcessIds = Get-CimInstance -Class Win32_Process -Filter "ProcessId = $($ParentProcessIds[0].ParentProcessId)"
            # $ParentProcessIds
            # $ParentProcessIds = Get-CimInstance -Class Win32_Process -Filter "ProcessId = $($ParentProcessIds[0].ParentProcessId)"
            # $ParentProcessIds
            # Start-Process cmd -ArgumentList "/c", "SET PATH=$SearchPath;%PATH%", "&&", "php -v", "&&", "TIMEOUT /T 20"
        }
    }
    
}

function New-TemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    [string] $name = [System.Guid]::NewGuid()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
}

main