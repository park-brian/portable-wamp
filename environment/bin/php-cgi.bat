@echo off
set "PHP_ROOT=%~dp0..\php"
"%PHP_ROOT%\php-cgi.exe" -d extension_dir="%PHP_ROOT%\ext" %*