#!/bin/bash

FIRST_COMMAND=
OTHER_COMMANDS=
BANG_LINE=

main()
{
    for arg in "$@"
    do
        if [ "$FIRST_COMMAND" = "" ]; then
            FIRST_COMMAND=$arg
            
        else
            if [ "$OTHER_COMMANDS" = "" ]; then
                OTHER_COMMANDS=$arg

            else
                OTHER_COMMANDS="$OTHER_COMMANDS $arg"

            fi
        fi
    done
    if [ -f $FIRST_COMMAND ]; then
        check_and_expand_bang_line
        if [[ "$BANG_LINE" != "" ]]; then
            eval "$BANG_LINE $OTHER_COMMANDS"

        else
            system_exec

        fi 
        
    else
        system_exec

    fi
}

check_and_expand_bang_line()
{
    read -r first_line<$FIRST_COMMAND
    if [[ $first_line == \#!* ]]; then
        BANG_LINE=${first_line:2}
        BANG_LINE=${BANG_LINE/\{0\}/$(readlink -e $FIRST_COMMAND)}

    elif [[ $first_line == //!* ]]; then
        BANG_LINE=${first_line:3}
        BANG_LINE=${BANG_LINE/\{0\}/$(readlink -e $FIRST_COMMAND)}

    elif [[ $first_line == /\*!* ]]; then
        BANG_LINE=${first_line:3:-2}
        BANG_LINE=${BANG_LINE/\{0\}/$(readlink -e $FIRST_COMMAND)}

    fi
}

system_exec()
{
    eval "$FIRST_COMMAND $OTHER_COMMANDS"
}

main $*