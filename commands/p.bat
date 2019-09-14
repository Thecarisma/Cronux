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
REM Send the output of a command as parameter to another program 
REM from the command line. Windows does not natively support inline 
REM command execution like the unix and linux base system `$()` the 
REM arrow option in windows only accept files or stream handles 
REM therefore it does not work the same magic.
REM 
REM ::
REM 	Usage: p theprogramgettingtheinput ([from] programtosendinput)... 
REM 
REM Example1.
REM 
REM ::
REM 	Usage: p dir [from] echo C:\
REM 
REM The command above is evaluated thus:
REM   get the output from the last command `echo C:\`, the output is `C:\`
REM   send the output as parameter to the first command `dir` 
REM   so we arrive at `dir C:\`
REM
REM using the script more command can send the output to the first program 
REM 
REM Example2.
REM 
REM ::
REM 	Usage: p dir [from] echo C:\ [and] echo C:\Program Files\
REM 
REM The command above is evaluated thus:
REM   get the output from the second command `echo C:\`, the output is `C:\`
REM   get the output from the last command `echo C:\Program Files\`, the output is `C:\Program Files\`
REM   send the output as parameter to the first command `dir` 
REM   so we arrive at `dir C:\ C:\Program Files\`
REM 
REM the [and] switch can contain more than one command e.g 
REM 
REM ::
REM 	Usage: p dir [from] echo C:\ [and] echo C:\Program Files\ [and] echo C:\Windows\ [and] echo C:\Users\
REM 
REM 

SET MAIN_COMMANDS=
SET CURRENT_PARSING=1
SET SUB_EVAL_COMMANDS=
SET EVALUATION_EXPR=
SET EVALUATION_RESULT=

for %%a in (%*) do (
	if "%%a"=="[from]" (
		SET CURRENT_PARSING=-2
		SET SUB_EVAL_COMMANDS=[command]
	)
	if "%%a"=="[and]" (
		SET CURRENT_PARSING=-2
		SET SUB_EVAL_COMMANDS=!SUB_EVAL_COMMANDS! [command]
	)
	if !CURRENT_PARSING!==1 (
		if "!MAIN_COMMANDS!"=="" (
			SET MAIN_COMMANDS=%%a
		) else (
			SET MAIN_COMMANDS=!MAIN_COMMANDS! %%a
		)
	)
	if !CURRENT_PARSING!==2 (
		SET SUB_EVAL_COMMANDS=!SUB_EVAL_COMMANDS! %%a
	)
	if !CURRENT_PARSING!==-2 (
		SET CURRENT_PARSING=2
	)
)
SET SUB_EVAL_COMMANDS=!SUB_EVAL_COMMANDS! [command]

for %%a in (!SUB_EVAL_COMMANDS!) do (
	if "%%a"=="[command]" (
		SET CURRENT_PARSING=-3
		if not "!EVALUATION_EXPR!"=="" (
			for /F "usebackq delims=" %%S in (`!EVALUATION_EXPR!`) do (
				if "!EVALUATION_RESULT!"=="" (
					SET EVALUATION_RESULT="%%S"
				) else (
					SET EVALUATION_RESULT=!EVALUATION_RESULT! "%%S"
				)
			)
		)
		SET EVALUATION_EXPR=
	)
	if !CURRENT_PARSING!==3 (
		if "!EVALUATION_EXPR!"=="" (
			SET EVALUATION_EXPR=%%a
		) else (
			SET EVALUATION_EXPR=!EVALUATION_EXPR! %%a
		)
	)
	if !CURRENT_PARSING!==-3 (
		SET CURRENT_PARSING=3
	) 
)
!MAIN_COMMANDS! !EVALUATION_RESULT!

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

REM CURRENT_PARSING data 
REM  1 = Main Command
REM -2 = To set to 2 and for skipping
REM  2 = Other commands
REM -3 = To set to 3 and for skipping
REM  3 = More Other commands

:display
	echo [0;32mCronux.p:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.p:[0m %* 
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
REM 	:time: 05:10 PM
REM 	:filename: p.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
