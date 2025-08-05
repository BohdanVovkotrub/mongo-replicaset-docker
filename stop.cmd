@echo off
setlocal

REM load environments from .env
for /f "usebackq tokens=1,2 delims==" %%a in (.env) do (
    set "%%a=%%b"
)

set "main_dir=%cd%"
cd %main_dir%

goto ask_what_stop

:ask_what_stop
  echo Please select what you want to stop:
  echo [0] Stop "One box" (primary + all secondaries on this host)
  echo [1] Stop only Primary on this host
  echo [2] Stop only Secondary-1 on this host
  echo [3] Stop only Secondary-2 on this host
  set /p answer=Input number [0:3]: 
  if /i "%answer:~,1%" EQU "0" goto stop_onebox
  if /i "%answer:~,1%" EQU "1" goto stop_primary
  if /i "%answer:~,1%" EQU "2" goto stop_secondary1
  if /i "%answer:~,1%" EQU "3" goto stop_secondary2
  echo Invalid input. Please enter a number from 0 to 3.
  goto ask_what_stop

:stop_onebox
  call "./scripts/stop-onebox.cmd"
  goto eof

:stop_primary
  call "./scripts/stop-mongodb-primary.cmd"
  goto eof

:stop_secondary1
  call "./scripts/stop-mongodb-secondary1.cmd"
  goto eof

:stop_secondary2
  call "./scripts/stop-mongodb-secondary2.cmd"
  goto eof

:eof
  endlocal
  pause
  exit /b