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
REM permanently remove a program, file or script. The file is 
REM searched for in the order below. the first found is deleted 
REM 
REM 	* the supplied full path
REM 	* the supplied full path with .bat added to the file name
REM 	* cronux test directoty
REM 	* cronux test directoty with .bat added to the file name
REM 	* cronux test\installation directoty
REM 	* cronux test\installation directoty with .bat added to the file name
REM 	* cronux installation directoty
REM 	* cronux installation directoty with .bat added to the file name
REM 
REM ::
REM 	Usage: remove [paths/to/files...]
REM 
REM Note that the file cannot be backed up into the Cronux backup 
REM directory before deletion. In case of a mistake it can be recovered 
REM from the backup directoty  
REM 
REM **Parameters**:	
REM 	param... : string
REM 		the variadic paths to the files or name of script to uninstall

SET IS_TEST=
SET COMMAND_TO_REMOVE=
SET ADMIN_REQUESTED=false
SET FROM_DELETE_ALL=false

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
		
		if "%%a"=="hfgjsghfgf__aassSF_S_FS_FSfskhfjfdjksgajkg" (
			SET IS_TEST=false
			SET ADMIN_REQUESTED=true
		)
	) else (	
		if "!COMMAND_TO_REMOVE!"=="" (
			SET COMMAND_TO_REMOVE=%%a
		) else (
			SET COMMAND_TO_REMOVE=!COMMAND_TO_REMOVE! %%a
		)
	)
)
if "!IS_TEST!"=="" (
	call:display_error you need to specify the target as first parameter. prod or test
)

if %IS_TEST%==true (
	SET FINAL_INSTALLATION_FOLDER=!TEST_FOLDER!\installation\
) else (
	SET FINAL_INSTALLATION_FOLDER=!INSTALLATION_FOLDER!
	if !ADMIN_REQUESTED!==false (
		call:display_warning requesting administration for Cronux installation 
		call:call_command_script_____remove elevate !SCRIPT_DIR!remove.bat hfgjsghfgf__aassSF_S_FS_FSfskhfjfdjksgajkg !COMMAND_TO_REMOVE!
		goto:eof
	)
	
)

for %%i in ("!FINAL_INSTALLATION_FOLDER!") do (
	SET FINAL_INSTALLATION_FOLDER=%%~si
)

if not "!COMMAND_TO_REMOVE!"=="" (
	call:display  Preparing to remove the specified Cronux commands '!COMMAND_TO_REMOVE!'
	:remove_files___gdhggdh
	if !ADMIN_REQUESTED!==true (
		cd !SCRIPT_DIR!
	)
	for %%a in (!COMMAND_TO_REMOVE!) do ( 
		if exist "%%a" (
			call:display removing the command script '%%a' 
			call:call_command_script_____remove backdel "%%a"
		) else (
			if exist "%%a.bat" (
				call:display removing the command script '%%a.bat' from !FINAL_INSTALLATION_FOLDER!
				call:call_command_script_____remove backdel "%%a.bat"
			) else (
				call:display_warning the script '%%a' does not exist in !FINAL_INSTALLATION_FOLDER!
			)
		)
	)
	if !FROM_DELETE_ALL!==true (
		goto:delete_parent_folder_hddhhf
	) else (
		goto:eof
	)
)

call:display Preparing to remove the all installed Cronux commands
cd !FINAL_INSTALLATION_FOLDER!
for %%x in (*) do (
	FOR %%i IN ("%%x") DO (
		SET filedrive=%%~di
		SET filepath=%%~pi
		SET filename=%%~ni
		SET fileextension=%%~xi
	) 
	if "!COMMAND_TO_REMOVE!"=="" (
		SET COMMAND_TO_REMOVE=!filedrive!!filepath!!filename!!fileextension!
	) else (
		SET COMMAND_TO_REMOVE=!COMMAND_TO_REMOVE! !filedrive!!filepath!!filename!!fileextension!
	)
)
cd !WORKING_DIR!
SET FROM_DELETE_ALL=true
goto:remove_files___gdhggdh
:delete_parent_folder_hddhhf
if !ADMIN_REQUESTED!==true (
	cd !WORKING_DIR!
)
rmdir !FINAL_INSTALLATION_FOLDER!
call:call_command_script_____remove delpath Machine Cronux

exit /b 0

:call_command_script_____remove
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
		goto:eof
	)
	if not exist "!SCRIPT_PATH!" (
		SET SCRIPT_PATH=commands\%1.bat
		if not exist "!SCRIPT_PATH!" (
			REM call:display_error cannot find the script '%1'
			call:%1 !ARGS__! 2> nul && SET LABEL_EXECUTED=true
			if !LABEL_EXECUTED!==true (
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
	echo [0;32mCronux.remove:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.remove:[0m %* 
	exit /b 0
	
:display_warning 
	echo [0;33mCronux.remove:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 02 September 2019
REM 	:time: 06:11 AM
REM 	:filename: remove.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
