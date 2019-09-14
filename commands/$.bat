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
REM Execute command with inline sub command with linux and unix 
REM style for command interpolation using `${}` or `$()`. 
REM 
REM ::
REM 	Usage: $ command $(evaluateexpr) $(evaluateexpr)
REM 	Usage: $ dir $(echo C:\)
REM 
REM The command is evaluated as expected. Any windows specific syntax 
REM in the command is evaluated before parsing e.g `$ echo $(echo !PATH!)`
REM The instruction is same as `$echo $(echo C:\;C:\flutter\bin;...)` 
REM even before the parsing begins.
REM 

SET TOFIND=$(
SET TOFIN2=)
SET TOFINDB=${
SET TOFINDB2=}
SET COMMAND_LINE_ARGS=%*
SET MAIN_COMMANDS=
SET PARSING_A_SUB_COMMAND=false
SET SUB_COMMANDS=
SET EXECUTION_RESULT=

for %%a in (!COMMAND_LINE_ARGS!) do (
	SET A_ARG=%%a
	if not "x!A_ARG:%TOFIND%=!"=="x!A_ARG!" (
		SET PARSING_A_SUB_COMMAND=true
		SET EXECUTION_RESULT=
	)
	if not "x!A_ARG:%TOFINDB%=!"=="x!A_ARG!" (
		SET PARSING_A_SUB_COMMAND=true
		SET EXECUTION_RESULT=
	)
	if !PARSING_A_SUB_COMMAND!==false (
		if "!MAIN_COMMANDS!"=="" (
			SET MAIN_COMMANDS=%%a
		) else (
			SET MAIN_COMMANDS=!MAIN_COMMANDS! %%a
		)
	)
	if !PARSING_A_SUB_COMMAND!==true (
		if "!SUB_COMMANDS!"=="" (
			SET SUB_COMMANDS=%%a
		) else (
			SET SUB_COMMANDS=!SUB_COMMANDS! %%a
		)
	)
	if not "x!A_ARG:%TOFIN2%=!"=="x!A_ARG!" (
		SET PARSING_A_SUB_COMMAND=false
		call:$$$$$$$$$$$$___exec !SUB_COMMANDS!
		if "!MAIN_COMMANDS!"=="" (
			SET MAIN_COMMANDS=!EXECUTION_RESULT!
		) else (
			SET MAIN_COMMANDS=!MAIN_COMMANDS! !EXECUTION_RESULT!
		)
		SET SUB_COMMANDS=
	)
	if not "x!A_ARG:%TOFINDB2%=!"=="x!A_ARG!" (
		SET PARSING_A_SUB_COMMAND=false
		call:$$$$$$$$$$$$___exec !SUB_COMMANDS!
		if "!MAIN_COMMANDS!"=="" (
			SET MAIN_COMMANDS=!EXECUTION_RESULT!
		) else (
			SET MAIN_COMMANDS=!MAIN_COMMANDS! !EXECUTION_RESULT!
		)
		SET SUB_COMMANDS=
	)
)
!MAIN_COMMANDS!

exit /b 0

:$$$$$$$$$$$$___exec
	SET SUB_SUB_COMMANDS=%*
	SET SUB_SUB_COMMANDS=%SUB_SUB_COMMANDS:$(=%
	SET SUB_SUB_COMMANDS=%SUB_SUB_COMMANDS:${=%
	SET SUB_SUB_COMMANDS=%SUB_SUB_COMMANDS:)=%
	SET SUB_SUB_COMMANDS=%SUB_SUB_COMMANDS:}=%
	
	echo before: %*	- !SUB_SUB_COMMANDS!
	for /F "usebackq delims=" %%S in (`!SUB_SUB_COMMANDS!`) do (
		if "!EXECUTION_RESULT!"=="" (
			SET EXECUTION_RESULT="%%S"
		) else (
			SET EXECUTION_RESULT=!EXECUTION_RESULT! "%%S"
		)
	)

	exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.$:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.$:[0m %* 
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
REM 	:date: 05 September 2019
REM 	:time: 10:56 PM
REM 	:filename: $.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
