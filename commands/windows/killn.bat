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
REM Kill a running process in windows using the Process 
REM name of the appliaction. To get the process name you can 
REM execute the command `qid` to show list of running 
REM processes with it details 
REM 
REM ::
REM 	Usage: killn Taskmgr.exe
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the process name of the program to kill with .exe extension

SET APPNAME=%1

if "!APPNAME!"=="" (
	call:display_error you need to specify the running program name.exe
	SET errorlevel=677
	goto:eof
)

if !IS_ADMIN!==true (
	taskkill /im !APPNAME! /f
) else (
	powershell -Command "Start-Process taskkill \" /im !APPNAME! /f  \" -Verb RunAs"
)

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.killn:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.killn:[0m %* 
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
REM 	:date: 21 November 2019
REM 	:time: 09:55 AM
REM 	:filename: killn.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
