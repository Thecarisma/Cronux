@echo off
SET errorlevel=0
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
REM Get the process information that is tied to an Id on the windows system 
REM 
REM ::
REM 	Usage: qid [id] [property]
REM 
REM If a property is specifeid after the Id number only the property will be 
REM outputed and the output can be piped to another program or script. e.g to 
REM shutdown a process using a Id, the output of this script is sent as input 
REM to the killpid script 
REM 
REM ::
REM 	Usage: [pipe] killpid $(qid 4 Id)
REM 
REM If no id is specifeid with the command all running processes is printed in
REM the standard output
REM 
REM **Parameters**:	
REM 	param1 : number
REM 		the id number to find it engaged process
REM 	param2 : string (optional)
REM 		the specific property to print out

if exist "qproc.bat" (
	qproc.bat id %* 
	SET errorlevel=677
	goto:eof
)
if exist "!SCRIPT_DIR!\qproc.bat" (
	!SCRIPT_DIR!\qproc.bat id %* 
	SET errorlevel=677
	goto:eof
)

if exist ".\commands\qproc.bat" (
	!WORKING_DIR!\commands\qproc.bat id %* 
	SET errorlevel=677
	goto:eof
)

REM 
REM Default to the label ssay in assumption the scripts has been combined 
REM if the ssay.bat file cannot be found in search path
REM 
call:call_command_script qproc id %*

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.qid:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.qid:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 04 September 2019
REM 	:time: 04:25 PM
REM 	:filename: qid.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
