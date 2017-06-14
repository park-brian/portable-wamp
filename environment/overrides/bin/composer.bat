@echo off
IF EXIST tmp GOTO COMPOSER
mkdir tmp

:COMPOSER
@php "%~dp0composer" %*
