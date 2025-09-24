@echo off
setlocal

cd %main_dir%

set "TEMPLATE_FILE=%~1"
set "COMPOSE_FILE=%~2"

if exist "%COMPOSE_FILE%" (
    del /F /Q "%COMPOSE_FILE%"
) 

copy /Y "%TEMPLATE_FILE%" "%COMPOSE_FILE%" >nul 2>&1

echo. >> %COMPOSE_FILE%
echo networks: >> %COMPOSE_FILE%
echo   %DOCKER_NETWORK_NAME%: >> %COMPOSE_FILE%
echo     external: true >> %COMPOSE_FILE%
echo. >> %COMPOSE_FILE%

endlocal
exit /b
