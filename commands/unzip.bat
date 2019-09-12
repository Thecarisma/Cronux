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
REM Extract a zip archive into a folder. if comflicting extracted files and folder 
REM and folder exist it is overidden.
REM 
REM ::
REM 	Usage: unzip [zipname.zip] [/folder/to/extract/to/]
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the name of the zip file to extract, it must end with **.zip**
REM 	params... : string
REM 		the relative or absolute folder to extract the zip into 

SET ZIP_FILE_NAME=
SET EXTRACT_FOLDER=

for %%a in (%*) do (
	if "!ZIP_FILE_NAME!"=="" (
		SET ZIP_FILE_NAME=%%a
	) else (
		if "%%a"=="C:\" (
			call:display_error the argument '%%a' is invalid
			SET errorlevel=677
			goto:eof
		)
		if "!EXTRACT_FOLDER!"=="" (
			SET EXTRACT_FOLDER=%%a
		) else (
			call:display_warning extra unused argument '%%a'
		)
	)
)

if not exist "!ZIP_FILE_NAME!" (
	call:display_error the zip archive '!ZIP_FILE_NAME!' does not exist 
	SET errorlevel=677
	goto:eof
)

if not exist "!EXTRACT_FOLDER!" (
	call:display_warning the directory '!EXTRACT_FOLDER!' does not exist and is been created
	mkdir "!EXTRACT_FOLDER!"
)

call:display preparing to extract archive !ZIP_FILE_NAME! into !EXTRACT_FOLDER! ...
powershell -Command "& { Expand-Archive -Path \"!ZIP_FILE_NAME!\" -DestinationPath \"!EXTRACT_FOLDER!\" -Force }"
call:display the zip archive !ZIP_FILE_NAME! has been extracted successfully

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.:[0m %* 
	exit /b 0

:display_warning 
	echo [0;33mCronux.zip:[0m %* 
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
