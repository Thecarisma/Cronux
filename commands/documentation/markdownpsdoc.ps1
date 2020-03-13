<#
.SYNOPSIS
   
.DESCRIPTION
    Add the -Verbose switch to see more output in the 
    shell
.INPUTS 
    None
.OUTPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : markdownpsdoc.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-08-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    markdownpsdoc .\dist\cronux_doc\commands\gencert.psdoc .\dist\cronux_markdown\
.EXAMPLE
    
#>

[CmdletBinding()]
Param(
    # The path to the psdoc file or folder to convert to markdown
    [Parameter(Mandatory=$true, Position=0)]
    [string]$PsDocPath,
    # the folder to put generated markdown
    [Parameter(Mandatory=$true, Position=1)]
    [string]$OutputFolder,
    # whether to generate table of content
    [switch]$Toc,
    # do not use html to position and format document
    [switch]$SkipHtml
)

$PsDocPath = [System.IO.Path]::GetFullPath($PsDocPath)
$OutputFolder = [System.IO.Path]::GetFullPath($OutputFolder)

Function main {
    If ( -not [System.IO.Directory]::Exists($OutputFolder)) {
        [System.IO.Directory]::CreateDirectory($OutputFolder) > $null
        If ( -not $?) {
            Return
        }
    }
    
    if (Test-Path -Path $PsDocPath -PathType Container) {
        
    } else {
        If ( -not [System.IO.File]::Exists($PsDocPath)) {
            Return
        }
        PsDoc-to-Markdown $PsDocPath
    }
}

Function PsDoc-to-Markdown {
    Param(
        [string]$SinglePsDocPath
    )
    
    "Do $SinglePsDocPath"
}




main






