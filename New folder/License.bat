Rem This batch file contains licensing steps for the Main Release and Sp1 of NI products.
Rem this file was created by Hemanth Kothari for any simplification can contact hemanth.kumar.kothari@ni.com.
rem ----------------
@Echo OFF
REM This files works for both RT-64 and RT-32Bit and Also the "Machine Bitness doesnot matter" -- can work in any situation
setlocal enableextensions enabledelayedexpansion
Set Labview=NULL
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
	Rem If Machine is 32 bit then Set the program files and bitness to 32bit
   Set "bit=Program Files"
   Set "bitness=32"
   Echo PROCESSOR_ARCHITECTURE = %PROCESSOR_ARCHITECTURE% and its a 32 bit machine
) else (
	REM If Machine is 64bit Machine.
   REM Find Where 'LabVIEW.exe' is installed on the Machine
   
   for /d /r "C:\Program Files (x86)\National Instruments\" %%d in (LabVIEW.exe) do @if exist "%%d" Set Labview=%%d

	IF /I Not "%Labview%"=="!Labview:LabVIEW.exe=!" (
		Rem If found LabVIEW.exe is 32 Bit
		Set "bit=Program Files (x86)"
		Set "bitness=32"
      Echo Labview path '!Labview!' 32Bit
	) ELSE (
		Rem If found LabVIEW.exe is 64 bit
		Set "bit=Program Files"
		Set "bitness=64"
      Echo Labview path '!Labview!' 64Bit
	)
)
Echo Computer Bit-ness = '%bitness%' and Program file to be refered is = '%bit%'

Echo Finding LabVIEW Folder
 for  /f "delims=" %%a in ('dir /b /a:d "C:\%bit%\National Instruments" ^|findstr "LabVIEW "') do SET LV=%%a
 echo labview Version = '%LV:~10,2%'

ECHO Getting the Version of LabVIEW
Rem F_LVV is Find labView Version
 SET "F_LVV=C:\%bit%\National Instruments\%LV%\LabVIEW.exe"
Rem finding the version "F_LVV:\=\\" this find and replace the '\' with '\\'
 for /f "tokens=2 delims==" %%f in ('wmic datafile where Name^="%F_LVV:\=\\%" get Version /value^|find "="') do set "F_LVVer=%%f"
rem %F_LVVer% it has the labview version
 echo LabVIEW Version = '%F_LVVer%' And Key is = '%LV:~10,2%000%F_LVVer:~5,1%'

Rem Starting Licensing
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_FDS_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_PDS_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_BDS_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_Student_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_CIS_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_AppBuilder_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_RealTime_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_RealTimeD_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_DatabaseTK_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_FPGA_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_FPGAD_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_PIDCtrl -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_ReportGenTK_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_PDSD_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_RemotePanel5_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_RemotePanel20_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_RemotePanel50_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"
"C:\%bit%\National Instruments\Shared\License Manager\NILicensingCmd.exe" -internalSilentActivate -type package -name LabVIEW_RemotePanelUnl_PKG -version %LV:~10,2%000%F_LVVer:~5,1%"

Echo Can licence any NI product
"\\US-AUS-RTWEB2\Resources\Apps\AutoLicense\autolicense.exe"
