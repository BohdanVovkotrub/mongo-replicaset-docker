@echo off
setlocal

docker network inspect %DOCKER_NETWORK_NAME% >nul 2>&1 || ( echo Creating network "%DOCKER_NETWORK_NAME%" && docker network create %DOCKER_NETWORK_NAME% )

endlocal
exit /b