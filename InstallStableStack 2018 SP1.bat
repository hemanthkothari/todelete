net use \\baltic.amer.corp.natinst.com /user:apac\nibtest nibtest
net use \\nibataserver /user:apac\nibtest nibtest
net use \\in-ban-argo\NISoftwarePrerelease /user:apac\nibtest nibtest
net use \\in-ban-fs2.apac.corp.natinst.com /user:apac\nibtest nibtest
net use \\130.164.41.189 /user:amer\lvghosttask labview===
net use \\nirvana.amer.corp.natinst.com /user:apac\nibtest nibtest

set year=2018
set yeay=2018 SP1
@echo off
Rem Finding latest Labview
FOR /F "delims=" %%i IN ('dir "\\in-ban-argo\NISoftwarePrerelease\LabVIEW\%yeay%\English\32bit\Daily\" /b /ad-h /t:c /od') DO SET lvlatest=%%i>>"%userprofile%\Desktop\LatestinstallLog.txt"
Echo [%date% %time%] \\in-ban-argo\NISoftwarePrerelease\LabVIEW\%yeay%\English\32bit\Daily\%lvlatest%\LabVIEW%year%\ >>"%userprofile%\Desktop\LatestinstallLog.txt"
"\\in-ban-argo\NISoftwarePrerelease\LabVIEW\%yeay%\English\32bit\Daily\%lvlatest%\LabVIEW%year%\setup.exe" /qb /r:n /AcceptLicenses yes /l c:\lv_inst.log /disableNotificationCheck /confirmCriticalWarnings /prop NICEIPNOSEND=0" >>"%userprofile%\Desktop\LatestinstallLog.txt"
Rem Finding latest LabviewRT
FOR /F "delims=" %%i IN ('dir "\\in-ban-argo\nisoftwareprerelease\labview real-time\%yeay%\english\daily\" /b /ad-h /t:c /od') DO SET RTlatest=%%i
Echo [%date% %time%] \\in-ban-argo\nisoftwareprerelease\labview real-time\%yeay%\english\daily\%RTlatest%\LVRT%year%\ >>"%userprofile%\Desktop\LatestinstallLog.txt"
"\\in-ban-argo\nisoftwareprerelease\labview real-time\%yeay%\english\daily\%RTlatest%\LVRT%year%\setup.exe"  /qb /r:n /AcceptLicenses yes /l c:\rt_inst.log /disableNotificationCheck /confirmCriticalWarnings /prop NICEIPNOSEND=0" >>"%userprofile%\Desktop\LatestinstallLog.txt"
Rem connect to us-aus-rtweb1
net use \\us-aus-rtweb1 /user:apac\nibtest nibtest >>"%userprofile%\Desktop\LatestinstallLog.txt"
Rem copy the p4 ticket and sync the stable RIO xml
xcopy /Y /i /f /s "\\us-aus-rtweb1\Script Templates\SubScripts\p4tickets.txt"  "%userprofile%" >>"%userprofile%\Desktop\LatestinstallLog.txt"
p4 -p perforce:1666 -c labview_rt-testmachine-perforcetest -u labview_rt sync -f //NIInstallers/DistributionLocators/CompactRIO/18.5.0.xml >>"%userprofile%\Desktop\LatestinstallLog.txt"
Rem read the xml file
@echo off
    setlocal enableextensions disabledelayedexpansion

    set "build="
    for /f "tokens=3 delims=<>" %%a in (
        'find /i "<InputRoot>" ^< "C:\sync\perforce\NIInstallers\DistributionLocators\CompactRIO\18.5.0.xml"'
    ) do set "build=%%a"
 Rem   echo %build%
Rem Replace us-aus to in-ban
set NIRIO=%build%
set NIRIO=%NIRIO:us-aus=in-ban%
set NIRIO=%NIRIO%\
echo [%date% %time%] %NIRIO% >>"%userprofile%\Desktop\LatestinstallLog.txt"
"%NIRIO%setup.exe" /qb /r:n /acceptlicenses yes /l c:\rio_inst.log /disableNotificationCheck /confirmCriticalWarnings >>"%userprofile%\Desktop\LatestinstallLog.txt"
xcopy /Y /i /f /s "\\nibataserver\RTFiles\Stack_valdiation_setup\p4tickets.txt" "%userprofile%\" >>"%userprofile%\Desktop\LatestinstallLog.txt"
xcopy /Y /i /f /s "\\nibataserver\RTFiles\Stack_valdiation_setup\GreenwaysFile.bat" "%userprofile%\Desktop\" >>"%userprofile%\Desktop\LatestinstallLog.txt"
xcopy /Y /i /f /s "\\nibataserver\RTFiles\Stack_valdiation_setup\p4tickets.txt" "%userprofile%\"
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2018/test/trunk/CommonSubVIs/...
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2018/test/trunk/executor/...
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2018/test/trunk/tests_auto/...
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2018/rtconn_test/trunk/...
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/InternalTools/Testing/SerenityStackReport/...

net use \\inrd-hemanthkumar /user:apac\nibtest nibtest
Powershell.exe -File "\\inrd-hemanthkumar\shared\software\EmailScript_with para.PS1" -to "hemanth.kumar.kothari@ni.com" -sub "Instalation 2018 SP1"
del %0