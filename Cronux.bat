echo off
REM bad thing `setlocal enabledelayedexpansion` can make your current session bloated
REM but good because it sure better than using %?%
setlocal enabledelayedexpansion

SET OPERATION=
SET OP_ARGS=
SET WORKING_DIR="%cd%"
SET AD="Heal the world, make it a better place"


for %%x in (%*) do (

	if "%%x"=="clear" (
		call:clear
	)
	if "%%x"=="cls" (
		call:clear
	)
	if "%%x"=="no-ad" (
		SET AD=
	)
	
	if not defined OPERATION (
		echo !AD!
	) else (
		if not defined OP_ARGS (
			SET OP_ARGS="%%x"
		) else (
			SET OP_ARGS=!OP_ARGS!++"%%x"
		)
	)
	
	if "%%x"=="ls" (
		SET OPERATION="listdir"
	)
	if "%%x"=="dir" (
		SET OPERATION="listdir"
	)
)

if !OPERATION!=="listdir" (
	call:listdir !OP_ARGS!
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
		echo !AD!
	) else (
		cd !WORKING_DIR!
	)
	exit /b 0

:clear
	cls
	
	exit /b 0