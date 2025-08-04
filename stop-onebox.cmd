@echo off

setlocal

REM load environments from .env
for /f "usebackq tokens=1,2 delims==" %%a in (.env) do (
    set "%%a=%%b"
)

set "main_dir=%cd%"
cd %main_dir%

echo Stopping primary ...
call "stop-mongodb-primary.cmd"

echo Stopping secondary-1 ...
call "stop-mongodb-secondary1.cmd"

echo Stopping secondary-2 ...
call "stop-mongodb-secondary2.cmd"

endlocal
pause
exit /b