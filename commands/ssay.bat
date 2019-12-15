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
REM Convert a text to speech and output it through the available 
REM sound output device. 
REM The speech synthesizer can be customize by changing it speed 
REM and the voice that is used. 
REM
REM If the voice is not of either David or Zira, Zira voice is used 
REM and if the speed is over 10 or less than -10 it is converted to 0.
REM 
REM ::
REM 	Usage: ssay [all the text to say...]
REM 
REM 
REM **Parameters**:	
REM 	param1 : int
REM 		the speed at which the text is spoken between -10 to 10 
REM 	param2 : string
REM 		the name of the voice to speak the text. Zira or David
REM 	param1... : string
REM 		The entire parameters is converted to speech and spoken 

SET VOICE=
SET SPEED=
SET TEXT=
for %%a in (%*) do (
	if "!VOICE!"=="" (
		SET VOICE=%%a
	) else (
		if "!SPEED!"=="" (
			SET SPEED=%%a
		) else (
			if "!TEXT!"=="" (
				SET TEXT=%%a
			) else (
				SET TEXT=!TEXT! %%a
			)
		)
	)
)
if "!VOICE!"=="" (
	SET VOICE=Zira
)
if "!SPEED!"=="" (
	SET SPEED=0
)
if !SPEED! gtr 10 (
	call:display_error Speed '!SPEED!' out of bound. The speed cannot be greater than 10 
	SET errorlevel=677
	goto:eof
)
if !SPEED! lss -10 (
	call:display_error Speed '!SPEED!' out of bound. The speed cannot be lesser than -10 
	SET errorlevel=677
	goto:eof
)
if "!TEXT!"=="" (
	call:display_error The text to speak cannot be empty
	SET errorlevel=677
	goto:eof
)
if not "!VOICE!"=="zira" (
	if not "!VOICE!"=="Zira" (
		if not "!VOICE!"=="ZIRA" (
			if not "!VOICE!"=="david" (
				if not "!VOICE!"=="David" (
					if not "!VOICE!"=="DAVID" (
						SET VOICE=Zira
					) else ( SET VOICE=David)
				) else ( SET VOICE=David)
			) else ( SET VOICE=David)
		) else ( SET VOICE=Zira)
	) else ( SET VOICE=Zira)
) else ( SET VOICE=Zira)

powershell -Command "& { Add-Type -AssemblyName System.speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.Rate  = !SPEED!; $speak.SelectVoice(\"Microsoft !VOICE! Desktop\"); $speak.Speak(\"!TEXT!\"); }"

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.say:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.say:[0m %* 
	exit /b 0
	
:is_administrator
	SET is_administrator_var=
	for /F "tokens=* USEBACKQ" %%F in (`fsutil dirty query %systemdrive%`) do SET is_administrator_var=%%F
	if "x!is_administrator_var:denied=!"=="x!is_administrator_var!" ( SET IS_ADMIN=true) 
	exit /b 0
	
REM S
REM 	:copyright: 2019, Adewale Azeez
REM 	:copyright: The MIT License (c) 2019 Cronux
REM 	:author: Adewale Azeez <azeezadewale98@gmail.com>
REM 	:date: 26 August 2019
REM 	:time: 06:05 AM
REM 	:filename: ssay.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
