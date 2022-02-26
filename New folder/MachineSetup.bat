Rem created by Hemanth kumar kothari its used for daily ATS
rem This batch file contains test machine setup steps which should run once after imaging.

echo.also copy p4tickets.txt over (overwrite if already there)
xCOPY /Y "\\us-aus-rtweb2\ScriptINI\p4tickets.txt" "%userprofile%\"

echo Turn off McAfee to improve performance
net stop mcshield

echo Disable Windows Error Reporting and security warnings.
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v DontShowUI /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disable /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d 0 /f

echo set NIER userid
reg add "HKEY_CURRENT_USER\Software\National Instruments\Report" /v uniqueId /t REG_SZ /d NI-bfrantz-%computername% /f

rem echo Install LV RTEs
rem "\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW Add-ons\Run-Time Engine\8.2\8.2.1\English\Daily\20070327_1819\setup.exe" /q /r:n /AcceptLicenses yes /l c:\lvrte_inst.log
rem \\us-aus-rtweb2\Resources\LVRTE\8.5\setup.exe /q /r:n /AcceptLicenses yes /l c:\lvrte_inst.log
rem \\us-aus-rtweb2\Resources\LVRTE\9.0\setup.exe /q /r:n /AcceptLicenses yes /l c:\lvrte_inst.log
rem "\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW Add-ons\Run-Time Engine\2011\11.1.0\32-bit\standard\setup.exe" /q /r:n /AcceptLicenses yes /l c:\lvrte_inst.log
rem "\\us-aus-argo.natinst.com\NISoftwareReleased\Windows\Distributions\LabVIEW Add-ons\Run-Time Engine\2013\13.0.0\32-bit\standard\setup.exe" /q /r:n /AcceptLicenses yes /l c:\lvrte_inst.log

Echo refer the BUG for below issue https://ni.visualstudio.com/DevCentral/_workitems/edit/1425857
bcdedit.exe -set TESTSIGNING ON

echo Install Filezilla
\\us-aus-rtweb2\Resources\Apps\filezilla.exe /S

echo Install Silverlight
\\us-aus-rtweb2\Resources\Apps\Silverlight.exe /q

echo Install Chrome
msiexec /qb /i \\us-aus-rtweb2\Resources\Apps\GoogleChromeStandaloneEnterprise.msi

echo Install Notepad++
\\us-aus-rtweb2\Resources\Apps\notepadpp.exe /S

echo Install 7Zip
msiexec /qb /i \\us-aus-rtweb2\Resources\Apps\7z920.msi

echo Install Putty
msiexec /qb /i \\us-aus-rtweb2\Resources\Apps\Quest-PuTTY-0.60_q1.129.msi

echo Install Python
msiexec /qb /i \\us-aus-rtweb2\Resources\Apps\python-2.7.msi TARGETDIR="C:\Python27"
setx PATH "%PATH%;C:\Python27" /M REM This will add it to the system Environment
setx PATH "%PATH%;C:\Python27"

echo Install Perforce
\\us-aus-rtweb2\resources\Apps\p4vinst.exe /v"/qn P4PORT=penguin.natinst.com:1666 P4USER=labview_rt P4CLIENT=labview_rt-testmachine-test REBOOT=ReallySuppress"
rem \\us-aus-rtweb2\resources\Apps\p4vinst.exe /v"/qn P4PORT=penguin.natinst.com:1666 P4USER=bfrantz P4CLIENT=bfrantz-testmachine-test REBOOT=ReallySuppress"

echo Install TestUtil
echo f | xcopy /y /i /f "\\us-aus-rtweb2\Resources\Apps\TestUtil.exe"  "%userprofile%\Desktop"

Echo Add open ssh support for this machine
Powershell.exe "Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'"
Echo Install the OpenSSH Client
Powershell.exe "Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0"
Echo Install the OpenSSH Server
Powershell.exe "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"
REM starting the service for ssh automatically
Powershell.exe "Set-Service -Name sshd -StartupType 'Automatic'"
