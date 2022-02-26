net use \\baltic.amer.corp.natinst.com /user:apac\nibtest nibtest
net use \\nibataserver /user:apac\nibtest nibtest
net use \\in-ban-argo.natinst.com\NISoftwarePrerelease /user:apac\nibtest nibtest
net use \\in-ban-fs2.apac.corp.natinst.com /user:apac\nibtest nibtest
net use \\130.164.41.189 /user:amer\lvghosttask labview===
net use \\nirvana.amer.corp.natinst.com /user:apac\nibtest nibtest

"\\in-ban-argo.natinst.com\nisoftwareprerelease\LabVIEW\2018\English\32bit\Daily\20180321_0033\LabVIEW2018\setup.exe"  /qb /r:n /AcceptLicenses yes /l c:\lv_inst.log /disableNotificationCheck /confirmCriticalWarnings /prop NICEIPNOSEND=0"
"\\in-ban-argo.natinst.com\nisoftwareprerelease\labview real-time\2018\english\daily\20180321_0359\LVRT2018\setup.exe"  /qb /r:n /AcceptLicenses yes /l c:\rt_inst.log /disableNotificationCheck /confirmCriticalWarnings /prop NICEIPNOSEND=0"
"\\in-ban-argo.natinst.com\nisoftwareprerelease\NI-RIO\NI CompactRIO\18.0.0\daily\20180320_2255b9\NICRIO\setup.exe" /qb /r:n /acceptlicenses yes /l c:\cRIO_inst.log /disableNotificationCheck /confirmCriticalWarnings /prop LV2017DETECTED="YES",LV2017RTEDETECTED="YES",RTVERSIONNUMERIC=1700"
"\\in-ban-argo.natinst.com\NISoftwareReleased\Windows\Distributions\Eclipse\2017\17.0.0\NIECLIPSE\setup.exe" /qb /r:n /acceptlicenses yes /l c:\Ecli_inst.log /disableNotificationCheck /confirmCriticalWarnings
xcopy /Y /i /f /s "\\nibataserver\RTFiles\Stack_valdiation_setup\p4tickets.txt" "%userprofile%\"
xcopy /Y /i /f /s "\\nibataserver\RTFiles\Stack_valdiation_setup\GreenwaysFile.bat" "%userprofile%\Desktop\"
echo off
IF "%PROCESSOR_ARCHITECTURE%"=="x86" (set bit=1) ELSE (set bit=2)
IF %bit%==1 (
xcopy /Y /i /f /s "\\nibataserver\RTFiles\Script Templates\SubScripts\TestSetup2018_32.bat" "%userprofile%\Desktop\"
)
IF %bit%==2 (
xcopy /Y /i /f /s "\\nibataserver\RTFiles\Script Templates\SubScripts\TestSetup2018_64.bat" "%userprofile%\Desktop\"
)
shutdown.exe /r /t 20
"\\nibataserver\RTFiles\Script Templates\SubScripts\License2018.bat"