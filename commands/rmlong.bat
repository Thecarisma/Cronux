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
REM Remove a directory with a very long path or a deep path 
REM using builtin **robocopy** command in windows. 
REM 
REM This command creates a temporary folder in yout `%TEMP%` path 
REM then the long folder to remove is purged through the folder 
REM and the created temporary folder is removed 
REM
REM ::
REM 	Usage: rmlong /root/path/to/deep/folder/
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the absolute or relative path to deep folder to delete 

mkdir C:\Users\ADEWAL~1.AZE\AppData\Local\Temp\cronux_tmp\
robocopy C:\Users\ADEWAL~1.AZE\AppData\Local\Temp\cronux_tmp\ "%1" /purge
rmdir "%1"
rmdir C:\Users\ADEWAL~1.AZE\AppData\Local\Temp\cronux_tmp\

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.rmlong:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.rmlong:[0m %* 
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
REM 	:date: 25 August 2019
REM 	:time: 02:24 PM
REM 	:filename: rmlong.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
