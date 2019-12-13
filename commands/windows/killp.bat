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
REM ID (PID) of the appliaction. To get the process Id you can 
REM execute the command `qid` to show list of running 
REM processes with it details 
REM 
REM ::
REM 	Usage: killp 12390
REM 
REM 
REM **Parameters**:	
REM 	param1 : number
REM 		the pid of the program to kill

SET PID=%1

if "!PID!"=="" (
	call:display_error you need to specify the running program pid
	SET errorlevel=677
	goto:eof
)

if !IS_ADMIN!==true (
	taskkill /pid !PID! /f
) else (
	powershell -Command "Start-Process taskkill \" /pid !PID! /f  \" -Verb RunAs"
)

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.killp:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.killp:[0m %* 
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
REM 	:time: 09:11 AM
REM 	:filename: killp.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
