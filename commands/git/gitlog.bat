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
REM An alias for the git command to show the log in a git repository 
REM before executing the command you have to change directory to the 
REM repository folder and you must have git installed on your Windows 
REM 
REM ::
REM 	Usage: gitlog [all the argument to git log command]
REM 
REM Download git at https://git-scm.com/
REM 
REM 



exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.gitlog:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.gitlog:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 12 September 2019
REM 	:time: 09:24 PM
REM 	:filename: gitlog.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
