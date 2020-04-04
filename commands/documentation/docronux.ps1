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

& "$PSScriptRoot\ps12markdown.ps1" "$dir" "$dir\dist\wiki\" "Cronux" -Recurse -SkipHtml
cp README.MD "$dir\dist\wiki\Home.md"
& "$PSScriptRoot\markdown2rst.ps1" "$dir\dist\wiki\" "$dir\dist\gh-pages\" -Recurse -FormatInternalLink

[System.IO.File]::WriteAllLines("$dir\dist\gh-pages\index.rst",  "

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Commands
   :name: commands-nav

   /*
   commands/*
   commands/alias/*
   commands/archive/*
   commands/certificates/*
   commands/conversions/*
   commands/cronux/*
   commands/crypto/*
   commands/documentation/*
   commands/filefolder/*
   commands/git/*
   commands/kubectl/*
   commands/net/*
   commands/others/*
   commands/system/*
   docs/*

")
cmd /c "copy `"$dir\dist\gh-pages\index.rst`"+`"$dir\dist\gh-pages\Home.rst`" $(Resolve-Path `"$dir\dist\gh-pages\index.rst`")"
If ([System.IO.Directory]::Exists("$PSScriptRoot\..\..\docs\")) {
    copy "$PSScriptRoot\..\..\docs\*" "$dir\dist\gh-pages\"
}


"Copy everything in $dir\dist\wiki\ to Cronux.wiki repo"
"Copy everything in $dir\dist\gh-pages\ to Cronux gh-pages branch"