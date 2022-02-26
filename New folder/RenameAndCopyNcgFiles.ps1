param
(
    [Parameter(Position = 1, ValueFromPipeline = $true)]
    [String[]]
	$SourcePaths = @(
		"\\baltic\LVReleases\ncg_r4_RT\rt_files\armv7-a\distarm\AppLibs\lvrt",
		"\\baltic\LVReleases\ncg_r4_RT\rt_files\armv7-a\distarm\AppLibs\liblvrt.so.15.0.0",
		"\\baltic\LVReleases\ncg_r4_RT\x86\other files\pharlap\lvrt.dll",
		"\\baltic\LVReleases\ncg_r4_RT\x86\other files\vxworks\lvrt.out",
		"\\baltic\LVReleases\ncg_r4_RT\rt_files\x64\dist64RT\AppLibs\liblvrt.so.15.0.0",
		"\\baltic\LVReleases\ncg_r4_RT\rt_files\x64\dist64RT\AppLibs\liblvrt-ui.so.15.0.0",
		"\\baltic\LVReleases\ncg_r4_RT\rt_files\x64\dist64RT\AppLibs\lvrt",
		"\\baltic\LVReleases\ncg_r4_RT\x86\LabView.exe",
		"\\baltic\LVReleases\ncg_r4_RT\x86\resource\tdtable.tdr",
        "\\baltic\LVReleases\ncg_r4_RT\x86\LabView.exe" 
        "\\us-aus-rtweb2\Resources\Scripts\LabVIEW.ini"
        "\\us-aus-rtweb2\Resources\Scripts\ni-rt.ini.ncghack"
		"\\baltic\penguinExports\labviewrt\Core\nbstructures\export\3.3\3.3.0d40\distribution\release\lvrt_rtfifo\RT Images\RTFIFO\3.3\*"
	),

    [Parameter(Position = 2, ValueFromPipeline = $true)]
    [String[]]
	$DestinationPaths = @(                                                                                        
		"C:\Program Files (x86)\National Instruments\RT Images\LabVIEW\2015\Linux\armv7-a\lvrt",
		"C:\Program Files (x86)\National Instruments\RT Images\LabVIEW\2015\Linux\armv7-a\liblvrt.so.15.0.0"
		"C:\Program Files (x86)\National Instruments\RT Images\LabVIEW\2015\lvrt.dll",
		"C:\Program Files (x86)\National Instruments\RT Images\LabVIEW\2015\lvrt.out",
		"C:\Program Files (x86)\National Instruments\RT Images\LabVIEW\2015\Linux\x64\liblvrt.so.15.0.0",
		"C:\Program Files (x86)\National Instruments\RT Images\LabVIEW\2015\Linux\x64\liblvrt-ui.so.15.0.0",
		"C:\Program Files (x86)\National Instruments\RT Images\LabVIEW\2015\Linux\x64\lvrt",
		"C:\Program Files (x86)\National Instruments\LabVIEW 2015\LabView.exe",
		"C:\Program Files (x86)\National Instruments\RT Images\LabVIEW\2015\tdtable.tdr",
        "C:\Program Files (x86)\National Instruments\LabVIEW 2015"  
        "C:\Program Files (x86)\National Instruments\LabVIEW 2015"
        "C:\Program Files (x86)\National Instruments\RT Images\LabVIEW\2015\ni-rt-linux.ini"	
		"C:\Program Files (x86)\National Instruments\RT Images\RTFIFO\3.3"
        ),
	
	[Switch]$RenameOnly,
	[Switch]$CopyOnly,
	[Switch]$Quiet,
	[String]$Email
)

# Stop on error, don't continue and try to do more stuff.
$ErrorActionPreference = "Stop"

# Write-Host wrapper that allows us to suppress output if the -Quiet parameter is specified.
function Write-Host-Conditional($message)
{
	if (!$Quiet)
	{
		Write-Host $message
	}
}

# Rename all files in DestinationPaths by appending .bak.
function Rename-Files-On-Host()
{
	foreach ($path in $DestinationPaths)
	{
		$newPath = $path + '.bak'
		Write-Host-Conditional "Renaming $path to $newPath"
		Copy-Item -path $path -destination $newPath -Force -Recurse
	}
}

function Send-Email($emailTo, $subject, $body)
{
	$emailFrom = "no-reply@ni.com"
	$smtpServer = "mailout.natinst.com"

	$smtp = New-Object System.Net.Mail.SmtpClient($smtpServer)
	$smtp.Send($emailFrom, $emailTo, $subject, $body)
}

# Copy files in SourcePaths to paths specified by DestinationPaths.
# NOTE: The lists are assumed to be matched.
function Copy-Files-To-Host()
{
	$i = 0
	foreach ($sourcePath in $SourcePaths)
	{
		$destinationPath = $DestinationPaths[$i]
		Write-Host-Conditional "Copying $sourcePath to $destinationPath"
		Copy-Item -path $sourcePath -destination $destinationPath -Force -Recurse
		$i++
	}
}

function Invoke-Main()
{
	$statusMessage = "RenameAndCopyNcgFiles.ps1 PASSED"
	$messageDetails = ""
	
	try
	{
		if (!$CopyOnly)
		{
			Write-Host-Conditional "Renaming host files..."
			Rename-Files-On-Host
			Write-Host-Conditional "Done renaming host files."
		}
		
		if (!$RenameOnly)
		{
			Write-Host-Conditional "Copying ncg files..."
			Copy-Files-To-Host
			Write-Host-Conditional "Done copying ncg files."
		}
	}
	catch
	{
		$statusMessage = "RenameAndCopyNcgFiles.ps1 FAILED!"
		
		$newline = "`r`n"
		$messageLine1 = "Caught an exception:"
		$messageLine2 = "Exception Type: $($_.Exception.GetType().FullName)"
		$messageLine3 = "Exception Message: $($_.Exception.Message)"
		$messageDetails = $messageLine1 + $newline + $messageLine2 + $newline + $messageLine3
		
		Write-Host $messageDetails -ForegroundColor Red
		exit 1
	}
	finally
	{
		Send-Email $Email $statusMessage $messageDetails
	}
}

Invoke-Main
