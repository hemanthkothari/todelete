rem This batch file contains test setup steps for the Main Release of NI products.

rem ----------------

echo Turn off McAfee to improve performance
net stop mcshield


echo workaround for p4 access for the first time
xcopy /Y /i /f /s "\\us-aus-rtweb2\ScriptINI\p4tickets.txt"  "%userprofile%\"

echo Sync ATS
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2020/test/trunk/CommonSubVIs/...
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2020/test/trunk/executor/...
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2020/test/trunk/tests_auto/...
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2020/rtconn_test/trunk/...
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/InternalTools/Testing/SerenityStackReport/...

echo Copying LabVIEW.ini
xcopy /y /i /f /s "\\us-aus-rtweb2\Resources\Scripts\LabVIEW.ini"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\"

Echo IPK setup files 'ctt-infra-libs' and sertting it as PythonPath
pip install --index-url http://nib-pypi --trusted-host nib-pypi mi_atsrunner
robocopy /MIR "\\us-aus-rtweb2\ScriptINI\ctt-infra-libs" "C:\ctt-infra-libs"
setx PythonPath C:\ctt-infra-libs /m

rem Echo redirect the reports to NIB 'Copying mongoconnect txt'
rem xcopy /Y /i /f /s "\\us-aus-rtweb2\Resources\mongoconn.txt"  "C:\sync\penguin\2020\test\trunk\executor\LVRT_ATS\SubVIs\Report Generation\Mongo\"

echo Install Mongodb API
cscript \\us-aus-rtweb2\Resources\Apps\installMongo.vbs

echo Enable Faster Deployment
cd C:\sync\penguin\2020\test\trunk\CommonSubVIs\Framework\DeploymentAPI
cscript UpdateProjectBasedDeploy.vbs

REM echo Workaround to move SysCfg files
REM xcopy /e /f /i /y /s "C:\Program Files (x86)\National Instruments\LabVIEW 2019\vi.lib\nisyscfg\*"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\vi.lib\nisyscfg\"
REM xcopy /e /f /i /y /s "C:\Program Files (x86)\National Instruments\LabVIEW 2019\resource\objmgr\nisyscfgTag.rch"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\resource\objmgr\"
REM xcopy /e /f /i /y /s "C:\Program Files (x86)\National Instruments\LabVIEW 2019\resource\objmgr\nisyscfgRef.rch"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\resource\objmgr\"
REM xcopy /e /f /i /y /s "C:\Program Files (x86)\National Instruments\LabVIEW 2019\resource\objmgr\nisysapiRef.rch"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\resource\objmgr\"
REM xcopy /e /f /i /y /s "C:\Program Files (x86)\National Instruments\LabVIEW 2019\resource\objmgr\nisysapi.rc"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\resource\objmgr\"
REM xcopy /e /f /i /y /s "C:\Program Files (x86)\National Instruments\LabVIEW 2019\resource\vicnvrt\nisyscfg10to12.cvt"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\resource\vicnvrt\"
REM xcopy /e /f /i /y /s "C:\Program Files (x86)\National Instruments\LabVIEW 2019\vi.lib\userdefined\nisysapi.ctl"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\vi.lib\userdefined\"
REM xcopy /e /f /i /y /s "C:\Program Files (x86)\National Instruments\LabVIEW 2019\vi.lib\userdefined\High Color\nisyscfg.ctl"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\vi.lib\userdefined\High Color\"
REM xcopy /e /f /i /y /s "C:\Program Files (x86)\National Instruments\LabVIEW 2019\vi.lib\userdefined\Silver\nisyscfg NI_Silver.ctl"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\vi.lib\userdefined\Silver\"

echo Workaround to move Left Over R1 files to LabVIEW 2020
xcopy /e /f /i /y /s "C:\Program Files (x86)\National Instruments\LabVIEW 2020 R1\*" "C:\Program Files (x86)\National Instruments\LabVIEW 2020\"

echo Mass Compiling ATS
"C:\Program Files (x86)\National Instruments\LabVIEW 2020\labview.exe" "C:\sync\penguin\2020\test\trunk\CommonSubVIs\Tools\Mass-Compile\MassCompile.vi" -unattended -- -dir "C:\Program Files (x86)\National Instruments\LabVIEW 2020\vi.lib\nisyscfg\" -cache 50
"C:\Program Files (x86)\National Instruments\LabVIEW 2020\labview.exe" "C:\sync\penguin\2020\test\trunk\CommonSubVIs\Tools\Mass-Compile\MassCompile.vi" -- -dir "C:\sync\penguin\2020\test\trunk\CommonSubVIs\" -cache 50
"C:\Program Files (x86)\National Instruments\LabVIEW 2020\labview.exe" "C:\sync\penguin\2020\test\trunk\CommonSubVIs\Tools\Mass-Compile\MassCompile.vi" -- -dir "C:\sync\penguin\2020\test\trunk\executor\" -cache 50

echo Resync reporting folder (workaround for issue with 2020 ATS)
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f "//labviewrt/branches/2020/test/trunk/executor/LVRT_ATS/Report Generators/..."

Echo syncying the latest install_feed.py
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //lvfpga/distributions/fpga/trunk/20.0/source/tools/dailyTestConfig/Ghost_Files/install_feed.py
xcopy /e /f /i /y "C:\sync\penguin\lvfpga\distributions\fpga\trunk\20.0\source\tools\dailyTestConfig\Ghost_Files\install_feed.py"  "C:\VM_SETUP"

rem echo Installing Simulated IO
rem msiexec /i "\\devimageserver\EIOVA-ATS\scripts\VC9_x86_ReleaseAndDebugCRT.msi" /qn
rem xcopy /e /f /i /y "\\us-aus-rtweb2\Resources\TestIO\labview"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020"
rem xcopy /e /f /i /y "\\us-aus-rtweb2\Resources\TestIO\RTImages"  "C:\Program Files (x86)\National Instruments\RT Images"
rem xcopy /e /f /i /y "\\us-aus-rtweb2\Resources\TestIO\NISharedDir"  "C:\Program Files (x86)\National Instruments\Shared"
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labview/branches/2020/dev/source/resource/objmgr/ni.var.file.rc
echo f | xcopy /e /f /i /y "C:\sync\penguin\labview\branches\2020\dev\source\resource\objmgr\ni.var.file.rc"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\resource\objmgr"

echo Installing latest Simulated IO using Installing GreenwaysFile.bat
call "\\us-aus-rtweb2\Script Templates\SubScripts\GreenwaysFile.bat"

echo Installing Vision tests
xcopy /e /f /i /y "C:\sync\penguin\2020\rtconn_test\trunk\tests_auto\functionality\VisionImageDatatype\*.dll"  "c:\Windows\System32"
xcopy /e /f /i /y "C:\sync\penguin\2020\rtconn_test\trunk\tests_auto\functionality\VisionImageDatatype\resource"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\resource"
xcopy /e /f /i /y "C:\sync\penguin\2020\rtconn_test\trunk\tests_auto\functionality\VisionImageDatatype\vi.lib"  "C:\Program Files (x86)\National Instruments\LabVIEW 2020\vi.lib"

echo Setting up CTF tests
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/branches/2020/test/trunk/tests_ctf/...
p4.exe -p penguin:1666 -u labview_rt -c labview_rt-testmachine-test sync -f //labviewrt/RTCTF/ATS_CTF_ENV/...
cd C:\sync\penguin\CTFSetup
call InstallRTCTF.bat

rem Uncomment "pause" below to rerun the script (for debugging)
rem pause