@ECHO OFF
setlocal enabledelayedexpansion

REM Array of p4 paths through which to search.  If you add to this array, also add to the 'p4 changes' call.
set p4path[0]=//lvdist/branches/2020/dev/common/...
set p4path[1]=//labview/branches/2020/dev/...
set p4path[2]=//labview/components/dfir/...
set p4path[3]=//labview/components/mgcore/...
set p4path[4]=//labview/components/LVManager/...
set p4path[5]=//labview/components/tdcore/...

:start
REM Query for cl range and trim whitespace
set oldestCl=""
set /p oldestCl="Enter oldest changelist from which to begin search (inclusive): "
call :TrimWhitespace oldestCl %oldestCl%
set newestCl=""
set /p newestCl="Enter newest changelist by which to end search (inclusive): "
call :TrimWhitespace newestCl %newestCl%
set p4args=""
set /p p4args="Enter additional arguments for 'p4 changes' such as "-l" (optional): "
call :TrimWhitespace p4args %p4args%
ECHO.

REM Prep the user with basic information to stdout
ECHO Searching the following CGLV p4 paths for CGLV changelists from %oldestCl% to %newestCl%, inclusive.
for /l %%n in (0,1,5) do (
ECHO penguin:!p4path[%%n]!
)
ECHO Please wait...
ECHO.

REM Do the work and report to stdout.
REM 'p4 changes' filters by p4paths; 'findstr.exe' filters out automated p4 submissions that are of little value to this report
p4 changes %p4args% -s submitted %p4path[0]%@%oldestCl%,@%newestCl% %p4path[1]%@%oldestCl%,@%newestCl% %p4path[2]%@%oldestCl%,@%newestCl% %p4path[3]%@%oldestCl%,@%newestCl% %p4path[4]%@%oldestCl%,@%newestCl% %p4path[5]%@%oldestCl%,@%newestCl% | findstr.exe /v /c:"i-aswcgbld-prod@ni-aswcgbld-prod-2020" /c:"labviewbuild@labviewbuild-mlvbuild" /c:"export_manager@export_manager-pds-fsmgmt" /c:"ni-aswcgbld-prod@ni-aswcgbld-prod-WINDDEPSBUILD-penguin" /c:"ni-aswngbld-prod@ni-aswngbld-prod_lvnginstaller" /c:"ni-aswcgbld-prod@labviewbuild-lnimble-blade"

REM Allow the user to repeat the script if desired
ECHO.
set choice=
set /p choice="Enter 'y' to restart, else exit: "
ECHO.
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='y' goto start
ECHO.

REM Function to cleanup user entries
:TrimWhitespace
SetLocal EnableDelayedExpansion
set Params=%*
for /f "tokens=1*" %%a in ("!Params!") do EndLocal & set %1=%%b
exit /b