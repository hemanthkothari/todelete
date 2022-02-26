net use \\baltic.amer.corp.natinst.com /user:apac\nibtest nibtest
net use \\nibataserver /user:apac\nibtest nibtest
net use \\in-ban-argo\NISoftwarePrerelease /user:apac\nibtest nibtest
net use \\in-ban-fs2.apac.corp.natinst.com /user:apac\nibtest nibtest
net use \\130.164.41.189 /user:amer\lvghosttask labview===
net use \\nirvana.amer.corp.natinst.com /user:apac\nibtest nibtest

Set year=2019
Echo Windows 10 macine , So copying to %userprofile%\Desktop\Labview >>"%userprofile%\Desktop\LatestinstallLog.txt"
Rem Finding latest Labview
FOR /F "delims=" %%i IN ('dir "\\in-ban-argo\NISoftwarePrerelease\LabVIEW\%year%\English\32bit\Daily\" /b /ad-h /t:c /od') DO SET lvlatest=%%i>>"%userprofile%\Desktop\LatestinstallLog.txt"
Echo [%date% %time%] \\in-ban-argo\NISoftwarePrerelease\LabVIEW\%year%\English\32bit\Daily\%lvlatest%\LabVIEW%year%\ >>"%userprofile%\Desktop\LatestinstallLog.txt"
Echo [%date% %time%]**************************************************LabVIEW Start %lvlatest%*************************************************************** >>%userprofile%\Desktop\Installer_Copy.log
xcopy /e /f /i /y /s "\\in-ban-argo.natinst.com\NISoftwarePrerelease\LabVIEW\%year%\English\32bit\Daily\%lvlatest%"  "%userprofile%\Desktop\labview\lv\%lvlatest%"  >>%userprofile%\Desktop\Installer_Copy.log
"%userprofile%\Desktop\labview\lv\%lvlatest%\LabVIEW%year%\setup.exe" /qb /r:n /AcceptLicenses yes /l c:\lv_inst.log /disableNotificationCheck /confirmCriticalWarnings /prop NICEIPNOSEND=0
Echo [%date% %time%]**************************************************LabVIEW End %lvlatest%*************************************************************** >>%userprofile%\Desktop\Installer_Copy.log

Rem Finding latest LabviewRT
FOR /F "delims=" %%i IN ('dir "\\in-ban-argo\nisoftwareprerelease\labview real-time\%year%\english\daily\" /b /ad-h /t:c /od') DO SET RTlatest=%%i
Echo [%date% %time%] \\in-ban-argo\nisoftwareprerelease\labview real-time\%year%\english\daily\%RTlatest%\LVRT%year%\ >>"%userprofile%\Desktop\LatestinstallLog.txt"
Echo [%date% %time%]**************************************************LabVIEW RT Start %RTlatest%*************************************************************** >>%userprofile%\Desktop\Installer_Copy.log
xcopy /e /f /i /y /s "\\in-ban-argo.natinst.com\NISoftwarePrerelease\LabVIEW Real-Time\%year%\English\Daily\%RTlatest%"  "%userprofile%\Desktop\labview\rt\%RTlatest%"  >>%userprofile%\Desktop\Installer_Copy.log
"%userprofile%\Desktop\labview\rt\%RTlatest%\LVRT%year%\setup.exe" /qb /r:n /AcceptLicenses yes /l c:\RT_inst.log /disableNotificationCheck /confirmCriticalWarnings /prop NICEIPNOSEND=0
Echo [%date% %time%]**************************************************LabVIEW RT End %RTlatest%*************************************************************** >>%userprofile%\Desktop\Installer_Copy.log

Rem connect to us-aus-rtweb1
net use \\us-aus-rtweb1 /user:apac\nibtest nibtest >>"%userprofile%\Desktop\LatestinstallLog.txt"
Rem copy the p4 ticket and sync the stable RIO xml
xcopy /Y /i /f /s "\\us-aus-rtweb1\Script Templates\SubScripts\p4tickets.txt"  "%userprofile%" >>"%userprofile%\Desktop\LatestinstallLog.txt"
p4 -p perforce:1666 -c labview_rt-testmachine-perforcetest -u labview_rt sync -f //NIInstallers/DistributionLocators/CompactRIO/19.0.0.xml >>"%userprofile%\Desktop\LatestinstallLog.txt"
Rem read the xml file
@echo off
    setlocal enableextensions disabledelayedexpansion

    set "build="
    for /f "tokens=3 delims=<>" %%a in (
        'find /i "<InputRoot>" ^< "C:\sync\perforce\NIInstallers\DistributionLocators\CompactRIO\19.0.0.xml"'
    ) do set "build=%%a"
 Rem   echo %build%
Rem Replace us-aus to in-ban
set NIRIO=%build%
set NIRIO=%NIRIO:us-aus=in-ban%
set NIRIO=%NIRIO%
echo [%date% %time%] %NIRIO%>>"%userprofile%\Desktop\LatestinstallLog.txt"
echo %NIRIO:~-7%
set NIRIO1=%NIRIO:\\in-ban-argo\NISoftwarePrerelease\NI-RIO\NI CompactRIO\19.0.0\daily\=%
Set NIRIO2=%NIRIO1:\NICRIO=%
echo Build folder name %NIRIO2%
Echo [%date% %time%]**************************************************cRio End %NIRIO2%********************************************************************* >>%userprofile%\Desktop\Installer_Copy.log
xcopy /e /f /i /y /s "\\in-ban-argo.natinst.com\NISoftwarePrerelease\NI-RIO\NI CompactRIO\19.0.0\daily\%NIRIO2%"  "%userprofile%\Desktop\labview\rio\%NIRIO2%"  >>%userprofile%\Desktop\Installer_Copy.log
"%userprofile%\Desktop\labview\rio\%NIRIO2%\NICRIO\setup.exe" /qb /r:n /AcceptLicenses yes /l c:\rio_inst.log /disableNotificationCheck /confirmCriticalWarnings /prop NICEIPNOSEND=0
Echo [%date% %time%]**************************************************cRio End %NIRIO2%********************************************************************* >>%userprofile%\Desktop\Installer_Copy.log


Echo Installing Eclipse
Echo [%date% %time%] \\in-ban-argo.natinst.com\NISoftwareReleased\Windows\Distributions\Eclipse\2017\17.0.0\NIECLIPSE >>"%userprofile%\Desktop\LatestinstallLog.txt"
Echo [%date% %time%]**************************************************Eclipse Start**************************************************************** >>%userprofile%\Desktop\Installer_Copy.log
xcopy /e /f /i /y /s "\\in-ban-argo.natinst.com\NISoftwareReleased\Windows\Distributions\Eclipse\2017\17.0.0"  "%userprofile%\Desktop\labview\eclip\17.0.0"  >>%userprofile%\Desktop\Installer_Copy.log
"%userprofile%\Desktop\labview\eclip\17.0.0\NIECLIPSE\setup.exe" /qb /r:n /AcceptLicenses yes /l c:\Eclip_inst.log /disableNotificationCheck /confirmCriticalWarnings /prop NICEIPNOSEND=0
Echo [%date% %time%]**************************************************Eclipse End****************************************************************** >>%userprofile%\Desktop\Installer_Copy.log
rmdir %userprofile%\Desktop\labview\ /s /q

xcopy /Y /i /f /s "\\nibataserver\RTFiles\Stack_valdiation_setup\p4tickets.txt" "%userprofile%\" >>"%userprofile%\Desktop\LatestinstallLog.txt"
xcopy /Y /i /f /s "\\nibataserver\RTFiles\Stack_valdiation_setup\GreenwaysFile.bat" "%userprofile%\Desktop\" >>"%userprofile%\Desktop\LatestinstallLog.txt"
xcopy /Y /i /f /s "\\nibataserver\RTFiles\Stack_valdiation_setup\p4tickets.txt" "%userprofile%\"
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2019/test/trunk/CommonSubVIs/...
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2019/test/trunk/executor/...
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2019/test/trunk/tests_auto/...
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2019/rtconn_test/trunk/...
p4.exe -p banperforce:1888 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/InternalTools/Testing/SerenityStackReport/...

