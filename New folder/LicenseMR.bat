rem This batch file contains licensing steps for the Main Release of NI products.

rem ----------------

echo Licensing NI Products
\\nirvana.natinst.com\LVPublic\Licensing\GetLicense\GetLicense_CommandLine.exe -- "LabVIEW_PDS_PKG_130000"
\\nirvana.natinst.com\LVPublic\Licensing\GetLicense\GetLicense_CommandLine.exe -- "LabVIEW_RealTime_PKG_130000"
\\nirvana.natinst.com\LVPublic\Licensing\GetLicense\GetLicense_CommandLine.exe -- "LabVIEW_FPGA_PKG_130000"
\\nirvana.natinst.com\LVPublic\Licensing\GetLicense\GetLicense_CommandLine.exe -- "LabVIEW_PIDCtrl_PKG_130000"
\\nirvana.natinst.com\LVPublic\Licensing\GetLicense\GetLicense_CommandLine.exe -- "LabVIEW_AppBuilder_PKG_130000"

rem Uncomment "pause" below to rerun the script (for debugging)
rem pause