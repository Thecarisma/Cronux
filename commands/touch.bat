@echo off
SET errorlevel=0
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
REM Create new files linux style
REM 
REM ::
REM 	Usage: touch [files/path/to/create/]...
REM 
REM 
REM **Parameters**:	
REM 	params : string (variadic)
REM 		the list of files to create 

for %%a in (%*) do (
	echo.>%%a
)

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.touch:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.touch:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 06 September 2019
REM 	:time: 12:17 PM
REM 	:filename: touch.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
