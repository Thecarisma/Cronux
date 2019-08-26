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
REM Print the documentation in the scripts
REM 
REM ::
REM 	Usage: cronuxhelp command
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the command to view it help file

SET FILE_PATH=%1.bat

if "%1"=="" (
	call:display_error The command cannot be empty, specify the command to view it help
	goto:eof
)

if not exist "!FILE_PATH!" (
	SET FILE_PATH=.\commands\%1.bat
	if not exist "!FILE_PATH!" (
		call:display_error The command batch script '%1' cannot be found 
		goto:eof
	)
)

call:display %1
echo.

exit /b 0

powershell -Command "& { $is_within_main_script = $False; foreach($line in Get-Content !FILE_PATH!) { if($line -match $regex){ if ($line.StartsWith(\"REM START_OFFSET_FOR_MERGE\")) { $is_within_main_script = $True; continue; } if ($line.StartsWith(\"REM END_OFFSET_FOR_MERGE\")) { $is_within_main_script = $False; continue; } if ($is_within_main_script -eq $True) { if ($line.StartsWith(\"REM\") -and $line -ne \"REM P\" -and $line -ne \"REM Prefix\" -and $line -ne \"REM S\" -and $line -ne \"REM Sufix\") { $line.Replace(\"REM \", \"\").Replace(\"REM	\", \"\"); } } } } }"

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.cronuxhelp:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.cronuxhelp:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 25 August 2019
REM 	:time: 10:13 PM
REM 	:filename: cronuxhelp.sim
REM 
REM 
REM		.. _ALink: ./ALink.html
