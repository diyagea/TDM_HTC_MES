echo off

setlocal enabledelayedexpansion
for /f "delims=" %%a in ('type "DB.ini"^| find /i "="') do (
set %%a
)

sqlcmd -U %username% -P %password% -S %server% -d %db% -i Create_All_Traggers.sql


set /p delExit=Press the ENTER key to exit...: