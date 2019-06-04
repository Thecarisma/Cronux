@echo off
REM bad thing `setlocal enabledelayedexpansion` can make your current session bloated
REM but good because it sure better than using %?%
setlocal enabledelayedexpansion

SET OPERATION=
SET OP_ARGS=
SET WORKING_DIR=%cd%
SET FIRST_PARAM=%0
SET AD="Heal the world, make it a better place"


for %%x in (%*) do (

	if "%%x"=="clear" (
		SET OPERATION="clear"
		SET AD=""
		call:clear
	)
	if "%%x"=="cls" (
		SET OPERATION="clear"
		SET AD=""
		call:clear
	)
	if "%%x"=="no-ad" (
		SET AD=""
	)
	
	if not defined OPERATION (
		@echo off
	) else (
		if not defined OP_ARGS (
			SET OP_ARGS=%%x
		) else (
			SET OP_ARGS=!OP_ARGS! %%x
		)
		
	)
	
	REM list files
	if "%%x"=="ls" (
		if not defined OPERATION ( SET OPERATION="listdir" )
	)
	if "%%x"=="dir" (
		if not defined OPERATION ( SET OPERATION="listdir" )
	)
	
	REM Request elevation 
	if "%%x"=="elevate" (
		if not defined OPERATION ( SET OPERATION="elevate" )
	)
	if "%%x"=="sudo" (
		if not defined OPERATION ( SET OPERATION="elevate" )
	)
	if "%%x"=="su" (
		if not defined OPERATION ( SET OPERATION="elevate" )
	)
	
	REM download file
	if "%%x"=="wget" (
		if not defined OPERATION ( SET OPERATION="download" )
	)
	if "%%x"=="download" (
		if not defined OPERATION ( SET OPERATION="download" )
	)
	if "%%x"=="irs" (
		if not defined OPERATION ( SET OPERATION="download" )
	)
	
	REM install the scripts
	if "%%x"=="elevated-install" (
		if not !OPERATION!=="elevate" (
			if not defined OPERATION ( SET OPERATION="elevated-install" )
		)
	)
	if "%%x"=="install" (
		call:elevate "%cd%\Cronux.bat elevated-install"	
		exit /b 0
	)
	
	REM print help and exit
	if "%%x"=="help" (
		call:help	
		exit /b 0
	)
)


if %OPERATION%=="elevate" (
	SET SUB_OP_ARGS=!OP_ARGS!
	if "!SUB_OP_ARGS!"=="" (
		SET SUB_OP_ARGS=cmd
	)
	SET OP_ARGS=""
	for %%a in (!SUB_OP_ARGS!) do (
		if !OP_ARGS!=="" (
			SET OP_ARGS=%%a \"/k
		) else (
			SET OP_ARGS=!OP_ARGS! %%a
		)
	)
	SET OP_ARGS=!OP_ARGS! \"
) else (
	REM SET OP_ARGS="!OP_ARGS!"
)
REM echo !OP_ARGS!

call:showad

if %OPERATION%=="listdir" (
	call:listdir !OP_ARGS!
)
if %OPERATION%=="elevate" (
	call:elevate %OP_ARGS%
)
if %OPERATION%=="elevated-install" (
	call:elevated-install !OP_ARGS!
)
if %OPERATION%=="download" (
	call:download !OP_ARGS!
)

exit /b 0

:showad 
	if not !AD!=="" (
		echo .
		echo !AD!
		echo .
	)
	exit /b 0

:listdir
	if "%1%"=="" (
		dir
	) else (
		cd %1%
		dir
	)
	
	if "%1%"=="" (
		call:showad
	) else (
		cd !WORKING_DIR!
	)
	exit /b 0

:clear
	cls
	
	exit /b 0
	
REM install all the individual command in the Program files 
REM the command are installed individually in the path 
REM **C:\Program Files\Cronux\** Each command get a batch file 
REM so as to allow using the command directly without prefixing 
REM Cronux in the command prompt e.g
REM 
REM ::
REM 	Before Install > Cronux ls
REM 	After Install > ls
REM 
REM An uninstall-cronux script will also be created in the folder
REM which can be used to remove Cronux supplementary command  
REM from the system. 	
REM To successfully install the commands you need to run as 
REM administrator or use the Cronux command
REM 
REM ::
REM 	Cronux install
REM 
:elevated-install
	echo Preparing to install all Cronux command
	mkdir "C:\Program Files\Cronux\"
	cp !FIRST_PARAM! "C:\Program Files\Cronux\"
	timeout 10 > NUL
	
	exit /b 0
	
REM Request elevation for a particular command 
REM This label request for administrator username 
REM and password then run the commands.
REM The command comes after the **elevate** 
REM option and the command parameter proceeds
REM 
REM ::
REM 
REM 	Usage: Cronux elevate <program> <program parameters>...
REM 
:elevate
	REM echo powershell -Command "Start-Process %* -Verb RunAs"
	powershell -Command "Start-Process %* -Verb RunAs"

	exit /b 0
	
REM Download file from the internet wget style this  
REM follows redirection 
REM 
REM ::
REM 	Usage: Cronux wget /save/file/path.full https://thefileurl.com
REM 
REM 
:download
	powershell -Command "& { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $request = (new-object System.Net.WebClient); $request.DownloadFile('%2','%1') ; }"

	exit /b 0
	
REM Print the help message and exit
REM 
:help 
	echo Usage: Cronux [COMMAND] [COMMAND_PARAMS]
	echo .
	echo [COMMAND]: the system or supplementary system command to execute
	echo The COMMANDS include:
	echo help                            print this help message and exit
	echo install                         install all the available command in the Script
	echo ls,dir                          list all the files and folder in a directory
	echo cls,clear                       clear the command prompt 
	echo wget,download,irs               download file from the internet into a folder widget style
	echo elevate 'program' 'params'...   run a command line program as administrator
	echo .
	exit /b 0
	