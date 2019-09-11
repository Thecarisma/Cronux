SET errorlevel=0
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
REM Remove a folder from the environment path. The first parameter is the target 
REM environment to edit and remove a folder from. if the command is called with 
REM just two parameter then the second parameter will be the folder to remove 
REM from the path if it is there. If more than two parameters are sent to the 
REM command each of the argument after the first argument(targetname) will be used
REM to determine which folder to remove by checking if each folder in path contains 
REM all the suppliment argument
REM 
REM ::
REM 	Usage: delpath User [the full path or parts of the environment...]
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the target name of the environment, usually User, Machine or Process
REM 	param2 : string
REM 		the folder to remove from environment path

SET TARGET=
SET FOLDER_FOR_EXPRESSION=
SET REM_ARGS=
SET DELPATH_ELEVATED=false

SET HOUR=%time:~0,2%
SET dtStamp9=%date:~-4%-%date:~3,2%-%date:~0,2%_0%time:~1,1%%time:~3,2%%time:~6,2%
SET dtStamp24=%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
if "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) else (SET dtStamp=%dtStamp24%)

for %%a in (%*) do (
	if "!TARGET!"=="" (
		SET TARGET=%%a
	) else (
		if "%%a"=="C:\" (
			call:display_error the argument '%%a' is invalid
			SET errorlevel=677
			goto:eof
		)
		if "!FOLDER_FOR_EXPRESSION!"=="" (
			SET FOLDER_FOR_EXPRESSION=$path.Contains^('%%a'^)
			SET REM_ARGS=%%a
		) else (
			SET FOLDER_FOR_EXPRESSION=!FOLDER_FOR_EXPRESSION! -and $path.Contains^('%%a'^)
			SET REM_ARGS=!REM_ARGS! %%a
		)
	)
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
									if not "!TARGET!"=="admin__maqwqadsafdswqeqe__ine___1212hghgg" (
										call:display_error The target is invalid, it has to be either User, Process or Machine
										SET errorlevel=677
										goto:eof
									) else ( SET TARGET=admin__maqwqadsafdswqeqe__ine___1212hghgg)
								) else ( SET TARGET=Process)
							) else ( SET TARGET=Process)
						) else ( SET TARGET=Process)
					) else ( SET TARGET=Machine)
				) else ( SET TARGET=Machine)
			) else ( SET TARGET=Machine)
		) else ( SET TARGET=User)
	) else ( SET TARGET=User)
) else ( SET TARGET=User)

if "!TARGET!"=="admin__maqwqadsafdswqeqe__ine___1212hghgg" (
	SET DELPATH_ELEVATED=true
	SET TARGET=Machine
)

if "!TARGET!"=="admin__maqwqadsafdswqeqe__ine___1212hghgg" (
	SET BACKUP_FULL_PATH=!ROAMING_FOLDER!environment\Path.Machine.!dtStamp!.cronux.backup
	call:display backing up Path at !BACKUP_FULL_PATH!
	powershell -Command "& { [environment]::GetEnvironmentVariable(\"Path\",\"Machine\") | Out-File !BACKUP_FULL_PATH! }"
) else (
	SET BACKUP_FULL_PATH=!ROAMING_FOLDER!environment\Path.!TARGET!.!dtStamp!.cronux.backup
	call:display backing up Path at !BACKUP_FULL_PATH!
	powershell -Command "& { [environment]::GetEnvironmentVariable(\"Path\",\"!TARGET!\") | Out-File !BACKUP_FULL_PATH! }"
)
if not exist "!BACKUP_FULL_PATH!" (
	call:display_error cannot modify the !TARGET! Path because backup failed
	SET errorlevel=677
	goto:eof
)

SET GET_VAR_POWERSHELL_COMMAND=$paths=[environment]::GetEnvironmentVariable(\"Path\",\"!TARGET!\").Split(\";\");$newpath=\"\";foreach($path in $paths){if($path.Trim().Equals(\"\")){continue;}if (!FOLDER_FOR_EXPRESSION!){continue;}$newpath=$newpath+$path+\";\";}$newpath=$newpath.Remove($newpath.Length-1);

if "!TARGET!"=="Machine" (
	if "!DELPATH_ELEVATED!"=="true" (
		SET TARGET=admin__maqwqadsafdswqeqe__ine___1212hghgg
	)
)

if "!TARGET!"=="Process" (
	powershell -Command "& { !GET_VAR_POWERSHELL_COMMAND! $env:Path = \"!VALUE!\" }"
)
if "!TARGET!"=="User" (
	powershell -Command "& { !GET_VAR_POWERSHELL_COMMAND! [Environment]::SetEnvironmentVariable(\"Path\", $newpath, \"!TARGET!\") }"
)
if "!TARGET!"=="Machine" (
	if "!DELPATH_ELEVATED!"=="false" (
		if exist "!SCRIPT_DIR!\delpath.bat" (
			powershell -Command "!GET_VAR_POWERSHELL_COMMAND! Start-Process cmd \"/k "!SCRIPT_DIR!\delpath.bat" admin__maqwqadsafdswqeqe__ine___1212hghgg !REM_ARGS! ^&^& exit \" -Verb RunAs"
		) else (
			powershell -Command "!GET_VAR_POWERSHELL_COMMAND!  Start-Process cmd \"/k "!SCRIPT_DIR!\Cronux.bat" delpath admin__maqwqadsafdswqeqe__ine___1212hghgg !REM_ARGS! ^&^& exit \" -Verb RunAs"
		)
	)
)
if "!TARGET!"=="admin__maqwqadsafdswqeqe__ine___1212hghgg" (
	powershell -Command "& { !GET_VAR_POWERSHELL_COMMAND!  [Environment]::SetEnvironmentVariable(\"Path\", $newpath, \"Machine\") }"
)
call:display all the folder containing '!REM_ARGS!' has been removed from !TARGET! Path

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.delpath:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.delpath:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 27 August 2019
REM 	:time: 04:43 PM
REM 	:filename: delpath.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
