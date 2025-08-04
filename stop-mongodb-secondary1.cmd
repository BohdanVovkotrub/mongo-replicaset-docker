@echo off

setlocal

REM load environments from .env
for /f "usebackq tokens=1,2 delims==" %%a in (.env) do (
    set "%%a=%%b"
)

set "main_dir=%cd%"
cd %main_dir%

echo STOP CONTAINER:%NAME_SECONDARY_1% ...
docker stop %NAME_SECONDARY_1%

goto ask_remove_containers

:ask_remove_containers 
   set /p answer=Remove mongodb-secondary1 container (Y/N)?
   if /i "%answer:~,1%" EQU "Y" goto remove_containers
   if /i "%answer:~,1%" EQU "N" goto ask_remove_all_data
   echo Please type Y for Yes or N for No
   goto ask_remove_containers

:ask_remove_all_data
  set /p answer=Remove all mongodb-secondary1 data (Y/N)?
  if /i "%answer:~,1%" EQU "Y" goto remove_all_data
  if /i "%answer:~,1%" EQU "N" goto eof
  echo Please type Y for Yes or N for No
  goto ask_remove_all_data


:remove_containers
  echo REMOVE CONTAINER: %NAME_SECONDARY_1% ...
  docker rm -f %NAME_SECONDARY_1%
  goto ask_remove_all_data
  

:remove_all_data
  cd data
  echo REMOVE /data/%NAME_SECONDARY_1% ...
  rmdir /s %NAME_SECONDARY_1%
  cd %main_dir%
  goto eof

:eof
  endlocal
  exit /b