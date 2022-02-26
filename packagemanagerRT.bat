REM Author Hemanth Kumar Kothari [hemanth.kumar.kothari@ni.com]
Rem this file is to install latest feeds of LV & RT with the stable cRIO
REM DATE 5-Dec-2018

Echo [%date% %time%] Maping >>"%userprofile%\Desktop\Package.log"
net use \\nirvana.amer.corp.natinst.com /user:apac\nibtest nibtest
net use \\baltic.amer.corp.natinst.com /user:apac\nibtest nibtest
net use \\nibataserver /user:apac\nibtest nibtest
net use \\in-ban-argo\NISoftwarePrerelease /user:apac\nibtest nibtest
net use \\in-ban-argo.natinst.com\NISoftwarePrerelease /user:apac\nibtest nibtest
net use \\argo\NISoftwarePrerelease /user:apac\nibtest nibtest
net use \\in-ban-fs2.apac.corp.natinst.com /user:apac\nibtest nibtest
net use \\130.164.41.189 /user:amer\lvghosttask labview===


@echo off
Rem Finding latest NIPKG [Package Manager]
FOR /F "delims=" %%i IN ('dir "\\in-ban-argo\ni\nipkg\Package Manager\19.0.0\" /b /ad-h /t:c /od') DO SET NIPKGlatest=%%i>>"%userprofile%\Desktop\Package.log"
 Echo [%date% %time%] \\in-ban-argo\ni\nipkg\Package Manager\19.0.0\%NIPKGlatest% >>"%userprofile%\Desktop\Package.log"
  "\\in-ban-argo\ni\nipkg\Package Manager\19.0.0\%NIPKGlatest%\Install.exe" /Q

Echo *******************************************************************************************************
Rem to install varified
for /d /r "\\in-ban-argo\ni\nipkg\Package Manager\19.5.0" %%d in (verified) do @if exist "%%d" SET NIPKGlatest=%%d
 Echo [%date% %time%] %NIPKGlatest:~0,-8%>>"%userprofile%\Desktop\Package.log"
  "%NIPKGlatest:~0,-8%\Install.exe" /Q

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
 xcopy /Y /i /f /s "\\us-aus-rtweb1\Script Templates\SubScripts\p4tickets.txt"  "%userprofile%" 
Rem to find the latest 'verified' folder
for /f %%i in ('p4 -p perforce:1666 -c labview_rt-testmachine-perforcetest -u labview_rt files -e //AST/PackageManagement/locators/feed/nipkg/ni-c/ni-compactrio/19.0.0/.../verified') do set p4VAR=%%i
  Rem triming the name 'verified#1' from the above string called p4VAR
  set p4VAR=%p4VAR:verified#1=%feedLocator.xml
    Rem sync the latest file path
    p4 -p perforce:1666 -c labview_rt-testmachine-perforcetest -u labview_rt sync -f %p4VAR%
       Echo %p4VAR%
	   set p4VAR=%p4VAR://=\%
	   set p4VAR=%p4VAR:/=\%
	   Rem replacing all \ with /
	          Echo %p4VAR%
Rem reading the .xml file
    setlocal enableextensions disabledelayedexpansion
    set "build="
    for /f "tokens=3 delims=<>" %%a in (
        'find /i "<path>" ^< "C:\sync\perforce%p4VAR%"'
    ) do set "build=%%a"
Rem Replace us-aus to in-ban
  set NIRIO=%build%
   set NIRIO=%NIRIO:us-aus=in-ban%
Echo [%date% %time%] %NIRIO% >>"%userprofile%\Desktop\Package.log"
 "C:\Program Files\National Instruments\NI Package Manager\nipkg.exe" repo-add "%NIRIO%\Packages" --name=cRIOStable>>"%userprofile%\Desktop\Package.log"

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

Rem TO get the feed-list to a text file
Rem Echo [%date% %time%] Feeds installed in Package Manager are: >>"%userprofile%\Desktop\Package.log"
Rem "C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe" feed-info >>"%userprofile%\Desktop\Package.log"


xcopy /Y /i /f /s "\\nibataserver\RTFiles\Stack_valdiation_setup\p4tickets.txt" "%userprofile%\" >>"%userprofile%\Desktop\Package.log"
xcopy /Y /i /f /s "\\nibataserver\RTFiles\Stack_valdiation_setup\GreenwaysFile.bat" "%userprofile%\Desktop\" >>"%userprofile%\Desktop\Package.log"
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2019/test/trunk/CommonSubVIs/...>>"%userprofile%\Desktop\P4V.log"
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2019/test/trunk/executor/...>>"%userprofile%\Desktop\P4V.log"
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2019/test/trunk/tests_auto/...>>"%userprofile%\Desktop\P4V.log"
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2019/rtconn_test/trunk/...>>"%userprofile%\Desktop\P4V.log"
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/InternalTools/Testing/SerenityStackReport/...>>"%userprofile%\Desktop\P4V.log"
