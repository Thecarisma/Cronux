<#
.SYNOPSIS
    
.DESCRIPTION
    
.INPUTS 
    
.OUTPUTS 
    
.NOTES
    Version    : 1.0
    File Name  : Cronux.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : Jan-06-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    
.EXAMPLE
    
#>

$support = "if you`'ve benefited from this project, consider supporting `nme on Patreon https://patreon.com/thecarisma"
$command_folder = $PSScriptRoot
$Global:found_command = $false

Function main {
    If ($args[0].Length -eq 0) {
        $args[0] = @("aboutx")        
        Execute-Command $args
        $Global:found_command = $false
        "`nUsage: [command] [command_args...]"
        "Execute 'listx -All' to view all commands..."
        "The Cronux specific commands are listed below.`n"
        $args[0] = @("listx") 
    }
    Execute-Command $args
}

Function Execute-Command {   
    $params = $args[0][0]
    $command, $sub_params = $params
    $params
    Iterate-Folder $command_folder $command $sub_params
    If ($Global:found_command -eq $false) {
        iex "$command $sub_params"
    }
}

Function Iterate-Folder {
    Param([string]$foldername, $command, $params)
    $foldername
    
    Get-ChildItem $foldername | Where-Object {$Global:found_command -eq $false} | Foreach-Object {
        If ( -not $_.PSIsContainer) {
            If ( -not $_.Name.EndsWith(".ps1")) {
                Return
            }
            $NameOnly = $_.Name.Substring(0, $_.Name.LastIndexOf("."))
            If ($NameOnly -eq $command) {
                $escaped_params  = New-Object System.Collections.Generic.List[string]
                ForEach($param in $params) {
                    if ($param.StartsWith('-')) {
                        $escaped_params.Add($param)
                    } else {
                        $escaped_params.Add("'$($param)'")
                    }
                }
                "Found: $($_.FullName)" 
                @($escaped_params)
                powershell -File $_.FullName  @($escaped_params)
                $Global:found_command = $true
                "Done with : $($_.FullName)"
                Return
            }
        } Else {
            Iterate-Folder $_.FullName $command $params
        }
    }
    if ($Global:found_command -ne $true) {
        $Global:found_command = $false
    }
}

main $args