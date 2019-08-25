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
REM list and view the files and directory structure of a folder
REM 
REM ::
REM 	Usage: ls
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		relative or absolute path to the folder to view it structure

if "%1%"=="" (
	dir
) else (
	cd %1%
	dir
)
if "%1%"=="" (
	REM
) else (
	cd C:\Users\adewale.azeez\Documents\THECARISMA_GITHUB\Cronux
)

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

exit /b 0

:display 
	echo [0;32mCronux.ls:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.ls:[0m %* 
	exit /b 0