
$command_folder = "./"
$Global:found_help = 0

Function main {
    ForEach ($arg in $args) {
        Iterate-Folder $command_folder $arg
        If ($found_help -eq 0) {
            powershell help $arg -full
        }
    }   
}

Function Iterate-Folder {
    Param([string]$foldername, $param)
    
    Get-ChildItem $foldername | Foreach-Object {
        If ( -not $_.PSIsContainer) {
            $NameOnly = $_.Name.Substring(0, $_.Name.LastIndexOf("."))
            If ($NameOnly -eq $param) {
                powershell help $_.FullName -full
                $Global:found_help = $true
                Return
            }
        } Else {
            Iterate-Folder $_.FullName $param
        }
    }
    if ($Global:found_help -ne $true) {
        $Global:found_help = $false
    }
}

main $args[0]