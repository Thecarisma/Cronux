@echo off
REM START_OFFSET_FOR_MERGE
@echo off
REM bad thing `setlocal enabledelayedexpansion` can make your current session bloated
REM but good because it sure better than using %?%
setlocal enabledelayedexpansion

SET OPERATION=none
SET OP_ARGS=
SET SCRIPT_DIR=%~dp0
SET WORKING_DIR=%cd%
SET IS_ADMIN=false
call:is_administrator

SET COMMANDS_FOLDER=commands\
SET USER_FOLDER=%HOMEDRIVE%%HOMEPATH%
SET TEST_FOLDER=!SCRIPT_DIR!\test\
SET INSTALLATION_FOLDER=C:\Program Files\Cronux\
SET ROAMING_FOLDER=!USER_FOLDER!\AppData\Roaming\Cronux\
SET BACKUP_FOLDER=!ROAMING_FOLDER!backup\

SET AD=if not paying for winrar is a sin you are going to hell
SET VERSION=1.3

cd !SCRIPT_DIR!


for %%x in (%*) do (

	if "%%x"=="nb" (
		SET AD=""
	) else (
		if "!OPERATION!"=="none" (
			SET OPERATION=%%x
		) else (
			if "!OP_ARGS!"=="" (
				SET OP_ARGS=%%x
			) else (
				SET OP_ARGS=!OP_ARGS! %%x
			)
		)
	)
)

REM Create the roaming folder in %user_dir\AppData\Roaming\Cronux\
REM if it does not exist
if not exist !ROAMING_FOLDER! (
	mkdir !ROAMING_FOLDER!
)

REM clear aliases
if !OPERATION!==clear (
	SET AD=""
)
if !OPERATION!==cls (
	SET OPERATION=clear
	SET AD=""
)
if !OPERATION!==version (
	echo !VERSION!
	exit /b 0
)

call:showad
call:call_command_script !OPERATION! !OP_ARGS!
call:showad

exit /b 0
	
REM 
:call_command_script
	SET LABEL_EXECUTED=false
	SET SCRIPT_PATH=
	SET COMMANDS_FOLDER__=.\ 
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
	cd !SCRIPT_DIR!
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
		cd !WORKING_DIR!
		call:%1 !ARGS__! 2> nul && SET LABEL_EXECUTED=true
		if !LABEL_EXECUTED!==true (
			exit /b 0
		) else (
			call:display_warning Cronux cannot find the batch label specified - %1. Delegating to system
			SET SCRIPT_PATH=%1
		)
	)
	cd !WORKING_DIR!
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
	
:testlabel
	echo this is it

	exit /b 0

:showad 
	if not !AD!=="" (
		@echo ````````````````````````````````````````````````````````
		echo !AD!
		@echo ........................................................
	)
	exit /b 0
	
REM Display message and title in the console
:display
	echo [0;32mCronux:[0m %* 

	exit /b 0
	
REM Display error message and title in the console
:display_error
	echo [0;31mCronux:[0m %* 

	exit /b 0
	
REM Display warning message and title in the console
:display_warning
	echo [0;33mCronux:[0m %* 
	
	exit /b 0
	
REM Check if command prompt is open as administrator
:is_administrator
	SET is_administrator_var=
	for /F "tokens=* USEBACKQ" %%F in (`fsutil dirty query %systemdrive%`) do SET is_administrator_var=%%F
	if "x!is_administrator_var:denied=!"=="x!is_administrator_var!" ( SET IS_ADMIN=true) 
	exit /b 0

:close 

	exit

	exit /b 0
