<#
.SYNOPSIS
   
.DESCRIPTION
    Even though this command do a fine job in converting 
    a .psdoc file to markdown it not a proper parser, there 
    are million ways to do this better, but I go for the 
    fastest and easiest method in this script.
    
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
    [switch]$SkipHtml,
    # convert psdoc to markdown for markdown2rst
    [switch]$ForRST
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
        PsDoc-to-Markdown $PsDocPath $OutputFolder
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
$Global:current = ""
$Global:syntax = ""
$Global:parsing_paramtype = 0
$Global:has_commonparams = $false
$Global:parameters = ""
$Global:any = ""
$Global:long_name = ""
$Global:notes = ""

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
    
    $Global:long_name = $argument
    $Splited = $argument.Split("\")
    $Global:name = $Splited[$Splited.Length - 1].Split(".ps1")[0]
}

Function Parse-Synopsis {
    param([string]$argument)
    
    if ($argument.Length -gt 4 -and $argument.StartsWith("   ")) {
        $argument = $argument.SubString(4, $argument.Length - 4)
    }
    
    $Global:synopsis += $argument.Replace("    ", " ")
}

Function Parse-Parameters {
    param([string]$argument)
    
    if ($argument.Length -gt 4 -and $argument.StartsWith("   ")) {
        $argument = $argument.SubString(4, $argument.Length - 4)
         if ($argument.Length -gt 4 -and $argument.StartsWith("   ")) {
            $argument = $argument.SubString(4, $argument.Length - 4)
            if ($argument.StartsWith("Required?")) {
                $Global:parameters += "```````powershell`r`n"
            }
            Parse-Any $argument
            $Global:parameters += $Global:current
            $Global:current = ""
        } else {
            if (-not [string]::IsNullOrWhitespace($Global:parameters) -and $argument.StartsWith("-")) {
                $Global:parameters += "```````r`n`r`n"
            }
            if ($argument.StartsWith("<") -and $argument.EndsWith(">")) {
                $argument = $argument.SubString(1, $argument.Length - 2);
                $Global:parameters += "```````r`n`r`n"
                $Global:parameters += "### $argument`r`n`r`n"
                $Global:has_commonparams = $true
                return
            }
            if (-not [string]::IsNullOrWhitespace($argument)) {
                $Global:parameters += "### $argument`r`n"
            }
            $Global:parameters += "`r`n"
        }
    }
    
    #$Global:parameters += $argument
}


Function Parse-Any {
    param([string]$argument)
    
    if ($Global:long_name) {
        $argument = $argument.Replace($Global:long_name, $Global:name)
    }
    if ($argument.Length -gt 4 -and $argument.StartsWith("   ")) {
        $argument = $argument.SubString(4, $argument.Length - 4)
    }
    if ($argument[0] -eq '-' -and -not [string]::IsNullOrWhitespace("$($argument[1])") -or 
        ($argument.StartsWith("http"))) {
        $argument = " - " + $argument
    }
    $Global:current += $argument + "`r`n"
}

Function PsDoc-to-Markdown {
    Param(
        [string]$SinglePsDocPath,
        [string]$SavePath
    )
    
    $name_only = [System.IO.Path]::GetFileNameWithoutExtension($SinglePsDocPath)
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
                
            } elseif ($header -eq "PARAMETERS") {
                $area_type = "Parameters"
                continue
                
            } elseif ($header -eq "SYNTAX") {
                $area_type = "Syntax"
                continue
                
            } elseif ($header -eq "NOTES") {
                $area_type = "Notes"
                continue
                
            } else {
                $area_type = "Unknown"
            }
            # set the TOC here and header
            $Global:body += "## " + (To-Sentence-Case $line) + "`r`n`r`n"
            continue
        }
        
        switch ($area_type) {
            Name {
                Parse-Name $line 
            }
            Synopsis {
                Parse-Synopsis $line 
            }
            Description {
                Parse-Any $line 
                $Global:description += $Global:current
            }
            Parameters {
                Parse-Parameters $line 
            }
            Notes {
                Parse-Notes $line 
            }
            Syntax {
                Parse-Any $line 
                $Global:syntax += $Global:current
            }
            Unknown {
                Parse-Any $line 
                $Global:body += $Global:current
            }
        }
        $Global:current = ""
    }
    
    $title_part = $Global:name
    if (-not $SkipHtml) {
        $title_part = "<p style=`"text-align: center;`" align=`"center`">{0}</p>" -f $Global:name
    }
    
    $brief_part = $Global:synopsis
    if (-not $SkipHtml) {
        $brief_part = "<p style=`"text-align: center;`" align=`"center`">{0}</p>" -f $Global:synopsis
    }
    if (-not $Global:has_commonparams) {
        $Global:parameters += "```````r`n`r`n"
    }
    
    $ContentMarkdown = "
# {0}

{1}

---

{2}  

## Syntax

``````powershell
{3}  
``````

## Parameters

{4}

{5}
    " -f 
      $title_part,
      $brief_part,
      $Global:description,
      $Global:syntax.Trim(),
      $Global:parameters.Trim(),
      $Global:body
        
    $Global:notes
    [System.IO.File]::WriteAllLines("$SavePath\$name_only.md",  $ContentMarkdown)
}

main










