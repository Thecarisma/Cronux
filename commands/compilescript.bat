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
REM This script is used to merge all the commands into one single 
REM batch file for distribution. 
REM It first looks for the Cronux.bat file in the working directory if 
REM it not found it check the parent directory, the entire content of 
REM the Cronux.bat is writtent to the output script and each individual 
REM script is extracted and appended to the output script if it found
REM if a command script is not cound it is skipped but the script is 
REM terminated with en error code of 1
REM 
REM ::
REM 	Usage: compilescript [commands]
REM 
REM The expected parameters is the name of the command only e.g 'ls' and 
REM not the full path to it file e.g no 'ls.bat' the file name resolution is 
REM taken care by the procedure.
REM 
REM 
REM **Parameters**:	
REM 	params... : string
REM 		the command to extract it script

SET MAIN_CRONUX_PATH=Cronux.bat
SET PARAM1=%1
SET OUTPUT_PATH=%1

if not exist "!MAIN_CRONUX_PATH!" (
	SET MAIN_CRONUX_PATH=..\Cronux.bat
	if not exist "!MAIN_CRONUX_PATH!" (
		SET MAIN_CRONUX_PATH=!SCRIPT_DIR!\Cronux.bat
		if not exist "!MAIN_CRONUX_PATH!" (
			SET MAIN_CRONUX_PATH=!SCRIPT_DIR!\..\Cronux.bat
			if not exist "!MAIN_CRONUX_PATH!" (
				call:display_error cannot find the main Cronux.bat file 
				SET errorlevel=677
				goto:eof
			)
		)
	)
)

if exist "!OUTPUT_PATH!" (
	del !OUTPUT_PATH!
)

call:display compiling the main script Cronux.bat file 
powershell -Command "& { $command_name = 'setenv'; $is_within_main_script = $False; $output_file = '!OUTPUT_PATH!'; foreach($line in Get-Content !MAIN_CRONUX_PATH!) { if($line -match $regex){ if ($line.StartsWith(\"REM START_OFFSET_FOR_MERGE\")) { $is_within_main_script = $True; continue } if ($line.StartsWith(\"REM END_OFFSET_FOR_MERGE\")) { $is_within_main_script = $False; continue } if ($line.Trim().StartsWith(\"REM\")) { continue; } if ($is_within_main_script -eq $True) { $line | Out-File -Append $output_file -Encoding ASCII } } } }"
call:display main script Cronux.bat file generated at !MAIN_CRONUX_PATH!

for %%a in (%*) do (
	if not "%%a"=="!PARAM1!" (
		call:display compiling '%%a' script into !OUTPUT_PATH! 
		SET SCRIPT_PATH=%%a
		
		for %%i in ("!SCRIPT_PATH!") do (
			SET filedrive=%%~di
			SET filepath=%%~pi
			SET filename=%%~ni
			SET fileextension=%%~xi
		) 
		if not exist "!SCRIPT_PATH!" (
			SET SCRIPT_PATH=%%a.bat
			if not exist "!SCRIPT_PATH!" (
				SET SCRIPT_PATH=.\commands\%%a.bat
				if not exist "!SCRIPT_PATH!" (
					SET SCRIPT_PATH=..\%%a.bat
					if not exist "!SCRIPT_PATH!" (
						call:display_error cannot find the script for the command '%%a' 
					) else ( call:compile_single_script !filename! !SCRIPT_PATH! !OUTPUT_PATH! )
				) else ( call:compile_single_script !filename! !SCRIPT_PATH! !OUTPUT_PATH! )
			) else ( call:compile_single_script !filename! !SCRIPT_PATH! !OUTPUT_PATH! )
		) else ( call:compile_single_script !filename! !SCRIPT_PATH! !OUTPUT_PATH!)
	)
)
call:display compilation and build completed successfully. 
call:display Built script at !OUTPUT_PATH!

exit /b 0

:compile_single_script
	powershell -Command "& { $command_name = '%1'; $is_within_main_script = $False; $output_file = '%3'; ':' + $command_name | Out-File -Append $output_file -Encoding ASCII; foreach($line in Get-Content '%2') { if($line -match $regex){ if ($line.StartsWith(\"REM START_OFFSET_FOR_MERGE\")) { $is_within_main_script = $True; continue } if ($line.Trim().StartsWith(\"REM END_OFFSET_FOR_MERGE\")) { $is_within_main_script = $False; continue } if ($line.StartsWith(\"REM\")) { continue; } if ($is_within_main_script -eq $True) { '	' + $line.Replace(\"REM \", \"\") | Out-File -Append $output_file -Encoding ASCII } } } }"

	exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.compilescript:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.compilescript:[0m %* 
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
REM 	:date: 26 August 2019
REM 	:time: 10:07 AM
REM 	:filename: compilescript.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
