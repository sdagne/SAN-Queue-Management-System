@echo off
echo.
echo ============================================================
echo       CLEAN ALL STUCK TICKETS - Quick Fix
echo ============================================================
echo.
cd /d "%~dp0"
python clean_tickets.py
echo.
pause

