@echo off
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
REM Backup a file before deleting it. The file is backed up in the 
REM declared backup folder !USER_FOLDER!\AppData\Roaming\Cronux\backup\ 
REM in the following format `!BACKUP_FOLDER!\!filename!!fileextension!.!time_stamp!`
REM for time script see https://stackoverflow.com/a/1445724/6626422
REM for full path split see https://stackoverflow.com/a/15568164/6626422
REM 
REM ::
REM 	Usage: backdel /path/to/file
REM 
REM
REM **Parameters**:	
REM 	param1 : string
REM 		the file to delete note that it accept file path only 

SET FULL_FILE_NAME=%1
SET REAL_BACKUP_FOLDER=%2

if "!FULL_FILE_NAME!"=="" (
	call:display_error file to backup cannot be empty
	SET errorlevel=677
	goto:eof		
)
if "!REAL_BACKUP_FOLDER!"=="" (
	SET REAL_BACKUP_FOLDER=!BACKUP_FOLDER!
)
if not exist "!FULL_FILE_NAME!" (
	call:display_error backup failed cannot find '!FULL_FILE_NAME!'
	SET errorlevel=677
	goto:eof		
)
SET HOUR=%time:~0,2%
SET dtStamp9=%date:~-4%-%date:~3,2%-%date:~0,2%_0%time:~1,1%%time:~3,2%%time:~6,2%
SET dtStamp24=%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
if "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) else (SET dtStamp=%dtStamp24%)

if not exist "!REAL_BACKUP_FOLDER!" (
	mkdir "!REAL_BACKUP_FOLDER!"
)

FOR %%i IN ("!FULL_FILE_NAME!") DO (
	SET filedrive=%%~di
	SET filepath=%%~pi
	SET filename=%%~ni
	SET fileextension=%%~xi
)
call:display backing up !filename!!fileextension! into !REAL_BACKUP_FOLDER!
copy !FULL_FILE_NAME! !REAL_BACKUP_FOLDER!\!filename!!fileextension!.!dtStamp!.cronux.backup
del !FULL_FILE_NAME! /s /f /q

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.backdel:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.backdel:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 25 August 2019
REM 	:time: 02:24 PM
REM 	:filename: backdel.bat
REM 
REM 
REM		.. _ALink: ./ALink.html