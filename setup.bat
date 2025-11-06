@echo off
setlocal enabledelayedexpansion

:: name|url|subfolder
set "RESOURCES[0]=httpd|https://www.apachelounge.com/download/VS17/binaries/httpd-2.4.65-250724-Win64-VS17.zip|Apache24"
set "RESOURCES[1]=mysql|https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.43-winx64.zip|mysql-8.0.43-winx64"
set "RESOURCES[2]=php|https://windows.php.net/downloads/releases/archives/php-8.4.13-Win32-vs17-x64.zip|"

mkdir environment\archive environment\bin 2>nul

for /L %%i in (0,1,2) do (
    for /f "tokens=1-3 delims=|" %%a in ("!RESOURCES[%%i]!") do (
        set name=%%a
        set url=%%b
        set sub=%%c
        
        for %%f in ("!url!") do set zip=environment\archive\%%~nxf
        set dir=environment\!name!
        
        :: Download
        if not exist "!zip!" (
            echo Downloading !url!
            curl -fL "!url!" -o "!zip!"
        )
        
        :: Extract
        echo Extracting to !dir!
        mkdir "!dir!" 2>nul
        tar -xf "!zip!" -C "!dir!" --strip-components=1 2>nul || (
            tar -xf "!zip!" -C "!dir!"
            if defined sub (
                xcopy /E /I /Y /Q "!dir!\!sub!\*" "!dir!" >nul
                rmdir /S /Q "!dir!\!sub!"
            )
        )
        
        :: Copy config
        if exist "default-configuration\!name!" (
            xcopy /E /I /Y /Q "default-configuration\!name!\*" "!dir!" >nul
        )
    )
)

:: Initialize MySQL
echo Initializing MySQL
environment\mysql\bin\mysqld.exe --default-authentication-plugin=mysql_native_password --initialize-insecure

:: Download Composer
echo Downloading Composer
curl -fL https://getcomposer.org/composer-stable.phar -o environment\bin\composer.php

echo.
echo Setup complete. Set a password for MySQL root user.
echo.
echo Next steps:
echo - start_httpd.bat
echo - start_mysqld.bat
echo - start_mysql_client.bat
echo - shell.bat