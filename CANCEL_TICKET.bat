@echo off
echo.
echo ============================================================
echo       QUEUE MANAGEMENT - CANCEL STUCK TICKETS
echo ============================================================
echo.
echo This tool helps you cancel stuck or active tickets
echo.
cd /d "%~dp0"
python cancel_ticket.py quick
pause

