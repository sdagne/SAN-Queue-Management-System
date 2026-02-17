@echo off
echo.
echo ============================================================
echo       QUEUE MANAGEMENT SYSTEM - RUN TESTS
echo ============================================================
echo.
echo Running API tests...
echo.
cd /d "%~dp0"
python test_api.py
echo.
echo ============================================================
echo Tests complete!
echo ============================================================
pause

