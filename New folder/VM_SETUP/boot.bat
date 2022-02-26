echo off
C:
cd "C:\VM_SETUP"
echo Initiating installer script.
echo Check "C:\VM_SETUP\scriptOut.log" for log file
echo
echo This window will close once the script has finished executing.
echo Please wait...
perl bootscript.pl 1>>scriptOut.log 2>&1

