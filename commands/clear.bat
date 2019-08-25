@echo off
setlocal enabledelayedexpansion

SET OPERATION="none"
SET OP_ARGS=
SET SCRIPT_DIR=%~dp0
SET WORKING_DIR=%cd%

SET USER_FOLDER=%HOMEDRIVE%%HOMEPATH%
SET INSTALLATION_FOLDER=C:\Program Files\Cronux\
SET ROAMING_FOLDER=!USER_FOLDER!\AppData\Roaming\Cronux\
SET BACKUP_FOLDER=!ROAMING_FOLDER!backup\

REM Place the operation script in the block below
REM START_OFFSET_FOR_MERGE

REM Prefix
REM clear the output on the command prompt
REM 
REM ::
REM 	Usage: colorlist
REM 

cls

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

exit /b 0

:display 
	echo [0;32mCronux.backdel:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.backdel:[0m %* 
	exit /b 0
