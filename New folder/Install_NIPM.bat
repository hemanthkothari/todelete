Rem to install Verified and Latest NIPM
Rem To be removed when Rio workaround is removed
FOR /F "delims=" %%i IN ('dir "\\us-aus-argo\ni\nipkg\Package Manager\" /b /ad-h /t:w /od') DO SET NIPKGlatestV=%%i
for /d /r "\\us-aus-argo\ni\nipkg\Package Manager\%NIPKGlatestV%" %%d in (verified) do @if exist "%%d" SET NIPKGlatest=%%d
 Echo [%date% %time%] %NIPKGlatest:~0,-8%
  "%NIPKGlatest:~0,-8%\Install.exe" --passive --accept-eulas --prevent-reboot
  
