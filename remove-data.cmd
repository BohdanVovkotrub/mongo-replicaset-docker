@echo off
setlocal

set "main_dir=%cd%"
cd %main_dir%

set "FOLDER=data"

if not exist "%FOLDER%" (
    echo Folder "%FOLDER%" not exist.
    exit /b
)

:ASK
    set /p "CONFIRM=Are you sure you want to delete the folder '%FOLDER%' along with all its contents? (y/n): "
    if /i "%CONFIRM%"=="y" (
        rd /s /q "%FOLDER%"
        echo Folder "%FOLDER%" removed.
        goto eof
    ) else if /i "%CONFIRM%"=="n" (
        echo Canceled by user.
        goto eof
    ) else (
        echo Please, input only Y or N
        goto ASK
    )
  
rmdir /s /q "data"
echo Data removed

:eof
    endlocal
    timeout /t 3 /nobreak >nul
    exit /b
