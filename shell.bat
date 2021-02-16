@echo off
rem Loads directories for command-line tools associated with httpd, mysql, and php into path
set "PHP_ROOT=%~dp0environment\php"
set "PATH=%PATH%;%~dp0environment\bin;%~dp0environment\httpd\bin;%~dp0environment\php;%~dp0environment\mysql\bin;%~dp0environment\web\vendor\bin"
set "COMPOSER_PROCESS_TIMEOUT=2000"
cmd /k
