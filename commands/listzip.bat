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
REM List all the content in a zip archive
REM 
REM ::
REM 	Usage: listzip /path/to/file.zip
REM 
REM Due to some path resolution issue in .NET SDK 
REM the working directory is switched to the archive parent folder 
REM and after the listing is complete the working directory is changed
REM back the the first 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the absolute or relative path to the zip file to view it content

SET ZIP_FILE_NAME=%1

if not exist "!ZIP_FILE_NAME!" (
	call:display_error the zip archive '!ZIP_FILE_NAME!' does not exist 
	SET errorlevel=677
	goto:eof
)

FOR %%i IN ("!ZIP_FILE_NAME!") DO (
	SET filedrive=%%~di
	SET filepath=%%~pi
	SET filename=%%~ni
	SET fileextension=%%~xi
)

cd !filedrive!!filepath!
powershell -Command "& { [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem'); foreach($sourceFile in (Get-ChildItem -filter '!filename!!fileextension!')) { [IO.Compression.ZipFile]::OpenRead($sourceFile.FullName).Entries.FullName } }"
cd !WORKING_DIR!

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.:[0m %* 
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
REM 	:date: 25 August 2019
REM 	:time: 02:24 PM
REM 	:filename: name.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
