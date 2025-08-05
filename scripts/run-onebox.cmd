@echo off

REM Please, run this script from run.cmd at main directory!!!

cd %main_dir%
cd scripts

echo Loading Primary ...
call "run-mongodb-primary.cmd"

echo Loading Secondary-1 ...
call "run-mongodb-secondary1.cmd"

echo Loading Secondary-2 ...
call "run-mongodb-secondary2.cmd"

exit /b