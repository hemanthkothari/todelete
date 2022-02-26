Rem This batch file contains test setup steps for the Main Release of NI products.

Rem This file is created by Hemanth kumar Kothari any clarification you can contact hemanth.kumar.kothari@ni.com
Rem Below code is to identify the LV + RT 32Bit installed on the machine " it can be used for both 32 and 64 bit machine but the LV should to be 32Bit"
@ECHO OFF
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
Echo Computer Bit-ness = '%bitness%' and Program file to be refered is = '%bit%'
Echo Finding LabVIEW Version
for  /f "delims=" %%a in ('dir /b /a:d "C:\%bit%\National Instruments" ^|findstr "LabVIEW "') do SET LV=%%a
echo labview Version = %LV:~8,4%
rem ----------------

echo Turn off McAfee to improve performance
net stop mcshield


echo workaround for p4 access for the first time
xcopy /Y /i /f /s "\\us-aus-rtweb2\ScriptINI\p4tickets.txt"  "%userprofile%\"

echo Sync ATS
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/%LV:~8,4%/test/trunk/CommonSubVIs/...
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/%LV:~8,4%/test/trunk/executor/...
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/%LV:~8,4%/test/trunk/tests_auto/...
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/%LV:~8,4%/rtconn_test/trunk/...
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/InternalTools/Testing/SerenityStackReport/...

echo Copying LabVIEW.ini
xcopy /y /i /f /s "\\us-aus-rtweb2\Resources\Scripts\LabVIEW.ini"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\"

Echo IPK setup files
Rem passing lv version as a parameter to the file
call "\\us-aus-rtweb2\Script Templates\SubScripts\IPK.bat" %LV:~8,4%

REM Echo redirect the reports to NIB 'Copying mongoconnect txt'
REM xcopy /Y /i /f /s "\\us-aus-rtweb2\Resources\mongoconn.txt"  "C:\sync\penguin\%LV:~8,4%\test\trunk\executor\LVRT_ATS\SubVIs\Report Generation\Mongo\"

echo Install Mongodb API
cscript \\us-aus-rtweb2\Resources\Apps\installMongo.vbs
REM Below line is just a workaround 
xcopy /e /f /i /y "\\us-aus-rtweb2\Resources\lvmongo"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\user.lib\lvmongo"

echo Enable Faster Deployment
cd C:\sync\penguin\%LV:~8,4%\test\trunk\CommonSubVIs\Framework\DeploymentAPI
cscript UpdateProjectBasedDeploy.vbs

REM echo Workaround to move SysCfg files
REM xcopy /e /f /i /y /s "C:\%bit%\National Instruments\LabVIEW 2020\vi.lib\nisyscfg\*"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\vi.lib\nisyscfg\"
REM xcopy /e /f /i /y /s "C:\%bit%\National Instruments\LabVIEW 2020\resource\objmgr\nisyscfgTag.rch"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\resource\objmgr\"
REM xcopy /e /f /i /y /s "C:\%bit%\National Instruments\LabVIEW 2020\resource\objmgr\nisyscfgRef.rch"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\resource\objmgr\"
REM xcopy /e /f /i /y /s "C:\%bit%\National Instruments\LabVIEW 2020\resource\objmgr\nisysapiRef.rch"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\resource\objmgr\"
REM xcopy /e /f /i /y /s "C:\%bit%\National Instruments\LabVIEW 2020\resource\objmgr\nisysapi.rc"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\resource\objmgr\"
REM xcopy /e /f /i /y /s "C:\%bit%\National Instruments\LabVIEW 2020\resource\vicnvrt\nisyscfg10to12.cvt"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\resource\vicnvrt\"
REM xcopy /e /f /i /y /s "C:\%bit%\National Instruments\LabVIEW 2020\vi.lib\userdefined\nisysapi.ctl"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\vi.lib\userdefined\"
REM xcopy /e /f /i /y /s "C:\%bit%\National Instruments\LabVIEW 2020\vi.lib\userdefined\High Color\nisyscfg.ctl"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\vi.lib\userdefined\High Color\"
REM xcopy /e /f /i /y /s "C:\%bit%\National Instruments\LabVIEW 2020\vi.lib\userdefined\Silver\nisyscfg NI_Silver.ctl"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\vi.lib\userdefined\Silver\"

echo Workaround to move Left Over R1 files to LabVIEW %LV:~8,4%
xcopy /e /f /i /y /s "C:\%bit%\National Instruments\LabVIEW %LV:~8,4% R1\*" "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\"

echo Mass Compiling ATS
"C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\labview.exe" "C:\sync\penguin\%LV:~8,4%\test\trunk\CommonSubVIs\Tools\Mass-Compile\MassCompile.vi" -unattended -- -dir "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\vi.lib\nisyscfg\" -cache 50
"C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\labview.exe" "C:\sync\penguin\%LV:~8,4%\test\trunk\CommonSubVIs\Tools\Mass-Compile\MassCompile.vi" -- -dir "C:\sync\penguin\%LV:~8,4%\test\trunk\CommonSubVIs\" -cache 50
"C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\labview.exe" "C:\sync\penguin\%LV:~8,4%\test\trunk\CommonSubVIs\Tools\Mass-Compile\MassCompile.vi" -- -dir "C:\sync\penguin\%LV:~8,4%\test\trunk\executor\" -cache 50

echo Resync reporting folder (workaround for issue with %LV:~8,4% ATS)
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f "//labviewrt/branches/%LV:~8,4%/test/trunk/executor/LVRT_ATS/Report Generators/..."

Echo syncying the latest install_feed.py
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //lvfpga/distributions/fpga/trunk/20.0/source/tools/dailyTestConfig/Ghost_Files/install_feed.py
xcopy /e /f /i /y "C:\sync\penguin\lvfpga\distributions\fpga\trunk\20.0\source\tools\dailyTestConfig\Ghost_Files\install_feed.py"  "C:\VM_SETUP"

rem echo Installing Simulated IO
rem msiexec /i "\\devimageserver\EIOVA-ATS\scripts\VC9_x86_ReleaseAndDebugCRT.msi" /qn
rem xcopy /e /f /i /y "\\us-aus-rtweb2\Resources\TestIO\labview"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%"
rem xcopy /e /f /i /y "\\us-aus-rtweb2\Resources\TestIO\RTImages"  "C:\%bit%\National Instruments\RT Images"
rem xcopy /e /f /i /y "\\us-aus-rtweb2\Resources\TestIO\NISharedDir"  "C:\%bit%\National Instruments\Shared"
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labview/branches/%LV:~8,4%/dev/source/resource/objmgr/ni.var.file.rc
echo f | xcopy /e /f /i /y "C:\sync\penguin\labview\branches\%LV:~8,4%\dev\source\resource\objmgr\ni.var.file.rc"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\resource\objmgr"

echo Installing latest Simulated IO using Installing GreenwaysFile.bat
call "\\us-aus-rtweb2\Script Templates\SubScripts\GreenwaysFile.bat"

echo Installing Vision tests
xcopy /e /f /i /y "C:\sync\penguin\%LV:~8,4%\rtconn_test\trunk\tests_auto\functionality\VisionImageDatatype\*.dll"  "c:\Windows\System32"
xcopy /e /f /i /y "C:\sync\penguin\%LV:~8,4%\rtconn_test\trunk\tests_auto\functionality\VisionImageDatatype\resource"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\resource"
xcopy /e /f /i /y "C:\sync\penguin\%LV:~8,4%\rtconn_test\trunk\tests_auto\functionality\VisionImageDatatype\vi.lib"  "C:\%bit%\National Instruments\LabVIEW %LV:~8,4%\vi.lib"

echo Setting up CTF tests
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/%LV:~8,4%/test/trunk/tests_ctf/...
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/RTCTF/ATS_CTF_ENV/...
cd C:\sync\penguin\CTFSetup
call InstallRTCTF.bat

rem Uncomment "pause" below to rerun the script (for debugging)
rem pause