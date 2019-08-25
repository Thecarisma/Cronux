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

REM Prefix
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
	goto:eof		
)
if "%2"=="" (
	call:display_error the url to download from cannot be empty
	goto:eof		
)

powershell -Command "& { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $request = (new-object System.Net.WebClient); $request.DownloadFile('%2','%1') ; }"

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

exit /b 0

:display 
	echo [0;32mCronux.backdel:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.backdel:[0m %* 
	exit /b 0