@echo off
"%~dp0..\php\php.exe" -d extension_dir="%~dp0..\php\ext" -f "%~dp0composer.php" %*