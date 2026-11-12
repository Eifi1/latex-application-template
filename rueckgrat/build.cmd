@echo off
rem Starts build.ps1 without touching the Windows script policy.
rem Double-click this file, or type in PowerShell:  .\build.cmd   (one document: .\build.cmd lebenslauf)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1" %*
rem keep the window open after an error so that the message can be read
if errorlevel 1 pause
