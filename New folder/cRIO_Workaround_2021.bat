REM Author Manasa H R [manasa.h.r@ni.com]
Rem For the server after and before drivers logs copied to temp location
echo off
systeminfo | findstr /B /C:"OS Name"
set TempString=%OS Name%
set temp1="Server"
if "%TempString%"=="%temp1%" goto notFound
robocopy "%USERPROFILE%\Desktop\NgLVInstaller" C:\Users\%username%\AppData\Local\Temp\NgLVInstaller"
goto deltacopy
:notFound
goto deltacopy
Rem copies the cRIO files form LV2020 to LV2021
:deltacopy
"C:\Python37\python.exe" "C:\VM_SETUP\cRIOSetup.py"