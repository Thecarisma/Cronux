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

#& "$PSScriptRoot\ps12markdown.ps1" "$dir" "$dir\dist\wiki\" "Cronux" -Recurse -SkipHtml
#cp README.MD "$dir\dist\wiki\Home.md"
& "$PSScriptRoot\markdown2rst.ps1" "$dir\dist\wiki\" "$dir\dist\gh-pages\" -Recurse

[System.IO.File]::WriteAllLines("$dir\dist\gh-pages\index.rst",  "

.. toctree::
   :hidden:
   :maxdepth: 1
   :name: main-nav

   download

.. toctree::
   :hidden:
   :maxdepth: 1
   :caption: Commands
   :name: commands-nav

   commands/index
   commands/alias/index
   commands/archive/index
   commands/certificates/index
   commands/conversions/index
   commands/cronux/index
   commands/crypto/index
   commands/documentation/index
   commands/filefolder/index
   commands/git/index
   commands/kubectl/index
   commands/net/index
   commands/others/index
   commands/system/index

")
cmd /c "copy `"$dir\dist\gh-pages\index.rst`"+`"$dir\dist\gh-pages\Home.rst`" $(Resolve-Path `"$dir\dist\gh-pages\index.rst`")"
"Copy everything in $dir\dist\wiki\ to Cronux.wiki repo"
"Copy everything in $dir\dist\gh-pages\ to Cronux gh-pages branch"