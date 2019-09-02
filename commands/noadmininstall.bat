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
REM install all the individual command in the Program files 
REM the command are installed individually in the path 
REM **C:\Program Files\Cronux\** Each command get a batch file 
REM so as to allow using the command directly without prefixing 
REM Cronux in the command prompt e.g
REM 
REM ::
REM 	Before Install > Cronux ls
REM 	After Install > ls
REM 
REM An uninstall-cronux script will also be created in the folder
REM which can be used to remove Cronux supplementary command  
REM from the system. 	
REM To successfully install the commands you need to run as 
REM administrator or use the Cronux command
REM 
REM ::
REM 	Cronux install
REM 
timeout 10 > NUL
SET FINAL_INSTALLATION_FOLDER=
SET COMMAND_SCRIPTS=
for %%a in (%*) do (
	if "%%a"=="prod" (
		SET IS_TEST=false
	)
	if "%%a"=="production" (
		SET IS_TEST=false
	)
	if "%%a"=="PROD" (
		SET IS_TEST=false
	)
	if "%%a"=="PRODUCTION" (
		SET IS_TEST=false
	)
	
	if "%%a"=="test" (
		SET IS_TEST=true
	)
	if "%%a"=="TEST" (
		SET IS_TEST=true
	)
)
call:display  Preparing to install all Cronux command
if %IS_TEST%==true (
	SET FINAL_INSTALLATION_FOLDER=!TEST_FOLDER!\installation\
) else (
	SET FINAL_INSTALLATION_FOLDER=!INSTALLATION_FOLDER!
)
mkdir "!FINAL_INSTALLATION_FOLDER!"
SET WORKING_DIR=%cd%

if exist "!COMMANDS_FOLDER!" (
	REM copy !COMMANDS_FOLDER! "!FINAL_INSTALLATION_FOLDER!"
	cd !COMMANDS_FOLDER!
	for %%a in (*) do ( 
		call:display copying the command script '%%a' into !FINAL_INSTALLATION_FOLDER!
		copy %%a "!FINAL_INSTALLATION_FOLDER!" > nul
		FOR %%i IN ("%%a") DO (
			SET filedrive=%%~di
			SET filepath=%%~pi
			SET filename=%%~ni
			SET fileextension=%%~xi
		) 
		if "!COMMAND_SCRIPTS!"=="" (
			SET COMMAND_SCRIPTS=!filename!
		) else (
			SET COMMAND_SCRIPTS=!COMMAND_SCRIPTS! !filename!
		)
	)
	cd !WORKING_DIR!
	REM call:display !COMMAND_SCRIPTS!
)
call:call_command_script compilescript "!FINAL_INSTALLATION_FOLDER!\Cronux.bat" !COMMAND_SCRIPTS!
call:call_command_script delpath Machine Cronux
call:call_command_script addpath !FINAL_INSTALLATION_FOLDER! Machine
timeout 10 > NUL

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.noadmininstall:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.noadmininstall:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 25 August 2019
REM 	:time: 07:14 PM
REM 	:filename: noadmininstall.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
