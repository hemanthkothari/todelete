REM Author Hemanth Kumar Kothari [hemanth.kumar.kothari@ni.com]
REM This file is used to find the installer for performance runs

Rem read the xml file
@echo off
set TypeInstaller=%1

    setlocal enableextensions disabledelayedexpansion

REM '%~dp0' is used for current working directory
set "CurrentWork=%~dp0"
echo %~dp0

REM Finding VM_Host name	
    set "Installer="
    for /f "tokens=3 delims=<>" %%a in (
        'find /i "<%TypeInstaller%>" ^< "%CurrentWork%IdentifyInstaller_Performance.xml"'
    ) do set "Installer=%%a"
	
Echo [%date% %time%] TypeInstaller=%TypeInstaller% Installer=%Installer%
Echo [%date% %time%] GetLatestInstaller: %Installer%

if %TypeInstaller% == DOTNET (
	Rem ForInstalling DotNet
    "%Installer%" /q /log C:\dotnet462_install.log
)else (
   Rem for installing other software
    "%Installer%Install.exe" --passive --accept-eulas
)