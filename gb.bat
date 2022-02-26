@ECHO OFF
for /f "tokens=1-3" %a in ('WMIC LOGICALDISK GET FreeSpace^,Name^,Size ^|FINDSTR /I /V "Name"') do @echo wsh.echo "%b" ^& " free=" ^& FormatNumber^(cdbl^(%a^)/1024/1024/1024, 2^)^& " GB"^& " size=" ^& FormatNumber^(cdbl^(%c^)/1024/1024/1024, 2^)^& " GB" > %temp%\tmp.vbs & @if not "%c"=="" @echo( & @cscript //nologo %temp%\tmp.vbs & del %temp%\tmp.vbs "%userprofile%\Desktop\vm.txt"
