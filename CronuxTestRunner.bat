@echo off
setlocal enabledelayedexpansion

REM if test is successfull it exit with 0 
REm if test failes it exit with code 678

SET SCRIPT_DIR=%~dp0
SET WORKING_DIR=%cd%
SET TOTAL_FILE_TEST=0
SET PASSED_TEST_FILE_COUNT=0
SET FAILED_TEST_FILE_COUNT=0
SET TOTAL_TEST=0
SET PASSED_TEST_COUNT=0
SET FAILED_TEST_COUNT=0
SET SUB_TOTAL_TEST=0
SET SUB_PASSED_TEST_COUNT=0
SET SUB_FAILED_TEST_COUNT=0
SET FILES_TO_RUN_TEST_ON=%*
SET SET ERROR_MESSAGE=
SET UNIT_TEST_FAILED=false
SET BACKSPACE=
SET CURRENT_SCRIPT_SOURCE=
SET VERBOSE=true
SET ERROR_CODE=677
SET LF=^


SET COMMANDS_FOLDER=commands\
SET USER_FOLDER=%HOMEDRIVE%%HOMEPATH%
SET TEST_FOLDER=!SCRIPT_DIR!\test\
SET INSTALLATION_FOLDER=C:\Program Files\Cronux\
SET ROAMING_FOLDER=!USER_FOLDER!\AppData\Roaming\Cronux\
SET BACKUP_FOLDER=!ROAMING_FOLDER!backup\
SET ROAMING_TEMP_FILE=!ROAMING_FOLDER!\CronuxTestRunner.CurrentBatchSource.bat.txt

SET ALREADY_TESTED_SCRIPT=tests
SET BLACKLISTED_NAMES=cls CronuxTestRunner Cronux tests
SET DEAFULT_VARIABLES=OP_ARGS SCRIPT_DIR WORKING_DIR USER_FOLDER INSTALLATION_FOLDER ROAMING_FOLDER BACKUP_FOLDER

for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do SET BACKSPACE=%%A

REM if no filename is specified run test on all the scripts 
REM in the commands folder and it subfolder

if "!FILES_TO_RUN_TEST_ON!"=="" (
	call:printline
	call:display_warning no test file specified, running test on the scripts in !COMMANDS_FOLDER! and it subfolders
	if not exist "!COMMANDS_FOLDER!" (
		call:display_error the command folder cannot be found
		SET errorlevel=677
		call:printline
		exit /b 0
	)
	cd !COMMANDS_FOLDER!
	for %%f in (*) do ( 
		FOR %%i IN ("%%f") DO (
			SET filedrive=%%~di
			SET filepath=%%~pi
			SET filename=%%~ni
			SET fileextension=%%~xi
		) 
		SET SINGLE_COMMAND_SCRIPT=!filedrive!!filepath!!filename!!fileextension!
		if "!FILES_TO_RUN_TEST_ON!"=="" (
			SET FILES_TO_RUN_TEST_ON=!SINGLE_COMMAND_SCRIPT!
		) else (
			SET FILES_TO_RUN_TEST_ON=!FILES_TO_RUN_TEST_ON! !SINGLE_COMMAND_SCRIPT!
		)
	)
	cd !WORKING_DIR!
	call:printline
)

for %%a in (!FILES_TO_RUN_TEST_ON!) do (
	SET /a SUB_TOTAL_TEST=!SUB_TOTAL_TEST!-!SUB_TOTAL_TEST!
	SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!-!SUB_FAILED_TEST_COUNT!
	SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!-!SUB_PASSED_TEST_COUNT!
	SET /a TOTAL_FILE_TEST=!TOTAL_FILE_TEST!+1
	call:printline
	call:performtest %%a
	SET /a TOTAL_TEST=!TOTAL_TEST!+!SUB_TOTAL_TEST!
	SET /a FAILED_TEST_COUNT=!FAILED_TEST_COUNT!+!SUB_FAILED_TEST_COUNT!
	SET /a PASSED_TEST_COUNT=!PASSED_TEST_COUNT!+!SUB_PASSED_TEST_COUNT!
	if not !SUB_FAILED_TEST_COUNT!==0 (
		SET /a FAILED_TEST_FILE_COUNT=!FAILED_TEST_FILE_COUNT!+1
	) else (
		SET /a PASSED_TEST_FILE_COUNT=!PASSED_TEST_FILE_COUNT!+1
	)
)

if !FAILED_TEST_COUNT!==0 (
	SET EXIT_CODE=0
) else (
	SET EXIT_CODE=678	
)

call:printline
echo CronuxTestRunner: [0;33mTests Total:[0m: !TOTAL_TEST!, [0;32mTests Passed:[0m !PASSED_TEST_COUNT!, [0;31mTests Failed:[0m !FAILED_TEST_COUNT!

if !PASSED_TEST_FILE_COUNT!==0 (
	if not !TOTAL_FILE_TEST!==!FAILED_TEST_FILE_COUNT! (
		SET /a PASSED_TEST_FILE_COUNT=!TOTAL_FILE_TEST!-!FAILED_TEST_FILE_COUNT!
	)
)
if !FAILED_TEST_FILE_COUNT!==0 (
	if not !TOTAL_FILE_TEST!==!PASSED_TEST_FILE_COUNT! (
		SET /a FAILED_TEST_FILE_COUNT=!TOTAL_FILE_TEST!-!PASSED_TEST_FILE_COUNT!
	)
)

echo CronuxTestRunner: [0;33mTest Scripts Total:[0m: !TOTAL_FILE_TEST!, [0;32mTest Scripts Passed:[0m !PASSED_TEST_FILE_COUNT!, [0;31mTest Scripts Failed:[0m !FAILED_TEST_FILE_COUNT!
call:printline

if !FAILED_TEST_COUNT!==0 ( 
	SET errorlevel=0
) else ( 
	SET errorlevel=677
)

exit /b !EXIT_CODE!

:performtest
	call:display_warning preparing to run test on %1 
	FOR %%i IN ("%1") DO (
		SET filedrive=%%~di
		SET filepath=%%~pi
		SET filename=%%~ni
		SET fileextension=%%~xi
	)
	SET FULL_SCRIPT_NAME=!filedrive!!filepath!!filename!!fileextension!
	
	call:check_file_existence !FULL_SCRIPT_NAME! !filename! !fileextension!
	call:check_file_name !FULL_SCRIPT_NAME! !filename! !fileextension!
	call:read_the_current_batch_file !FULL_SCRIPT_NAME! !filename! !fileextension!
	call:check_default_variables
	call:checkerrorlevel
	call:check_merge_comments
	REM if !UNIT_TEST_FAILED!==true ( goto:test_fails )
	
	SET /a SUB_TOTAL_TEST=!SUB_FAILED_TEST_COUNT!+!SUB_PASSED_TEST_COUNT!
	echo     !filename!!fileextension!: [0;33mTotal:[0m: !SUB_TOTAL_TEST!, [0;32mPassed:[0m !SUB_PASSED_TEST_COUNT!, [0;31mFailed:[0m !SUB_FAILED_TEST_COUNT!

	goto:nextloop
	:test_fails
		SET /a SUB_TOTAL_TEST=!SUB_FAILED_TEST_COUNT!+!SUB_PASSED_TEST_COUNT!
		echo     !filename!!fileextension!: [0;33mTotal:[0m: !SUB_TOTAL_TEST!, [0;32mPassed:[0m !SUB_PASSED_TEST_COUNT!, [0;31mFailed:[0m !SUB_FAILED_TEST_COUNT!
		SET UNIT_TEST_FAILED=false
		goto:nextloop
		
	:nextloop			
		if "!ALREADY_TESTED_SCRIPT!"=="" (
			SET ALREADY_TESTED_SCRIPT=!filename!
		) else (
			SET ALREADY_TESTED_SCRIPT=!ALREADY_TESTED_SCRIPT! !filename!
		)
		REM DO NOTHING
	exit /b 0
	
REM Check if the file exist
:check_file_existence
	SET UNIT_TEST_FAILED=false
	call:a_display %BACKSPACE%    checking if the file exist         - 
	if not exist "%1" (
		SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
		SET ERROR_MESSAGE=cannot find the file '%1'
		SET UNIT_TEST_FAILED=true
		call:printerror_value !ERROR_MESSAGE!
		exit /b 0
	)
	echo [0;32m [passed][0m
	SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1

	exit /b 0
	
REM Check the filename attribute for conflict and error
:check_file_name
	SET UNIT_TEST_FAILED=false
	call:a_display %BACKSPACE%    checking the filename in blacklist - 
	for %%b in (!BLACKLISTED_NAMES!) do (
		if "%2"=="%%b" (
			SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
			SET ERROR_MESSAGE=the filename '%2' is a reserved name or blacklisted
			SET UNIT_TEST_FAILED=true
			call:printerror_value !ERROR_MESSAGE!
			goto:check_file_name__blacklist
		)
	)
	echo [0;32m [passed][0m
	SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	
	:check_file_name__blacklist
	call:a_display %BACKSPACE%    checking the filename for conflict - 
	for %%b in (!ALREADY_TESTED_SCRIPT!) do (
		if "%2"=="%%b" (
			SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
			SET ERROR_MESSAGE=duplicate filename detected. '%2' has already been created
			SET UNIT_TEST_FAILED=true
			call:printerror_value !ERROR_MESSAGE!
			goto:check_file_name__extension
		)
	)
	echo [0;32m [passed][0m
	SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	
	:check_file_name__extension
	call:a_display %BACKSPACE%    checking the filename extension    - 
	if not "%3"==".bat" (
		SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
		SET ERROR_MESSAGE=invalid filename extension '%3', .bat expected
		SET UNIT_TEST_FAILED=true
		call:printerror_value !ERROR_MESSAGE!
		goto:check_file_name__end
	)
	echo [0;32m [passed][0m
	SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	
	:check_file_name__end
	exit /b 0
	
REM Get the file content into a variable
:read_the_current_batch_file
	SET UNIT_TEST_FAILED=false
	SET CURRENT_SCRIPT_SOURCE=

	call:a_display %BACKSPACE%    reading the script source          -
	if not exist "%1" (
		SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
		SET ERROR_MESSAGE=cannot read the source code of %1
		SET UNIT_TEST_FAILED=true
		call:printerror_value !ERROR_MESSAGE!
		goto:read_the_current_batch_file__end
	)
	for /f "delims=" %%x in (%1) do (
		SET CURRENT_SCRIPT_SOURCE=!CURRENT_SCRIPT_SOURCE!%%x!LF!
	)
	if "!CURRENT_SCRIPT_SOURCE!"=="" (
		SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
		SET ERROR_MESSAGE=cannot read the source code of %1
		SET UNIT_TEST_FAILED=true
		call:printerror_value !ERROR_MESSAGE!
		goto:read_the_current_batch_file__end
	)
	
	echo [0;32m [passed][0m
	SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	
	:read_the_current_batch_file__end
	exit /b 0	
	
REM Check the expected default variables
:check_default_variables
	SET UNIT_TEST_FAILED=false
	SET FOUND_VARIABLE_COUNTS=0

	call:a_display %BACKSPACE%    checking constants variables       - 
	echo !CURRENT_SCRIPT_SOURCE! > !ROAMING_TEMP_FILE!
	for /f "delims=" %%x in (!ROAMING_TEMP_FILE!) do (
		SET A_ARG=%%x
		for %%b in (!DEAFULT_VARIABLES!) do (
			if not "x!A_ARG:%%b=!"=="x!A_ARG!" (
				SET /a FOUND_VARIABLE_COUNTS=!FOUND_VARIABLE_COUNTS!+1
			)
		)
	)
	if !FOUND_VARIABLE_COUNTS! lss 7 (
		SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
		SET ERROR_MESSAGE=one or more constant is not defined
		SET UNIT_TEST_FAILED=true
		call:printerror_value !ERROR_MESSAGE!
		goto:check_default_variables__end
	)
	
	echo [0;32m [passed][0m
	SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	
	:check_default_variables__end
	exit /b 0

REM check errorlevel is set before got:eof
REM ensure it goto:eof after error occur (figure that out)
:checkerrorlevel
	SET UNIT_TEST_FAILED=false
	SET FIRST_SCRIPT_LINE=
	SET PREVIOUS_LINE=
	SET LINE_NUMBER=1
		
	call:a_display %BACKSPACE%    confirm error level has been reset - 
	echo !CURRENT_SCRIPT_SOURCE! > !ROAMING_TEMP_FILE!
	for /f "delims=" %%x in (!ROAMING_TEMP_FILE!) do (
		SET FIRST_SCRIPT_LINE=%%x
		if "x!FIRST_SCRIPT_LINE:errorlevel=!"=="x!FIRST_SCRIPT_LINE!" (
			SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
			SET ERROR_MESSAGE=the errorlevel has must set to 0 at the beginning of the file
			SET UNIT_TEST_FAILED=true
			call:printerror_value !ERROR_MESSAGE!
			goto:checkerrorlevel_exit
		)
		if not "!FIRST_SCRIPT_LINE!"=="" (
			goto:continue_reset_errorlevel
		)
	)
	
	:continue_reset_errorlevel
	echo [0;32m [passed][0m
	SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1

	:checkerrorlevel_exit
	call:a_display %BACKSPACE%    confirm proper 'errorlevel' exit   - 
	for /f "delims=" %%x in (!ROAMING_TEMP_FILE!) do (
		SET A_ARG=%%x
		SET /a LINE_NUMBER=!LINE_NUMBER!+1
		if not "x!A_ARG:eof=!"=="x!A_ARG!" (
			if "x!PREVIOUS_LINE:%ERROR_CODE%=!"=="x!PREVIOUS_LINE!" (
				SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
				SET ERROR_MESSAGE=the errorlevel is not set before 'goto:eof' around Line !LINE_NUMBER!
				SET UNIT_TEST_FAILED=true
				call:printerror_value !ERROR_MESSAGE!
				goto:checkerrorlevel__end
			)
		)
		SET PREVIOUS_LINE=!A_ARG!
	)
	
	echo [0;32m [passed][0m
	SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1

	:checkerrorlevel__end
	exit /b 0
	
REM Check the merge variables for compilation
:check_merge_comments
	SET UNIT_TEST_FAILED=false
	SET FOUND_START_OFFSET_FOR_MERGE=false
	SET FOUND_END_OFFSET_FOR_MERGE=false
	
	call:a_display %BACKSPACE%    check compilation\build offsets    - 
	for /f "delims=" %%x in (!ROAMING_TEMP_FILE!) do (
		SET A_ARG=%%x
		if not "x!A_ARG:START_OFFSET_FOR_MERGE=!"=="x!A_ARG!" (
			SET FOUND_START_OFFSET_FOR_MERGE=true
		)
		if not "x!A_ARG:END_OFFSET_FOR_MERGE=!"=="x!A_ARG!" (
			SET FOUND_END_OFFSET_FOR_MERGE=true
		)
	)
	
	if !FOUND_START_OFFSET_FOR_MERGE!==false (
		goto:check_merge_comments__not_found
	)	
	if !FOUND_END_OFFSET_FOR_MERGE!==false (
		goto:check_merge_comments__not_found
	)
	
	goto:check_merge_comments__passed
	:check_merge_comments__not_found
		SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
		SET ERROR_MESSAGE=the script is not marked for compilation and build
		SET UNIT_TEST_FAILED=true
		call:printerror_value !ERROR_MESSAGE!
		goto:checkerrorlevel__end
	
	:check_merge_comments__passed
		echo [0;32m [passed][0m
		SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1

	:check_merge_comments__end
	exit /b 0

	
	
REM print error
:printerror_value
	if !VERBOSE!==true (
		echo [0;31m [failed][0m - %*
	) else (
		echo [0;31m [failed][0m 
	)

	exit /b 0
	
REM print a lone line
:printline
	echo ----------------------------------------------------------------------------------------------------

	exit /b 0
	
:a_display
	echo|set /p="%*"

	exit /b 0
	
REM Display message and title in the console
:display_default 
	echo CronuxTestRunner: %* 

	exit /b 0
	
REM Display message and title in the console
:display 
	echo [0;32mCronuxTestRunner:[0m %* 

	exit /b 0
	
REM Display error message and title in the console
:display_error
	echo [0;31mCronuxTestRunner:[0m %* 

	exit /b 0
	
REM Display warning message and title in the console
:display_warning 
	echo [0;33mCronuxTestRunner:[0m %* 
	
	exit /b 0
	
