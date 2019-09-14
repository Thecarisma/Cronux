
## Calling Commands

If you want your command to reference another Cronux command copy the entire function label 
`:call_command_script` into the batch script then you can use `call:call_command_script command` 
in your batch script. This allow the script to function independent of Cronux.

Ensure that the function label `:call_command_script` is pasted after the *REM END_OFFSET_FOR_MERGE* 
offset to prevent it from being compiled into the Cronux script again during build.

## Check if Administrator

There is no straight way to check if the command prompt is opened as Administrator therefore 
hacky method can be used to check if it open as Admin. 

A method is to execute a command that requires Admin access and check for the `errorlevel` value after 
execution if `errorlevel` is zero then it open as admin, but the method in Cronux context does not work 
and is breaking structure as the global variable `errorlevel` is heavily used. 

The method used is to read the output of an Admin level command and check if it contains the keyword `denied` 
if it does not contain `denied` the commnd is open as admin. The system command used to check is `fsutil` which 
is used to check if the system drive is dirty (i have no idea what it usefulness is)

The batch function snippet below should be in your script after the OFFSET MERGE line 

```batch
:is_administrator
	SET is_administrator_var=
	for /F "tokens=* USEBACKQ" %%F in (`fsutil dirty query %systemdrive%`) do SET is_administrator_var=%%F
	if "x!is_administrator_var:denied=!"=="x!is_administrator_var!" ( SET IS_ADMIN=true) 
	exit /b 0
```

and the following statement should be declared at the top of your script before START MERGE line 

```batch
SET IS_ADMIN=false
call:is_administrator
```

if a command requires elevation from within your script you can first check if the command prompt is open as 
administrator before you send the commands to `elevate`

```
if !IS_ADMIN!==true (
	REM do whatever as admin 
) else (
	call:call_command_script elevate [your command here]
)
```


## Debuging Script Execution

You can check if command is succesfully by either checking the **errorlevel** at the end 
of the script execution. if the command call into a system or external program the error 
will will be printed into the screen but to prevent having a dirty output the output and 
error output can be redirected to `nul` and you can check the errorlevel to confirm if the 
program execution is succesful. The errorlevel is 0 for success and other number for 
not succesful execution. e.g 

```bash
timeout !SECONDS_TO_SLEEP_FOR! 2> nul 
if not "%errorlevel%"=="0" (
	call:display_error failed to sleep, check your parameter only number between -1 to 99999 accepted
)
```

in the snippet above both the output and error is redirected to nul but the errorlevel code is 
checked to confirm if the program execute succesfully. 

## Error Level

Cronux uses 677 as the errorlevel. So always set the errorlevel to 677 to indicate 
an error occur from within your code before exiting. 

Always ensure you set the errorlevel to 0 at the second line of your file before any other 
operation at all. Note that `goto:eof` is exclusive for ending the script after an error 
occur, if you want to stop the script for other reason apart from fault or error use 
`exit /b 0`

## Expected Test To Be Passed

 1.  The File must Exist 
 2.  Ensure the filename, extension conform with Cronux 
 3.  The Script must be Readable
 4.  Ensure a script has the expected variable defined
 5.  The `errorlevel` variable must be properly treated
 6.  Check if the two comment needed to compile is defined
 7.  `@echo off` statement must be at the top of the file
 8.  function label `:call_command_script` must be after compilable segment
 9.  check to ensure function label `:call_command_script` is defined if used 
 9.  if function label `:call_command_script` is defined check `display_warning` label  
 10. check :display function is defined if used
 11. check :display_error function is defined if used
 12. check :display_warning function is defined if used
 13. Check for IS_ADMIN variable and check permission call
 13. Confirm the check administrator function is defined
 
Looking forward to your contribution.
 
