@echo off
set "PATH=%PATH%;%~dp0environment\php;"
echo httpd is now running [ctrl+c to exit]
cd "%~dp0environment\httpd"
bin\httpd.exe
