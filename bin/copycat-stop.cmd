@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\scripts\copycat-stop.ps1" %*
