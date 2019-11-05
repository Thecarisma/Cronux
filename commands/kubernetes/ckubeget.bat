@echo off
SET errorlevel=0
setlocal enabledelayedexpansion

SET OPERATION="none"
SET OP_ARGS=
SET SCRIPT_DIR=%~dp0
SET WORKING_DIR=%cd%
SET IS_ADMIN=false
call:is_administrator

SET USER_FOLDER=%HOMEDRIVE%%HOMEPATH%
SET INSTALLATION_FOLDER=C:\Program Files\Cronux\
SET ROAMING_FOLDER=!USER_FOLDER!\AppData\Roaming\Cronux\
SET BACKUP_FOLDER=!ROAMING_FOLDER!backup\

REM Place the operation script in the block below
REM START_OFFSET_FOR_MERGE

REM P
REM This kubernetes command requires you to have configure 
REM your environment with your kubernetes clusters to work.
REM 
REM The command will show all the pod which contains the 
REM first parameter sent to the command. If non of the pod 
REM is present nothing is printed to the console.
REM 
REM The second parameter is the status of the pod, the second 
REM parameter is optional if not specified all the pods that 
REM matches the first parameter will be listed, else all the 
REM pods that matches the name(first parameter) and the status 
REM (second parameter) will be listed
REM 
REM 
REM ::
REM 	Usage: ckubeget podname
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the pod name or part of the pod name to get
REM 	param2 : string
REM 		the pod status to get and show

SET NAME=%1
SET STATUS=%2

if "!NAME!"=="" (
	call:display_error you need to specify the pod name or part of the pod name as first parameter
	SET errorlevel=677
	goto:eof
)

for /F "tokens=* USEBACKQ" %%F in (`kubectl get pods`) do (
	SET ___TEMP_VAR=%%F
    if not "x!___TEMP_VAR:%NAME%=!"=="x!___TEMP_VAR!" (
		if "!STATUS!"=="" (
			echo !___TEMP_VAR!
		) else (
			if not "x!___TEMP_VAR:%STATUS%=!"=="x!___TEMP_VAR!" (
				echo !___TEMP_VAR!
			)
		)
    )
    if not "x!___TEMP_VAR:RESTARTS=!"=="x!___TEMP_VAR!" (
        if not "x!___TEMP_VAR:STATUS=!"=="x!___TEMP_VAR!" (
			echo !___TEMP_VAR!
		)
    )
)

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.ckubeget:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.ckubeget:[0m %* 
	exit /b 0
	
:is_administrator
	SET is_administrator_var=
	for /F "tokens=* USEBACKQ" %%F in (`fsutil dirty query %systemdrive%`) do SET is_administrator_var=%%F
	if "x!is_administrator_var:denied=!"=="x!is_administrator_var!" ( SET IS_ADMIN=true) 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: The MIT License (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 05 November 2019
REM 	:time: 12:05 PM
REM 	:filename: ckubeget.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
