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
REM print out the list of colors that can be passed to the 
REM command **echocolor**. The list of colors is extracted from 
REM the gist https://gist.github.com/mlocati/fdabcaeb8071d5c75a2d51712db24011
REM provided by [Michele Locati](https://gist.github.com/mlocati/)
REM 
REM ::
REM 	Usage: colorlist
REM 

echo.
echo [101;93m NORMAL FOREGROUND COLORS [0m
echo 30 [30mBlack[0m (black)
echo 31 [31mRed[0m
echo 32 [32mGreen[0m
echo 33 [33mYellow[0m
echo 34 [34mBlue[0m
echo 35 [35mMagenta[0m
echo 36 [36mCyan[0m
echo 37 [37mWhite[0m
echo.
echo [101;93m NORMAL BACKGROUND COLORS [0m
echo 40 [40mBlack[0m
echo 41 [41mRed[0m
echo 42 [42mGreen[0m
echo 43 [43mYellow[0m
echo 44 [44mBlue[0m
echo 45 [45mMagenta[0m
echo 46 [46mCyan[0m
echo 47 [47mWhite[0m (white)
echo.
echo [101;93m STRONG FOREGROUND COLORS [0m
echo 90 [90mWhite[0m
echo 91 [91mRed[0m
echo 92 [92mGreen[0m
echo 93 [93mYellow[0m
echo 94 [94mBlue[0m
echo 95 [95mMagenta[0m
echo 96 [96mCyan[0m
echo 97 [97mWhite[0m
echo.
echo [101;93m STRONG BACKGROUND COLORS [0m
echo 100 [100mBlack[0m
echo 101 [101mRed[0m
echo 102 [102mGreen[0m
echo 103 [103mYellow[0m
echo 104 [104mBlue[0m
echo 105 [105mMagenta[0m
echo 106 [106mCyan[0m
echo 107 [107mWhite[0m
echo.
echo see https://gist.github.com/mlocati/fdabcaeb8071d5c75a2d51712db24011

exit /b 0

REM END_OFFSET_FOR_MERGE
REM End of the actual operating script

:display
	echo [0;32mCronux.colorlist:[0m %* 
	exit /b 0
	
:display_error
	echo [0;31mCronux.colorlist:[0m %* 
	exit /b 0
	
:is_administrator
	SET is_administrator_var=
	for /F "tokens=* USEBACKQ" %%F in (`fsutil dirty query %systemdrive%`) do SET is_administrator_var=%%F
	if "x!is_administrator_var:denied=!"=="x!is_administrator_var!" ( SET IS_ADMIN=true) 
	exit /b 0

	
REM S
REM 	:copyright: 2019, Azeez Adewale
REM 	:copyright: GNU LESSER GENERAL PUBLIC LICENSE v3 (c) 2019 Cronux
REM 	:author: Azeez Adewale <azeezadewale98@gmail.com>
REM 	:date: 25 August 2019
REM 	:time: 02:24 PM
REM 	:filename: colorlist.bat
REM 
REM 
REM		.. _ALink: ./ALink.html