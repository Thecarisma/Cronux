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
REM Set an environment variable for the system. The first parameter is 
REM is the target name of the environment which are 
REM 
REM 	* User
REM		* Machine
REM		* Process
REM 
REM If the first parameter is not one of the three above it is an error. 
REM The second parameter is the Name of the environement variable and the 
REM remaining argument is the value of the environement variable
REM 
REM ::
REM 	Usage: setenv tartgetname varname [all the other argument is the value...]
REM 
REM If the target name is the Machine administrative access is requested to 
REM allow the script make changes to the system environement variables.
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the target name of the environment, usually User, Machine or Process
REM 	param2 : string
REM 		the name of the environment variable
REM 	params... : string
REM 		the value of the environment variable to set

SET TARGET=
SET NAME=
SET VALUE=
for %%a in (%*) do (
	if "!TARGET!"=="" (
		SET TARGET=%%a
	) else (
		if "!NAME!"=="" (
			SET NAME=%%a
		) else (
			if "!VALUE!"=="" (
				SET VALUE=%%a
			) else (
				SET VALUE=!VALUE! %%a
			)
		)
	)
)
if "!TARGET!"=="" (
	call:display_error The target name cannot be empty
	goto:eof
)
if "!NAME!"=="" (
	call:display_error The name of the environment to set or create cannot be empty
	goto:eof
)
if "!VALUE!"=="" (
	call:display_error The value of the environment to set or create cannot be empty
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
									if not "!TARGET!"=="admin__maqwqwch__ine___1212hghgg" (
										call:display_error The target is invalid, it has to be either User, Process or Machine
										goto:eof
									) else ( SET TARGET=admin__maqwqwch__ine___1212hghgg)
								) else ( SET TARGET=Process)
							) else ( SET TARGET=Process)
						) else ( SET TARGET=Process)
					) else ( SET TARGET=Machine)
				) else ( SET TARGET=Machine)
			) else ( SET TARGET=Machine)
		) else ( SET TARGET=User)
	) else ( SET TARGET=User)
) else ( SET TARGET=User)

if "!TARGET!"=="Process" (
	powershell -Command "& { $env:!NAME! = \"!VALUE!\" }"
)
if "!TARGET!"=="User" (
	powershell -Command "& { [Environment]::SetEnvironmentVariable(\"!NAME!\", \"!VALUE!\", \"!TARGET!\") }"
)
if "!TARGET!"=="Machine" (
	powershell -Command "Start-Process cmd \"/k "!SCRIPT_DIR!\setenv.bat" admin__maqwqwch__ine___1212hghgg !NAME! !VALUE! ^&^& exit \" -Verb RunAs"
)
if "!TARGET!"=="admin__maqwqwch__ine___1212hghgg" (
	powershell -Command "& { [Environment]::SetEnvironmentVariable(\"!NAME!\", \"!VALUE!\", \"Machine\") }"
)
call:display the environement variable !NAME! has been created and updated

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

exit /b 0

:display 
	echo [0;32mCronux.setenv:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.setenv:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 25 August 2019
REM 	:time: 02:24 PM
REM 	:filename: setenv.bat
REM 
REM 
REM		.. _ALink: ./ALink.html