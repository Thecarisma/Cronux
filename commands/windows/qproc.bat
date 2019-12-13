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
REM Query a runing process properties. qproc = queryprocess
REM 
REM ::
REM 	Usage: qproc [identification] [value] [property]
REM 
REM The [identification]:
REM 
REM 	* all  <to list all running process> 
REM 	* list <to list all running process> 
REM 	* port 
REM 	* id
REM 
REM If a property is specifeid after the port number only the property will be 
REM outputed and the output can be piped to another program or script. e.g to 
REM shutdown a process using a port, the output of this script is sent as input 
REM to the killpid script 
REM 
REM ::
REM 	Usage: [pipe] killpid $(qproc port 8080 Id) 
REM 
REM The expected properties are 
REM 
REM     * BasePriority
REM     * EnableRaisingEvents
REM     * Handle
REM     * HandleCount
REM     * Id
REM     * MachineName
REM     * MainWindowHandle
REM     * MainWindowTitle
REM     * NonpagedSystemMemorySize64
REM     * PagedMemorySize64
REM     * PagedSystemMemorySize64
REM     * PeakPagedMemorySize64
REM     * PeakVirtualMemorySize64
REM     * PeakWorkingSet64
REM     * PrivateMemorySize64
REM     * ProcessName
REM     * Responding
REM     * SessionId
REM     * StartInfo
REM     * StartTime
REM     * Threads
REM     * VirtualMemorySize64
REM     * WorkingSet64
REM 
REM The properties corresponds to the defined properties in the .NET 
REM System.Diagnostics.Process Library
REM 
REM Depending on the type of property requested if the requested property 
REM is an object then the property of the object can also be accessed. 
REM e.g to view the WindowsStyle of the StartInfo
REM 
REM ::
REM 	Usage: qproc port 8080 StartInfo.WindowStyle
REM
REM And if it is a list too the index can be specified e.g to find the 
REM the first Thread from the Threads Property result 
REM 
REM ::
REM 	Usage: qproc port 8080 Threads[0]
REM 
REM 
REM 
REM **Parameters**:	
REM 	param1 : number
REM 		the port number to find it engaged process
REM 	param2 : string
REM 		the property to identify the process with it should be any 
REM			any of the properties
REM 	param3 : string
REM 		the value of the property 
REM 	param4 : string (optional)
REM 		another specific property of the process to print out
REM 
REM TODO: properlly treat error from within powershell

SET WHATTOIDENTIFYPROCESSWITH=%1
SET VALUE=%2
SET PROPERTY=%3
SET FIND_PROC_SHELL_CODE=$res
SET OUTPUT_SHELL_CODE=$res

if "!WHATTOIDENTIFYPROCESSWITH!"=="" (
	call:display_error you have to specify how you want to identify the process 
	call:display_error do `chelp qproc` to view the identity list
	SET errorlevel=677
	goto:eof
)
if not "!WHATTOIDENTIFYPROCESSWITH!"=="all" (
	if not "!WHATTOIDENTIFYPROCESSWITH!"=="list" (
		if "!VALUE!"=="" (
			if "!WHATTOIDENTIFYPROCESSWITH!"=="id" (
				SET WHATTOIDENTIFYPROCESSWITH=all
			) else (
				call:display_error you have to specify the value for the process identify '!WHATTOIDENTIFYPROCESSWITH!'
				SET errorlevel=677
				goto:eof
			)
		)
	)
)

if not "!WHATTOIDENTIFYPROCESSWITH!"=="id" (
	if not "!WHATTOIDENTIFYPROCESSWITH!"=="port" (
		if not "!WHATTOIDENTIFYPROCESSWITH!"=="all" (
			if not "!WHATTOIDENTIFYPROCESSWITH!"=="list" (
				REM
			) 
		) 
	) else ( SET FIND_PROC_SHELL_CODE=^(Get-NetTCPConnection -LocalPort !VALUE!^).OwningProcess)
) else ( SET FIND_PROC_SHELL_CODE=!VALUE!)


if not "!PROPERTY!"=="" (
	SET OUTPUT_SHELL_CODE=$res.!PROPERTY!
)

if "!WHATTOIDENTIFYPROCESSWITH!"=="all" (
	powershell -Command "& { Get-Process; }"
) else (
	if "!WHATTOIDENTIFYPROCESSWITH!"=="list" (
		powershell -Command "& { Get-Process; }"
	) else (
		powershell -Command "& { $res=Get-Process -Id !FIND_PROC_SHELL_CODE!;!OUTPUT_SHELL_CODE!; }"
	)
)

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.qproc:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.qproc:[0m %* 
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
REM 	:date: 04 September 2019
REM 	:time: 04:37 PM
REM 	:filename: qproc.bat
REM 
REM 
REM		.. _ALink: ./ALink.html
