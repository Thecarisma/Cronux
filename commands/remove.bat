@echo off
SET errorlevel=0
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
		call:call_command_script elevate !SCRIPT_DIR!remove.bat hfgjsghfgf__aassSF_S_FS_FSfskhfjfdjksgajkg !COMMAND_TO_REMOVE!
		SET errorlevel=677
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
			call:call_command_script backdel "%%a"
		) else (
			if exist "%%a.bat" (
				call:display removing the command script '%%a.bat' from !FINAL_INSTALLATION_FOLDER!
				call:call_command_script backdel "%%a.bat"
			) else (
				call:display_warning the script '%%a' does not exist in !FINAL_INSTALLATION_FOLDER!
			)
		)
	)
	if !FROM_DELETE_ALL!==true (
		goto:delete_parent_folder_hddhhf
	) else (
		exit /b 0
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
call:call_command_script delpath Machine Cronux

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:call_command_script
	SET LABEL_EXECUTED=false
	SET SCRIPT_PATH=
	SET COMMANDS_FOLDER__=!COMMANDS_FOLDER!
	SET FOLDERS_TO_VISIT__=
	SET ARGS__=
	SET BACKWARD_SEARCH_PATHS=..\ ..\..\ ..\..\..\
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
		goto:call_command_script_loop	
	) 
	:call_command_script__search_complete
	cd !SCRIPT_DIR!
	if not exist "!SCRIPT_PATH!" (
		for %%b in (!BACKWARD_SEARCH_PATHS!) do (
			if exist "%%b\%1.bat" (
				SET SCRIPT_PATH=%%b\%1.bat
				goto:call_command_script__search_complete
			)
		)
		call:display_error cannot find the script '%1'
		call:%1 !ARGS__! 2> nul && SET LABEL_EXECUTED=true
		if !LABEL_EXECUTED!==true (
			exit /b 0
		) else (
			call:display_warning Cronux cannot find the batch label specified - %1. Delegating to system
			SET SCRIPT_PATH=%1
		)
	)	
	!SCRIPT_PATH! !ARGS__!
	goto:call_command_script__end
	
	:call_command_script_loop
		cd !COMMANDS_FOLDER__!
		for /d %%d in (*.*) do (
			for %%i in ("%%d") do (
				SET shortfullname=%%~si
			) 
			REM echo !shortfullname!\%1.bat
			if not exist "!shortfullname!\%1.bat" (
				if "!FOLDERS_TO_VISIT__!"=="" (
					SET FOLDERS_TO_VISIT__=!shortfullname!\
				) else (
					SET FOLDERS_TO_VISIT__=!FOLDERS_TO_VISIT__! !shortfullname!\
				)
			) else (
				SET SCRIPT_PATH=!shortfullname!\%1.bat
				goto:call_command_script__search_complete
			)
		)
		for %%g in (!FOLDERS_TO_VISIT__!) do (
			SET COMMANDS_FOLDER__=%%g
			SET FOLDERS_TO_VISIT__HOLDER=!FOLDERS_TO_VISIT__!
			SET FOLDERS_TO_VISIT__=
			for %%f in (!FOLDERS_TO_VISIT__HOLDER!) do (
				if not "%%f"=="%%g" (
					if "!FOLDERS_TO_VISIT__!"=="" (
						SET FOLDERS_TO_VISIT__=%%f
					) else (
						SET FOLDERS_TO_VISIT__=!FOLDERS_TO_VISIT__! %%f
					)
				)
			)
			goto:call_command_script_loop
		)
		goto:call_command_script__search_complete
	
	:call_command_script__end
	exit /b 0

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
