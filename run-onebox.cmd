@echo off

setlocal

REM load environments from .env
for /f "usebackq tokens=1,2 delims==" %%a in (.env) do (
    set "%%a=%%b"
)

set "main_dir=%cd%"
cd %main_dir%

echo Loading Primary ...
call "run-mongodb-primary.cmd"

echo Loading Secondary-1 ...
call "run-mongodb-secondary1.cmd"

echo Loading Secondary-2 ...
call "run-mongodb-secondary2.cmd"


echo wait ...
call "init-replica-set.cmd"

endlocal
exit /b