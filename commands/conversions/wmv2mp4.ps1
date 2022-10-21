<#
.SYNOPSIS
    Convert a WMV file to MP4
.DESCRIPTION
    Convert a WMV to MP4 using ffmpefg. 
    Download ffmpeg from https://ffmpeg.org/download.html.
.INPUTS 
    [System.String[]]
.OUTPUTS 
    [System.String[]]
.NOTES
    Version    : 1.0
    File Name  : wmv2mp4.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : October-21-2022
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    wmv2mp4 video.wmv
    This will generates video.mp4 in the folder ./output 
    relative to the working dir.
.EXAMPLE
    wmv2mp4 video.wmv C:/videos/
    This will generates video.mp4 in the folder C:/videos/
#>

[CmdletBinding()]
Param(
    # The path to the WMV file to convert to mp4
    [Parameter(Mandatory=$true, Position=0)]
    [string]$MediaPath,
    # the folder to put generated reStructuredText
    [string]$OutputFolder = "./output",
    # whether to print anything to the console
    [switch]$Silent
)

$MediaPath = [System.IO.Path]::GetFullPath($MediaPath)
$OutputFolder = [System.IO.Path]::GetFullPath($OutputFolder)

Function main {
    If ( -not [System.IO.Directory]::Exists($OutputFolder)) {
        [System.IO.Directory]::CreateDirectory($OutputFolder) > $null
        If ( -not $?) {
            Return
        }
    }

    If ( -not [System.IO.File]::Exists($MediaPath)) {
        throw "The WMV media file '$MediaPath' does not exists"
    }
    $OutPutFile = "$OutputFolder/$([System.IO.Path]::GetFileNameWithoutExtension($MediaPath)).mp4"
    if (-not $Silent) {
        Write-Output "Converting $MediaPath => $OutPutFile"
    }
    if (-not $Silent) {
        ffmpeg -i "$MediaPath" -c:v libx264 -crf 23 -c:a aac -q:a 100 "$OutPutFile"
    } else {
        ffmpeg -i "$MediaPath" -c:v libx264 -crf 23 -c:a aac -q:a 100 "$OutPutFile" 2> $null
    }
}


main