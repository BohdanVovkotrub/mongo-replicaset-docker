@echo off

cd %main_dir%

set "ENV_FILE=.env"

if exist "%ENV_FILE%" (
    echo "%ENV_FILE%" already exists. Skip creating "%ENV_FILE%" ...
    goto loadEnv
) 

echo Creating .env config ...
type nul > "%ENV_FILE%"

REM load environments from .env.example
for /f "usebackq delims=" %%L in (.env.example) do (
    if not "%%L"=="" (
        for /f "tokens=1* delims==" %%a in ("%%L") do (
            set "KEY=%%a"
            set "VAL=%%b"
            
            findstr /b /c:"%%a=" "%ENV_FILE%" >nul 2>&1
            if errorlevel 1 (
                call :addEnvVar "%%a" "%%b"
            )
        )
    )
)

goto loadEnv

:loadEnv
    REM load environments from .env
    for /f "usebackq tokens=1,2 delims==" %%a in (.env) do (
        set "%%a=%%b"
    )
    goto eof

:addEnvVar
    setlocal DisableDelayedExpansion
    set "VAR_NAME=%~1"
    set "DEFAULT_VALUE=%~2"
    set "VAR_VALUE="

    set /p VAR_VALUE=Input value for "%VAR_NAME%" [%DEFAULT_VALUE%]: 
    if not defined VAR_VALUE set "VAR_VALUE=%DEFAULT_VALUE%"

    REM видаляємо лапки зі введеного значення
    set "VAR_VALUE=%VAR_VALUE:"=%"

    REM якщо значення містить пробіл, додаємо лапки
    echo %VAR_VALUE% | findstr " " >nul 2>&1
    if not errorlevel 1 (
        set "VAR_VALUE=\"%VAR_VALUE%\""
    )

    >> "%ENV_FILE%" echo %VAR_NAME%=%VAR_VALUE%
    endlocal
    exit /b

:eof

    exit /b
