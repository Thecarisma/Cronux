<#
.SYNOPSIS
    View and change the kubernetes configuration context
.DESCRIPTION
    This command list all the context in the current 
    kubernetes and also switch the context also if an 
    extra parameter is specified.

    Adding the switch -All without any other parameter 
    shows the all the context in the configuration.
    
    The -User switch display the first user and the -Users 
    list all the users. The switch -User and -Users should 
    not be combined.
.INPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : kubecontext.ps1
    Author     : Adewale Azeez - azeezadewale98@gmail.com
    Date       : March-27-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    kubecontext
    View the current context
.EXAMPLE
    kubecontext -All
    List all the context in the configuration
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
    # view all the context in the configuration
    [switch]$All,
    # display the first user
    [switch]$User,
    # list all the users
    [switch]$Users
)

if ($User) {
    kubectl config view -o jsonpath='{.users[].name}'
    return
} elseif ($Users) {
    kubectl config view -o jsonpath='{.users[*].name}'
    return
}

if ($ContextName) {
    kubectl config use-context $ContextName
} else {
    if ($All) {
        kubectl config get-contexts
    } else {
        kubectl config current-context
    }
}

    