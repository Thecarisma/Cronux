<#
.SYNOPSIS
    Enter a pod shell using it full name or select from 
    matching pods.
.DESCRIPTION
    Enter a pod shell  using it full name or select from 
    matching pods.
    Kubectl is required for this command to work, 
    it can be downloaded from 
    https://kubernetes.io/docs/tasks/tools/install-kubectl/
    
.INPUTS 
    [System.String]
.OUTPUTS 
    [System.String[]]
.NOTES
    Version    : 1.0
    File Name  : podshell.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : March-31-2019
.LINK
    https://thecarisma.github.io/Cronux
    https://kubernetes.io/docs/reference/kubectl
.EXAMPLE
    podshell mypod
    Find all pod that match the name 'mypod' the use 
    the index to select which pod to enter it shell .
.EXAMPLE
    podshell mypod-service-5d94df45ff-pnnn
    Enter the pod mypod-service-5d94df45ff-pnnn shell 
    if found in the current context.
#>

[CmdletBinding()]
Param(
    # the full pod name or matching part of pod name
    [Parameter(Mandatory=$true, Position=0)]
    [string]$PodName
)

& "$PSScriptRoot\podexec.ps1" $PodName bash


