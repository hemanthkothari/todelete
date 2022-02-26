Rem This file is to Install old Released LabVIEW + RT + cRIO[compact RIO]
@ECHO OFF

Echo Mapping  >>"%userprofile%\Desktop\installLog.log"
net use O: /persistent:no /user:amer\lvghosttask \\us-aus-argo\nisoftwarereleased LabVIEW=3! >>"%userprofile%\Desktop\installLog.log"

SET /P LVRTuVER="Choose Version you need to install (type  2017, 2017_Sp1): "
2>NUL CALL :CASE_%LVRTuVER% #  jump to :CASE_2016, :CASE_2017, :CASE_2017_Sp1,etc.
IF ERRORLEVEL 1 CALL :DEFAULT_CASE # If label doesn't exist

ECHO Done.
EXIT /B
:CASE_2013
  Set LVPATH="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW\2013\13.0.0\English\32-bit\"
  Set LVRTPath="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW Add-ons\Real-Time\2013\13.0.0\English\"
  Set cRIO="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\NI-RIO\13.0\13.0.0\NIRIO\"
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE_WInMIF
:CASE_2013_Sp1
  Set LVPATH="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW\2013\13.1.12\32-bit\"
  Set LVRTPath="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW Add-ons\Real-Time\2013\13.1.2\"
  Set cRIO="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\NI-RIO\13.1\13.1.1\NIRIO\"
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE_WInMIF
:CASE_2015
  Set LVPATH="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW\2015\15.0.0\English\32bit\LabVIEW2015\"
  Set LVRTPath="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW Add-ons\Real-Time\2015\15.0.0\English\LVRT2015\"
  Set cRIO="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\CompactRIO\15.0\15.0.0\NICRIO\"
  Rem Set Eclips="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\Eclipse\2014\14.0.0\NIECLIPSE\"
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE_WInMIF
:CASE_2016
  Set LVPATH="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW\2016\16.0.0\English\32bit\LabVIEW2016\"
  Set LVRTPath="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW Add-ons\Real-Time\2016\16.0.0\English\LVRT2016\"
  Set cRIO="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\CompactRIO\16.0\16.0.0\NICRIO\"
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE_WInMIF
:CASE_2017
  Set LVPATH="\\us-aus-argo\NISoftwareReleased\Windows\Distributions\LabVIEW\2017\17.0.0\English\32bit\LabVIEW2017\"
  Set LVRTPath="\\us-aus-argo\NISoftwareReleased\Windows\Distributions\LabVIEW Add-ons\Real-Time\2017\17.0.0\English\LVRT2017\"
  Set cRIO="\\us-aus-argo\NISoftwareReleased\Windows\Distributions\CompactRIO\17.0\17.0.0\NICRIO\"
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE_WInMIF
:CASE_2017_Sp1
  Set LVPATH="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW\2017\17.1.0\English\32bit\LabVIEW2017\"
  Set LVRTPath="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW Add-ons\Real-Time\2017\17.0.0\English\LVRT2017\"
  Set cRIO="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\CompactRIO\17.6\17.6.0\NICRIO\"
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE_WInMIF
:CASE_2018
  Set LVPATH="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW\2018\18.0.0\English\32bit\LabVIEW2018\"
  Set LVRTPath="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW\2018\18.0.0\English\32bit\LabVIEW2018\"
  Set cRIO="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\CompactRIO\18.0\18.0.0\NICRIO\"
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE_WInMIF
:CASE_2018_Sp1
  Set LVPATH="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW\2018\18.1.0\English\32bit\LabVIEW2018\"
  Set LVRTPath="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW Add-ons\Real-Time\2018\18.1.0\English\LVRT2018\"
  Set cRIO="\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\CompactRIO\18.5\18.5.0\NICRIO\"
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE_WInMIF
:CASE_2019
  Set LVPATH="\\us-aus-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-x86\19.0.0\19.0.0.49152-0+f0"
  Set LVRTPath="\\us-aus-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-rt-module-x86\19.0.0\19.0.0.49152-0+f0"
  Set cRIO="\\us-aus-argo\ni\nipkg\suites\ni-c\ni-compactrio-device-drivers\19.0.0\19.0.0.49152-0+f0\offline\uncompressed"
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE_NIPKG
:CASE_2019_Sp1
  Set LVPATH="\\us-aus-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-x86\19.1.0\19.1.0.49153-0+f1"
  Set LVRTPath="\\us-aus-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-rt-module-x86\19.0.0\19.0.0.49152-0+f0"
  Set cRIO="\\us-aus-argo\ni\nipkg\suites\ni-c\ni-compactrio-device-drivers\19.5.0\19.5.0.49152-0+f0\offline\uncompressed"
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE_NIPKG
:CASE_2020
  Set LVPATH="\\us-aus-argo\ni\nipkg\feeds\ni-l\ni-labview-2020-x86\20.0.0\20.0.0.49153-0+f1"
  Set LVRTPath="\\us-aus-argo\ni\nipkg\feeds\ni-l\ni-labview-2020-rt-module-x86\20.0.0\20.0.0.49155-0+f3"
  Set cRIO="\\us-aus-argo\ni\nipkg\suites\ni-c\ni-compactrio-device-drivers\20.0.0\20.0.0.49154-0+f2\offline\uncompressed"
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE_NIPKG
:DEFAULT_CASE
  ECHO Error With labview Version %LV:~8,4% "NO CASE DEFINED FOR IT" >>"%userprofile%\Desktop\installLog.log"
  EXIT /B
:END_CASE
  VER > NUL # reset ERRORLEVEL
  GOTO :EOF # return from CALL
:END_CASE_WInMIF
Rem in this it has the standard exe base installer creating a log file
  Echo [%date% %time%] "%LVPATH%setup.exe">>%userprofile%\Desktop\installLog.log
  "%LVPATH%setup.exe" /qb /r:n /acceptlicenses yes /l c:\LV_inst.log /disableNotificationCheck /confirmCriticalWarnings
  Echo [%date% %time%] "%LVRTPath%setup.exe">>%userprofile%\Desktop\installLog.log
  "%LVRTPath%setup.exe" /qb /r:n /acceptlicenses yes /l c:\RT_inst.log /disableNotificationCheck /confirmCriticalWarnings
  Echo [%date% %time%] "%cRIO%setup.exe">>%userprofile%\Desktop\installLog.log
  "%cRIO%setup.exe" /qb /r:n /acceptlicenses yes /l c:\cRIO_inst.log /disableNotificationCheck /confirmCriticalWarnings
  VER > NUL # reset ERRORLEVEL
  GOTO :EOF # return from CALL
:END_CASE_NIPKG
Rem in this it has the standard Package base installer

Rem Finding latest NIPKG version
  FOR /F "delims=" %%i IN ('dir "\\us-aus-argo\ni\nipkg\Package Manager\" /b /ad-h /t:c /od') DO SET LatestNIPKG=%%i
Rem fining the "verified" NIPKG [Package Manager]
Echo fining the 'verified' NIPKG [Package Manager] from "%LatestNIPKG%"
  For /d /r "\\us-aus-argo\ni\nipkg\Package Manager\%LatestNIPKG%" %%d in (verified) do @if exist "%%d" SET NIPKGlatest=%%d
Rem in this NIPKGlatest:~0,-8% we are removing "verified" from the string
 Echo [%date% %time%] %NIPKGlatest:~0,-8%>>"%userprofile%\Desktop\installLog.log"
  "%NIPKGlatest:~0,-8%\Install.exe" --passive --accept-eulas
  Echo [%date% %time%] %LVPATH% >>"%userprofile%\Desktop\installLog.log"
  Echo [%date% %time%] %LVRTPath% >>"%userprofile%\Desktop\installLog.log"
  Echo [%date% %time%] %cRIO% >>"%userprofile%\Desktop\installLog.log"
   "C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" repo-add "%LVPATH%\Packages" --name=LabVIEW%LVRTuVER% >>"%userprofile%\Desktop\installLog.log"
   "C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" repo-add "%LVRTPath%\Packages" --name=LabVIEW_RT%LVRTuVER% >>"%userprofile%\Desktop\installLog.log"
   "C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" repo-add "%cRIO%\Packages" --name=cRIO%LVRTuVER% >>"%userprofile%\Desktop\installLog.log"

 Echo [%date% %time%] Updating and Installation starts for LV RT and cRIO Using feeds >>"%userprofile%\Desktop\installLog.log"
  "C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" update >>"%userprofile%\Desktop\installLog.log"
  "C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe" install "ni-labview-%LVRTuVER:~0,4%-core-x86-en" --progress-only --accept-eulas --prevent-reboot >>"%userprofile%\Desktop\NIPKGinstallLog.log"
  "C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe" install "ni-labview-%LVRTuVER:~0,4%-rt-module-x86" --progress-only --accept-eulas --prevent-reboot >>"%userprofile%\Desktop\NIPKGinstallLog.log"
  "C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe" install "ni-rt-trace-viewer-%LVRTuVER:~0,4%-labview-support" --progress-only --accept-eulas --prevent-reboot >>"%userprofile%\Desktop\NIPKGinstallLog.log"
  "%cRIO%\Install.exe" --progress-only --accept-eulas --prevent-reboot >>"%userprofile%\Desktop\installLog.log"  
  VER > NUL # reset ERRORLEVEL
  GOTO :EOF # return from CALL
  