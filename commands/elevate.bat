SET errorlevel=0
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

REM TODO: Revisit for argument error
REM Place the operation script in the block below
REM START_OFFSET_FOR_MERGE

REM P
REM Request elevation for a particular command 
REM This label request for administrator username 
REM and password then run the commands.
REM The command comes after the **elevate** 
REM option and the command parameter proceeds
REM 
REM ::
REM 
REM 	Usage: elevate <program> <program parameters>...
REM 
REM
REM **Parameters**:	
REM 	param1 : string
REM 		the application or command to run as administrator
REM 	params... : string
REM 		the arguments to pass to the application to run

SET OP_ARGS=""
for %%a in (%*) do (
	if !OP_ARGS!=="" (
		SET OP_ARGS=%%a \"/k
	) else ( 
		SET OP_ARGS=!OP_ARGS! %%a
	)
)
SET OP_ARGS=!OP_ARGS! \"

powershell -Command "Start-Process !OP_ARGS! -Verb RunAs"

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.elevate:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.elevate:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 25 August 2019
REM 	:time: 02:24 PM
REM 	:filename: elevate.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
