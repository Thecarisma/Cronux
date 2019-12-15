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
REM Backup a file in the specified folder
REM 
REM ::
REM 	Usage: download /save/file/path.full https://thefileurl.com
REM 
REM Ensure that you use the forward slash in your file path for both 
REM the file to backup and folder to back it up into
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the the absolute or relative path  to file to backup
REM 	param2 : string
REM 		the absolute or relative path to the folder to save backup

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

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.cronuxbackup:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.cronuxbackup:[0m %* 
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
REM 	:date: 27 August 2019
REM 	:time: 06:13 PM
REM 	:filename: cronuxbackup.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
