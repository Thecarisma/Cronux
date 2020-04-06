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
& "$PSScriptRoot\markdown2rst.ps1" "$dir\dist\wiki\" "$dir\dist\gh-pages\" -Recurse -FilterRst

[System.IO.File]::WriteAllLines("$dir\dist\gh-pages\index.rst",  "

.. toctree::
   :hidden:
   :maxdepth: 1
   :caption: Commands
   :name: commands-nav

   commands/index
   commands/Cronux
   commands/commands
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

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Alias
   :name: alias-nav

   commands/alias/*

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Archive
   :name: archive-nav

   commands/archive/*

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Certificates
   :name: certificates-nav

   commands/certificates/*

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Conversions
   :name: conversions-nav

   commands/conversions/*

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Cronux
   :name: cronux-nav

   commands/cronux/*

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Crypto
   :name: crypto-nav

   commands/crypto/*

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Documentation
   :name: documentation-nav

   commands/documentation/*

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Filefolder
   :name: filefolder-nav

   commands/filefolder/*

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Git
   :name: git-nav

   commands/git/*

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Kubectl
   :name: kubectl-nav

   commands/kubectl/*

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Net
   :name: net-nav

   commands/net/*

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: Others
   :name: others-nav

   commands/others/*

.. toctree::
   :hidden:
   :glob:
   :reversed:
   :maxdepth: 1
   :caption: System
   :name: system-nav

   commands/system/*

")
cmd /c "copy `"$dir\dist\gh-pages\index.rst`"+`"$dir\dist\gh-pages\Home.rst`" $(Resolve-Path `"$dir\dist\gh-pages\index.rst`")"
If ([System.IO.Directory]::Exists("$PSScriptRoot\..\..\docs\")) {
    copy "$PSScriptRoot\..\..\docs\*" "$dir\dist\gh-pages\"
}


"Copy everything in $dir\dist\wiki\ to Cronux.wiki repo"
"Copy everything in $dir\dist\gh-pages\ to Cronux gh-pages branch"