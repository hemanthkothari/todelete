rem This batch file contains test machine setup steps which should run once after imaging.

rem --Script setup--
set ProgramFiles32=%ProgramFiles(x86)%
if "%ProgramFiles32%"=="" set ProgramFiles32=%ProgramFiles%

rem -- Remove remote tests until they're working on Linux
cd C:\sync\penguin\2020\test\trunk\tests_auto\functionality_display
python skip_remote_tests.py

rem -- Set Windows theme to "classic" (Aero doesn't seem to work over RDP and Win7 Basic doesn't work with some tests).
Rem Below line has been comented by hemanth.kumar.kothari on June-7-2020 because there is no more Themes called Classic
Rem rundll32.exe %SystemRoot%\system32\shell32.dll,Control_RunDLL %SystemRoot%\system32\desk.cpl desk,@Themes /Action:OpenTheme /file:"C:\Windows\Resources\Ease of Access Themes\classic.theme"

rem wait 10 sec then force reboot (perforce seems to prompt an asynchronous reboot anyway)
rem shutdown -r -t 10

rem ping -n 60 127.0.0.1>nul