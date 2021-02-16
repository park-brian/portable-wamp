@echo off
set "PHP_ROOT=%~dp0environment\php"
set "PATH=%PATH%;%PHP_ROOT%;%PHP_ROOT%\ext;"
echo httpd is now running [ctrl+c to exit]
cd "%~dp0environment\httpd"
bin\httpd.exe
