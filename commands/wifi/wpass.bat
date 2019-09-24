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
REM view the password of a saved wifi network 
REM 
REM ::
REM 	Usage: wpass [WIFI_PROFILE_NAME]
REM 	Usage: wpass SMILE@THECARISMA
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the path to save the downloaded file to
REM 

SET WIFI_PROFILE_NAME=%1
SET EXECUTION_RESULT=
SET LF=^



if "!WIFI_PROFILE_NAME!"=="" (
	call:display_error you need to specify the password profile name
	SET errorlevel=677
	goto:eof
)
for /F "usebackq delims=" %%S in (`netsh wlan show profile name^=!WIFI_PROFILE_NAME! key^=clear`) do (
	SET A_ARG=%%S
	if not "x!A_ARG:Key Content=!"=="x!A_ARG!" (
		SET EXECUTION_RESULT=!A_ARG!
	)
)
echo Password:!EXECUTION_RESULT:    Key Content            :=!

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.wpass:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.wpass:[0m %* 
	exit /b 0
	
:is_administrator
	SET is_administrator_var=
	for /F "tokens=* USEBACKQ" %%F in (`fsutil dirty query %systemdrive%`) do SET is_administrator_var=%%F
	if "x!is_administrator_var:denied=!"=="x!is_administrator_var!" ( SET IS_ADMIN=true) 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 25 August 2019
REM 	:time: 03:26 PM
REM 	:filename: wpass.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
