@echo OFF

REM This should run on startup. 
REM Determine correct script.ini file based on machine name and copy it if it doesn't exist locally.
REM Then call boot.bat regardless.
attrib -R C:\VM_SETUP\* /S
if exist C:\VM_SETUP\script.ini (
	echo.Found script.ini, don't copy it.
) else (
	echo.script.ini not found, copy it from folder on \\us-aus-rtweb2.
	net use V: /persistent:no /user:amer\lvghosttask "\\us-aus-rtweb2\ScriptINI" 3LabVIEW1=!
	Rem then below if is added by Hemanth Kumar Kothari
	if not exist V:\ (
		Rem Try with a different Crededtials
		net use V: /persistent:no /user:NI\RTadmin "\\us-aus-rtweb2\ScriptINI" Labview===
	)
	echo.also copy all the files from the folder VM_SETUP (overwrite if already there)
	XCOPY /Y /E "V:\VM_SETUP\*" "C:\VM_SETUP\"
	COPY "V:\Test\%COMPUTERNAME%\*" "C:\VM_SETUP\"
	echo.also copy p4tickets.txt over (overwrite if already there)
	COPY /Y "V:\p4tickets.txt" "%userprofile%\p4tickets.txt"
	Echo refer the BUG for below issue https://ni.visualstudio.com/DevCentral/_workitems/edit/1425857
	bcdedit.exe -set TESTSIGNING ON
)


REM run boot.bat
C:\VM_SETUP\boot.bat