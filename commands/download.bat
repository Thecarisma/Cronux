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
REM Download file from the internet wget style this  
REM follows redirection 
REM 
REM ::
REM 	Usage: download /save/file/path.full https://thefileurl.com
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the path to save the downloaded file to
REM 	param2 : string
REM 		the full url of the file to download

if "%1"=="" (
	call:display_error the full path to save file to cannot be empty
	SET errorlevel=677
	goto:eof		
)
if "%2"=="" (
	call:display_error the url to download from cannot be empty
	SET errorlevel=677
	goto:eof		
)

powershell -Command "& { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $request = (new-object System.Net.WebClient); $request.DownloadFile('%2','%1') ; }"

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.download:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.download:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 25 August 2019
REM 	:time: 02:24 PM
REM 	:filename: download.bat
REM 
REM 
REM		.. _ALink: ./ALink.html