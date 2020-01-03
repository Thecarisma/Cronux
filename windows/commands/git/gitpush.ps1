<#
.SYNOPSIS
    A summary of what this script does
    In this case, this script documents the auto-help text in PSH CTP 3
    Appears in all basic, -detailed, -full, -examples
.DESCRIPTION
    A more in depth description of the script
    Should give script developer more things to talk about
    Hopefully this can help the community too
    Becomes: "DETAILED DESCRIPTION"
    Appears in basic, -full and -detailed
.NOTES
    Additional Notes, eg
    File Name  : Get-AutoHelp.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Appears in -full
.LINK
    A hyper link, eg
    http://www.pshscripts.blogspot.com
    Becomes: "RELATED LINKS"
    Appears in basic and -Full
.EXAMPLE
    The first example - just text documentation
    You should provide a way of calling the script, plus expected output
    Appears in -detailed and -full
.EXAMPLE
    The second example - more text documentation
    This would be an example calling the script differently. You can have lots
    and lots, and lots of examples if this is useful.
    Appears in -detailed and -full
.COMPONENT
    Thsi
#>
git add .
git commit -m "$args"
git push origin HEAD