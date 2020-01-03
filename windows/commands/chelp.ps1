
$command_folder = "./commands/"

Function main {
    ForEach ($arg in $args) {
        Iterate-Folder $command_folder $arg
    }
}

Function Iterate-Folder {
    Param([string]$foldername, $param)
    
    Get-ChildItem $foldername | Foreach-Object {
        if ( -not $_.PSIsContainer) {
            $NameOnly = $_.Name.Substring(0, $_.Name.LastIndexOf("."))
            if ($NameOnly -eq $param) {
                powershell help $_.FullName -full
                return
            }
        } else {
            Iterate-Folder $_.FullName $param
        }
    }
}

main $args[0]