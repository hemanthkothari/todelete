echo off

cls

echo Installs the ghost service and brings up the Ghost tray icon 
echo should service fail to re-install after cloning.

cd "C:\Program Files\Symantec\Ghost"
ngctw32.exe -install
ngtray.exe

EXIT