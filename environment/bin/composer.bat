@echo off
set "PHP_ROOT=%~dp0..\php"
"%PHP_ROOT%\php.exe" -d extension_dir="%PHP_ROOT%\ext" -f "%~dp0composer.php" %*
