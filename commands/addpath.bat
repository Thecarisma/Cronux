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
REM Add a folder to the environment path. The second parameter which is optional 
REM is the targeted environment which is usually one of the option below
REM 
REM 	* User
REM		* Machine
REM		* Process
REM 
REM If the second parameter is not a valid target name then the folder is added to 
REM the User environment. If the folder does not exist it is not added and be sure 
REM to provide the absolute name to the folder 
REM 
REM ::
REM 	Usage: addpath /the/folder/to/add/topath.full targetname
REM 
REM Since the Path environment is very vital for the system to function properly the 
REM Path variable of the targeted environment is backed up before making changes to it 
REM the path is backed up in the following format Path.!TARGET!.`!TIME_STAMP`.cronux.backup
REM in the folder `%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Cronux\environment\` in just plain 
REM text format before changing it. Therefore incase of corruption in the Path you can 
REM execute the command below to set the path
REM 
REM ::
REM 	setenvf tartgetname Path /full/path/to/Path.!TARGET!.`!TIME_STAMP`.cronux.backup
REM 
REM Endure you view the Path backup file in a text editor or using the cat command before 
REM you revert it
REM 
REM **Parameters**:	
REM 	param1 : string 
REM 		the full absolute path to the directory to add to path
REM 	param2 : string (optional)
REM 		the target name of the environment, usually User, Machine or Process


SET HOUR=%time:~0,2%
SET dtStamp9=%date:~-4%-%date:~3,2%-%date:~0,2%_0%time:~1,1%%time:~3,2%%time:~6,2%
SET dtStamp24=%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
if "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) else (SET dtStamp=%dtStamp24%)

if not exist "!ROAMING_FOLDER!environment" (
	mkdir "!ROAMING_FOLDER!environment"
)

SET FOLDER_FULL_PATH=%1
SET TARGET=%2

if "!TARGET!"=="" (
	SET TARGET=User
)
if "!FOLDER_FULL_PATH!"=="" (
	call:display_error The full path of the folder to add to environment Path cannot be empty
	SET errorlevel=677
	goto:eof
)
if not exist "!FOLDER_FULL_PATH!" (
	call:display_error The specified folder '!FOLDER_FULL_PATH!' does not exist
	SET errorlevel=677
	goto:eof
)
if not "!TARGET!"=="user" (
	if not "!TARGET!"=="User" (
		if not "!TARGET!"=="USER" (
			if not "!TARGET!"=="machine" (
				if not "!TARGET!"=="Machine" (
					if not "!TARGET!"=="MACHINE" (
						if not "!TARGET!"=="process" (
							if not "!TARGET!"=="Process" (
								if not "!TARGET!"=="PROCESS" (
									if not "!TARGET!"=="admiwn_awqwch__ine__esds_1212hghgg" (
										call:display_error The target is invalid, it has to be either User, Process or Machine
										SET errorlevel=677
										goto:eof
									) else ( SET TARGET=admiwn_awqwch__ine__esds_1212hghgg)
								) else ( SET TARGET=Process)
							) else ( SET TARGET=Process)
						) else ( SET TARGET=Process)
					) else ( SET TARGET=Machine)
				) else ( SET TARGET=Machine)
			) else ( SET TARGET=Machine)
		) else ( SET TARGET=User)
	) else ( SET TARGET=User)
) else ( SET TARGET=User)

if "!TARGET!"=="admiwn_awqwch__ine__esds_1212hghgg" (
	SET BACKUP_FULL_PATH=!ROAMING_FOLDER!environment\Path.Machine.!dtStamp!.cronux.backup
	call:display backing up Path at !BACKUP_FULL_PATH!
	powershell -Command "& { [environment]::GetEnvironmentVariable(\"Path\",\"Machine\") | Out-File !BACKUP_FULL_PATH! }"
) else (
	SET BACKUP_FULL_PATH=!ROAMING_FOLDER!environment\Path.!TARGET!.!dtStamp!.cronux.backup
	call:display backing up Path at !BACKUP_FULL_PATH!
	powershell -Command "& { [environment]::GetEnvironmentVariable(\"Path\",\"!TARGET!\") | Out-File !BACKUP_FULL_PATH! }"
)
if not exist "!BACKUP_FULL_PATH!" (
	call:display_error backup failed
	SET errorlevel=677
	goto:eof
)

for %%i in ("!FOLDER_FULL_PATH!") do (
	SET FOLDER_FULL_PATH=%%~si
)
call:display adding !FOLDER_FULL_PATH! to path
if "!TARGET!"=="Process" (
	powershell -Command "& { $path = [environment]::GetEnvironmentVariable(\"Path\",\"!TARGET!\") + \";!FOLDER_FULL_PATH!\"; $env:Path = \"$path\" }"
)
if "!TARGET!"=="User" (
	powershell -Command "& { $path = [environment]::GetEnvironmentVariable(\"Path\",\"!TARGET!\") + ';!FOLDER_FULL_PATH!'; [Environment]::SetEnvironmentVariable(\"Path\", \"$path\", \"!TARGET!\") }"
)
if "!TARGET!"=="Machine" (
	if exist "!SCRIPT_DIR!\addpath.bat" (
		powershell -Command "Start-Process cmd \"/k "!SCRIPT_DIR!\addpath.bat" !FOLDER_FULL_PATH! admiwn_awqwch__ine__esds_1212hghgg ^&^& exit \" -Verb RunAs"
	) else (
		powershell -Command "Start-Process cmd \"/k "!SCRIPT_DIR!\Cronux.bat" addpath !FOLDER_FULL_PATH! admiwn_awqwch__ine__esds_1212hghgg ^&^& exit \" -Verb RunAs"
	)
)
if "!TARGET!"=="admiwn_awqwch__ine__esds_1212hghgg" (
	powershell -Command "& { $path = [environment]::GetEnvironmentVariable(\"Path\",\"Machine\") + ';!FOLDER_FULL_PATH!'; [Environment]::SetEnvironmentVariable(\"Path\", \"$path\", \"Machine\") }"
)
call:display the environement Path  has been updated for target '!TARGET!'

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.addpath:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.addpath:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 26 August 2019
REM 	:time: 04:52 PM
REM 	:filename: addpath.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
