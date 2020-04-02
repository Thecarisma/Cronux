<#
.SYNOPSIS
    Convert a markdown to reStructuredText using pandoc
.DESCRIPTION
    Convert a markdown to reStructuredText using pandoc. 
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
    markdown2rst file.md ./dist/
    This will generates file.rst in the folder ./dist 
    relative to the working dir.
.EXAMPLE
    markdown2rst ./md_doc/ ./md_rst/ -Recurse
    Generate the reStructuredText files for all the markdown 
    in the folder ./md_doc/ and it sub folders into the 
    folder ./md_rst/.
#>

[CmdletBinding()]
Param(
    # The path to the markdown file or folder to convert to reStructuredText
    [Parameter(Mandatory=$true, Position=0)]
    [string]$MdPath,
    # the folder to put generated reStructuredText
    [Parameter(Mandatory=$true, Position=1)]
    [string]$OutputFolder,
    # generate reStructuredText in subfolders?
    [switch]$Recurse,
    # whether to print anything to the console
    [switch]$Silent
)

$MdPath = [System.IO.Path]::GetFullPath($MdPath)
$OutputFolder = [System.IO.Path]::GetFullPath($OutputFolder)

Function main {
    If ( -not [System.IO.Directory]::Exists($OutputFolder)) {
        [System.IO.Directory]::CreateDirectory($OutputFolder) > $null
        If ( -not $?) {
            Return
        }
    }
    
    if (Test-Path -Path $MdPath -PathType Container) {
        Iterate-Folder $MdPath
    } else {
        If ( -not [System.IO.File]::Exists($MdPath)) {
            Return
        }
        Markdown-To-ReStructuredText $MdPath $OutputFolder
    }
}



Function Iterate-Folder {
    Param([string]$FolderName)
    
    $NN1 = [System.IO.Path]::GetFileNameWithoutExtension($FolderName)
    $NN2 = [System.IO.Path]::GetFileNameWithoutExtension($OutputFolder)
    if ((($FolderName + '\') -eq $OutputFolder) -or $NN1 -eq "dist") {
        return
    }
    
    $RelName = '\' + $FolderName.SubString($MdPath.Length, $FolderName.Length - $MdPath.Length)
    $OutputName = $OutputFolder + $RelName
    Create-Directory $OutputName
    
    Get-ChildItem $FolderName | Foreach-Object {
        $NameOnly = $_.Name
        if ($_.Name.Contains(".")) {
            $NameOnly = $_.Name.SubString(0, $_.Name.LastIndexOf('.'))
        }
        If ( -not $_.PSIsContainer) {
            If ( -not $_.Name.EndsWith(".md")) {
                Return
            }
            Markdown-To-ReStructuredText $_.FullName $OutputName
        } Else {
            If ($Recurse) {
                Iterate-Folder $_.FullName
            }
        }
    }
    
}


Function Markdown-To-ReStructuredText {
    Param(
        [string]$SinglePsDocPath,
        [string]$SavePath
    )
     
    $Name_Only = [System.IO.Path]::GetFileNameWithoutExtension($SinglePsDocPath)
    if (-not $Silent) {
        Write-Host "Generating rst for $Name_Only.md -> " -NoNewLine
    }
    pandoc $SinglePsDocPath -t rst -o "$SavePath/$Name_Only.rst"
    
    $RelativePath = Resolve-Path -relative $SavePath
    if (-not $Silent) {
        "$RelativePath\$Name_Only.md"
    }
    
}

Function Create-Directory {
    Param(
        [string]$folderpath
    )
    
    If ( -not [System.IO.Directory]::Exists($folderpath)) {
        [System.IO.Directory]::CreateDirectory($folderpath) > $null
        If ( -not $?) {
            Return
        }
    }
}


main