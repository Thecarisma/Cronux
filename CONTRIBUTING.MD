
## Filename Extension 


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

 1. The File must Exist 
 2. Ensure the filename, extension conform with Cronux 
 3. The Script must be Readable
 4. Ensure a script has the expected variable defined
 5. The `errorlevel` variable must be properly treated
 6. Check if the two comment needed to compile is defined
 7. `@echo off` statement must be at the top of the file
 
