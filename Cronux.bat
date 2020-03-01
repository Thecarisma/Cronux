@echo off
SET WD=%cd%
powershell -noprofile -executionpolicy bypass -file %~dp0/commands/Cronux.ps1 %*
cd %WD%