@echo off
REM ============================================================
REM  Smart Billing Management System - reliable launcher
REM  Serves this folder over http://localhost so PDF parsing
REM  works without the file:// Web Worker limitation.
REM ============================================================
cd /d "%~dp0"
set PORT=8000

echo Starting a local server for the Smart Billing app...
echo.

REM Try Python 3 (python), then the py launcher, then Node.
where python >nul 2>nul
if %errorlevel%==0 (
  start "" "http://localhost:%PORT%/index.html"
  python -m http.server %PORT%
  goto :eof
)

where py >nul 2>nul
if %errorlevel%==0 (
  start "" "http://localhost:%PORT%/index.html"
  py -m http.server %PORT%
  goto :eof
)

where npx >nul 2>nul
if %errorlevel%==0 (
  start "" "http://localhost:%PORT%/index.html"
  npx --yes http-server -p %PORT% -c-1
  goto :eof
)

echo Could not find Python or Node to run a local server.
echo You can still just double-click index.html (works while online).
echo To run fully offline, install Python from https://python.org and run this file again.
pause
