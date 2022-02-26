rem This batch file contains licensing steps for the Main Release of NI products.

rem ----------------

echo Licensing NI Products
\\nirvana.natinst.com\LVPublic\Licensing\GetLicense\GetLicense_CommandLine.exe -- "LabVIEW_PDS_PKG_120001"
\\nirvana.natinst.com\LVPublic\Licensing\GetLicense\GetLicense_CommandLine.exe -- "LabVIEW_RealTime_PKG_120001"
\\nirvana.natinst.com\LVPublic\Licensing\GetLicense\GetLicense_CommandLine.exe -- "LabVIEW_PIDCtrl_PKG_120000"
\\nirvana.natinst.com\LVPublic\Licensing\GetLicense\GetLicense_CommandLine.exe -- "LabVIEW_AppBuilder_PKG_120001"

rem Uncomment "pause" below to rerun the script (for debugging)
rem pause