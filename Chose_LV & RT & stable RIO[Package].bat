@ECHO OFF
net use \\baltic.amer.corp.natinst.com /user:apac\nibtest nibtest >>"%userprofile%\Desktop\Package.log"
net use \\nibataserver /user:apac\nibtest nibtest >>"%userprofile%\Desktop\Package.log"
net use \\in-ban-argo.natinst.com\NISoftwarePrerelease /user:apac\nibtest nibtest >>"%userprofile%\Desktop\Package.log"
net use \\in-ban-argo\NISoftwarePrerelease /user:apac\nibtest nibtest >>"%userprofile%\Desktop\Package.log"
net use \\in-ban-fs2.apac.corp.natinst.com /user:apac\nibtest nibtest >>"%userprofile%\Desktop\Package.log"
net use \\130.164.41.189 /user:amer\lvghosttask labview=== >>"%userprofile%\Desktop\Package.log"
net use \\nirvana.amer.corp.natinst.com /user:apac\nibtest nibtest >>"%userprofile%\Desktop\Package.log"
echo            MENU Selection for installation 
echo -------------------------------------------------------
echo 1. To Install latest Labview LabviewRT and Stable NIRIO[2019]
echo 2. To specify Daily number
echo _______________________________________________________
SET /P choise="Enter your choise: "
echo _______________________________________________________
2>NUL CALL :CASE_%choise% # jump to :CASE_1, :CASE_2, etc.
IF ERRORLEVEL 1 CALL :DEFAULT_CASE # if label doesn't exist

ECHO Done.
EXIT /B

:CASE_1
  Rem Connecting to network 
Echo [%date% %time%] you have chosen auto install latest Labview LabviewRT and NIRIO "Please do Wait while we get some things Ready to install" >>"%userprofile%\Desktop\Package.log"
@echo off
Rem Finding latest NIPKG [Package Manager]
FOR /F "delims=" %%i IN ('dir "\\in-ban-argo\ni\nipkg\Package Manager\19.0.0\" /b /ad-h /t:c /od') DO SET NIPKGlatest=%%i>>"%userprofile%\Desktop\Package.log"
 Echo [%date% %time%] \\in-ban-argo\ni\nipkg\Package Manager\19.0.0\%NIPKGlatest% >>"%userprofile%\Desktop\Package.log"
  "\\in-ban-argo\ni\nipkg\Package Manager\19.0.0\%NIPKGlatest%\Install.exe" /Q

Rem Finding latest Labview
FOR /F "delims=" %%i IN ('dir "\\in-ban-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-x86\19.0.0\" /b /ad-h /t:c /od') DO SET lvlatest=%%i>>"%userprofile%\Desktop\Package.log"
 Echo [%date% %time%] \\in-ban-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-x86\19.0.0\%lvlatest%\Packages >>"%userprofile%\Desktop\Package.log"
  "C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" repo-add "\\in-ban-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-x86\19.0.0\%lvlatest%\Packages" --name=LabVIEW >>"%userprofile%\Desktop\Package.log"

Rem Finding latest LvRT
FOR /F "delims=" %%i IN ('dir "\\in-ban-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-rt-module-x86\19.0.0\" /b /ad-h /t:c /od') DO SET RTlatest=%%i>>"%userprofile%\Desktop\Package.log"
 Echo [%date% %time%] \\in-ban-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-rt-module-x86\19.0.0\%RTlatest%\Packages >>"%userprofile%\Desktop\Package.log"
  "C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" repo-add "\\in-ban-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-rt-module-x86\19.0.0\%RTlatest%\Packages" --name=LabVIEW_RT >>"%userprofile%\Desktop\Package.log"

Rem to find stable cRIO
@echo off
Rem connect to us-aus-rtweb1
 net use \\us-aus-rtweb1 /user:apac\nibtest nibtest
Rem copy p4v ticket
 xcopy /Y /i /f /s "\\us-aus-rtweb1\Script Templates\SubScripts\p4tickets.txt"  "%userprofile%" >>"%userprofile%\Desktop\Package.log"
Rem to find the latest 'verified' folder
for /f %%i in ('p4 -p perforce:1666 -c labview_rt-testmachine-perforcetest -u labview_rt files -e //AST/PackageManagement/locators/feed/nipkg/ni-c/ni-compactrio/19.0.0/.../verified') do set p4VAR=%%i
  Rem triming the name 'verified#1' from the above string called p4VAR
  set p4VAR=%p4VAR:verified#1=%feedLocator.xml
    Rem sync the latest file path
    p4 -p perforce:1666 -c labview_rt-testmachine-perforcetest -u labview_rt sync -f %p4VAR% >>"%userprofile%\Desktop\Package.log"
	   set p4VAR=%p4VAR://=\%
	   set p4VAR=%p4VAR:/=\%
	   Rem replacing all \ with /
    setlocal enableextensions disabledelayedexpansion
Rem finding The path from the xml file for cRIO
    set "build="
    for /f "tokens=3 delims=<>" %%a in (
        'find /i "<path>" ^< "C:\sync\perforce%p4VAR%"'
    ) do set "build=%%a"
Rem Replace us-aus to in-ban
  set NIRIO=%build%
   set NIRIO=%NIRIO:us-aus=in-ban%
Echo [%date% %time%] %NIRIO% >>"%userprofile%\Desktop\Package.log"
 "C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" repo-add "%NIRIO%\Packages" --name=cRIOStable >>"%userprofile%\Desktop\Package.log"

REM installation starts for LV, RT & RTO
Echo [%date% %time%] Updating and Installation starts for LV RT and cRIO Using feeds >>"%userprofile%\Desktop\Package.log"
 "C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" update >>"%userprofile%\Desktop\Package.log"
 "C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe" install "ni-labview-2019-core-x86-en" --progress-only --accept-eulas --prevent-reboot >>"%userprofile%\Desktop\install.log"
 "C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe" install "ni-labview-2019-rt-module-x86" --progress-only --accept-eulas --prevent-reboot >>"%userprofile%\Desktop\install.log"
 "C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe" install "ni-rt-trace-viewer-2019-labview-support" --progress-only --accept-eulas --prevent-reboot >>"%userprofile%\Desktop\install.log"
 "C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe" install "ni-compactrio" --progress-only --accept-eulas --prevent-reboot >>"%userprofile%\Desktop\install.log"

Rem installing Eclipse
Echo [%date% %time%] \\in-ban-argo.natinst.com\NISoftwareReleased\Windows\Distributions\Eclipse\2017\17.0.0\NIECLIPSE >>"%userprofile%\Desktop\Package.log"
"\\in-ban-argo.natinst.com\NISoftwareReleased\Windows\Distributions\Eclipse\2017\17.0.0\NIECLIPSE\setup.exe" /qb /r:n /acceptlicenses yes /l c:\Ecl_inst.log /disableNotificationCheck /confirmCriticalWarnings
Rem restart the machine in 20 sec
echo [%date% %time%] shutdown.exe /r /t 40 >>"%userprofile%\Desktop\Package.log"
shutdown.exe /r /t 20 >>"%userprofile%\Desktop\Package.log"
Echo [%date% %time%] Licenseing started
"\\nibataserver\RTFiles\Script Templates\SubScripts\License.bat" >>"%userprofile%\Desktop\Package.log"
Echo [%date% %time%] Licenseing Finished
  GOTO END_CASE
:CASE_2
  set /p NIPKGINST="Enter Package Manager\19.0.0 :"
  set /P lvDaily="Specify LabView Daily number:"
  set /P lvRT="Specify LabView RT Daily number:"
  set /P NIRIO="Specify NIRIO Daily number:"
Echo Taking from %NIPKGINST% lvDaily=%lvDaily% labViewRT=%lvRT% and NIRIO=%NIRIO% >>"%userprofile%\Desktop\Package.log"
Rem print to log file
Echo [%date% %time%] Installing Started >>"%userprofile%\Desktop\Package.log"
echo \\in-ban-argo\ni\nipkg\Package Manager\19.0.0\%NIPKGINST% >>"%userprofile%\Desktop\Package.log"
echo \\in-ban-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-x86\19.0.0\%lvDaily%\Packages >>"%userprofile%\Desktop\Package.log"
echo \\in-ban-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-rt-module-x86\19.0.0\%lvRT%\Packages >>"%userprofile%\Desktop\Package.log"
Echo \\in-ban-argo\ni\nipkg\feeds\ni-c\ni-compactrio\19.0.0\%NIRIO%\Packages >>"%userprofile%\Desktop\Package.log"
Rem adding feeds
"\\in-ban-argo\ni\nipkg\Package Manager\19.0.0\%NIPKGINST%\Install.exe" /Q
"C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" repo-add "\\in-ban-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-x86\19.0.0\%lvDaily%\Packages" --name=LabVIEW >>"%userprofile%\Desktop\Package.log"
"C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" repo-add "\\in-ban-argo\ni\nipkg\feeds\ni-l\ni-labview-2019-rt-module-x86\19.0.0\%lvRT%\Packages" --name=LabVIEW_RT >>"%userprofile%\Desktop\Package.log"
"C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" repo-add "\\in-ban-argo\ni\nipkg\feeds\ni-c\ni-compactrio\19.0.0\%NIRIO%\Packages" --name=cRIO >>"%userprofile%\Desktop\Package.log"
Rem installing add feeds
Echo [%date% %time%] Updating and Installation starts for LV RT and cRIO Using feeds >>"%userprofile%\Desktop\Package.log"
 "C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" update >>"%userprofile%\Desktop\Package.log"
 "C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe" install "ni-labview-2019-core-x86-en" --progress-only --accept-eulas --prevent-reboot >>"%userprofile%\Desktop\install.log"
 "C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe" install "ni-labview-2019-rt-module-x86" --progress-only --accept-eulas --prevent-reboot >>"%userprofile%\Desktop\install.log"
 "C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe" install "ni-rt-trace-viewer-2019-labview-support" --progress-only --accept-eulas --prevent-reboot >>"%userprofile%\Desktop\install.log"
 "C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe" install "ni-compactrio" --progress-only --accept-eulas --prevent-reboot >>"%userprofile%\Desktop\install.log"
Rem installing Eclipse
Echo [%date% %time%] \\in-ban-argo.natinst.com\NISoftwareReleased\Windows\Distributions\Eclipse\2017\17.0.0\NIECLIPSE >>"%userprofile%\Desktop\Package.log"
"\\in-ban-argo.natinst.com\NISoftwareReleased\Windows\Distributions\Eclipse\2017\17.0.0\NIECLIPSE\setup.exe" /qb /r:n /acceptlicenses yes /l c:\Ecl_inst.log /disableNotificationCheck /confirmCriticalWarnings
Echo [%date% %time%] Installing Completed >>"%userprofile%\Desktop\Package.log"
Echo Copying p4Ticket and Greenways File >>"%userprofile%\Desktop\Package.log"
xcopy /Y /i /f /s "\\nibataserver\RTFiles\Stack_valdiation_setup\p4tickets.txt" "%userprofile%\" >>"%userprofile%\Desktop\Package.log"
xcopy /Y /i /f /s "\\nibataserver\RTFiles\Stack_valdiation_setup\GreenwaysFile.bat" "%userprofile%\Desktop\" >>"%userprofile%\Desktop\Package.log"
Echo [%date% %time%] Licenseing started >>"%userprofile%\Desktop\Package.log"
"\\nibataserver\RTFiles\Script Templates\SubScripts\License.bat" >>"%userprofile%\Desktop\Package.log"
Echo [%date% %time%] Licenseing Finished >>"%userprofile%\Desktop\Package.log"
echo [%date% %time%] shutdown.exe /r /t 40 >>"%userprofile%\Desktop\Package.log"
shutdown.exe /r /t 20 >>"%userprofile%\Desktop\Package.log"
  GOTO END_CASE
:DEFAULT_CASE
  ECHO Unknown Choise "%choise%" >>"%userprofile%\Desktop\Package.log"
  GOTO END_CASE
:END_CASE
  VER > NUL # reset ERRORLEVEL
  GOTO :EOF # return from CALL