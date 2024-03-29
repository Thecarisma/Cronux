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
    File Name  : ps12markdown.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : March-12-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    ps12markdown .\ .\dist\Cronux.wiki\ -Recurse
.EXAMPLE
    
#>

[CmdletBinding()]
Param(
    # The path to the powershell scri[t to extract documentation
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Path,
    # the folder to put generated exported documenation
    [Parameter(Mandatory=$true, Position=1)]
    [string]$OutputFolder,
    # The project name
    [Parameter(Mandatory=$false, Position=2)]
    [string]$ProjectName,
    # do not use html to position and format document
    [switch]$SkipHtml,
    # do not add notes detail before description
    [switch]$SkipNotes,
    # whether to print anythin to the console
    [switch]$Silent,
    # generate markdown in subfolders?
    [switch]$Recurse,
    # do not delete the generated .psdoc files in OutputFolder
    [switch]$Keep
)

& "$PSScriptRoot\psdoc.ps1" $Path "$OutputFolder" -Recurse:$Recurse -Silent:$Silent 
& "$PSScriptRoot\psdoc2markdown.ps1" $OutputFolder $OutputFolder $ProjectName -SkipHtml:$SkipHtml -SkipNotes:$SkipNotes -Silent:$Silent -Recurse:$Recurse

If (-not $Keep) {
    if (-not $Silent) {
        "Cleaning up generated *.psdoc files"
    }
    Get-ChildItem $OutputFolder -Recurse | Where{$_.Name -Match "(.*?)(\.psdoc)"} | Remove-Item
}