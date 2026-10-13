@echo off
rem Runs scripts\copycat-selftest.sh with Git Bash (needs only Docker + Git for Windows).
set "GB=%ProgramFiles%\Git\bin\bash.exe"
if not exist "%GB%" (
  echo copycat-selftest needs Git for Windows ^(Git Bash^). Not found at "%GB%".
  exit /b 1
)
"%GB%" "%~dp0..\scripts\copycat-selftest.sh" %*
