#!/bin/bash
WD=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
powershell -noprofile -executionpolicy bypass -file $DIR/commands/Cronux.ps1 $*
cd $WD