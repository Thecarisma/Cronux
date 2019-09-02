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
REM permanently remove a program, file or script. The file is 
REM searched for in the order below. the first found is deleted 
REM 
REM 	* the supplied full path
REM 	* the supplied full path with .bat added to the file name
REM 	* cronux test directoty
REM 	* cronux test directoty with .bat added to the file name
REM 	* cronux test\installation directoty
REM 	* cronux test\installation directoty with .bat added to the file name
REM 	* cronux installation directoty
REM 	* cronux installation directoty with .bat added to the file name
REM 
REM ::
REM 	Usage: remove [paths/to/files...]
REM 
REM Note that the file cannot be backed up into the Cronux backup 
REM directory before deletion. In case of a mistake it can be recovered 
REM from the backup directoty  
REM 
REM **Parameters**:	
REM 	param... : string
REM 		the variadic paths to the files or name of script to uninstall

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

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.:[0m %* 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 25 August 2019
REM 	:time: 02:24 PM
REM 	:filename: name.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
