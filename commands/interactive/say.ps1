<#
.SYNOPSIS
    Convert a text to speech
.DESCRIPTION
    This will use the powershell SpeechSynthesizer 
    module to convert the text to speech.
    
    All the text after the say command is spoken 
.INPUTS 
    System.String[]
.OUTPUTS 
    System.String
.NOTES
    Version    : 1.0
    File Name  : say.ps1
    Author     : Adewale Azeez - iamthecarisma@gmail.com
    Date       : Jul-30-2020
.LINK
    https://thecarisma.github.io/Cronux
.EXAMPLE
    say hello World 
    This will use the WinAPI to speak the text 
    'hello World'
    
#>

Add-Type -AssemblyName System.Speech
$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$synthesizer.Speak($args)
