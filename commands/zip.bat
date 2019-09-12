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
REM Create a zip archive using the .NET Compression library
REM Add the content of a folder or a single file to the archive. 
REM if the zipfile does not exists it is created first if it 
REM already exist the file or folder will be added to the existing 
REM archive
REM 
REM ::
REM 	Usage: zip [zipname.zip] [folder/files...]
REM 
REM Note that all the file are added in the root folder of the 
REM zip file
REM 
REM 
REM **Parameters**:	
REM 	param1 : string
REM 		the name of the zip file to create, it must end with **.zip**
REM 	params... : string
REM 		all the remaining parameter must be existing file and folders

SET ZIP_FILE_NAME=
SET ZIP_EXIST=false
SET POWERSHELL_COMMAND=

for %%a in (%*) do (
	if "!ZIP_FILE_NAME!"=="" (
		SET ZIP_FILE_NAME=%%a
		if exist "!ZIP_FILE_NAME!" (
			SET ZIP_EXIST=true
			call:display_warning the archive '!ZIP_FILE_NAME!' already exist, content will be appended to it
		)
	) else (
		if "%%a"=="C:\" (
			call:display_error the argument '%%a' is invalid
			SET errorlevel=677
			goto:eof
		)
		if not exist "%%a" (
			call:display_error the file or folder to archive '%%a' does not exist
			SET errorlevel=677
			goto:eof
		)
		FOR %%i IN (%%a) DO ( 
			call:display formating '%%a' to 8.3 filename
			if "!ZIP_EXIST!"=="false" (
				if exist %%~si\NUL ( 
					if "!POWERSHELL_COMMAND!"=="" (
						SET POWERSHELL_COMMAND=Add-Type -Assembly System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::CreateFromDirectory^('%%~si','!ZIP_FILE_NAME!', [System.IO.Compression.CompressionLevel]::Optimal, $false^);
					) else (
						SET POWERSHELL_COMMAND=!POWERSHELL_COMMAND!Add-Type -Assembly System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::CreateFromDirectory^('%%~si','!ZIP_FILE_NAME!', [System.IO.Compression.CompressionLevel]::Optimal, $false^);
					)
				) else (
					if "!POWERSHELL_COMMAND!"=="" (
						SET POWERSHELL_COMMAND=Compress-Archive -Path %%~si -DestinationPath !ZIP_FILE_NAME!;
					) else (
						SET POWERSHELL_COMMAND=!POWERSHELL_COMMAND!Compress-Archive -Path %%~si -DestinationPath !ZIP_FILE_NAME!;
					)
				)	
				SET ZIP_EXIST=true
				
			) else (
				if exist %%~si\NUL ( 
					if "!POWERSHELL_COMMAND!"=="" (
						SET POWERSHELL_COMMAND=Compress-Archive -Path %%~si\* -Update -DestinationPath !ZIP_FILE_NAME!;
					) else (
						SET POWERSHELL_COMMAND=!POWERSHELL_COMMAND!Compress-Archive -Path %%~si\* -Update -DestinationPath !ZIP_FILE_NAME!;
					)
				) else (
					if "!POWERSHELL_COMMAND!"=="" (
						SET POWERSHELL_COMMAND=Compress-Archive -Path %%~si -Update -DestinationPath !ZIP_FILE_NAME!;
					) else (
						SET POWERSHELL_COMMAND=!POWERSHELL_COMMAND!Compress-Archive -Path %%~si -Update -DestinationPath !ZIP_FILE_NAME!;
					)
				)	 
			)
		)
	)
)

if "!ZIP_FILE_NAME!"=="" (
	call:display_error the name of the archive must be specified and must ends in .zip
	SET errorlevel=677
	goto:eof
)

if "!POWERSHELL_COMMAND!"=="" (
	call:display_error no file or folder is specified to add into archive
	SET errorlevel=677
	goto:eof
)

call:display preparing to create archive !ZIP_FILE_NAME! ...
powershell -Command "& { !POWERSHELL_COMMAND! }"
call:display the zip archive !ZIP_FILE_NAME! has been created

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display 
	echo [0;32mCronux.zip:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.zip:[0m %* 
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
