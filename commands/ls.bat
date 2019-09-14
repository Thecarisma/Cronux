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
REM list and view the files and directory structure of a folder
REM 
REM ::
REM 	Usage: ls
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		relative or absolute path to the folder to view it structure

if "%1%"=="" (
	dir
) else (
	cd %1%
	dir
)
if "%1%"=="" (
	REM
) else (
	cd C:\Users\adewale.azeez\Documents\THECARISMA_GITHUB\Cronux
)

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.ls:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.ls:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 25 August 2019
REM 	:time: 02:24 PM
REM 	:filename: ls.bat
REM 
REM 
REM		.. _ALink: ./ALink.html