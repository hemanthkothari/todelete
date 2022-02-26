##################################################################################  
# Author Hemanth Kumar Kothari
# Purpose: DiskCleanUp
# Deleting unwanted stuff from the Machine in a certain folder
##################################################################################  
 

param (
    
    # Drives to check: set to $null or empty to check all local (non-network) drives
    # $drivesToMoniter = @("C","D"); or $drivesToMoniter = $null;
    [Parameter(Mandatory=$true)][string]$drivesToMoniter,
    
    [Parameter(Mandatory=$true)][string]$email_to_addressArray,
    
    # Delete all Files in $Folder older than $ThresholdDays
    [Parameter(Mandatory=$true)][int]$ThresholdDays

    )

# The minimum disk size to check for raising the warning
$minGbThreshold = 20GB;
# $minGbThreshold.GetType()



# SMTP configuration: username, password & so on
$email_username = "hemanth.kumar.kothari@ni.com";
$email_password = "yourpassword";
$email_smtp_host = "mailout.natinst.com";
$email_smtp_port = 25;
$email_smtp_SSL = 0;
$email_from_address = "RunningLowHDD@ni.com";


while($true){

if ($drivesToMoniter -eq $null -Or $drivesToMoniter -lt 1) {
    $localVolumes = Get-WMIObject win32_volume;
    $drivesToMoniter = @();
    foreach ($vol in $localVolumes) {
        if ($vol.DriveType -eq 3 -And $vol.DriveLetter -ne $null ) {
            $drivesToMoniter += $vol.DriveLetter[0];
        }
    }
}


    # Delete Files from a perticular folder
    $Folder = @("C:\Program Files\National Instruments\Shared\ATS\temp","C:\NIFPGA\compilation","C:\Program Files (x86)\National Instruments\Shared\ATS\temp")
    $Folder | ForEach-Object {
        # Delete all Files in $Folder older than $ThresholdDays
        # $ThresholdDays = "0"
        Write-Host ("Checking In the Folder '" + $PSItem + "'")
        Get-ChildItem $PSItem | Select-Object Name,CreationTime,@{n='AgeInDays';e={(New-TimeSpan -Start $PSItem.CreationTime).Days}}
        Get-ChildItem –Path $PSItem -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays($ThresholdDays))} | Remove-Item -Recurse -ErrorAction SilentlyContinue -Force -Verbose
    }
    
    
    foreach ($drive in $drivesToMoniter) {
        Write-Host ("`r`n");
        Write-Host ("Checking drive '" + $drive + "' ...");
        $disk = Get-PSDrive $drive;

        $minGbThreshold = [math]::Round($minGbThreshold / 1GB, 2);
        $DiskFreeSpace = [math]::Round($disk.Free / 1GB, 2);
        $DiskUsage =[math]::Round($disk.Used / 1GB, 2);

    
       if ($DiskFreeSpace -lt $minGbThreshold) {
            Write-Host ("Drive '" + $drive + "' has less than " + $minGbThreshold + " GB free (" + $DiskFreeSpace + " GB): sending e-mail...");
        
            $message = new-object Net.Mail.MailMessage;
            $message.From = $email_from_address;        
                $message.To.Add($email_to_addressArray);

            $message.Subject =  ("[RunningLow] WARNING: " + $env:computername.ToUpper() + " Drive " + $drive);
            $message.Subject += (" has less than '" + $minGbThreshold + "' GB free (" + $DiskFreeSpace + ") GB");
            $message.Body =     "Hello there, `r`n`r`n";
            $message.Body +=    "This is an automatic e-mail message sent by RunningLow Powershell script to inform you that '" + $env:computername.ToUpper() + "' drive " + $drive + " is running low on free space. `r`n`r`n";

            $message.Body +=    "--------------------------------------------------------------";
            $message.Body +=    "`r`n";
            $message.Body +=    ("Machine HostName: " + $env:computername + " `r`n");
            $message.Body +=    "Machine IP Address(es): ";
                $ipAddresses = Get-NetIPAddress -AddressFamily IPv4;
                foreach ($ip in $ipAddresses) {
                    if ($ip.IPAddress -like "127.0.0.1") {
                        continue;
                    }
                    $message.Body += ($ip.IPAddress + " ");
                }
            $message.Body +=    (" `r`n")
            $message.Body +=    (" `r`n Capacity on drive " + $drive + ": " + $DiskUsage + " GB. `r`n");
            $message.Body +=    ("Free space on drive " + $drive + ": " + $DiskFreeSpace + " GB. `r`n");
            $message.Body +=    "--------------------------------------------------------------";
            $message.Body +=    "`r`n`r`n";
            $message.Body +=    "This warning will fire when the free space is lower ";
            $message.Body +=    ("than " + $minGbThreshold + " GB `r`n`r`n");
            $message.Body +=    "Sincerely, `r`n`r`n";
            $message.Body +=    "Hemanth Kumar Kothari";

            $smtp = new-object Net.Mail.SmtpClient($email_smtp_host, $email_smtp_port);
            $smtp.EnableSSL = $email_smtp_SSL;
            $smtp.Credentials = New-Object System.Net.NetworkCredential($email_username, $email_password);
            $smtp.send($message);


            $message.Dispose();
            write-host "... E-Mail sent!" ; 
        } else {
            Write-Host ("Drive " + $drive + " has more than " + $minGbThreshold + " GB free: nothing to do.");
        }
    }
}