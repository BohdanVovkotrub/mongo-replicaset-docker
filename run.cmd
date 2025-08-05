@echo off
setlocal

REM load environments from .env
for /f "usebackq tokens=1,2 delims==" %%a in (.env) do (
    set "%%a=%%b"
)

set "main_dir=%cd%"
cd %main_dir%
set primary_need_run=0

goto ask_remove_containers

:ask_remove_containers
  echo Please select what you want to run:
  echo [0] "One box" (primary + all secondaries on this host)
  echo [1] Only Primary on this host
  echo [2] Only Secondary-1 on this host
  echo [3] Only Secondary-2 on this host
  set /p answer=Input number [0:3]: 
  if /i "%answer:~,1%" EQU "0" goto run_onebox
  if /i "%answer:~,1%" EQU "1" goto run_primary
  if /i "%answer:~,1%" EQU "2" goto run_secondary1
  if /i "%answer:~,1%" EQU "3" goto run_secondary2
  echo Invalid input. Please enter a number from 0 to 3.
  goto ask_remove_containers

:run_onebox
  set primary_need_run=1
  call "./scripts/run-onebox.cmd"
  goto after_run

:run_primary
  set primary_need_run=1
  call "./scripts/run-mongodb-primary.cmd"
  goto after_run

:run_secondary1
  call "./scripts/run-mongodb-secondary1.cmd"
  goto after_run

:run_secondary2
  call "./scripts/run-mongodb-secondary2.cmd"
  goto after_run

:after_run
  cd %main_dir%
  if %primary_need_run% EQU 1 (
    call "./scripts/init-replica-set.cmd"
  )
  goto eof

:eof
  endlocal
  pause
  exit /b