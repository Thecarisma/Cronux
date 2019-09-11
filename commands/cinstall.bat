SET errorlevel=0
@echo off
setlocal enabledelayedexpansion

SET OPERATION="none"
SET OP_ARGS=
SET SCRIPT_DIR=%~dp0
SET WORKING_DIR=%cd%

SET COMMANDS_FOLDER=.\
SET USER_FOLDER=%HOMEDRIVE%%HOMEPATH%
SET TEST_FOLDER=!SCRIPT_DIR!\..\test\
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
REM 	Cronux cinstall
REM 

SET FINAL_INSTALLATION_FOLDER=
SET COMMAND_SCRIPTS=
SET ADMIN_REQUESTED=false
SET FILES_TO_INSTALL=
SET IS_TEST=

for %%a in (%*) do (
	if "!IS_TEST!"=="" (
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
		
		if "%%a"=="hfgjsghfgf__SF_S_FS_FSfskhfjfdjksgajkg" (
			SET IS_TEST=false
			SET ADMIN_REQUESTED=true
		)
	) else (	
		FOR %%i IN ("%%a") DO (
			SET filedrive=%%~di
			SET filepath=%%~pi
			SET filename=%%~ni
			SET fileextension=%%~xi
		)
		if "!FILES_TO_INSTALL!"=="" (
			SET FILES_TO_INSTALL=!filedrive!!filepath!!filename!!fileextension!
		) else (
			SET FILES_TO_INSTALL=!FILES_TO_INSTALL! !filedrive!!filepath!!filename!!fileextension!
		)
	)
)
call:display  Preparing to install all Cronux command
if %IS_TEST%==true (
	SET FINAL_INSTALLATION_FOLDER=!TEST_FOLDER!\installation\
) else (
	SET FINAL_INSTALLATION_FOLDER=!INSTALLATION_FOLDER!
	if !ADMIN_REQUESTED!==false (
		call:display_warning requesting administration for Cronux installation 
		call:call_command_script_____cinstall elevate !SCRIPT_DIR!cinstall.bat hfgjsghfgf__SF_S_FS_FSfskhfjfdjksgajkg !FILES_TO_INSTALL!
		SET errorlevel=677
		goto:eof
	)
	
)

mkdir "!FINAL_INSTALLATION_FOLDER!" 2> nul
for %%i in ("!FINAL_INSTALLATION_FOLDER!") do (
	SET FINAL_INSTALLATION_FOLDER=%%~si
)
if !ADMIN_REQUESTED!==true (
	cd !SCRIPT_DIR!
)

if not "!FILES_TO_INSTALL!"=="" (
	for %%a in (!FILES_TO_INSTALL!) do ( 
		call:display copying the command script '%%a' into !FINAL_INSTALLATION_FOLDER!
		copy %%a "!FINAL_INSTALLATION_FOLDER!" > nul
	)
	SET errorlevel=677
	goto:eof
)

if not exist "!COMMANDS_FOLDER!\cinstall.bat" (
	SET COMMANDS_FOLDER=commands\
	if not exist "!COMMANDS_FOLDER!\cinstall.bat" (
		REM TODO: Accept the folder by parameter here
		call:display_error cannot find the folder where the commands are 
		SET errorlevel=677
		goto:eof
	)
)

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
	if !ADMIN_REQUESTED!==true (
		cd !SCRIPT_DIR!
	) else (
		cd !WORKING_DIR!
	)
	REM call:display !COMMAND_SCRIPTS!
)
call:call_command_script_____cinstall compilescript "!FINAL_INSTALLATION_FOLDER!\Cronux.bat" !COMMAND_SCRIPTS!
call:call_command_script_____cinstall delpath Machine Cronux
call:call_command_script_____cinstall addpath !FINAL_INSTALLATION_FOLDER! Machine

exit /b 0

:call_command_script_____cinstall
	SET LABEL_EXECUTED=false
	SET SCRIPT_PATH=
	SET ARGS__=
	for %%a in (%*) do (
		if "!SCRIPT_PATH!"=="" (
			SET SCRIPT_PATH=%%a.bat
		) else (
			if "!ARGS__!"=="" (
				SET ARGS__=%%a
			) else (
				SET ARGS__=!ARGS__! %%a
			)
		)
	)
	if "!SCRIPT_PATH!"=="" (
		call:display_error the script name or path cannot be empty
		SET errorlevel=677
		goto:eof
	)
	if not exist "!SCRIPT_PATH!" (
		SET SCRIPT_PATH=commands\%1.bat
		if not exist "!SCRIPT_PATH!" (
			REM call:display_error cannot find the script '%1'
			call:%1 !ARGS__! 2> nul && SET LABEL_EXECUTED=true
			if !LABEL_EXECUTED!==true (
				SET errorlevel=677
				SET errorlevel=677
				goto:eof
			) else (
				call:display_warning Cronux cannot find the batch label specified - %1. Delegating to system
				SET SCRIPT_PATH=%1
			)
		)
	) 
	!SCRIPT_PATH! !ARGS__!
	
	exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.cinstall:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.cinstall:[0m %* 
	exit /b 0
	
:display_warning 
	echo [0;33mCronux.cinstall:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 01 September 2019
REM 	:time: 07:14 PM
REM 	:filename: cinstall.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
