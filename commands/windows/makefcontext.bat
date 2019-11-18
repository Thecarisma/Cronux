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
REM Create a right-click context for file in the Windows Explorer. 
REM This command make calls to the windows registry to register 
REM the application and it extra arguments.
REM 
REM ::
REM 	Usage: makefcontext ViewName c:/full/path/to/command.exe
REM 
REM for a more robust application to manage the Windows Explore 
REM right-click context download the EasyFileShift app from sourceforge 
REM https://sourceforge.net/projects/easy-file-shift/
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the name to show on the right-click context list
REM 	param2 : string
REM 		the full path to the application to execute when clicked
REM     params...: string (optional)
REM 		extra arguments to send to the command 

SET VIEW_NAME=%1
SET SHEL_NAME=%1
SET APPLICATION_PATH=%2

if "!NAME!"=="" (
	call:display_error you need to specify the pod name or part of the pod name as first parameter
	SET errorlevel=677
	goto:eof
)


Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\shell\Open In Command Prompt]
@="Open In Command Prompt"
"icon"="cmd.exe,0"
"

[HKEY_CLASSES_ROOT\Directory\shell\Open In Command Prompt\command]
@="cmd.exe %*"


exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.makefcontext:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.makefcontext:[0m %* 
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
REM 	:date: 18 November 2019
REM 	:filename: makefcontext.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
