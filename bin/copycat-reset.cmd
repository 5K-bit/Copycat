@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\scripts\copycat-reset.ps1" %*
