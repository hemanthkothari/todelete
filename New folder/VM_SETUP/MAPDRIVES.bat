
echo off
echo Deleting previously mapped drives (if they exist)
Rem the below cammand will remove all the network drive if present and then reconnect it
net use * /DELETE /y

echo Mapping Network Drives

echo Mapping us-aus-rtweb2\Resources
net use J: /persistent:no /user:NI\rtadmin \\us-aus-rtweb2\Resources Labview===

echo Mapping baltic\penguinExports\labviewrt
net use K: /persistent:no /user:NI\rtadmin \\baltic\penguinExports\labviewrt Labview===

echo Mapping baltic.amer.corp.natinst.com\penguinExports\labviewrt
net use L: /persistent:no /user:NI\rtadmin \\baltic.amer.corp.natinst.com\penguinExports\labviewrt Labview===

echo Mapping nirvana
net use M: /persistent:no /user:NI\rtadmin \\nirvana\lvpublic Labview===

echo Mapping nirvana.natinst.com
net use O: /persistent:no /user:NI\rtadmin \\nirvana.natinst.com\lvpublic Labview===

echo Mapping us-aus-argo.natinst.com
net use P: /persistent:no /user:NI\rtadmin \\us-aus-argo.natinst.com\nisoftwarereleased Labview===

echo Mapping us-aus-argo
net use Q: /persistent:no /user:NI\rtadmin \\us-aus-argo\nisoftwarereleased Labview===

REM echo Mapping rtimgserver
REM net use R: /persistent:no /user:NI\rtadmin "\\rtimgserver\Ghost_Files" Labview===
REM net use S: /persistent:no /user:lvadmin "\\rtimgserver\RTATS Scripts" labview===

echo on
