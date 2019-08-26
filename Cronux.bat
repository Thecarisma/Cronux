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
SET CLEARED=false

SET USER_FOLDER=%HOMEDRIVE%%HOMEPATH%
SET TEST_FOLDER=!SCRIPT_DIR!\test\
SET INSTALLATION_FOLDER=C:\Program Files\Cronux\
SET ROAMING_FOLDER=!USER_FOLDER!\AppData\Roaming\Cronux\
SET BACKUP_FOLDER=!ROAMING_FOLDER!backup\

SET AD="Heal the world, make it a better place"


for %%x in (%*) do (

	REM silent the advertisement
	if "%%x"=="noad" (
		SET AD=""
	)

	if "%%x"=="clear" (
		SET AD=""
		call:call_command_script clear.bat %OP_ARGS% 
		SET CLEARED=true
	)
	if "%%x"=="cls" (
		call:call_command_script clear.bat %OP_ARGS% 
		SET CLEARED=true
	)
	
	if !OPERATION!=="none" (
		@echo off
	) else (
		if "%%x"=="noad" (
			SET AD=""
		) else (
			if not defined OP_ARGS (
				SET OP_ARGS=%%x
			) else (
				SET OP_ARGS=!OP_ARGS! %%x
			)
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
		if !OPERATION!=="none" ( SET OPERATION="removecommand" )
	)
	if "%%x"=="remove" (
		if !OPERATION!=="none" ( SET OPERATION="removecommand" )
	)
	if "%%x"=="removecommand" (
		if !OPERATION!=="none" ( SET OPERATION="removecommand" )
	)
	
	REM install the scripts
	if "%%x"=="noadmin-install" (
		if not !OPERATION!=="elevate" (
			if !OPERATION!=="none" ( SET OPERATION="noadmin-install" )
		)
	)
	if "%%x"=="install" (
		call:elevate "%cd%\Cronux.bat noadmin-install"	
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
		if !OPERATION!=="none" ( SET OPERATION="help" )
	)
	if "%%x"=="cronuxhelp" (
		if !OPERATION!=="none" ( SET OPERATION="help" )
	)
	
	REM echo text with color
	if "%%x"=="echocolor" (
		SET AD=""
		if !OPERATION!=="none" ( SET OPERATION="echocolor" )
	)
	
	REM print all colors accepted in echocommand
	if "%%x"=="colorlist" (
		if !OPERATION!=="none" ( SET OPERATION="colorlist" )
	)
	
	REM backup a file before deleting it 
	if "%%x"=="backdel" (
		if !OPERATION!=="none" ( SET OPERATION="backupdelete" )
	)
	
	REM get an environment variable 
	if "%%x"=="getenv" (
		if !OPERATION!=="none" ( SET OPERATION="getenv" )
	)
	
	REM set an environment variable 
	if "%%x"=="setenv" (
		if !OPERATION!=="none" ( SET OPERATION="setenv" )
	)
	
	REM delete an environment variable 
	if "%%x"=="delenv" (
		if !OPERATION!=="none" ( SET OPERATION="delenv" )
	)
	
	REM print content of a file in console
	if "%%x"=="cat" (
		if !OPERATION!=="none" ( SET OPERATION="printfile" )
	)
	if "%%x"=="printfile" (
		if !OPERATION!=="none" ( SET OPERATION="printfile" )
	)
	
	REM text to speech with custom voice nd speed
	if "%%x"=="ssay" (
		if !OPERATION!=="none" ( SET OPERATION="ssay" )
	)
	
	REM text to speech
	if "%%x"=="say" (
		if !OPERATION!=="none" ( SET OPERATION="say" )
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

if %OPERATION%=="none" (
	if "!CLEARED!"=="false" (
		call:help !OP_ARGS!
	)
)
if %OPERATION%=="help" (
	call:help !OP_ARGS!
)
if %OPERATION%=="noadmin-install" (
	call:noadmin_install !OP_ARGS!
)
if %OPERATION%=="removecommand" (
	call:remove !OP_ARGS!
)
if %OPERATION%=="listdir" (
	call:call_command_script ls.bat %OP_ARGS%
)
if %OPERATION%=="elevate" (
	call:call_command_script elevate.bat %OP_ARGS%
)
if %OPERATION%=="download" (
	call:call_command_script download.bat %OP_ARGS%
)
if %OPERATION%=="rmlong" (
	call:call_command_script rmlong.bat %OP_ARGS%
)
if %OPERATION%=="echocolor" (
	call:call_command_script echocolor.bat %OP_ARGS%
)
if %OPERATION%=="colorlist" (
	call:call_command_script colorlist.bat %OP_ARGS%
)
if %OPERATION%=="backupdelete" (
	call:call_command_script backdel.bat %OP_ARGS%
)
if %OPERATION%=="getenv" (
	call:call_command_script getenv.bat %OP_ARGS%
)
if %OPERATION%=="setenv" (
	call:call_command_script setenv.bat %OP_ARGS%
)
if %OPERATION%=="delenv" (
	call:call_command_script delenv.bat %OP_ARGS%
)
if %OPERATION%=="printfile" (
	call:call_command_script printfile.bat %OP_ARGS%
)
if %OPERATION%=="ssay" (
	call:call_command_script ssay.bat %OP_ARGS%
)
if %OPERATION%=="say" (
	call:call_command_script say.bat %OP_ARGS%
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
	
REM 
:call_command_script
	SET SCRIPT_PATH=
	SET ARGS__=
	for %%a in (%*) do (
		if "!SCRIPT_PATH!"=="" (
			SET SCRIPT_PATH=%%a
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
		exit /b 0
	)
	if not exist "!SCRIPT_PATH!" (
		SET SCRIPT_PATH=commands\%1
		if not exist "!SCRIPT_PATH!" (
			call:display_error cannot find the script !SCRIPT_PATH!
		)
	) 
	!SCRIPT_PATH! !ARGS__!
	
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
:noadmin_install
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
			call:backup_and_delete "%%x"
		) else (
			REM Check the provide full path after appending .bat
			if exist %%x.bat (
				call:backup_and_delete "%%x.bat"
			) else (
				REM check test directory
				if exist !TEST_FOLDER!\%%x (
					call:backup_and_delete "!TEST_FOLDER!\%%x"
				) else (
					REM check test directory after appending .bat
					if exist !TEST_FOLDER!\%%x.bat (
						call:backup_and_delete "!TEST_FOLDER!\%%x.bat"
					) else (
						REM check test\installation directory
						if exist !TEST_FOLDER!\installation\%%x (
							call:backup_and_delete "!TEST_FOLDER!\installation\%%x"
						) else (
							REM check test\installation directory after appending .bat
							if exist !TEST_FOLDER!\installation\%%x.bat (
								call:backup_and_delete "!TEST_FOLDER!\installation\%%x.bat"
							) else (
								REM check installation directory
								if exist !INSTALLATION_FOLDER!\%%x (
									call:backup_and_delete "!INSTALLATION_FOLDER!\%%x"
								) else (
									REM check installation directory after appending .bat
									if exist !INSTALLATION_FOLDER!\%%x.bat (
										call:backup_and_delete "!INSTALLATION_FOLDER!\%%x.bat"
									) else (
										call:display_error deletion failed cannot find '%%x' in search paths 
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
	
REM Display message and title in the console
:display 
	echo [0;32mCronux:[0m %* 

	exit /b 0
	
REM Display message and title in the console
:display_error
	echo [0;31mCronux:[0m %* 

	exit /b 0
	

	
REM Print the help message and exit
REM 
:help 
	if "%1"=="all" (
		call:allhelp
		exit /b 0
	)
	if "%1"=="" (
		call:allhelp
		exit /b 0
	) 
	
	for %%x in (%*) do (
		call:call_command_script cronuxhelp.bat %%x
	)
	
	exit /b 0
	
REM DO not run the blocks below directly 
REM Write each command to independent batch 
REM script that can be executed individually 
REM from the command line without prepending
REM `Cronux`. 
:allhelp
	echo Usage: Cronux [COMMAND] [COMMAND_PARAMS]
	echo For more information on a specific command, type `Cronux HELP command-name`
	echo [COMMAND]: the system or supplementary system command to execute
	echo [COMMAND_PARAMS]: the parameters or arguments to send to the command
	echo.
	echo The COMMANDS include:
	echo  HELP                              print this help message and exit
	echo  ECHOCOLOR                         print in the command prompt with custom background and foreground color
	echo  INSTALL                           install all the available command in the Script (admin)
	echo  NOADMIN-INSTALL                   install all the available command in the Script
	echo  DIR,LS                            list all the files and folder in a directory
	echo  CLEAR,CLS                         clear the command prompt 
	echo  DOWNLOAD,WGET,IRS                 download file from the internet into a folder widget style
	echo  ELEVATE 'PROGRAM' 'PARAMS...'     run a command line program as administrator
	echo  REMOVE,UNINSTALL,REMOVECOMMAND    delete a file, script or command in the the search paths
	echo  COLORLIST                         print all the console color that can be used with `echocolor` command
	echo  BACKDEL                           backup a file before deleting it
	echo  GETENV                            get an environment variable from either Machine, User or Process
	echo  SETENV                            set an environment variable for either Machine, User or Process
	echo  DELENV                            delete an environment variable from either Machine, User or Process environment
	echo  SSAY                              use the speech syntensizer to speak provided text with custom speed and voice
	echo  SAY                               use the speech syntensizer to speak provided text
	echo.
	exit /b 0

