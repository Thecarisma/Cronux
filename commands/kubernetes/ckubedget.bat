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
REM The command will show all the deployment which contains the 
REM first parameter sent to the command. If non of the deployment 
REM is present nothing is printed to the console.
REM 
REM The second parameter is the availability status of the deployment, the second 
REM parameter is optional if not specified all the deployments that 
REM matches the first parameter will be listed, else all the 
REM deployments that matches the name(first parameter) and the status 
REM (second parameter) will be listed
REM 
REM 
REM ::
REM 	Usage: ckubeget deploymentname
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the deployment name or part of the deployment name to get
REM 	param2 : boolean (optional)
REM 		the availability status to get and show (true/false)

SET NAME=%1
SET STATUS=%2

if "!NAME!"=="" (
	kubectl get deployments --all-namespaces
	exit /b 0
)

if not "!STATUS!"=="" (
	if "!STATUS!"=="true" (
		SET STATUS=1
	) else (
		if not "!STATUS!"=="1" (
			SET STATUS=0
		)
	)
)

for /F "tokens=* USEBACKQ" %%F in (`kubectl get deployments --all-namespaces`) do (
	SET ___TEMP_VAR=%%F
    if not "x!___TEMP_VAR:%NAME%=!"=="x!___TEMP_VAR!" (
		if "!STATUS!"=="" (
			echo !___TEMP_VAR!
		) else (
			if not "x!___TEMP_VAR:1            %STATUS%=!"=="x!___TEMP_VAR!" (
				echo !___TEMP_VAR!
			)
		)
    )
    if not "x!___TEMP_VAR:NAMESPACE=!"=="x!___TEMP_VAR!" (
        if not "x!___TEMP_VAR:AVAILABLE=!"=="x!___TEMP_VAR!" (
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
