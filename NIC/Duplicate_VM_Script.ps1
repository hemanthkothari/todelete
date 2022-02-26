# ------------------------------------------------------------------------------
# Create Virtual Machine Wizard Script
# ------------------------------------------------------------------------------
# Script generated on Wednesday, November 11, 2015 11:44:57 AM by Virtual Machine Manager
# 
# For additional help on cmdlet usage, type get-help <cmdlet name>
# ------------------------------------------------------------------------------

#Since we want to be able to call this script from a PS1 script, this imports the 
#Virtual Machine Manager PowerShell module.
ipmo 'virtualmachinemanager\virtualmachinemanager.psd1'

#Load the VB assembly so we can create a dialog.
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

#########################<FUNCTIONS>##############################

#Populate VMlist
function getVMList{
    $gps=Get-VM| Where-Object { $_.status -ne 'Stored'} |select name |sort-object name
    $list = New-Object System.collections.ArrayList
    $list.AddRange($gps)
    $dataGridView.DataSource = $list
    CheckVMstatus
}

#Checks the status of the VMs in the datagrid and assigns a color for each status ("running"=Green, "PowerOff"=Red, "Cloning"/"Cloned"= orange)
function CheckVMstatus()
{
    
            foreach ($Row in $dataGridView.Rows) 
            {
            write-host $Row.Index
            $rowIndex=$Row.Index
            $gridelement=$dataGridView.Rows[$rowIndex].Cells[0].value
            Write-host $gridelement
            $status=Get-VM $gridelement | select status
            write-host $status
                if ($status -like '*Running*') 
                {
                    $row.defaultcellstyle.backcolor = "Green"
                } 
                else 
                {
                    $row.defaultcellstyle.backcolor = "Red"
                }
            }
}

#Manipulate already existing VMs
#StartVM - Starts the VM(s) which was selected in the datagrid
function powerOnButton()
{
 $chosenItem | 
        ForEach-Object{
          $targetToStart = Get-VM | Where-Object { $_.status -like '*Running*' -and $_.Name -eq $chosenItem.value}
          $VM1=Get-VM $_.Value
            if($targetToStart -eq $chosenItem.value)
            {
                write-host $VM1 "is already running."
            }

            else
            {
                Start-VM $VM1 -RunAsync
                Write-host "Starting VM" $VM1 
                $running = @(get-job | ? {$_.Status -eq "Running"})

                    while ($running.Count -gt "0") 
                    {
                        $running = @(get-job | ? {$_.Status -eq "Running"})

                    }

            write-host VM Started.
            }
        }
getVMList
}


#StopVM
function powerOffButton()
{
$chosenItem | 
        ForEach-Object
        {
           $targetToStop = Get-VM | Where-Object { $_.Status -like 'PowerOff' -and $_.Name -eq $chosenItem.Value}
           $VM1=Get-VM $_.Value
           if($targetToStop -eq $chosenItem.Value)
           {
                write-host $VM1 "is turned off."}

           else
           {
                Stop-VM $VM1 -RunAsync
                Write-host "Powering Off VM..." $VM1
                start-sleep -s 10
                $stopped = @(get-job | ? {$_.Status -eq "PowerOff"})
                    while ($stopped.Count -gt "0") 
                    {
                        $stopped = @(get-job | ? {$_.Status -eq "PowerOff"})
                    }
            write-host VM Turned Off.
           }
        }
getVMList
}


#DeleteVM
function deleteButton()
{
$chosenItem | 
        ForEach-Object{
          $targetToDelete = Get-VM | Where-Object { $_.status -like '*Running*' -and $_.Name -eq $chosenItem.value}
          $VM1=Get-VM -Name $_.Value
          if($targetToDelete -eq $chosenItem.value)
          {
                write-host $VM1 "is running. Stop the VM and try to delete it again"
          }
          else
          {
                Remove-VM $VM1 -RunAsync
                Write-host "Removing VM" $VM1
                $powerOff = @(get-job | ? {$_.Status -eq "Stopped"})
                    while ($powerOff.Count -gt "0") 
                    {
                        $powerOff = @(get-job | ? {$_.Status -eq "Stopped"})
                    }
           write-host VM deleted.
           }
        }    
getVMList
}

#Specifies the selected grid from VMList
function gridClick()
{
    $rowIndex = $dataGridView.CurrentRow.Index
    $columnIndex = $dataGridView.CurrentCell.ColumnIndex
    #Write-Host $rowIndex
    #Write-Host $columnIndex 
    #Write-Host $dataGridView.Rows[$rowIndex].Cells[0].value
    $chosenItem=$dataGridView.SelectedCells
    write-host $chosenItem.value
}

#Getting a list of Tempaltes and VM's available from the server
$TemplateList= Get-SCVMTemplate | select name | sort-object Name
$VMList= Get-SCVirtualMachine | select name | sort-object Name
$itemsource = @()
foreach ($Template in $TemplateList) 
{  
        $itemsource += [PSCustomObject]@{  
            Name = $Template.Name 
        } 
    }  
	
foreach ($VMT in $VMList){
        $itemsource += [PSCustomObject]@{  
            Name = $VMT.Name 
        } 
    }

$ComboBox1_SelectedIndexChanged=
{
write-host $comboBox.text "----------"
$DesiredTemplate = $comboBox.Text
$DesiredTemplate = [string]$DesiredTemplate
Write-Host $DesiredTemplate.GetType() "Desired Template type is "
} 

######## Declaring Global variables #############################
New-Variable -Name namingprefix -Option AllScope
New-Variable -Name numberofvms -Option AllScope
New-Variable -Name SelectedTemplate -Option AllScope
New-Variable -Name VM -Option AllScope
New-Variable -Name running -Option AllScope
New-Variable -Name chosenItem -Option AllScope
New-Variable -Name gps -option AllScope
New-Variable -Name DesiredTemplate -Option AllScope

###################Load Assembly for creating form & button######

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[System.Windows.Forms.Application]::DoEvents()

#Creating a windows form
$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Duplicate VM Menu"
$objForm.Size = New-Object System.Drawing.Size(500,700) 
$objForm.StartPosition = "CenterScreen"

#Adding Key functions to the form
$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {:$namingprefix = $objTextBox1.Text;
	[int]$numberofvms = $objTextBox2.Text;
	$SelectedTemplate = $Combobox.SelectedItem;
	$objForm.Close()}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()}})

#Creating Buttons
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75,200)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$namingprefix=$objTextBox1.Text;
	[int]$numberofvms=$objTextBox2.Text;
	$SelectedTemplate = $Combobox.SelectedItem;
	$objForm.Close()})
$objForm.Controls.Add($OKButton)

write-host $SelectedTemplate "selected template is"

$ExitButton = New-Object System.Windows.Forms.Button
$ExitButton.Location = New-Object System.Drawing.Size(150,200)
$ExitButton.Size = New-Object System.Drawing.Size(75,23)
$ExitButton.Text = "Exit"
$ExitButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($ExitButton)

#Creating Labels and Text Boxes
$objLabel1 = New-Object System.Windows.Forms.Label
$objLabel1.Location = New-Object System.Drawing.Size(10,20) 
$objLabel1.Size = New-Object System.Drawing.Size(280,20) 
$objLabel1.Text = "Provide the Virtual Machine Name Prefix below:"
$objForm.Controls.Add($objLabel1) 

$objTextBox1 = New-Object System.Windows.Forms.TextBox 
$objTextBox1.Location = New-Object System.Drawing.Size(10,40) 
$objTextBox1.Size = New-Object System.Drawing.Size(260,20)
$objTextBox1.Text = "RO-VV-CW"
$objForm.Controls.Add($objTextBox1) 

$objLabel2 = New-Object System.Windows.Forms.Label
$objLabel2.Location = New-Object System.Drawing.Size(10,70) 
$objLabel2.Size = New-Object System.Drawing.Size(280,30) 
$objLabel2.Text = "Provide the number of Virtual Machines to create below:"
$objForm.Controls.Add($objLabel2) 

#$objTextBox2 = New-Object System.Windows.Forms.TextBox 
#$objTextBox2.Location = New-Object System.Drawing.Size(10,100) 
#$objTextBox2.Size = New-Object System.Drawing.Size(260,20)
#$objTextBox2.Text = "12" 
#$objTextBox.Maximum = 2
#$objTextBox.Minimum = 1

$objTextBox2 = New-Object System.Windows.Forms.NumericUpDown
$objTextBox2.Location = New-Object System.Drawing.Size(10,100)
$objTextBox2.Size = New-Object System.Drawing.Size(55,20)
$objTextBox2.Value = 1
$objTextBox.Maximum = 2
$objTextBox.Minimum = 1

$objForm.Controls.Add($objTextBox2) 

#Creating Label and a Combo Box that will work as a Drop box in our case
$objLabel3 = New-Object System.Windows.Forms.Label
$objLabel3.Location = New-Object System.Drawing.Size(10,120) 
$objLabel3.Size = New-Object System.Drawing.Size(280,20) 
$objLabel3.Text = "Select a Template from the list:"
$objForm.Controls.Add($objLabel3) 

$ComboBox = New-Object System.Windows.Forms.ComboBox
$ComboBox.Location = New-Object System.Drawing.Size(10,140)
$ComboBox.Size = New-Object System.Drawing.Size(260,20)
$ComboBox.Height = 80
$ComboBox.Name = 'List of Templates'
$ComboBox.Add_SelectedIndexChanged($ComboBox1_SelectedIndexChanged)
$objForm.Controls.Add($ComboBox)

#Creating a list box which will be populated with the available VMs
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Size = New-Object System.Drawing.Size(300,250)
$dataGridView.Location = New-Object System.Drawing.Size(10,240)
$dataGridView.MultiSelect = $true
$dataGridView.ColumnHeadersVisible = $true
$dataGridView.ColumnHeadersHeightSizeMode = 'AutoSize'
$dataGridView.DataBindings.DefaultDataSourceUpdateMode = 0 
$dataGridView.ReadOnly = $True 
$dataGridView.DataSource = $null
$dataGridView.Refresh
$dataGridView.Add_CellMouseClick({gridClick})
$objForm.Controls.Add($dataGridView)

getVMList

#Populate the Combo Box
foreach ($item in $itemsource) 
{  
       $ComboBox.Items.Add($item.Name)
    } 

#VM controlls (start, stop, delete, refresh)

#StartButton
$vmStartButton = New-Object System.Windows.Forms.Button
$vmStartButton.Location = New-Object System.Drawing.Size(320,270)
$vmStartButton.Size = New-Object System.Drawing.Size(75,23)
$vmStartButton.Text = "PowerOn"
$vmStartButton.Add_Click({powerOnButton})

$objForm.Controls.Add($vmStartButton)

#StopButton
$vmStopButton = New-Object System.Windows.Forms.Button
$vmStopButton.Location = New-Object System.Drawing.Size(320,300)
$vmStopButton.Size = New-Object System.Drawing.Size(75,23)
$vmStopButton.Text = "PowerOff"
$vmStopButton.Add_Click({powerOffButton})

$objForm.Controls.Add($vmStopButton)

#DeleteVMButton
$vmDeleteButton = New-Object System.Windows.Forms.Button
$vmDeleteButton.Location = New-Object System.Drawing.Size(320,330)
$vmDeleteButton.Size = New-Object System.Drawing.Size(75,23)
$vmDeleteButton.Text = "Delete"
$vmDeleteButton.Add_Click({deleteButton})

$objForm.Controls.Add($vmDeleteButton)

#refreshListButton
$vmRefreshListButton = New-Object System.Windows.Forms.Button
$vmRefreshListButton.Location = New-Object System.Drawing.Size(320,360)
$vmRefreshListButton.Size = New-Object System.Drawing.Size(75,23)
$vmRefreshListButton.Text = "Refresh"
$vmRefreshListButton.Add_Click({getVMList})

$objForm.Controls.Add($vmRefreshListButton)

$objForm.Controls.Add($textBox1)

#Setting the Window on TOP
$objForm.Topmost = $false

#Displaying the Window Form created
$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()				
	  
############################## OLD CODE, improved above with Window Form #########################							  
#Present a VB dialog to the administrator to provide the VM Name Prefix.
#$namingprefix = [Microsoft.VisualBasic.Interaction]::InputBox("Provide the Virtual Machine Name Prefix:", "Virtual Machine Name Prefix", "RO-VV-CW")

#Present a VB dialog to the administrator to provide the number (integer) of VMs to create.
#[int]$numberofvms = [Microsoft.VisualBasic.Interaction]::InputBox("How Many Virtual Machines to Create?", "How Many Virtual Machines to Create?", "12")
############################# END OF OLD CODE ####################################################

#Specify the maximum number of SCVMM jobs for throttling. If your hosts and array can handle
#more than five simultaneous provisioning actions, you can increase the number of jobs here.
[int]$maxjobs = "1"

#Determine â€œWhere we left offâ€ and start the provisioning process from there. For example,
#if your prefix was HVXD71W7-6 and you already had VMs 01-10, it would start at 11 for the 
#next VM to create. If you want to create three digits for the increment 
#(more than 100 VMs for the prefix), change the number 2 (two places) to 3.

$server="us-aus-rtvmm.ni.corp.natinst.com"

get-vm | sort-object Name | where {$_.Name -like $namingprefix + "*"} | Select-Object -last 1 | foreach-object {$lastvm = $_.Name.Substring($_.Name.Length - 2,2)}
if ( $lastvm -ne $null ){ $i = [int]$lastvm} else { $i = 0}

#Create the upper boundary ($j) and for loop.
$j = $i + $numberofvms
for ($i += 1; $i -le $j; $i++) {

#Throttle the jobs to create $maxjobs (i.e. 5) VMs at a time, based on total running jobs on SCVMM. 
#Sleep for 15 seconds and check again.
$running = @(get-job | ? {$_.Status -eq "Running"})
while ($running.Count -ge $maxjobs) 
{
$running = @(get-job | ? {$_.Status -eq "Running"});
write-host Sleeping;start-sleep -s 15
}

#Create the $computername variable based on the namingprefix and current job number (for example HVXD71W7-601).
#If you want to create three digits for the increment (more than 100 VMs for the prefix), change the d2 to d3.
$computername = $namingprefix + "{0:d2}" -f $i

#Generating new ID's 
$jobgroup = [guid]::NewGuid()
$jobgroup2 = [guid]::NewGuid()
$profile = [guid]::NewGuid()
$temptemplate = [guid]::NewGuid()

#Checking the Selected item if it's a VM or Template
$VM = Get-SCVirtualMachine -VMMServer $server -Name $SelectedTemplate | where {$_.Cloud.Name -eq "Cloud US-AUS R&D FPGA VnV"}

if (!$VM)
{
#Creating a VM from a Template (Duplicating Using Template File)
write-host (get-date -uformat %I:%M:%S) "- Creating virtual machine from Template" $computername -ForegroundColor Green

$Template = Get-SCVMTemplate -VMMServer $server -Name $DesiredTemplate | select Name
$GuestOSProfile = Get-SCGuestOSProfile -VMMServer $server | where {$_.Name -eq "OS US-AUS R&D Windows 7 - 64bit - Workgroup"}
$LocalAdministratorCredential = get-scrunasaccount -VMMServer "us-aus-rtvmm" -Name "rtadmin" #-ID "8c1eca25-0c1a-4cd3-9bcd-2a549db56a62"

$OperatingSystem = Get-SCOperatingSystem -VMMServer $server | where {$_.Name -eq "64-bit edition of Windows 7"}

#-ID "c440a422-7447-49b5-a4ce-bccb7ef17a47"

#Creating a temporary Template to use for our new VM and also applying the new configuration
New-SCVMTemplate -Name $temptemplate -VMTemplate $Template.value -GuestOSProfile $GuestOSProfile -JobGroup $jobgroup -ComputerName $computername -TimeZone 115 -LocalAdministratorCredential $LocalAdministratorCredential  -Workgroup "Workgroup" -AnswerFile $null -OperatingSystem $OperatingSystem 

$template = Get-SCVMTemplate -VMMServer $server -Name $temptemplate

Write-host $Template
write-host $temptemplate "-----------------------------------"
$virtualMachineConfiguration = New-SCVMConfiguration -VMTemplate $template -Name $computername
Write-Output $virtualMachineConfiguration
$cloud = Get-SCCloud -Name "Cloud US-AUS R&D FPGA VnV"

#Command for creating a new VM
New-SCVirtualMachine -Name $computername -VMConfiguration $virtualMachineConfiguration -Cloud $cloud -Description "" -JobGroup $jobgroup -ReturnImmediately -StartAction "NeverAutoTurnOnVM" -StopAction "TurnOffVM" -Jobvariable "TemplateJob"

#Deleting the temporary Template 
write-host "Removing Temporary Template" $template.Name -ForegroundColor Red
Remove-SCVMTemplate $template

#Checking if the Job failed and the reason why since it would not error out when we use a Template to create VM
$JobNameString = $TemplateJob.CmdletName+" "+$TemplateJob.ResultName

$JobInfo = Get-SCJob | where { $_.Name -eq $TemplateJob }
Write-Host $JobNameString $Job.Status -ForegroundColor Red

if ($JobInfo.Status -eq "Failed")
{
#Making the UI RED since it's an Error
 $t = $host.ui.RawUI.ForegroundColor #-variable for normal UI collor
 $host.ui.RawUI.ForegroundColor = "Red"

#Displaying the Error message
Write-Output $JobInfo.AdditionalMessages | Select-Object -first 1 

#Setting the UI back to normal
$host.ui.RawUI.ForegroundColor = $t
}

}
else
{

#Creating a VM using another VM as template(Duplicating)
write-host (get-date -uformat %I:%M:%S) "- Creating virtual machine from a VM" $computername -ForegroundColor Green

New-SCVirtualScsiAdapter -VMMServer $server -JobGroup $jobgroup -AdapterID 255 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType 


New-SCVirtualDVDDrive -VMMServer $server -JobGroup $jobgroup -Bus 1 -LUN 0 

#Setting network adapter and internet connection
$VMSubnet = Get-SCVMSubnet -VMMServer $server -Name "User -RO-CLU_0" | where {$_.VMNetwork.ID -eq "e69dfe56-d33a-41df-acb4-957e29c5feb1"}
$VMNetwork = Get-SCVMNetwork -VMMServer $server -Name "User -RO-CLU" -ID "e69dfe56-d33a-41df-acb4-957e29c5feb1"

New-SCVirtualNetworkAdapter -VMMServer $server -JobGroup $jobgroup -MACAddressType Dynamic -VirtualNetwork "LogicalNetSwitch - RO-CLU" -VLanEnabled $false -Synthetic -EnableVMNetworkOptimization $false -EnableMACAddressSpoofing $false -EnableGuestIPNetworkVirtualizationUpdates $false -IPv4AddressType Dynamic -IPv6AddressType Dynamic -VMSubnet $VMSubnet -VMNetwork $VMNetwork 


Set-SCVirtualCOMPort -NoAttach -VMMServer $server -GuestPort 1 -JobGroup $jobgroup 


Set-SCVirtualCOMPort -NoAttach -VMMServer $server -GuestPort 2 -JobGroup $jobgroup 


Set-SCVirtualFloppyDrive -RunAsynchronously -VMMServer $server  -NoMedia -JobGroup $jobgroup 

$CPUType = Get-SCCPUType -VMMServer $server  | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}

#Creating a temporary HardwareProfile to use for our new VM and also applying the new configuration
New-SCHardwareProfile -VMMServer $server  -CPUType $CPUType -Name $profile -Description "Profile used to create a VM/Template" -CPUCount 5 -MemoryMB 40960 -DynamicMemoryEnabled $false -MemoryWeight 5000 -VirtualVideoAdapterEnabled $false -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 -NumaIsolationRequired $false -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $false -DRProtectionRequired $false -NumLock $false -BootOrder "CD", "IdeHardDrive", "PxeBoot", "Floppy" -CPULimitFunctionality $false -CPULimitForMigration $false -Generation 1 -JobGroup $jobgroup 


$VM = Get-SCVirtualMachine -VMMServer $server -Name $SelectedTemplate | where {$_.Cloud.Name -eq "Cloud US-AUS R&D FPGA VnV"}
$Cloud = Get-SCCloud -VMMServer $server | where {$_.Name -eq "Cloud US-AUS R&D FPGA VnV"}
$HardwareProfile = Get-SCHardwareProfile -VMMServer $server | where {$_.Name -eq $profile}

#Command for creating a new VM
New-SCVirtualMachine -VM $VM -Name $computername -Description "" -JobGroup $jobgroup2 -UseDiffDiskOptimization -RunAsync -Cloud $Cloud -HardwareProfile $HardwareProfile -StartAction NeverAutoTurnOnVM -StopAction TurnOffVM -Jobvariable "TemplateJob"

#Deleting the temporary HardwareProfile
write-host "Removing Temporary Profile" $HardwareProfile.Name -ForegroundColor Red
Remove-SCHardwareProfile $HardwareProfile

#Checking if the Job failed and the reason why since it would not error out when we use a Template to create VM
$JobInfo = Get-SCJob | where { $_.Name -eq $TemplateJob }
Write-Host $JobNameString $Job.Status -ForegroundColor Red

if ($JobInfo.Status -eq "Failed")
{
#Making the UI RED since it's an Error
 $t = $host.ui.RawUI.ForegroundColor #-variable for normal UI collor
 $host.ui.RawUI.ForegroundColor = "Red"

#Displaying the Error message
Write-Output $JobInfo.AdditionalMessages | Select-Object -first 1 

#Setting the UI back to normal
$host.ui.RawUI.ForegroundColor = $t
}

}
} #END OF For Loop
$running = @(get-job | ? {$_.Status -eq "Running"})

while ($running.Count -gt "0") 
{
$running = @(get-job | ? {$_.Status -eq "Running"})
write-host Waiting to finish the jobs and change Owner;start-sleep -s 15
}

#get-vm | sort-object Name | where {($_.Name -like $namingprefix + "*") -And ($_.Status -eq "PowerOff") -And ($_.Owner -ne "NI\UG-RO-CLU R&D FPGA VnV Cloud Users")} | foreach-object {Set-SCVirtualMachine -VM $_.Name -Owner "NI\UG-RO-CLU R&D FPGA VnV Cloud Users"}|FT Name,Status,Owner
