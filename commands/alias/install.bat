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
REM 
REM alias for `cinstall`

call:call_command_script cinstall %*

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

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
	for %%i in ("!SCRIPT_PATH!") do (
		SET SCRIPT_PATH=%%~si
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

:display
	echo [0;32mCronux.install:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.install:[0m %* 
	exit /b 0
	
:display_warning
	echo [0;33mCronux.cinstall:[0m %* 
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
REM 	:date: 14 September 2019
REM 	:time: 06:52 PM
REM 	:filename: install.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
