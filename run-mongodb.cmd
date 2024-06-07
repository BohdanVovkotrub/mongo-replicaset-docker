@echo off

setlocal

REM load environments from .env
for /f "usebackq tokens=1,2 delims==" %%a in (.env) do (
    set "%%a=%%b"
)


set "main_dir=%cd%"
cd %main_dir%

mkdir data 
cd data
mkdir %NAME_PRIMARY%
mkdir %NAME_SECONDARY_1%
mkdir %NAME_SECONDARY_2%
cd %main_dir%



REM docker-compose -f docker-compose-mongodb.yml up -d --remove-orphans
docker-compose -f docker-compose-mongodb.yml up -d 

:ask_init_replica_set
  echo Init the mongoDB Replica Set. IT NEED ONLY FOR THE FIRST RUNNING.
  echo Please, input Y if you run this at the first time.
  set /p answer=Do You want to init the Replica Set (Y/N)?
  if /i "%answer:~,1%" EQU "Y" goto init_replica_set
  if /i "%answer:~,1%" EQU "N" goto eof
  echo Please type Y for Yes or N for No
  goto ask_init_replica_set

:init_replica_set
  echo Wait for the containers will be run ...
  timeout /t %TIMEOUT_INIT_REPLICA% /nobreak

  REM Настройка Replica Set
  echo setuping the Replica Set ...
  docker exec -it %NAME_PRIMARY% mongosh --username %USERNAME% --password %PASSWORD% --eval "rs.initiate({_id: '%REPLICA_ID%', members: [{_id: 0, host: '%GUEST_HOST%:%PORT_PRIMARY%'}, { _id: 1, host: '%GUEST_HOST%:%PORT_SECONDARY_1%'}, { _id: 2, host: '%GUEST_HOST%:%PORT_SECONDARY_2%'}]})"

  REM Проверка состояния Replica Set
  echo check status of the Replica Set ...
  docker exec -it %NAME_PRIMARY% mongosh --username %USERNAME% --password %PASSWORD% --eval "rs.status()"

  REM Создание базы данных и пользователя
  echo Creating DB <%DB%> and user <%USERNAME%> ...
  docker exec -it %NAME_PRIMARY% mongosh --username %USERNAME% --password %PASSWORD%  --eval "use %DB%; db.createUser({user: '%USERNAME%', pwd: '%PASSWORD%', roles: [{role: 'readWrite', db: '%DB%'}]})"

  echo if You see "ok: <int_num>" thats good! Bye...
  goto eof

:eof
  endlocal
  pause
  exit /b