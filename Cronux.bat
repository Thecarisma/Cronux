@echo off
REM bad thing `setlocal enabledelayedexpansion` can make your current session bloated
REM but good because it sure better than using %?%
setlocal enabledelayedexpansion

SET OPERATION="none"
SET OP_ARGS=
SET SCRIPT_DIR=%~dp0
SET WORKING_DIR=%cd%
SET FIRST_PARAM=%0
SET IS_TEST=true

SET USER_FOLDER=%HOMEDRIVE%%HOMEPATH%
SET TEST_FOLDER=!SCRIPT_DIR!\test\
SET INSTALLATION_FOLDER=C:\Program Files\Cronux\
SET ROAMING_FOLDER=!USER_FOLDER!\AppData\Roaming\Cronux\
SET BACKUP_FOLDER=!ROAMING_FOLDER!backup\

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
	
	if !OPERATION!=="none" (
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
		if !OPERATION!=="none" ( SET OPERATION="listdir" )
	)
	if "%%x"=="dir" (
		if !OPERATION!=="none" ( SET OPERATION="listdir" )
	)
	
	REM Request elevation 
	if "%%x"=="elevate" (
		if !OPERATION!=="none" ( SET OPERATION="elevate" )
	)
	if "%%x"=="sudo" (
		if !OPERATION!=="none" ( SET OPERATION="elevate" )
	)
	if "%%x"=="su" (
		if !OPERATION!=="none" ( SET OPERATION="elevate" )
	)
	
	REM download file
	if "%%x"=="wget" (
		if !OPERATION!=="none" ( SET OPERATION="download" )
	)
	if "%%x"=="download" (
		if !OPERATION!=="none" ( SET OPERATION="download" )
	)
	if "%%x"=="irs" (
		if !OPERATION!=="none" ( SET OPERATION="download" )
	)
	
	REM remove installed script
	if "%%x"=="uninstall" (
		if !OPERATION!=="none" ( SET OPERATION="remove-command" )
	)
	if "%%x"=="remove" (
		if !OPERATION!=="none" ( SET OPERATION="remove-command" )
	)
	if "%%x"=="remove-command" (
		if !OPERATION!=="none" ( SET OPERATION="remove-command" )
	)
	
	REM install the scripts
	if "%%x"=="elevated-install" (
		if not !OPERATION!=="elevate" (
			if !OPERATION!=="none" ( SET OPERATION="elevated-install" )
		)
	)
	if "%%x"=="install" (
		call:elevate "%cd%\Cronux.bat elevated-install"	
		exit /b 0
	)
	
	REM remove long directory
	if "%%x"=="rmlong" (
		if not !OPERATION!=="rmlong" (
			if !OPERATION!=="none" ( SET OPERATION="rmlong" )
		)
	)
	
	REM print help and exit
	if "%%x"=="help" (
		call:help	
		exit /b 0
	)
)


if !OPERATION!=="elevate" (
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

REM Create the roaming folder in %user_dir\AppData\Roaming\Cronux\
REM if it does not exist
if not exist !ROAMING_FOLDER! (
	mkdir !ROAMING_FOLDER!
)

if %OPERATION%=="listdir" (
	call:listdir !OP_ARGS!
)
if %OPERATION%=="elevate" (
	call:elevate %OP_ARGS%
)
if %OPERATION%=="elevated-install" (
	call:elevated_install !OP_ARGS!
)
if %OPERATION%=="download" (
	call:download !OP_ARGS!
)
if %OPERATION%=="rmlong" (
	call:rmlong !OP_ARGS!
)
if %OPERATION%=="remove-command" (
	call:remove !OP_ARGS!
)

call:showad

exit /b 0

:showad 
	if not !AD!=="" (
		@echo ``````````````````````````````````````````````
		echo !AD!
		@echo ..............................................
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

REM Clear all the output in the current Command line window
REM ad is disable by default in this command 
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
:elevated_install
	call:display  Preparing to install all Cronux command
	if %IS_TEST%==true (
		mkdir "!TEST_FOLDER!\installation\"
		copy !SCRIPT_DIR!\Cronux.bat "!TEST_FOLDER!\installation\Cronux.bat"
		call:write_and_create_comands "!TEST_FOLDER!\installation\"
	) else (
		mkdir "!INSTALLATION_FOLDER!"
		copy !FIRST_PARAM! "!INSTALLATION_FOLDER!"
		call:write_and_create_comands "!INSTALLATION_FOLDER!"
	)
	REM timeout 10 > NUL
	
	exit /b 0
	
REM permanently remove a program, file or script. The file is 
REM searched for in the order below. the first found is deleted 
REM
REM 	* the supplied full path
REm 	* the supplied full path with .bat added to the file name
REM 	* cronux test directoty
REM 	* cronux test directoty with .bat added to the file name
REM 	* cronux test\installation directoty
REM 	* cronux test\installation directoty with .bat added to the file name
REM 	* cronux installation directoty
REM 	* cronux installation directoty with .bat added to the file name
REM
REM Note that the file cannot be backed up into the Cronux backup 
REM directory before deletion. In case of a mistake it can be recovered 
REM from the backup directoty  
:remove
	for %%x in (%*) do (
		if %%x==Cronux (
			call:display you cannot delete the Cronux script
			exit /b 0
		)
		if %%x==Cronux.bat (
			call:display you cannot delete the Cronux script
			exit /b 0
		)
		REM Check the provide full path
		if exist %%x (
			call:delete_and_backup "%%x"
		) else (
			REM Check the provide full path after appending .bat
			if exist %%x.bat (
				call:delete_and_backup "%%x.bat"
			) else (
				REM check test directory
				if exist !TEST_FOLDER!\%%x (
					call:delete_and_backup "!TEST_FOLDER!\%%x"
				) else (
					REM check test directory after appending .bat
					if exist !TEST_FOLDER!\%%x.bat (
						call:delete_and_backup "!TEST_FOLDER!\%%x.bat"
					) else (
						REM check test\installation directory
						if exist !TEST_FOLDER!\installation\%%x (
							call:delete_and_backup "!TEST_FOLDER!\installation\%%x"
						) else (
							REM check test\installation directory after appending .bat
							if exist !TEST_FOLDER!\installation\%%x.bat (
								call:delete_and_backup "!TEST_FOLDER!\installation\%%x.bat"
							) else (
								REM check installation directory
								if exist !INSTALLATION_FOLDER!\%%x (
									call:delete_and_backup "!INSTALLATION_FOLDER!\%%x"
								) else (
									REM check installation directory after appending .bat
									if exist !INSTALLATION_FOLDER!\%%x.bat (
										call:delete_and_backup "!INSTALLATION_FOLDER!\%%x.bat"
									) else (
										call:display deletion failed cannot find '%%x' in search path 
									)
								)
							)
						)
					)
				)
			)
		)
	)

	exit /b 0
	
REM for time script see https://stackoverflow.com/a/1445724/6626422
REM for full path split see https://stackoverflow.com/a/15568164/6626422
:delete_and_backup
	SET HOUR=%time:~0,2%
	SET dtStamp9=%date:~-4%-%date:~4,2%-%date:~7,2%_0%time:~1,1%%time:~3,2%%time:~6,2% 
	SET dtStamp24=%date:~-4%-%date:~4,2%-%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
	if "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) else (SET dtStamp=%dtStamp24%)
	
	if not exist !BACKUP_FOLDER! (
		mkdir !BACKUP_FOLDER!
	)
	
	FOR %%i IN ("%1") DO (
		SET filedrive=%%~di
		SET filepath=%%~pi
		SET filename=%%~ni
		SET fileextension=%%~xi
	)
	call:display backing up !filename!!fileextension! before deleting
	copy %1 !BACKUP_FOLDER!\!filename!!fileextension!.!dtStamp!.cronux.backup
	del %1 /s /f /q

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
	
REM Remove a directory with a very long path or an endless path 
REM using builting **robocopy** command in windows. 
REM 
REM This command creates a temporary folder in yout `%TEMP%` path 
REM then the long folder to remove is purged through the folder 
REM and the created temporary folder is removed 
:rmlong
	mkdir %TEMP%\cronux_tmp\
	robocopy %TEMP%\cronux_tmp\ "%1" /purge
	rmdir "%1"
	rmdir %TEMP%\cronux_tmp\
	
	exit /b 0
	
:display 
	echo Cronux: %* 

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
	echo clear,cls                       clear the command prompt 
	echo download,wget,irs               download file from the internet into a folder widget style
	echo elevate 'program' 'params...'   run a command line program as administrator
	echo remove,uninstall,remove-command delete a file, script or command in the the search paths
	echo .
	exit /b 0
	
REM DO not run the commands below directly 
REM Write each command to independent batch 
REM script that can be executed individually 
REM from the command line without prepending
REM `Cronux`. 

REM The script created is not for the alias but 
REM for the main command. E.g to request Admin 
REM priviledge the following commands are valid 
REM `su sudo elevate`. Only the elevate command 
REM will be exported as the alias commands such 
REM `su` `sudo` can conflict with an actual 
REM installed program on the PC
:write_and_create_comands
	call:write_create_elevate %1
	
	exit /b 0
	
REM Create an independent batch script for 
REM the elevate command 
:write_create_elevate
	SET ELEVATE_SCRIPT_PATH=%1/elevate.bat
	call:display Creating batch script for the 'elevate' command at !ELEVATE_SCRIPT_PATH!
	echo @echo off> !ELEVATE_SCRIPT_PATH!
	echo setlocal enabledelayedexpansion>> !ELEVATE_SCRIPT_PATH!
	echo SET OP_ARGS="">> !ELEVATE_SCRIPT_PATH!
	echo for %%%%a in (%%*) do (>> !ELEVATE_SCRIPT_PATH!
	echo 	if ^^!OP_ARGS^^!=="" (>> !ELEVATE_SCRIPT_PATH!
	echo 		SET OP_ARGS=%%%%a \^"/k>> !ELEVATE_SCRIPT_PATH!
	echo 	) else ( >> !ELEVATE_SCRIPT_PATH!
	echo 		SET OP_ARGS=^^!OP_ARGS^^! %%%%a>> !ELEVATE_SCRIPT_PATH!
	echo 	)>> !ELEVATE_SCRIPT_PATH!
	echo )>> !ELEVATE_SCRIPT_PATH!
	echo SET OP_ARGS=^^!OP_ARGS^^! \^">> !ELEVATE_SCRIPT_PATH!
	echo powershell -Command ^"Start-Process ^^!OP_ARGS^^! -Verb RunAs^">> !ELEVATE_SCRIPT_PATH!
	
	exit /b 0

