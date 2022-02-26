REM Author Hemanth Kumar Kothari [hemanth.kumar.kothari@ni.com]
@Echo off
REM For this setup to run you need 'VMware vSphere CLI & PsExec' the PsExec should be copyed to the same location where the VMware vSphere CLI is installed.
   Rem to find VMX path use 'vmware-cmd.pl -H lviat -U user -P password -l'

Rem Find the Day
reg copy "HKCU\Control Panel\International" "HKCU\Control Panel\International-Temp" /f >nul
reg add "HKCU\Control Panel\International" /v sShortDate /d "ddd" /f >nul
Set DOW=%DATE%

REM deleting LatestinstallLog.txt since it is no longer required Because all the data from the file is appended to Ceip.log
del /f %userprofile%\Desktop\LatestinstallLog.txt

Rem Finds the Week_In_Month[Week of the Month]
For /F "delims=" %%i in ('wmic path Win32_LocalTime get WeekInMonth /value^|find "="') do Set /a %%i

IF "%PROCESSOR_ARCHITECTURE%"=="x86" (set "bit=Program Files") ELSE (set "bit=Program Files (x86)")
echo C:\%bit%\VMware\VMware vSphere CLI\bin
CD "C:\%bit%\VMware\VMware vSphere CLI\bin"  >>%userprofile%\Desktop\LatestinstallLog.txt
set year=%1

:find_SIO
2>NUL CALL :%WeekInMonth% # jump to :1, :2, :3,etc.
IF ERRORLEVEL 1 CALL :DEFAULT_CASE # if label doesn't exist

EXIT /B

:1
Rem IF it is 1st Week of the Month then Win 7 Sp1
   Set OS="""Win 7SP1"""
   Set revert_vm1=rtatsvm-4
   Set revert_vm2=rtatsvm-5
   set subjectEmail="""CEIP RUNS %year% OS %OS%"""
   Set body="""%subjectEmail% Dont use %revert_vm1% and %revert_vm2%. Log Files are attached in the mail"""
   Set revert_vm_id=/vmfs/volumes/55351f5e-18a66bcd-5ccc-549f3515f8b6/RTATSVM-4_/RTATSVM-4_.vmx /vmfs/volumes/5acf51ff-9f634577-21b4-549f3515e81e/rtatsvm-5/rtatsvm-5.vmx
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE1
:2
Rem IF it is 1st Week of the Month then Win 8.1
   Set OS="""Win 8.1"""
   Set revert_vm1=rtatsvm-2
   Set revert_vm2=rtatsvm-3
   set subjectEmail="""CEIP RUNS %year% OS %OS%"""
   Set body="""%subjectEmail% Dont use %revert_vm1% and %revert_vm2%. Log Files are attached in the mail"""
   Set revert_vm_id=/vmfs/volumes/583c08ad-d4b9fc40-3683-c81f66f62e51/rtatsvm-2/rtatsvm-2.vmx /vmfs/volumes/591add76-7e380fed-0cb5-549f3515f8b6/rtatsvm-3/rtatsvm-3.vmx
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE1
:3
Rem IF it is 1st Week of the Month then Win 10
   Set OS="""Win 10"""
   Set revert_vm1=rtatsvm-7
   Set revert_vm2=rtatsvm-10
   set subjectEmail="""CEIP RUNS %year% OS %OS%"""
   Set body="""%subjectEmail% Dont use %revert_vm1% and %revert_vm2%. Log Files are attached in the mail"""
   Set revert_vm_id=/vmfs/volumes/4f4fcdda-f902880a-b7bf-d067e5fc2af8/rtatsvm-7_1/rtatsvm-.vmx /vmfs/volumes/55351f5e-18a66bcd-5ccc-549f3515f8b6/RTATSVM-10/RTATSVM-1.vmx
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE1
:4
Rem IF it is 1st Week of the Month then Win 7 Sp1
   Set OS="""Win 7SP1"""
   Set revert_vm1=rtatsvm-4
   Set revert_vm2=rtatsvm-5
   set subjectEmail="""CEIP RUNS %year% OS %OS%"""
   Set body="""%subjectEmail% Dont use %revert_vm1% and %revert_vm2%. Log Files are attached in the mail"""
   Set revert_vm_id=/vmfs/volumes/55351f5e-18a66bcd-5ccc-549f3515f8b6/RTATSVM-4_/RTATSVM-4_.vmx /vmfs/volumes/5acf51ff-9f634577-21b4-549f3515e81e/rtatsvm-5/rtatsvm-5.vmx
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE1
:5
Rem IF it is 1st Week of the Month then Win 8.1
   Set OS="""Win 8.1"""
   Set revert_vm1=rtatsvm-2
   Set revert_vm2=rtatsvm-3
   set subjectEmail="""CEIP RUNS %year% on Windows OS %OS%"""
   Set body="""%subjectEmail% Dont use %revert_vm1% and %revert_vm2%. Log Files are attached in the mail"""
   Set revert_vm_id=/vmfs/volumes/583c08ad-d4b9fc40-3683-c81f66f62e51/rtatsvm-2/rtatsvm-2.vmx /vmfs/volumes/591add76-7e380fed-0cb5-549f3515f8b6/rtatsvm-3/rtatsvm-3.vmx
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE1
:6
   Set OS="""What to Do"""
   Set revert_vm1=""
   Set revert_vm2=""
   Set revert_vm_id=""
   set subjectEmail="""What to do for CEIP RUNS today ?"""
   Set body="""Plan to trigger"""
  VER > NUL # reset ERRORLEVEL
  GOTO END_CASE1
:DEFAULT_CASE
  ECHO [%date% %time%] Error Cant execute it today Because Week_In_Month = %WeekInMonth% and DAY = %DATE% "</br>" >>%userprofile%\Desktop\LatestinstallLog.txt
  Echo ******************************************* [%date% %time%] *************************************>>c:\Ceip.log
  Type %userprofile%\Desktop\LatestinstallLog.txt >>c:\Ceip.log
  del /f %userprofile%\Desktop\LatestinstallLog.txt
  EXIT /B
:END_CASE
  VER > NUL # reset ERRORLEVEL
  GOTO :EOF # return from CALL
:END_CASE1

	   IF %DATE%==Wed (
	Echo Week_of_Month = %WeekInMonth% and DAY = %DATE%, Trigger on Machine\VM name = %revert_vm1% and %revert_vm2% OS = %OS% "</br>" >>%userprofile%\Desktop\LatestinstallLog.txt
	Rem reverting the VM's
	For %%a in (%revert_vm_id%) do (
		Echo "</br>" [%date% %time%] Reverting %%a >>%userprofile%\Desktop\LatestinstallLog.txt
			perl vmware-cmd.pl -H "10.164.43.31" -U root -P INpwdAdm!n "%%a" revertsnapshot >>%userprofile%\Desktop\LatestinstallLog.txt
		)
	Rem wait for 50 sec before going to next line of code
	 TIMEOUT /T 50 
	 
	Rem copying to startup location
	Echo "</br>" [%date% %time%] Copying 'Sync_and_Run.bat' to %revert_vm1% and %revert_vm2% >>%userprofile%\Desktop\LatestinstallLog.txt
		PsExec.exe \\%revert_vm1% -u lvadmin -p labview=== robocopy "\\in-ban-rtweb1\RTFiles_NIB\CEIP Scripts\%year%\Startup" "C:\Users\lvadmin\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" >>%userprofile%\Desktop\LatestinstallLog.txt
	Echo "</br>" >>%userprofile%\Desktop\LatestinstallLog.txt
		PsExec.exe \\%revert_vm2% -u lvadmin -p labview=== robocopy "\\in-ban-rtweb1\RTFiles_NIB\CEIP Scripts\%year%\Startup" "C:\Users\lvadmin\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" >>%userprofile%\Desktop\LatestinstallLog.txt
	
	
	Rem Restarting the vm's
	For %%a in (%revert_vm_id%) do (
		Echo "</br>" [%date% %time%] Restarting %%a >>%userprofile%\Desktop\LatestinstallLog.txt
			perl vmware-cmd.pl -H "10.164.43.31" -U root -P INpwdAdm!n "%%a" reset soft >>%userprofile%\Desktop\LatestinstallLog.txt
		)

		Rem Sends a mail with the content of LatestinstallLog.txt as the body of the E-mail
		Rem in the 'to' parameter you can specify email using comma separated like -to "Hemanth.kumar.kothari@ni.com,krupa.jois@ni.com"
		    Rem """ are given because to send space to the power shell script
		 Powershell.exe -executionpolicy remotesigned -File "D:\RTFiles_NIB\CEIP Scripts\EmailScript_with para.PS1" -from "CEIP2019SP1@ni.com" -to "Hemanth.kumar.kothari@ni.com" -sub "%subjectEmail%" -file "%userprofile%\Desktop\LatestinstallLog.txt" -BodyMessage "%body%"

	Echo ******************************************* [%date% %time%] *************************************>>D:\Test Management\Overlord\Logs\CEIP\Ceip%year%.log
		TIMEOUT /T 50
	REM copy the enter log from LatestinstallLog.txt -> Ceip%year%.log
	Type %userprofile%\Desktop\LatestinstallLog.txt >>D:\Test Management\Overlord\Logs\CEIP\Ceip%year%.log
	
	
	)
VER > NUL # reset ERRORLEVEL