@echo off
setlocal

REM Please, run this script from run.cmd at main directory!!!

cd %main_dir%

docker-compose -f docker-compose-mongodb-secondary1.yml down -v

goto ask_remove_all_data

:ask_remove_all_data
  set /p answer=Remove all mongodb-secondary-1 data (Y/N)?
  if /i "%answer:~,1%" EQU "Y" goto remove_all_data
  if /i "%answer:~,1%" EQU "N" goto eof
  echo Please type Y for Yes or N for No
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