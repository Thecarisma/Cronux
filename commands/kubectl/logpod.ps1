<#
.SYNOPSIS
    Tail a pod log
.DESCRIPTION
    Tail and follow a pod log.
    Kubectl is required for this command to work, 
    it can be downloaded from 
    https://kubernetes.io/docs/tasks/tools/install-kubectl/
    
.INPUTS 
    [System.String]
.OUTPUTS 
    [System.String[]]
.NOTES
    Version    : 1.0
    File Name  : logpod.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : March-30-2020
.LINK
    https://thecarisma.github.io/Cronux
    https://kubernetes.io/docs/reference/kubectl
.EXAMPLE
    logpod mypod
    Find all pod that match the name 'mypod' the use 
    the index to select which pod to tail it log.
.EXAMPLE
    logpod mypod-service-5d94df45ff-pnnn
    Tail the log of the pod mypod-service-5d94df45ff-pnnn.
.EXAMPLE
    logpod mypod -NoTail
    Find all pod that match the name 'mypod' the use 
    the index to select which pod to prints it log.
.EXAMPLE
    logpod mypod-service-5d94df45ff-pnnn -NoTail
    Prints the log of the pod mypod-service-5d94df45ff-pnnn 
    in stdout.
#>

[CmdletBinding()]
Param(
    # the full pod name or matching part of pod name
    [Parameter(Mandatory=$true, Position=0)]
    [string]$PodName,
    # only print the log do not tail
    [switch]$NoTail
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
        $Loc = Read-Host 'Which pod do you want to log? '
        $Pod_Name = $Pods[$Loc].Name
        if (-not $Pod_Name) {
            "Invalid index specified '$Loc'" | Write-Host -Fore red
            return
        }
    } else {
        $Pod_Name = $Pods[0].Name
    }
    Log-Pod $Pod_Name
}

Function Log-Pod {
    Param(
        [string]$Pod_Name
    )
    if ($NoTail) {
        kubectl logs $Pod_Name
    } else {
        kubectl logs -f $Pod_Name
    }
    
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

