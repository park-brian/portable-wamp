@echo off
"%~dp0..\php\php-cgi.exe" -d extension_dir="%~dp0..\php\ext" %*