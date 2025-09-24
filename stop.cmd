@echo off
setlocal

set "main_dir=%cd%"
cd %main_dir%

call "./scripts/dotenv.cmd"

echo "%DOCKER_COMPOSE_NAME%"
docker-compose -f "%DOCKER_COMPOSE_NAME%" down -v --remove-orphans

:eof
    endlocal
    timeout /t 3 /nobreak >nul
    exit /b