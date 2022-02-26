Rem this file is created by 'Hemanth Kumar Kothari' for any clarification you can contact hemanth.kumar.kothari@ni.com
Rem Refer this https://niweb.natinst.com/confluence/display/LV/Scan+Engine+Dummy+Plug+In to install manually installation of 'Scan Engine Dummy Plug In / Greenways'

REM This files is used to install 'Scan Engine Dummy Plug In / Greenways' on any windows machine
REM This files works for both RT-64 and RT-32Bit and Also the "Machine Bitness doesnot matter" -- can work in any situation

@Echo OFF
setlocal enableextensions enabledelayedexpansion
Set Labview=NULL
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
	Rem If Machine is 32 bit then Set the program files and bitness to 32bit
   Set "bit=Program Files"
   Set "bitness=32"
   Set "unzipPath=Program Files"
   Echo PROCESSOR_ARCHITECTURE = %PROCESSOR_ARCHITECTURE% and its a 32 bit machine
) else (
	REM If Machine is 64bit Machine.
   REM Find Where 'LabVIEW.exe' is installed on the Machine
   
   Set "unzipPath=Program Files (x86)"
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

Echo [%date% %time%] 'LabVIEW.exe' Bit-ness= '%bitness%' and Program file to be refered is= '%bit%' unzipPath= '%unzipPath%'
Echo Finding Latest LabVIEW Version installed on the machine
for  /f "delims=" %%a in ('dir /b /a:d "C:\%bit%\National Instruments" ^|findstr "LabVIEW "') do Set LV=%%a
Echo Latest Labview Version installed = '%LV:~8,4%'
goto :find_SIO

REM ********** NOTE ************
Rem for the NEW RT-x64 Bit support of greenways we use the below varioable [GWV stand for Greenways Variable Version]
Rem by default its Set to 'OLD' and this value 'GWV' changed from 2021 onwards
Set GWV=OLD

:find_SIO
2>NUL CALL :CASE_%LV:~8,4% # jump to :CASE_2009, :CASE_2010, etc.
IF ERRORLEVEL 1 CALL :DEFAULT_CASE # if label doesn't exist

EXIT /B

:CASE_2009
  Set SIO=1.1
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:CASE_2010
  Set SIO=2.0
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:CASE_2011
  Set SIO=2.0
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:CASE_2012
  Set SIO=3.0
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:CASE_2013
  Set SIO=3.1
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:CASE_2014
  Set SIO=3.2
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:CASE_2015
  Set SIO=3.3
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:CASE_2016
  Set SIO=3.4
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:CASE_2017
  Set SIO=3.5
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:CASE_2018
  Set SIO=3.6
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:CASE_2019
  Set SIO=3.7
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:CASE_2020
  Set SIO=3.8
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:CASE_2021
  Set SIO=21.0
  Set GWV=NEW
  VER > NUL # reSet ERRORLEVEL
  GOTO END_CASE1
:DEFAULT_CASE
  Echo Error With LabVIEW Version '%LV:~8,4%' "NO CASE DEFINED FOR IT"
  Echo Please Define a case to this '%LV:~8,4%' Version and then try to run this script ;)
  Echo If still, it doesn't work contact "Hemanth Kumar Kothari"
  EXIT /B
:END_CASE
  VER > NUL # reSet ERRORLEVEL
  GOTO :EOF # return from CALL
:END_CASE1

Echo Mapping Baltic\penguinExports\labviewrt to 'R:' directory
net use R: /persistent:no /user:apac\nibtest \\baltic\penguinExports\labviewrt nibtest

Echo Install '7Zip' to extract file
"\\in-ban-rtweb1\Resources\Apps\7zip.exe" /S

Echo [%date% %time%] Finding Latest 'Scan Engine Dummy Plug In / Greenways' in Baltic for '%SIO%'
Echo [%date% %time%] Start Copying files to '%bit%' from Baltic 
FOR /F "delims=" %%i IN ('dir "\\baltic\penguinExports\labviewrt\Industrial\testStack\export\%SIO%\" /b /ad-h /t:c /od') DO Set latest=%%i
Echo [%date% %time%] Labview='%LV%' SimulatedIO Version='%SIO%' Latest_simulatedIO Version='%latest%'
Echo [%date% %time%] Copying Simulated IO in '%bit%' because Installed Labview is a = '%bitness%'
xcopy /e /f /i /y /s "\\baltic\penguinExports\labviewrt\Industrial\testStack\export\%SIO%\%latest%\RTImages"  "C:\%bit%\National Instruments\RT Images"

if "NEW" NEQ "%GWV%" (
	Echo Greenways untill 3.8: '%GWV%' RT was only 32 bit
	xcopy /e /f /i /y /s "\\baltic\penguinExports\labviewrt\Industrial\testStack\export\%SIO%\%latest%\labview"  "C:\%bit%\National Instruments\%LV%"
	xcopy /e /f /i /y /s "\\baltic\penguinExports\labviewrt\Industrial\testStack\export\%SIO%\%latest%\NISharedDir"  "C:\%bit%\National Instruments\Shared"
) else (
	Echo Greenways above 21.0: '%GWV%' as after that RT started to supporting both 32 and 64 RT-Installer
	xcopy /e /f /i /y /s "\\baltic\penguinExports\labviewrt\Industrial\testStack\export\%SIO%\%latest%\labview\win%bitness%U"  "C:\%bit%\National Instruments\%LV%"
	xcopy /e /f /i /y /s "\\baltic\penguinExports\labviewrt\Industrial\testStack\export\%SIO%\%latest%\NISharedDir\win%bitness%U"  "C:\%bit%\National Instruments\Shared"
)

Echo Make Directory called 'linux' in '%userprofile%\Desktop\'
cd "%userprofile%\Desktop"
mkdir linux
Echo Past the '.zip' file to '%userprofile%\Desktop\linux\' directory
copy /Y "\\baltic\penguinExports\labviewrt\Industrial\testStack\export\%SIO%\%latest%\.archives\linux.zip"  "%userprofile%\Desktop\linux"
for /R "%userprofile%\Desktop\linux" %%I IN ("*.zip") DO (
    "C:\%unzipPath%\7-Zip\7z.exe" x -y -o"%%~dpI" "%%I" 
   )
xcopy /e /f /i /y /s "%userprofile%\Desktop\linux\RTImages"  "C:\%bit%\National Instruments\RT Images"
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labview/branches/%LV:~8,4%/dev/source/resource/objmgr/ni.var.file.rc
Echo F | xcopy /f /i /Y "C:\sync\penguin\labview\branches\%LV:~8,4%\dev\source\resource\objmgr\ni.var.file.rc"  "C:\%bit%\National Instruments\%LV%\resource\objmgr"
)

VER > NUL # reSet ERRORLEVEL