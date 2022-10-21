<#
.SYNOPSIS
    Listen on a port on the local machine and 
    forward to pod port
.DESCRIPTION
    Listen on a port on the local machine and 
    forward to pod port.
    Kubectl is required for this command to work, 
    it can be downloaded from 
    https://kubernetes.io/docs/tasks/tools/install-kubectl/
    
    MinPod Object
    ----------
    {
        Name
    }
    
.INPUTS 
    [System.String]
.OUTPUTS 
    [System.String[]]
.NOTES
    Version    : 1.0
    File Name  : portforward.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : March-30-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://kubernetes.io/docs/reference/kubectl
.EXAMPLE
    portforward mypod 7000:80
    Find all pod that match the name 'mypod' the use 
    the index to select which port to forward it port.
.EXAMPLE
    portforward mypod-service-5d94df45ff-pnnn 7000:80
    Forward the pod 'mypod-service-5d94df45ff-pnnn' port 
    80 to localhost on port 7000.
#>

[CmdletBinding()]
Param(
    # the full pod name or matching part of pod name
    [Parameter(Mandatory=$true, Position=0)]
    [string]$PodName,
    # the forwarded-port:podport
    [Parameter(Mandatory=$true, Position=1)]
    [string]$PodPort,
    # get only the first pod that matches the name
    [switch]$Single
)

Function main {
    $Pods = @()
    $(kubectl get pods | findstr $PodName) | ForEach-Object {
        $Result = Parse-Pod-Detail $($_ -replace '\s+', ' ')
        $Pods += $Result
        if ($Single) {
            break
        }
    }
    
    $Pod_Name = ""
    if ($Pods.Length -eq 0) {
        "No pod found matching the name: $PodName" | Write-Host -Fore red
        return
    }
    if ($Pods.Length -gt 1) {
        $Index = 0
        ForEach ($Apod in $Pods) {
            "$($Index): $($Apod.Name)"
            $Index++
        }
        $Loc = Read-Host 'Which pod do you want to forward it port? '
        $Pod_Name = $Pods[$Loc].Name
        if (-not $Pod_Name) {
            "Invalid index specified '$Loc'" | Write-Host -Fore red
            return
        }
    } else {
        $Pod_Name = $Pods[0].Name
    }
    Port-Forward $Pod_Name
}

Function Port-Forward {
    Param(
        [string]$Pod_Name
    )
    kubectl port-forward $Pod_Name $PodPort
}

Class MinPod {
    [string]$Name
}

Function Parse-Pod-Detail {
    Param(
        [string]$Pod_Line
    )
    
    $APod = New-Object MinPod
    $Splited = $Pod_Line.Split(" ")
    $Index = 0
    
    ForEach ($Token in $Splited) {
        if ($Index -eq 0) {
            $APod.Name = $Token
            
        }
        $Index++
    }
    
    return $APod
}

main

