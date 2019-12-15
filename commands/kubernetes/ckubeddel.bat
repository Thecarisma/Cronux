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
REM The command will delete all the namespace deployment which contains the 
REM first parameter sent to the command with the status specified
REM 
REM The second parameter is the availability status of the deployment, 
REM the second parameter is compulsory if not specified the command will 
REM fail
REM 
REM 
REM ::
REM 	Usage: ckubeddel podname status
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the deployment name or part of the deployment name to get
REM 	param2 : boolean 
REM 		the deployment availability to get (true/false)

SET NAME=%1
SET STATUS=%2

if "!NAME!"=="" (
	call:display_error you need to specify the deployment name or part of the deployment name as first parameter
	SET errorlevel=677
	goto:eof
)

if "!STATUS!"=="" (
	call:display_error you need to specify the pod status as second parameter
	SET errorlevel=677
	goto:eof
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
        if not "x!___TEMP_VAR:1            %STATUS%=!"=="x!___TEMP_VAR!" (
			SET namespace=0
			FOR /F "tokens=1" %%a in ('echo !___TEMP_VAR!') do (
				SET namespace=%%a
			)
			FOR /F "tokens=2" %%a in ('echo !___TEMP_VAR!') do (
				kubectl delete -n !namespace! deployment %%a
			)
		)
    )
)

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.ckubeddel:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.ckubeddel:[0m %* 
	exit /b 0
	
:is_administrator
	SET is_administrator_var=
	for /F "tokens=* USEBACKQ" %%F in (`fsutil dirty query %systemdrive%`) do SET is_administrator_var=%%F
	if "x!is_administrator_var:denied=!"=="x!is_administrator_var!" ( SET IS_ADMIN=true) 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Adewale Azeez
REM 	:copyright: The MIT License (c) 2019 Cronux
REM 	:author: Adewale Azeez <azeezadewale98@gmail.com>
REM 	:date: 06 November 2019
REM 	:time: 11:35 AM
REM 	:filename: ckubeddel.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
