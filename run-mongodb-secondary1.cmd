@echo off

setlocal

REM load environments from .env
for /f "usebackq tokens=1,2 delims==" %%a in (.env) do (
    set "%%a=%%b"
)



set "main_dir=%cd%"
cd %main_dir%

if not exist data (
  mkdir data 
)



if not exist data\%NAME_SECONDARY_1% (
  mkdir data\%NAME_SECONDARY_1% 
)
if not exist data\%NAME_SECONDARY_1%\db (
  mkdir data\%NAME_SECONDARY_1%\db
)
if not exist data\%NAME_SECONDARY_1%\configdb (
  mkdir data\%NAME_SECONDARY_1%\configdb
)
if not exist data\%NAME_SECONDARY_1%\replication_key (
  mkdir data\%NAME_SECONDARY_1%\replication_key
)
if not exist data\%NAME_SECONDARY_1%\replication_key\mongo-replication.key (
  copy mongo-replication.key data\%NAME_SECONDARY_1%\replication_key\mongo-replication.key
)


REM Generate docker-compose-mongodb.yml
set "TEMPLATE_COMPOSE=compose.mongodb-secondary1.template.yml"
set "OUTPUT_COMPOSE=docker-compose-mongodb-secondary1.yml"

REM Copy template to final file
copy /Y "%TEMPLATE_COMPOSE%" "%OUTPUT_COMPOSE%" >nul

REM Add networks section to end of file
echo. >> %OUTPUT_COMPOSE%
echo networks: >> %OUTPUT_COMPOSE%
echo   %DOCKER_NETWORK_NAME%: >> %OUTPUT_COMPOSE%
echo     external: true >> %OUTPUT_COMPOSE%



echo Creating network %DOCKER_NETWORK_NAME% if it is not exists
docker network inspect %DOCKER_NETWORK_NAME% >nul 2>&1 || docker network create %DOCKER_NETWORK_NAME%


REM docker-compose -f docker-compose-mongodb.yml up -d --remove-orphans
docker-compose -f %OUTPUT_COMPOSE% up -d 

endlocal
exit /b