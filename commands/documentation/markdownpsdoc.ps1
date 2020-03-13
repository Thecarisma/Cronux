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
$TocMarkdown = ""
$ContentMarkdown = ""

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

enum AreaType 
{
    Name
    Synopsis
    Syntax
    Description
    Parameters
    Inputs
    Outputs
    Notes
    RelatedLinks
    Unknown
}

$Global:res = $false
$Global:name = ""
$Global:synopsis = ""
$Global:description = ""

Function To-Sentence-Case {
    param(
        [string]$argument
    )
    
    return $argument.SubString(0, 1)  + $argument.SubString(1, $argument.Length - 1).ToLower()
}

Function Parse-Name {
    param([string]$argument)
    
    if ($argument.Trim() -eq "") {
        return
    }
    
    $Splited = $argument.Split("\")
    $Global:name = $Splited[$Splited.Length - 1].Split(".ps1")[0]
}

Function Parse-Synopsis {
    param([string]$argument)
    
    if ($argument.Length -gt 5 -and $argument.StartsWith("   ")) {
        $argument = $argument.SubString(4, $argument.Length - 5)
    }
    
    $Global:synopsis += $argument.Replace("    ", " ")
}

Function Parse-Description {
    param([string]$argument)
    
    if ($argument.Length -gt 5 -and $argument.StartsWith("   ")) {
        $argument = $argument.SubString(4, $argument.Length - 5)
    }
    $Global:description += $argument + "`r`n"
}

Function PsDoc-to-Markdown {
    Param(
        [string]$SinglePsDocPath
    )
    
    [AreaType]$area_type = "Unknown"
    
    ForEach($line in Get-Content $SinglePsDocPath) {
        If ($line -ne "" -and -not $line.StartsWith("  ")) {
            $header = $line.Trim()
            if ($header -eq "NAME") {
                $area_type = "Name"
                continue
                
            } elseif ($header -eq "SYNOPSIS") {
                $area_type = "Synopsis"
                continue
                
            } elseif ($header -eq "DESCRIPTION") {
                $area_type = "Description"
                continue
                
            } else {
                $area_type = "Unknown"
            }
            # set the TOC here and header
            $ContentMarkdown += "## " + (To-Sentence-Case $line) + "`r`n`r`n"
        }
        
        switch ($area_type) {
            Name {
                Parse-Name $line 
            }
            Synopsis {
                Parse-Synopsis $line 
            }
            Description {
                Parse-Description $line 
            }
            Unknown {
                
            }
        }
    }
    
    $title_part = $Global:name
    if (-not $SkipHtml) {
        $title_part = "<p style=`"text-align: center;`" align=`"center`">{0}</p>" -f $Global:name
    }
    
    $brief_part = $Global:synopsis
    if (-not $SkipHtml) {
        $brief_part = "<p style=`"text-align: center;`" align=`"center`">{0}</p>" -f $Global:synopsis
    }
    
    $ContentMarkdown = "
# {0}

{1}

---

{2}    
    " -f 
      $title_part,
      $brief_part,
      $Global:description
        
    $ContentMarkdown
}

main










