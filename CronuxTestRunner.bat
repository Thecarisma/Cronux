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
SET DEAFULT_VARIABLES=OP_ARGS SCRIPT_DIR WORKING_DIR USER_FOLDER INSTALLATION_FOLDER ROAMING_FOLDER BACKUP_FOLDER IS_ADMIN

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
	call:checkechooff
	call:check_attributes
	call:check_call_command_script
	call:check_display_functions
	call:confirm_is_administrator_attributes
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
	for /f "delims=" %%x in (!ROAMING_TEMP_FILE!) do (
		if not "!PREVIOUS_LINE!"=="" (
			SET FIRST_SCRIPT_LINE=%%x
		) else (
			SET PREVIOUS_LINE=%%x
		)
		if not "!FIRST_SCRIPT_LINE!"=="" (
			if "x!FIRST_SCRIPT_LINE:errorlevel=!"=="x!FIRST_SCRIPT_LINE!" (
				SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
				SET ERROR_MESSAGE=the errorlevel has must set to 0 at the beginning of the file
				SET UNIT_TEST_FAILED=true
				call:printerror_value !ERROR_MESSAGE!
				goto:checkerrorlevel_exit
			)
		)
		if not "!FIRST_SCRIPT_LINE!"=="" (
			if not "!PREVIOUS_LINE!"=="" (
				goto:continue_reset_errorlevel
			)
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

REM '@echo off' statement at begining of a script
:checkechooff
	SET UNIT_TEST_FAILED=false
	SET FIRST_SCRIPT_LINE=
	SET LINE_NUMBER=1
		
	call:a_display %BACKSPACE%    checking the '@echo off' statement - 
	for /f "delims=" %%x in (!ROAMING_TEMP_FILE!) do (
		SET FIRST_SCRIPT_LINE=%%x
		if "x!FIRST_SCRIPT_LINE:@echo=!"=="x!FIRST_SCRIPT_LINE!" (
			goto:checkechooff_error_occur
		)
		if "x!FIRST_SCRIPT_LINE:off=!"=="x!FIRST_SCRIPT_LINE!" (
			goto:checkechooff_error_occur
		)
		if not "!FIRST_SCRIPT_LINE!"=="" (
			goto:checkechooff_passed
		)
	)
	
	goto:checkechooff_passed
	:checkechooff_error_occur
		SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
		SET ERROR_MESSAGE=the statement '@echo off' is expected on the first line
		SET UNIT_TEST_FAILED=true
		call:printerror_value !ERROR_MESSAGE!
		goto:checkerrorlevel_exit
	
	:checkechooff_passed
	echo [0;32m [passed][0m
	SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	
	:checkechooff_end
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

REM '@echo off' statement at begining of a script
:check_attributes
	SET UNIT_TEST_FAILED=false
	SET FOUND_ATTRIBUTES=
	SET CURRENT_ATTR=
	
	call:a_display %BACKSPACE%    create the script attributes       - 
	for /f "delims=" %%x in (!ROAMING_TEMP_FILE!) do (
		SET LINE_VALUE=%%x
		if not "x!LINE_VALUE:REM=!"=="x!LINE_VALUE!" (
			if not "x!LINE_VALUE:author=!"=="x!LINE_VALUE!" (
				SET FOUND_ATTRIBUTES=!FOUND_ATTRIBUTES! author
			)
			if not "x!LINE_VALUE:copyright=!"=="x!LINE_VALUE!" (
				SET FOUND_ATTRIBUTES=!FOUND_ATTRIBUTES! copyright
			)
			if not "x!LINE_VALUE:date=!"=="x!LINE_VALUE!" (
				SET FOUND_ATTRIBUTES=!FOUND_ATTRIBUTES! date
			)
			if not "x!LINE_VALUE:time=!"=="x!LINE_VALUE!" (
				SET FOUND_ATTRIBUTES=!FOUND_ATTRIBUTES! time
			)
			if not "x!LINE_VALUE:filename=!"=="x!LINE_VALUE!" (
				SET FOUND_ATTRIBUTES=!FOUND_ATTRIBUTES! filename
			)
		)
	)
	
	if "x!FOUND_ATTRIBUTES:author=!"=="x!FOUND_ATTRIBUTES!" (
		SET CURRENT_ATTR=author
		goto:check_attributes_error_occur 
	)
	if "x!FOUND_ATTRIBUTES:copyright=!"=="x!FOUND_ATTRIBUTES!" (
		SET CURRENT_ATTR=copyright
		goto:check_attributes_error_occur 
	)
	if "x!FOUND_ATTRIBUTES:date=!"=="x!FOUND_ATTRIBUTES!" (
		SET CURRENT_ATTR=date
		goto:check_attributes_error_occur 
	)
	if "x!FOUND_ATTRIBUTES:time=!"=="x!FOUND_ATTRIBUTES!" (
		SET CURRENT_ATTR=time
		goto:check_attributes_error_occur 
	)
	if "x!FOUND_ATTRIBUTES:filename=!"=="x!FOUND_ATTRIBUTES!" (
		SET CURRENT_ATTR=filename
		goto:check_attributes_error_occur 
	)
	
	goto:check_attributes_passed
	:check_attributes_error_occur
		SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
		SET ERROR_MESSAGE=you need to define the attribute '!CURRENT_ATTR!' in the footer
		SET UNIT_TEST_FAILED=true
		call:printerror_value !ERROR_MESSAGE!
		goto:check_attributes__end
	
	:check_attributes_passed
	echo [0;32m [passed][0m
	SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1

	:check_attributes__end
	exit /b 0
	
REM Check the function label `:call_command_script` position
:check_call_command_script
	SET UNIT_TEST_FAILED=false
	SET FOUND_END_SEGMENT=false
	SET CALL_COMMAND_USED=false
	SET FOUND_CALL_COMMAND=false

	call:a_display %BACKSPACE%    check :call_command_script positon - 
	for /f "delims=" %%x in (!ROAMING_TEMP_FILE!) do (
		SET A_ARG=%%x
		if not "x!A_ARG:END_OFFSET_FOR_MERGE=!"=="x!A_ARG!" (
			SET FOUND_END_SEGMENT=true
		)
		if not "x!A_ARG:call_command_script=!"=="x!A_ARG!" (
			if "!A_ARG!"==":call_command_script" (
				SET FOUND_CALL_COMMAND=true
				if !FOUND_END_SEGMENT!==false (
					goto:check_call_command_script__error
				)
			) else (
				if not "x!A_ARG:call:=!"=="x!A_ARG!" (
					SET CALL_COMMAND_USED=true
				)
			)
		)
	)
	
	goto:check_call_command_script__passed
	:check_call_command_script__error
		SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
		SET ERROR_MESSAGE=expecting function label `:call_command_script` after compilable segment
		SET UNIT_TEST_FAILED=true
		call:printerror_value !ERROR_MESSAGE!
		goto:check_call_command_script__if_used
	
	:check_call_command_script__passed
		echo [0;32m [passed][0m
		SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
		
	:check_call_command_script__if_used
	call:a_display %BACKSPACE%    check call_command_ is defined iu  - 
	if !CALL_COMMAND_USED!==true (
		if !FOUND_CALL_COMMAND!==false (
			SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
			SET ERROR_MESSAGE=function label `:call_command_script` is used but not defined
			SET UNIT_TEST_FAILED=true
			call:printerror_value !ERROR_MESSAGE!
			goto:check_call_command_script__end
		)
	)
	
	echo [0;32m [passed][0m
	SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	
	:check_call_command_script__end
	exit /b 0
	
REM Check display_* function label if defined 
REM display_error is compulsory if used
REM display is compulsory if used
REM display_warning is compulsory if used
:check_display_functions
	SET UNIT_TEST_FAILED=false
	SET USED_DISPLAY_FUNCTION=false
	SET USED_DISPLAY_ERROR_FUNCTION=false
	SET USED_DISPLAY_WARNING_FUNCTION=false
	SET FOUND_DISPLAY_FUNCTION=false
	SET FOUND_DISPLAY_ERROR_FUNCTION=false
	SET FOUND_DISPLAY_WARNING_FUNCTION=false
	
	for /f "delims=" %%x in (!ROAMING_TEMP_FILE!) do (
		SET A_ARG=%%x
		if not "x!A_ARG:display=!"=="x!A_ARG!" (
			if "!A_ARG!"==":display" (
				SET FOUND_DISPLAY_FUNCTION=true
			)
			if not "x!A_ARG:call:=!"=="x!A_ARG!" (
				SET USED_DISPLAY_FUNCTION=true
			)
		)
		if not "x!A_ARG:display_error=!"=="x!A_ARG!" (
			if "!A_ARG!"==":display_error" (
				SET FOUND_DISPLAY_ERROR_FUNCTION=true
			)
			if not "x!A_ARG:call:=!"=="x!A_ARG!" (
				SET USED_DISPLAY_ERROR_FUNCTION=true
			)
		)
		if not "x!A_ARG:display_warning=!"=="x!A_ARG!" (
			if "!A_ARG!"==":display_warning" (
				SET FOUND_DISPLAY_WARNING_FUNCTION=true
			)
			if not "x!A_ARG:call:=!"=="x!A_ARG!" (
				SET USED_DISPLAY_WARNING_FUNCTION=true
			)
		)
	)
	
	call:a_display %BACKSPACE%    check :display function            - 
	if !USED_DISPLAY_FUNCTION!==true (
		if !FOUND_DISPLAY_FUNCTION!==true (
			echo [0;32m [passed][0m
			SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
		) else (
			SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
			SET ERROR_MESSAGE=the 'display' function is used but not defined
			SET UNIT_TEST_FAILED=true
			call:printerror_value !ERROR_MESSAGE!
		)
	) else (
		echo [0;32m [passed][0m
		SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	)
	
	call:a_display %BACKSPACE%    check :display_error function      - 
	if !USED_DISPLAY_ERROR_FUNCTION!==true (
		if !FOUND_DISPLAY_ERROR_FUNCTION!==true (
			echo [0;32m [passed][0m
			SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
		) else (
			SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
			SET ERROR_MESSAGE=the 'display_error' function is used but not defined
			SET UNIT_TEST_FAILED=true
			call:printerror_value !ERROR_MESSAGE!
		)
	) else (
		echo [0;32m [passed][0m
		SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	)
	
	call:a_display %BACKSPACE%    check :display_warning function    - 
	if !USED_DISPLAY_WARNING_FUNCTION!==true (
		if !FOUND_DISPLAY_WARNING_FUNCTION!==true (
			echo [0;32m [passed][0m
			SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
		) else (
			SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
			SET ERROR_MESSAGE=the 'display_warning' function is used but not defined
			SET UNIT_TEST_FAILED=true
			call:printerror_value !ERROR_MESSAGE!
		)
	) else (
		echo [0;32m [passed][0m
		SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	)

	:check_merge_comments__end
	exit /b 0
	
REM confirm the is_administrator variable and function is defined and called
:confirm_is_administrator_attributes
	SET UNIT_TEST_FAILED=false
	SET IS_IS_ADMIN_DEFINED=false
	SET IS_IS_ADMINISTRATOR_CALLED=false
	SET IS_IS_ADMINISTRATOR_DEFINED=false
	
	for /f "delims=" %%x in (!ROAMING_TEMP_FILE!) do (
		SET A_ARG=%%x
		if not "x!A_ARG:is_administrator=!"=="x!A_ARG!" (
			if "!A_ARG!"==":is_administrator" (
				SET IS_IS_ADMINISTRATOR_DEFINED=true
			)
			if not "x!A_ARG:call:=!"=="x!A_ARG!" (
				SET IS_IS_ADMINISTRATOR_CALLED=true
			)
		)
		if not "x!A_ARG:IS_ADMIN=!"=="x!A_ARG!" (
			if not "x!A_ARG:SET=!"=="x!A_ARG!" (				
				if not "x!A_ARG:false=!"=="x!A_ARG!" (
					SET IS_IS_ADMIN_DEFINED=true
				)
			)
		)
	)
	
	call:a_display %BACKSPACE%    is IS_ADMIN variable declared      - 
	if !IS_IS_ADMIN_DEFINED!==true (
		echo [0;32m [passed][0m
		SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	) else (
		SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
		SET ERROR_MESSAGE=the variable 'IS_ADMIN' is not defined
		SET UNIT_TEST_FAILED=true
		call:printerror_value !ERROR_MESSAGE!
	)
	
	call:a_display %BACKSPACE%    is :is_administrator defined       - 
	if !IS_IS_ADMINISTRATOR_DEFINED!==true (
		echo [0;32m [passed][0m
		SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	) else (
		SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
		SET ERROR_MESSAGE=the 'is_administrator' function is not defined
		SET UNIT_TEST_FAILED=true
		call:printerror_value !ERROR_MESSAGE!
	)
	
	call:a_display %BACKSPACE%    is :is_administrator called        - 
	if !IS_IS_ADMINISTRATOR_CALLED!==true (
		echo [0;32m [passed][0m
		SET /a SUB_PASSED_TEST_COUNT=!SUB_PASSED_TEST_COUNT!+1
	) else (
		SET /a SUB_FAILED_TEST_COUNT=!SUB_FAILED_TEST_COUNT!+1
		SET ERROR_MESSAGE=the 'is_administrator' function is not called
		SET UNIT_TEST_FAILED=true
		call:printerror_value !ERROR_MESSAGE!
	)
	
	:confirm_is_administrator_attributes_end
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
	