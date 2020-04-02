<#
.SYNOPSIS
    Convert a markdown to reStructured using pandoc
.DESCRIPTION
    Convert a markdown to reStructured using pandoc. 
    Download pandoc from https://pandoc.org/.
    
    To convert all the markdown file in a folder 
    specify the first argument as a the folder instead 
    of a markdown file.
.INPUTS 
    [System.String[]]
.OUTPUTS 
    [System.String[]]
.NOTES
    Version    : 1.0
    File Name  : markdown2rst.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : April-02-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    markdown2rst file.md
    This will generates file.rst in the same folder
.EXAMPLE
    markdown2rst file.md ./dist/
    This will generates file.rst in the folder ./dist 
    relative to the working dir.
.EXAMPLE
    markdown2rst ./md_doc/ ./md_rst/ -Recurse
    Generate the reStructured files for all the markdown 
    in the folder ./md_doc/ and it sub folders into the 
    folder ./md_rst/.
#>