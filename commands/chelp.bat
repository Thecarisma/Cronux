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
REM Print the documentation in the scripts
REM 
REM ::
REM 	Usage: cronuxhelp command
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the command to view it help file

if "%1"=="all" (
	call:allhelp
	exit /b 0
)
if "%1"=="" (
	call:allhelp
	exit /b 0
) 

for %%x in (%*) do (
	SET FILE_PATH=%%x.bat
	if not exist "!FILE_PATH!" (
		SET FILE_PATH=.\commands\%%x.bat
		if not exist "!FILE_PATH!" (
			call:display_error The command batch script '%%x' cannot be found 
			SET errorlevel=677
			goto:eof
		)
	)
	echo.
	call:display %%x
	echo.
	powershell -Command "& { $is_within_main_script = $False; foreach($line in Get-Content !FILE_PATH!) { if($line -match $regex){ if ($line.StartsWith(\"REM START_OFFSET_FOR_MERGE\")) { $is_within_main_script = $True; continue; } if ($line.StartsWith(\"REM END_OFFSET_FOR_MERGE\")) { $is_within_main_script = $False; continue; } if ($is_within_main_script -eq $True) { if ($line.StartsWith(\"REM\") -and $line -ne \"REM P\" -and $line -ne \"REM Prefix\" -and $line -ne \"REM S\" -and $line -ne \"REM Sufix\") { $line.Replace(\"REM \", \"\").Replace(\"REM	\", \"\"); } } } } }"
)

exit /b 0

REM DO not run the blocks below directly 
REM Write each command to independent batch 
REM script that can be executed individually 
REM from the command line without prepending
REM `Cronux`. 
:allhelp
	echo Usage: Cronux [COMMAND] [COMMAND_PARAMS]
	echo For more information on a specific command, type `Cronux HELP command-name`
	echo [COMMAND]: the system or supplementary system command to execute
	echo [COMMAND_PARAMS]: the parameters or arguments to send to the command
	echo.
	powershell -Command "& { function LoopFolder($folderName) {Get-ChildItem $folderName | Foreach-Object{if((Test-Path -Path $_.FullName -PathType Container) -eq $true){LoopFolder $_.FullName;}else{$NameOnly = $_.Name.replace('.bat','');Write-Host \"$NameOnly\";}}}LoopFolder '!SCRIPT_DIR!' }"
	
	echo.
	exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.cronuxhelp:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.cronuxhelp:[0m %* 
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
REM 	:date: 25 August 2019
REM 	:time: 10:13 PM
REM 	:filename: cronuxhelp.sim
REM 
REM 
REM		.. _ALink: ./ALink.html
