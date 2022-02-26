REM Author Hemanth Kumar Kothari [hemanth.kumar.kothari@ni.com]
REM This files is used to set up moblise for RTATS

"\\us-aus-rtweb2\Resources\Apps\python-3.7.0.exe" /passive InstallAllUsers=1 PrependPath=1 Include_test=0 TargetDir=C:\Python37\

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
Echo Finding LabVIEW Version
for  /f "delims=" %%a in ('dir /b /a:d "C:\%bit%\National Instruments" ^|findstr "LabVIEW "') do SET LV=%%a
echo labview Version = %LV:~8,4%
Rem taking parameter from cammandline
if "%~1"=="" (
	Rem Finding the LV version and then setting the year value
	echo No parameters have been provided.
	set year=%LV:~8,4%
) else (
	Rem setting the year value which is passed in CMD 
    set year=%1
	echo Parameters passes was:%*
)

setx PATH "%PATH%;C:\Python37\Scripts" /M
setx PATH "%PATH%;C:\Python37\Scripts"
setx PATH "%PATH%;C:\Python37" /M
setx PATH "%PATH%;C:\Python37"
C:\Python37\python.exe -m pip install --upgrade pip
C:\Python37\Scripts\pip install --index-url http://nib-pypi --trusted-host nib-pypi arcadia_mobilize_adapter

echo Copying ctt-infra-libs and setting to PythonPath
robocopy /MIR "\\us-aus-rtweb2\ScriptINI\ctt-infra-libs" "C:\ctt-infra-libs"
setx PythonPath C:\ctt-infra-libs /m

echo Installing from C:\ctt-infra-libs\CG\SetupRT\requirements.txt
C:\Python37\Scripts\pip install -r "C:\ctt-infra-libs\CG\SetupRT\requirements.txt"

echo workaroud till testing for IPK is complted
COPY /Y "\\us-aus-rtweb2\ScriptINI\Hemanth\Test_Install_IPK.vi" "C:\sync\penguin\%year%\test\trunk\tests_auto\special\installers\Target_Prep_PXI-Linux\"
COPY /Y "\\us-aus-rtweb2\ScriptINI\Hemanth\test_allsw_IPK_Linux_Moblise.xml" "C:\sync\penguin\%year%\test\trunk\tests_auto\special\installers\Target_Prep\"
COPY /Y "\\us-aus-rtweb2\ScriptINI\Hemanth\Test_allsw_IPK_Linux_Moblise.vi" "C:\sync\penguin\%year%\test\trunk\tests_auto\special\installers\Target_Prep\"
COPY /Y "\\us-aus-rtweb2\ScriptINI\Hemanth\Target_Prep_AllSW_IPK.xml" "C:\sync\penguin\%year%\test\trunk\tests_auto\special\installers\Target_Prep\"
COPY /Y "\\us-aus-rtweb2\ScriptINI\Hemanth\test_allsw_IPK_Linux_Moblise_UI.xml" "C:\sync\penguin\%year%\test\trunk\tests_auto\special\installers\Target_Prep\"
COPY /Y "\\us-aus-rtweb2\ScriptINI\Hemanth\Test_allsw_IPK_Linux_Moblise_UI.vi" "C:\sync\penguin\%year%\test\trunk\tests_auto\special\installers\Target_Prep\"
COPY /Y "\\us-aus-rtweb2\ScriptINI\Hemanth\Target_Prep_AllSW_IPK_UI.xml" "C:\sync\penguin\%year%\test\trunk\tests_auto\special\installers\Target_Prep\"
