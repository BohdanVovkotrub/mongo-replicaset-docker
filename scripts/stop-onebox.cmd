@echo off

REM Please, run this script from run.cmd at main directory!!!

cd %main_dir%
cd scripts

echo Stopping primary ...
call "stop-mongodb-primary.cmd"

echo Stopping secondary-1 ...
call "stop-mongodb-secondary1.cmd"

echo Stopping secondary-2 ...
call "stop-mongodb-secondary2.cmd"

exit /b