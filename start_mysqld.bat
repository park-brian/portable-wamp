@echo off
echo mysqld is now running [ctrl+c to exit]
"%~dp0environment\mysql\bin\mysqld.exe" -u root --console --default-authentication-plugin=mysql_native_password

