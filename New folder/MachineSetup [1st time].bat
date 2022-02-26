Rem created by Hemanth kumar kothari
REm For the 1st time on a clean machine run this and it will set up the machine to use
rem This batch file contains test machine setup steps which should run once after imaging.
net use \\us-aus-argo.natinst.com\NISoftwarePrerelease /user:apac\nibtest nibtest
net use \\baltic.amer.corp.natinst.com /user:apac\nibtest nibtest
net use \\us-aus-rtweb2 /user:apac\nibtest nibtest
net use \\us-aus-argo\NISoftwarePrerelease /user:apac\nibtest nibtest

cd %windir%\system32

Echo Disbaling UAC...
%windir%\System32\reg.exe ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
Echo UAC disabled

Echo Set New computer Name and autologin for this computer
set /p MachineName= Enter 'NEW NAME FOR this Machine' :
wmic computersystem where name="%COMPUTERNAME%" call rename name=%MachineName% 

Echo Enabling Auto admin login...
set /p User= Enter 'Username' :
set /p Pass= Enter 'Password for '%User%'' :
REG ADD "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f
REG ADD "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d %User% /f
REG ADD "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d %Pass% /f
Echo Auto admin login enabled.

Echo Disabling sleep seting
POWERCFG /change standby-timeout-ac 0
POWERCFG /change standby-timeout-dc 0
POWERCFG /change hibernate-timeout-ac 0
POWERCFG /change hibernate-timeout-dc 0
POWERCFG /change monitor-timeout-ac 0
POWERCFG /change monitor-timeout-dc 0

Echo Disabling firewall...
netsh firewall set opmode disable
NetSh Advfirewall set allprofiles state off
rem to see the status
Rem Netsh Advfirewall show allprofiles
Echo Firewall disalbled.

REM Setting India time
Echo To set time
TZUTIL /s "India Standard Time"

if "%PROCESSOR_ARCHITECTURE%"=="x86" (
   Echo Installing '32 bit Perl'
   msiexec /qn /i "\\us-aus-rtweb2\Resources\VM_SETUP_backup\OtherStuff\ActivePerl-5.16.3.1604-MSWin32-x86-298023.msi" TARGETDIR="C:\"
) else (
   Echo Installing '64 bit Perl'
   msiexec /qn /i "\\us-aus-rtweb2\Resources\VM_SETUP_backup\OtherStuff\ActivePerl-5.16.3.1604-MSWin32-x64-298023.msi" TARGETDIR="C:\"
)

REM Below code is used for strawberry perl
REM Echo off
REM IF "%PROCESSOR_ARCHITECTURE%"=="x86" (set bit=1) ELSE (set bit=2)
REM IF %bit%==1 (
REM Echo 32 Bit
REM msiexec /qn /i "\\us-aus-rtweb2\Resources\Apps\strawberry-perl-5.16.3.1-32bit.msi" TARGETDIR="C:\strawberry\"
REM )
REM IF %bit%==2 (
REM Echo 64 Bit
REM msiexec /qn /i "\\us-aus-rtweb2\Resources\Apps\strawberry-perl-5.16.3.1-64bit.msi" TARGETDIR="c:\strawberry\"
REM )
REM perl -MCPAN -e shell cpan shell
REM start cmd /k Echo please enter "install CPAN" and then type "install Config::IniFiles" in the previous 'cammand prompt'

ECHO F | xcopy /y /i /f "\\us-aus-rtweb2\ScriptINI\VM_SETUP\sync_and_run.bat" "C:\VM_SETUP\"
cd "C:\VM_SETUP\"
"\\us-aus-rtweb2\Script Templates\SubScripts\mkshortcut.vbs" /target:"C:\VM_SETUP\sync_and_run.bat" /shortcut:"sync_and_run.bat - Shortcut"
Echo Moving the 'sync_and_run.bat - Shortcut' to '%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\'
move /Y "c:\VM_SETUP\sync_and_run.bat - Shortcut.lnk" "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
move /Y "c:\VM_SETUP\sync_and_run.bat - Shortcut.lnk" "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"

Echo Copying CPU Moniter
ECHO F | xcopy /y /i /f "\\us-aus-rtweb2\Resources\Apps\DesktopInfo151\*" "C:\DesktopInfo151\"
move /Y "C:\DesktopInfo151\DesktopInfo.exe - Shortcut.lnk" "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"

cd %windir%\system32

Echo calling "\\us-aus-rtweb2\Script Templates\SubScripts\MachineSetup.bat" for more setup
call "\\us-aus-rtweb2\Script Templates\SubScripts\MachineSetup.bat"

del /f "%userprofile%\p4tickets.txt"

ECHO Type Yes or NO
set /p RTE= Do you need to install RTE[Run Time Engine]Like  :

if /I "%RTE%"=="yes" (
   Echo Install LV RTEs from "\\us-aus-rtweb2\Script Templates\SubScripts\installOldRTE.bat"
   "\\us-aus-rtweb2\Script Templates\SubScripts\installOldRTE.bat"
) else (
   Echo Not Installed RTE
)

powershell.exe -executionpolicy remotesigned  "\\us-aus-rtweb2\Script Templates\SubScripts\CleanDisk.ps1"

Echo please restart the Machine