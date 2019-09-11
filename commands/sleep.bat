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

REM Place the operation script in the block below
REM START_OFFSET_FOR_MERGE

REM P
REM Sleep for the specified time. The script strictly accept only 
REM one parameter. The output is suppressed and not printed in console. 
REM If you want dirty output call the system command `timeout` instead
REM 
REM ::
REM 	Usage: sleep [timeinseconds]
REM 
REM 
REM **Parameters**:	
REM 	params : number
REM 		the list of files to create 

SET SECONDS_TO_SLEEP_FOR=

for %%a in (%*) do (
	if "!SECONDS_TO_SLEEP_FOR!"=="" (
		SET SECONDS_TO_SLEEP_FOR=ade
	) else (
		call:display_error only one parameter expected and must be string
		SET errorlevel=677
		goto:eof
	)
)

timeout !SECONDS_TO_SLEEP_FOR! 2> nul 
if not "%errorlevel%"=="0" (
	call:display_error failed to sleep, check your parameter only number between -1 to 99999 accepted
)

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.sleep:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.sleep:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 09 September 2019
REM 	:time: 04:48 PM
REM 	:filename: sleep.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
