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
REM Print into the windows command prompt with 
REM color set for the foreground and background
REM 
REM ::
REM 
REM 	Usage: echocolor [background-color] [foreground-color] <text to print...>
REM 
REM .. Revisit for normal param block
REM This console color behaviour is proudly learned at 
REM from this stackoverflow question 
REM https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line
REM The actual color codes is provided by [Michele Locati](https://gist.github.com/mlocati/) at 
REM https://gist.github.com/mlocati/fdabcaeb8071d5c75a2d51712db24011
REM first param is Background
REM second param is Foreground
REM The remaining is the text to print
REM 
REM **Parameters**:	
REM 	param1 : int
REM 		the background color to use when printing
REM 	param2 : int
REM 		the foreground color to use when printing
REM 	param3... : string
REM 		the remaining params are printed using the two 
REM			previous attributes

SET BG=
SET FG=
SET TEXT=
for %%a in (%*) do (
	if "!BG!"=="" (
		SET BG=%%a
	) else (
		if "!FG!"=="" (
			SET FG=%%a
		) else (
			if "!TEXT!"=="" (
				SET TEXT=%%a
			) else (
				SET TEXT=!TEXT! %%a
			)
		)
	)
)
echo [!FG!;!BG!m!TEXT![0m

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.echocolor:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.echocolor:[0m %* 
	exit /b 0
	
:is_administrator
	SET is_administrator_var=
	for /F "tokens=* USEBACKQ" %%F in (`fsutil dirty query %systemdrive%`) do SET is_administrator_var=%%F
	if "x!is_administrator_var:denied=!"=="x!is_administrator_var!" ( SET IS_ADMIN=true) 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Adewale Azeez
REM 	:copyright: The MIT License (c) 2019 Cronux
REM 	:author: Adewale Azeez <azeezadewale98@gmail.com>
REM 	:date: 25 August 2019
REM 	:time: 02:24 PM
REM 	:filename: echocolor.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
	

