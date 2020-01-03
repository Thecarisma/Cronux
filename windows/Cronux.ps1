
$annoyance = "if you've benefited from this project, consider supporting `nme on Patreon https://patreon.com/thecarisma this is it we are here am the light of the world`nand I know it"
$command_folder = "./commands/"

Function main {
    Print-Advert $annoyance
    Execute-Command $args
    Print-Advert $annoyance
}

Function Execute-Command {    
    Param($params)
    Get-ChildItem $command_folder -Filter *.ps1 | Foreach-Object {
        #$content = Get-Content $_.FullName
        $_.FullName
    }
    $params[0]
}

Function Print-Advert {
    Param([string]$ad)
    
    $lines = $ad.Split("`n")
    $length = 0
    ForEach ($line in $lines) {
        If ($line.length -gt $length - 2) {
            $length = $line.length + 2
        }
    }
    $i = $length
    While (--$i -gt 0) {
        Write-Host -NoNewline  "=" 
    }
    ""
    $ad
    While (++$i -lt $length) {
        Write-Host -NoNewline  "=" 
    }
    ""
}

main $args