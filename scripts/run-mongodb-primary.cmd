@echo off
setlocal 

REM Please, run this script from run.cmd at main directory!!!

cd %main_dir%

if not exist data (
  mkdir data 
)

if not exist data\%NAME_PRIMARY% (
  mkdir data\%NAME_PRIMARY% 
)
if not exist data\%NAME_PRIMARY%\db (
  mkdir data\%NAME_PRIMARY%\db
)
if not exist data\%NAME_PRIMARY%\configdb (
  mkdir data\%NAME_PRIMARY%\configdb
)
if not exist data\%NAME_PRIMARY%\replication_key (
  mkdir data\%NAME_PRIMARY%\replication_key
)
if not exist data\%NAME_PRIMARY%\replication_key\mongo-replication.key (
  copy mongo-replication.key data\%NAME_PRIMARY%\replication_key\mongo-replication.key
)

set "TEMPLATE_COMPOSE=compose-templates\compose.mongodb-primary.template.yml"
set "OUTPUT_COMPOSE=docker-compose-mongodb-primary.yml"

REM Copy template to final file
copy /Y "%TEMPLATE_COMPOSE%" "%OUTPUT_COMPOSE%" >nul

REM Add networks section to end of file
echo. >> %OUTPUT_COMPOSE%
echo networks: >> %OUTPUT_COMPOSE%
echo   %DOCKER_NETWORK_NAME%: >> %OUTPUT_COMPOSE%
echo     external: true >> %OUTPUT_COMPOSE%

echo Creating network %DOCKER_NETWORK_NAME% if it is not exists
docker network inspect %DOCKER_NETWORK_NAME% >nul 2>&1 || docker network create %DOCKER_NETWORK_NAME%

docker-compose -f %OUTPUT_COMPOSE% up -d 

endlocal
exit /b