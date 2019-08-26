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
REM Convert a text to speech and output it through the available 
REM sound output device. 
REM 
REM ::
REM 	Usage: say [all the text to say...]
REM 
REM 
REM **Parameters**:	
REM 	param1... : string
REM 		The entire parameters is converted to speech and spoken 

if exist "ssay.bat" (
	ssay.bat Zira 0 %* 
	goto:eof
)

if exist "./commands/ssay.bat" (
	!WORKING_DIR!\commands\ssay.bat Zira 0 %* 
	goto:eof
)

REM 
REM Default to the label ssay in assumption the scripts has been combined 
REM if the ssay.bat file cannot be found in search path
REM 
call:ssay Zira 0 %*

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.say:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.say:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 26 August 2019
REM 	:time: 06:02 AM
REM 	:filename: say.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
