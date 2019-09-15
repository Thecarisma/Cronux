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
REM An alias for the git command to show the log in a git repository 
REM before executing the command you have to change directory to the 
REM repository folder and you must have git installed on your Windows 
REM 
REM ::
REM 	Usage: gitlogp
REM 
REM Download git at https://git-scm.com/
REM

git log --pretty=format:"%%h - %%an : %%s" %*

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.gitlogp:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.gitlogp:[0m %* 
	exit /b 0
	
:display_warning
	echo [0;33mCronux.cinstall:[0m %* 
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
REM 	:date: 12 September 2019
REM 	:time: 09:24 PM
REM 	:filename: gitlogp.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
