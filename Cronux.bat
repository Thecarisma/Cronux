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

	REM silent the advertisement
	if "%%x"=="no-ad" (
		SET AD=""
	)

	if "%%x"=="clear" (
		SET AD=""
		if !OPERATION!=="none" ( call:clear ) 
	)
	if "%%x"=="cls" (
		SET AD=""
		if !OPERATION!=="none" ( call:clear ) 
	)
	
	if !OPERATION!=="none" (
		@echo off
	) else (
		if "%%x"=="no-ad" (
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
	call:help !OP_ARGS!
)
if %OPERATION%=="help" (
	call:help !OP_ARGS!
)
if %OPERATION%=="listdir" (
	call:listdir !OP_ARGS!
)
if %OPERATION%=="elevate" (
	call:elevate %OP_ARGS%
)
if %OPERATION%=="noadmin-install" (
	call:noadmin_install !OP_ARGS!
)
if %OPERATION%=="download" (
	call:download !OP_ARGS!
)
if %OPERATION%=="rmlong" (
	call:rmlong !OP_ARGS!
)
if %OPERATION%=="removecommand" (
	call:remove !OP_ARGS!
)
if %OPERATION%=="echocolor" (
	call:foreground_background_echo !OP_ARGS!
)
if %OPERATION%=="colorlist" (
	call:print_console_colors_list !OP_ARGS!
)
if %OPERATION%=="backupdelete" (
	call:backup_and_delete !OP_ARGS!
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
:backup_and_delete
	SET HOUR=%time:~0,2%
	SET dtStamp9=%date:~-4%-%date:~3,2%-%date:~0,2%_0%time:~1,1%%time:~3,2%%time:~6,2% 
	SET dtStamp24=%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
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
REM 	Usage: Cronux download /save/file/path.full https://thefileurl.com
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
	
REM Display message and title in the console
:display 
	echo Cronux: %* 

	exit /b 0
	
REM Print into the windows command prompt with 
REM color set for the foreground and background
REM 
REM ::
REM 
REM 	Usage: Cronux echocolor [background-color] [foreground-color] <text to print...?
REM 	Example: Cronux echocolor 101 34 this is the remaining text
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
:foreground_background_echo
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
	
REM print out the list of colors that can be passed to the 
REM command **echocolor**. The list of colors is extracted from 
REM the gist https://gist.github.com/mlocati/fdabcaeb8071d5c75a2d51712db24011
REM provided by [Michele Locati](https://gist.github.com/mlocati/)
:print_console_colors_list
	echo.
	echo [101;93m NORMAL FOREGROUND COLORS [0m
	echo 30 [30mBlack[0m (black)
	echo 31 [31mRed[0m
	echo 32 [32mGreen[0m
	echo 33 [33mYellow[0m
	echo 34 [34mBlue[0m
	echo 35 [35mMagenta[0m
	echo 36 [36mCyan[0m
	echo 37 [37mWhite[0m
	echo.
	echo [101;93m NORMAL BACKGROUND COLORS [0m
	echo 40 [40mBlack[0m
	echo 41 [41mRed[0m
	echo 42 [42mGreen[0m
	echo 43 [43mYellow[0m
	echo 44 [44mBlue[0m
	echo 45 [45mMagenta[0m
	echo 46 [46mCyan[0m
	echo 47 [47mWhite[0m (white)
	echo.
	echo [101;93m STRONG FOREGROUND COLORS [0m
	echo 90 [90mWhite[0m
	echo 91 [91mRed[0m
	echo 92 [92mGreen[0m
	echo 93 [93mYellow[0m
	echo 94 [94mBlue[0m
	echo 95 [95mMagenta[0m
	echo 96 [96mCyan[0m
	echo 97 [97mWhite[0m
	echo.
	echo [101;93m STRONG BACKGROUND COLORS [0m
	echo 100 [100mBlack[0m
	echo 101 [101mRed[0m
	echo 102 [102mGreen[0m
	echo 103 [103mYellow[0m
	echo 104 [104mBlue[0m
	echo 105 [105mMagenta[0m
	echo 106 [106mCyan[0m
	echo 107 [107mWhite[0m
	echo.
	echo see https://gist.github.com/mlocati/fdabcaeb8071d5c75a2d51712db24011

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
		echo %%x
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
	echo.
	exit /b 0

REM The script created is not for the alias but 
REM for the main command. E.g to request Admin 
REM priviledge the following commands are valid 
REM `su sudo elevate`. Only the elevate command 
REM will be exported as the alias commands such 
REM `su` `sudo` can conflict with an actual 
REM installed program on the PC
:write_and_create_comands
	call:write_clear %1
	call:write_create_elevate %1
	call:write_listdir %1
	call:write_download %1
	call:write_rmlong %1
	call:write_backup_and_delete %1
	call:write_echocolor %1
	call:write_colorlist %1
	
	exit /b 0
	
REM Create an independent batch script for 
REM the `clear` command 
:write_clear
	SET SCRIPT_PATH=%1/clear.bat
	call:display Creating batch script for the 'clear' command at !SCRIPT_PATH!
	echo @echo off> !SCRIPT_PATH!
	echo setlocal enabledelayedexpansion>> !SCRIPT_PATH!
	echo cls>> !SCRIPT_PATH!
	
	exit /b 0
	
REM Create an independent batch script for 
REM the `elevate` command 
:write_create_elevate
	SET SCRIPT_PATH=%1/elevate.bat
	call:display Creating batch script for the 'elevate' command at !SCRIPT_PATH!
	echo @echo off> !SCRIPT_PATH!
	echo setlocal enabledelayedexpansion>> !SCRIPT_PATH!
	echo SET OP_ARGS="">> !SCRIPT_PATH!
	echo for %%%%a in (%%*) do (>> !SCRIPT_PATH!
	echo 	if ^^!OP_ARGS^^!=="" (>> !SCRIPT_PATH!
	echo 		SET OP_ARGS=%%%%a \^"/k>> !SCRIPT_PATH!
	echo 	) else ( >> !SCRIPT_PATH!
	echo 		SET OP_ARGS=^^!OP_ARGS^^! %%%%a>> !SCRIPT_PATH!
	echo 	)>> !SCRIPT_PATH!
	echo )>> !SCRIPT_PATH!
	echo SET OP_ARGS=^^!OP_ARGS^^! \^">> !SCRIPT_PATH!
	echo powershell -Command ^"Start-Process ^^!OP_ARGS^^! -Verb RunAs^">> !SCRIPT_PATH!
	
	exit /b 0
	
REM Create an independent batch script for 
REM the `ls` command not **dir** since the dir program 
REM is built into the Windows OS
:write_listdir
	SET SCRIPT_PATH=%1/ls.bat
	call:display Creating batch script for the 'ls' command at !SCRIPT_PATH!
	echo @echo off> !SCRIPT_PATH!
	echo setlocal enabledelayedexpansion>> !SCRIPT_PATH!
	echo if "%%1%%"=="" (>> !SCRIPT_PATH!
	echo 	dir>> !SCRIPT_PATH!
	echo ) else (>> !SCRIPT_PATH!
	echo 	cd %%1%%>> !SCRIPT_PATH!
	echo 	dir>> !SCRIPT_PATH!
	echo )>> !SCRIPT_PATH!
	echo if "%%1%%"=="" (>> !SCRIPT_PATH!
	echo 	REM>> !SCRIPT_PATH!
	echo ) else (>> !SCRIPT_PATH!
	echo 	cd !WORKING_DIR!>> !SCRIPT_PATH!
	echo )>> !SCRIPT_PATH!
	
	exit /b 0
	
REM Create an independent batch script for 
REM the `download` 
:write_download
	SET SCRIPT_PATH=%1/download.bat
	call:display Creating batch script for the 'download' command at !SCRIPT_PATH!
	echo @echo off> !SCRIPT_PATH!
	echo setlocal enabledelayedexpansion>> !SCRIPT_PATH!
	echo powershell -Command "& { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $request = (new-object System.Net.WebClient); $request.DownloadFile('%%2','%%1') ; }">> !SCRIPT_PATH!

	exit /b 0
	
REM Create an independent batch script for 
REM the `rmlong` 
:write_rmlong
	SET SCRIPT_PATH=%1/rmlong.bat
	call:display Creating batch script for the 'rmlong' command at !SCRIPT_PATH!
	echo @echo off> !SCRIPT_PATH!
	echo setlocal enabledelayedexpansion>> !SCRIPT_PATH!
	echo mkdir %TEMP%\cronux_tmp\>> !SCRIPT_PATH!
	echo robocopy %TEMP%\cronux_tmp\ "%%1" /purge>> !SCRIPT_PATH!
	echo rmdir "%%1">> !SCRIPT_PATH!
	echo rmdir %TEMP%\cronux_tmp\>> !SCRIPT_PATH!
	
	exit /b 0
	
REM Create an independent batch script for 
REM the `backdel` 
:write_backup_and_delete
	SET SCRIPT_PATH=%1/backdel.bat
	call:display Creating batch script for the 'backdel' command at !SCRIPT_PATH!
	echo @echo off> !SCRIPT_PATH!
	echo setlocal enabledelayedexpansion>> !SCRIPT_PATH!
	echo SET HOUR=%%time:~0,2%%>> !SCRIPT_PATH!
	echo SET dtStamp9=%%date:~-4%%-%%date:~3,2%%-%%date:~0,2%%_0%%time:~1,1%%%%time:~3,2%%%%time:~6,2%%>> !SCRIPT_PATH!
	echo SET dtStamp24=%%date:~-4%%-%%date:~3,2%%-%%date:~0,2%%_%%time:~0,2%%%%time:~3,2%%%%time:~6,2%%>> !SCRIPT_PATH!
	echo if "%%HOUR:~0,1%%" == " " (SET dtStamp=%%dtStamp9%%) else (SET dtStamp=%%dtStamp24%%)>> !SCRIPT_PATH!
	echo.>> !SCRIPT_PATH!
	echo if not exist !BACKUP_FOLDER! (>> !SCRIPT_PATH!
	echo 	mkdir !BACKUP_FOLDER!>> !SCRIPT_PATH!
	echo )>> !SCRIPT_PATH!
	echo.>> !SCRIPT_PATH!
	echo FOR %%%%i IN ("%%1") DO (>> !SCRIPT_PATH!
	echo 	SET filedrive=%%%%~di>> !SCRIPT_PATH!
	echo 	SET filepath=%%%%~pi>> !SCRIPT_PATH!
	echo 	SET filename=%%%%~ni>> !SCRIPT_PATH!
	echo 	SET fileextension=%%%%~xi>> !SCRIPT_PATH!
	echo )>> !SCRIPT_PATH!
	echo Cronux: backing up ^^!filename^^!^^!fileextension^^! before deleting>> !SCRIPT_PATH!
	echo copy %%1 !BACKUP_FOLDER!\^^!filename^^!^^!fileextension^^!.^^!dtStamp^^!.cronux.backup>> !SCRIPT_PATH!
	echo del %%1 /s /f /q>> !SCRIPT_PATH!
	
	exit /b 0
	
REM Create an independent batch script for 
REM the `echocolor` 
:write_echocolor
	SET SCRIPT_PATH=%1/echocolor.bat
	call:display Creating batch script for the 'echocolor' command at !SCRIPT_PATH!
	echo @echo off> !SCRIPT_PATH!
	echo setlocal enabledelayedexpansion>> !SCRIPT_PATH!
	echo SET BG=>> !SCRIPT_PATH!
	echo SET FG=>> !SCRIPT_PATH!
	echo SET TEXT=>> !SCRIPT_PATH!
	echo for %%%%a in (%%*) do (>> !SCRIPT_PATH!
	echo 	if "^!BG^!"=="" (>> !SCRIPT_PATH!
	echo 		SET BG=%%%%a>> !SCRIPT_PATH!
	echo 	) else (>> !SCRIPT_PATH!
	echo 		if "^!FG^!"=="" (>> !SCRIPT_PATH!
	echo 			SET FG=%%%%a>> !SCRIPT_PATH!
	echo 		) else (>> !SCRIPT_PATH!
	echo 			if "^!TEXT^!"=="" (>> !SCRIPT_PATH!
	echo 				SET TEXT=%%%%a>> !SCRIPT_PATH!
	echo 			) else (>> !SCRIPT_PATH!
	echo 				SET TEXT=^^!TEXT^^! %%%%a>> !SCRIPT_PATH!
	echo 			)>> !SCRIPT_PATH!
	echo 		)>> !SCRIPT_PATH!
	echo 	)>> !SCRIPT_PATH!
	echo )>> !SCRIPT_PATH!
	echo echo [^^!FG^^!;^^!BG^^!m^^!TEXT^^![0m>> !SCRIPT_PATH!
	
	exit /b 0
	
REM Create an independent batch script for 
REM the `colorlist` command
:write_colorlist
	SET SCRIPT_PATH=%1/colorlist.bat
	call:display Creating batch script for the 'colorlist' command at !SCRIPT_PATH!
	echo @echo off> !SCRIPT_PATH!
	echo setlocal enabledelayedexpansion>> !SCRIPT_PATH!
	echo echo.>> !SCRIPT_PATH!
	echo echo [101;93m NORMAL FOREGROUND COLORS [0m>> !SCRIPT_PATH!
	echo echo 30 [30mBlack[0m (black)>> !SCRIPT_PATH!
	echo echo 31 [31mRed[0m>> !SCRIPT_PATH!
	echo echo 32 [32mGreen[0m>> !SCRIPT_PATH!
	echo echo 33 [33mYellow[0m>> !SCRIPT_PATH!
	echo echo 34 [34mBlue[0m>> !SCRIPT_PATH!
	echo echo 35 [35mMagenta[0m>> !SCRIPT_PATH!
	echo echo 36 [36mCyan[0m>> !SCRIPT_PATH!
	echo echo 37 [37mWhite[0m>> !SCRIPT_PATH!
	echo echo.>> !SCRIPT_PATH!
	echo echo [101;93m NORMAL BACKGROUND COLORS [0m>> !SCRIPT_PATH!
	echo echo 40 [40mBlack[0m>> !SCRIPT_PATH!
	echo echo 41 [41mRed[0m>> !SCRIPT_PATH!
	echo echo 42 [42mGreen[0m>> !SCRIPT_PATH!
	echo echo 43 [43mYellow[0m>> !SCRIPT_PATH!
	echo echo 44 [44mBlue[0m>> !SCRIPT_PATH!
	echo echo 45 [45mMagenta[0m>> !SCRIPT_PATH!
	echo echo 46 [46mCyan[0m>> !SCRIPT_PATH!
	echo echo 47 [47mWhite[0m (white)>> !SCRIPT_PATH!
	echo echo.>> !SCRIPT_PATH!
	echo echo [101;93m STRONG FOREGROUND COLORS [0m>> !SCRIPT_PATH!
	echo echo 90 [90mWhite[0m>> !SCRIPT_PATH!
	echo echo 91 [91mRed[0m>> !SCRIPT_PATH!
	echo echo 92 [92mGreen[0m>> !SCRIPT_PATH!
	echo echo 93 [93mYellow[0m>> !SCRIPT_PATH!
	echo echo 94 [94mBlue[0m>> !SCRIPT_PATH!
	echo echo 95 [95mMagenta[0m>> !SCRIPT_PATH!
	echo echo 96 [96mCyan[0m>> !SCRIPT_PATH!
	echo echo 97 [97mWhite[0m>> !SCRIPT_PATH!
	echo echo.>> !SCRIPT_PATH!
	echo echo [101;93m STRONG BACKGROUND COLORS [0m>> !SCRIPT_PATH!
	echo echo 100 [100mBlack[0m>> !SCRIPT_PATH!
	echo echo 101 [101mRed[0m>> !SCRIPT_PATH!
	echo echo 102 [102mGreen[0m>> !SCRIPT_PATH!
	echo echo 103 [103mYellow[0m>> !SCRIPT_PATH!
	echo echo 104 [104mBlue[0m>> !SCRIPT_PATH!
	echo echo 105 [105mMagenta[0m>> !SCRIPT_PATH!
	echo echo 106 [106mCyan[0m>> !SCRIPT_PATH!
	echo echo 107 [107mWhite[0m>> !SCRIPT_PATH!
	echo echo.>> !SCRIPT_PATH!
	echo echo see https://gist.github.com/mlocati/fdabcaeb8071d5c75a2d51712db24011>> !SCRIPT_PATH!

	exit /b 0
	
	

