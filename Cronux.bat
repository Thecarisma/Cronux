@echo off
SET WD=%cd%
cd %~dp0
powershell -noprofile -executionpolicy bypass -file ./windows/Cronux.ps1 %*
cd %WD%