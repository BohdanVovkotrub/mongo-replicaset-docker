@echo off
setlocal 

set "main_dir=%cd%"
cd %main_dir%

call "./scripts/dotenv.cmd"
call "./scripts/create-docker-network.cmd"
call "./scripts/create-compose.cmd" "%DOCKER_COMPOSE_TEMPLATE_NAME%" "%DOCKER_COMPOSE_NAME%"

exit /b %errorlevel%
if %errorlevel% neq 0 (
    echo Error occurred during setup. Exiting.
    goto :eof
)
docker-compose -f "%DOCKER_COMPOSE_NAME%" up -d

:eof
    endlocal
    timeout /t 3 /nobreak >nul
    exit /b