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

REM Prefix
REM Get an environment variable from the system. the first parameter is the 
REM environment variable to get, the second and last parameter which is the 
REM environment target name and file to write output to is optional. 
REM if the target name is not set then the environement target defualt to **Process**
REM
REM **Parameters**:	
REM 	param1 : string
REM 		the environment parameter to fetch 
REM 	param2 : string (optional)
REM 		the target name of the environment, usually User, Machine or Process
REM 	param3 : string (optional)
REM 		full file path to write the output to instead of the console

SET ENV=%1
SET TARGET=%2
SET WRITE_FILE=%3
if "!ENV!"=="" (
	call:display_error the getenv command expect at least one parameter 
	goto:eof
)
if "!TARGET!"=="" (
	SET TARGET=Process
)
if "!WRITE_FILE!"=="" (
	powershell -Command "& { [environment]::GetEnvironmentVariable(\"!ENV!\",\"!TARGET!\") }"
) else (
	powershell -Command "& { [environment]::GetEnvironmentVariable(\"!ENV!\",\"!TARGET!\") | Out-File !WRITE_FILE! }"
)

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

exit /b 0

:display 
	echo [0;32mCronux.backdel:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.backdel:[0m %* 
	exit /b 0