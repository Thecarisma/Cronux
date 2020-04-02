<#
.SYNOPSIS
   Generate documenation for Cronux
.DESCRIPTION
    Add the -Verbose switch to see more output in the 
    shell
.INPUTS 
    None
.OUTPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : docronux.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : March-16-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    docronux    
#>

[CmdletBinding()]
Param(
    
)

$dir = $PSScriptRoot
If ( -not [System.IO.File]::Exists("$dir\Cronux.bat")) {
    $dir = "..\..\"
    If ( -not [System.IO.File]::Exists("$dir\Cronux.bat")) {
        $dir = ".\"
    }
}

& "$PSScriptRoot\ps12markdown.ps1" "$dir" "$dir\dist\wiki\" "Cronux" -Recurse
& "$PSScriptRoot\markdown2rst.ps1" "$dir\dist\wiki\" "$dir\dist\gh-pages\" -Recurse
"Copy everything in $dir\dist\wiki\ to Cronux.wiki repo"
"Copy everything in $dir\dist\gh-pages\ to Cronux gh-pages branch"