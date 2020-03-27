<#
.SYNOPSIS
    View and change the kubernetes configuration context
.DESCRIPTION
    This command list all the context in the current 
    kubernetes and also switch the context also if an 
    extra parameter is specified.

    Adding the switch -Current withoput any other parameter 
    shows the current context.
.INPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : kubecontext.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : March-27-2019
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    kubecontext
    List all the context in the configuration
.EXAMPLE
    kubecontext -Current
    View the current context
.EXAMPLE
    kubecontext test
    Switch your kubernetes context to 'test'
.EXAMPLE
    kubecontext prod
    Switch your kubernetes context to 'prod'
#>

[CmdletBinding()]
Param(
    # the name of the context to switch to
    [Parameter(Mandatory=$false)]
    [string]$ContextName,
    # view the current context
    [switch]$Current
)

if ($ContextName) {
    kubectl config use-context $ContextName
} else {
    if ($Current) {
        kubectl config current-context
    } else {
        kubectl config get-contexts
    }
}