@echo off
cls
Echo Enter the computer name of the computer you would like to connect with
echo.
set /p computerid="Computername: "

msra /offerra %computerid%