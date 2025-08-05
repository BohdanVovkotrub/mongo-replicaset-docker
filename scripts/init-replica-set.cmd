@echo off
setlocal

echo hello from init

REM Please, run this script from run.cmd at main directory!!!

:ask_init_replica_set
  echo Init the mongoDB Replica Set. IT NEED ONLY FOR THE FIRST RUNNING.
  echo Please, input Y if you run this at the first time.
  set /p answer=Do You want to init the Replica Set (Y/N)? 
  if /i "%answer:~,1%" EQU "Y" goto init_replica_set
  if /i "%answer:~,1%" EQU "N" goto eof
  echo Please type Y for Yes or N for No
  goto ask_init_replica_set

:init_replica_set
  echo Please, wait ...
  timeout /t %TIMEOUT_INIT_REPLICA% /nobreak

  REM Configure Replica Set
  echo setuping the Replica Set ...
  docker exec -it %NAME_PRIMARY% mongosh --username %USERNAME% --password %PASSWORD% --eval "rs.initiate({_id: '%REPLICA_ID%', members: [{_id: 0, host: '%HOST_PRIMARY%:%PORT_PRIMARY%'}, { _id: 1, host: '%HOST_SECONDARY1%:%PORT_SECONDARY_1%'}, { _id: 2, host: '%HOST_SECONDARY2%:%PORT_SECONDARY_2%'}]})"

  REM Check status of the Replica Set
  echo check status of the Replica Set ...
  docker exec -it %NAME_PRIMARY% mongosh --username %USERNAME% --password %PASSWORD% --eval "rs.status()"

  REM Creating DB and User
  echo Creating DB <%DB%> and user <%USERNAME%> ...
  docker exec -it %NAME_PRIMARY% mongosh --username %USERNAME% --password %PASSWORD%  --eval "use %DB%; db.createUser({user: '%USERNAME%', pwd: '%PASSWORD%', roles: [{role: 'readWrite', db: '%DB%'}]})"

  echo if You see "ok: <int_num>" thats good! Bye...
  goto eof

:eof
  endlocal
  exit /b