##################################################################################  
# Author Hemanth Kumar Kothari
# Purpose: DiskCleanUp
# Deleting unwanted stuff from the Machine
##################################################################################  
 
## Variables ####
    
    # Running Disk Clean up Tool  
    write-Host "Tick All the option which are applicable for you to delete" -ForegroundColor Yellow 
    cleanmgr /sageset:1 | out-Null
   
    $objShell = New-Object -ComObject Shell.Application   
    $objFolder = $objShell.Namespace(0xA)  
    
    # Get System Drive in other words get OS drive
    $OSDrive = (Get-WmiObject Win32_OperatingSystem).SystemDrive 
      
    # temp files located in "C:\Users\USERNAME\AppData\Local\Temp" 
    $temp = get-ChildItem "env:\TEMP"   
    $temp2 = $temp.Value   
    
    # Folder and Files to be deleted
    $WinTemp = @("$temp2\*","$OSDrive\Windows\Logs\*","$OSDrive\Windows\SoftwareDistribution\*","$OSDrive\Windows\Temp\*")
      
 # Deleting the Files
 $WinTemp | ForEach-Object {
        write-Host "Removing Junk files in $temp2." -ForegroundColor Magenta    
        Remove-Item -Recurse  "$PSItem" -Force -Verbose
    }
  
# Empty Recycle Bin # http://demonictalkingskull.com/2010/06/empty-users-recycle-bin-with-powershell-and-gpo/   
    write-Host "Emptying Recycle Bin." -ForegroundColor Cyan    
    $objFolder.items() | %{ remove-item $_.path -Recurse -Confirm:$false}   
      
# Running Disk Clean up Tool    
    write-Host "Finally now , Running Windows disk Clean up Tool" -ForegroundColor DarkRed   
    cleanmgr /sagerun:1 | out-Null    
       
    $([char]7)   
    Sleep 1    
    $([char]7)   
    Sleep 1   
    write-Host "Clean Up Task Finished !!!" -ForegroundColor Green