#!/usr/bin/perl 

use strict;             #Strict syntax checking
use warnings;           #Show warnings
use StepClass;          #Include the Step classes        
use Config::IniFiles;   #INI files
use IO::File;           #Log file
use Time::localtime;    #Time and date
use Win32::TieRegistry; #Windows registry

#For debugging purposes
use Carp ();            #to get a call stack
local $SIG{__WARN__} = \&Carp::cluck;;
use Data::Dumper;       #Useful for debugging, to see inside objects and structures


########################################################################################
#---------------------------------------------------------------------------------------
#       Global Definitions
#---------------------------------------------------------------------------------------
########################################################################################

my $endl = 			        "\n";
my $blankspace = 		        " ";
my $step_type_name=                     "type";
my $section_steps =		        "steps"; 
my $simulation_mode=                    0;
        
        
#get rid of these at some point. create auto-log-in class and auto-run class or something
my $Auto_Admin_Login_State_name=        "AutoAdminLoginOriginalState";
my $Auto_Admin_Login_User_name=         "AutoAdminLoginOriginalUserName";
my $Auto_Admin_Login_Domain_name=       "AutoAdminLoginOriginalDomainName";
my $setttings_section_name=             "settings";
my $run_key_value_name=                 'run_key_value';

########################################################################################
#---------------------------------------------------------------------------------------
#       Main
#---------------------------------------------------------------------------------------
########################################################################################

# Open log file
my $log_file = new IO::File "Script_Log.txt", O_CREAT | O_RDWR | O_APPEND;
if (defined $log_file) {
                &log_out ("** Log file opened succesfully **");
        }
        else
        {
                &log_out ("Unable to create or open log file");
        }
&log_out ("** Script started **");

#Initialize step class
Step::initialize_step_class($log_file,$simulation_mode);

#run the autotests for the Step class and subclasses
if (StepClassTest::step_class_autotest ())              
{
        &log_out ("Step class autotests passed");          #All is OK
}
else                                                    #Trouble...
{
        print "Step class autotests failed\n";                          # Print out the tests that failed
        for my $failed_test_number (StepClassTest::failed_tests())
        {
                print "Test: " . $failed_test_number . " failed\n";
        }
}

# Open configuration INI file
my $cfg = new Config::IniFiles( -file => "script.ini" );  
if (!$cfg)
{
        &log_out ("FATAL ERROR: Failed to open or parse INI file\n"); 
        if (!(defined ($cfg)))
        {
            &log_out (@Config::IniFiles::errors);
        } 
        die;
}

&AutoAdminLoginSet(1);
&AutoRunOnBootEnable (1);

my @step_names = $cfg->Parameters($section_steps);              #Create an array of all the step names in the 'steps' section
my @steps_to_execute = ();                                      #This is where we'll store all the executable steps

foreach my $step_name(@step_names)                              #for each step listed in the 'steps' section
{
        #&log_out ("Creating " . $step_name);
        push (@steps_to_execute,create_step($step_name));       #Create the step object and push it into the array
}

foreach my $step (@steps_to_execute)                            #for each executable step we have found
{
        #print Dumper($step);
        if ($step->enabled())                                   #If the step is enabled                      
        {
                disable_step($step);                                 #Try to disable the step in the INI file, if the step can be disabled
                &log_out ("Executing step: " . $step->name());
                $step->execute();                               #execute the step
                if (Step::rebooting_flag())                     #if this step requires a reboot
                {
                    log_out ("Waiting for reboot...");
                    exit;
                }
        }
}

&script_cleanup();
&log_out ("** Installer Script is Done **");
close $log_file;
exit;

########################################################################################
#---------------------------------------------------------------------------------------
#       Subroutines
#---------------------------------------------------------------------------------------
########################################################################################

#-------------------------------------------
#       create_step (Step's name)
#-------------------------------------------
#This usesthe appropriate section of the INI file to figure out the type of the step
#and dynamically creates the step object of the right type. 

sub create_step{
    my ($step_name) = @_;                                                               #The name is needed find the respective INI section  
    my $new_step = Step::new_step ($cfg->val($step_name,$step_type_name),$step_name);   #The step's type is specified in the INI file
    $new_step->enabled($cfg->val($section_steps,$step_name));                           #Set the step's enabled status, also fromthe INI file
    my %the_parameters = step_parameters($step_name);                                   #read the whole INI section with the same name as the step's
    $new_step->fill_parameters(%the_parameters);                                        #pass that parameter map to the object, it'll take care of filling itself up
    #print Dumper($new_step);
    return $new_step;                                                                   #return the newly-created step
}

#-------------------------------------------
#       step_parameters (Step's name)
#-------------------------------------------
#This function knows reads the appropriate section from the INI file for the given step name, 
#returns a MAP structure with all the parameters under the step's section

sub step_parameters {
    my ($step_name) = @_;
    my %parameter_map;
    my @step_parameters = $cfg->Parameters($step_name);
    
    
    foreach my $parameter(@step_parameters)
    {
        $parameter_map{$parameter} = $cfg->val($step_name,$parameter);
        #print $parameter . " " . $parameter_map{$parameter} . "\n";
    }
    return %parameter_map;
}





#--------------------------------------------------------
# Disable the step if possible
#--------------------------------------------------------
sub disable_step {
        my ($step)=@_;
        if ($step->always_run())
        {
            return 1;
        }
        else
        {
            &write_setting($section_steps, $step->name(), 0);
        }
}

#--------------------------------------------------------
# Generic INI file setting read
#--------------------------------------------------------
sub read_setting {
	my $section = $_[0];
	my $setting = $_[1];
 	my $value =  $cfg->val($section, $setting);
	return ($value);
	}

#--------------------------------------------------------
# Generic INI file setting write
#--------------------------------------------------------
sub write_setting {
	my $section = $_[0];
	my $setting = $_[1];
	my $value = $_[2];
	$cfg->setval($section, $setting, $value);
	if (!($cfg->RewriteConfig))
	{
	&log_out ("error writing INI file");
	return 0;
	}
}

#--------------------------------------------------------
# Log to std out and file
#--------------------------------------------------------
sub log_out {
	       
        my $log_line = "*| " . ctime() . " | " . $_[0]  . " |*" . $endl;
        print $log_line;
        print $log_file $log_line;
	}
        
#--------------------------------------------------------
# Log to std out and file
#--------------------------------------------------------
sub script_cleanup(){

        auto_admin_logon_cleanup();
}


################################################################################################ 
# Move this stuff to its own class later on
################################################################################################


sub auto_admin_logon_cleanup {
    &AutoRunOnBootEnable (0);   #Delete Auto-Run Key. We don't need to reboot again.
    if (!(&read_setting ("settings", $Auto_Admin_Login_State_name)))        # If autologin was Disabled, reboot to restore machine to
    {                                                                           # original state (no one is logged in)
        &AutoAdminLoginSet(0);      #Restore AutoAdminLogin State
        Reboot::rebootself ();
    }
}


#--------------------------------------------------------
# AutoAdminLoginEnable 
#--------------------------------------------------------
sub AutoAdminLoginSet {
        my $set = $_[0];
        my $AutoAdminLogonKeyPath = 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\\';
        my $AutoAdminLogonKey = '\\AutoAdminLogon';
        my $DefaultPasswordKey = '\\DefaultPassword';
        my $DefaultUserNameKey = '\\DefaultUserName';
        my $DefaultDomainNameKey = '\\DefaultDomainName';
        my $TempKey1;
        my $TempKey2;
        my $DefaultPassword=    'labview===';
        my $DefaultUserName=    'administrator';
        my $DefaultDomainName=  'localhost';
        my $TempKeyStringValue= " ";
        my $step_to_check=      $setttings_section_name;
        my $AutoAdminLogonState=0;
        
   
        if ($set)       #Set AutoAdminLogon
        {    
                $TempKey1 = $Registry->{$AutoAdminLogonKeyPath};                #Point to WinLogon
                $AutoAdminLogonState= $TempKey1->{$AutoAdminLogonKey};          #Read current AutoAdminLogin value
                &write_setting ($step_to_check, $Auto_Admin_Login_State_name,$AutoAdminLogonState);     #Remember original setting in INI file
                
                if ($AutoAdminLogonState)                                       #If it's enabled
                {
                        &log_out("Auto Administrator Login currently enabled. Leaving it as is.");
                        
                }
                else                                                            #If not enabled
                {
                         &log_out("Auto Administrator Login currently disabled. Temporarily enabling it.");
                
                        $TempKey1->{$AutoAdminLogonKey} =1;                                                     #Enable AutoAdminLogin
                                                
                        $TempKey2 = $Registry->{$AutoAdminLogonKeyPath};                                        #Look for default password key
                        $TempKey2->{$DefaultPasswordKey}= $DefaultPassword;                                     #Set or create&set default password key
                        &log_out("Set DefaultPassword key.");
                                
                        $TempKeyStringValue = ($Registry->{$AutoAdminLogonKeyPath . $DefaultUserNameKey});         #Read current Default User

                        &log_out("DefaultUserName: " . $TempKeyStringValue);
		
                        if ($TempKeyStringValue)                                                                #If Default User Exists
                        {
                                &write_setting ($step_to_check, $Auto_Admin_Login_User_name, $TempKeyStringValue);      #Remember original setting in INI file
                        }
                        $TempKey2 = $Registry->{$AutoAdminLogonKeyPath};                                        
                        $TempKey2->{$DefaultUserNameKey}= $DefaultUserName;                                     #Set Default User
                        &log_out("Set DefaultUser key.");
                
                        $TempKeyStringValue = ($Registry->{$AutoAdminLogonKeyPath . $DefaultDomainNameKey});     #Read current Default Domain
                        &log_out("DefaultDomainName: " . $TempKeyStringValue);
		        if ($TempKeyStringValue)                                                                #If Default Domain Exists
                        {
                                &write_setting ($step_to_check, $Auto_Admin_Login_Domain_name, $TempKeyStringValue);    #Remember original setting in INI file
                        }
                        $TempKey2 = $Registry->{$AutoAdminLogonKeyPath};             
                        $TempKey2->{$DefaultDomainNameKey}= $DefaultDomainName;                                 #Set Default Domain
                        &log_out("Set DefaultDomain key.");
                }
        }
        else            #Restore AutoAdminLogon to its previous state
        {
                
                $TempKey1 = $Registry->{$AutoAdminLogonKeyPath};
                &log_out("Restoring Auto Administrator Login to previous state");
                $TempKey1->{$AutoAdminLogonKey} = &read_setting ($step_to_check, $Auto_Admin_Login_State_name);         #Restore original AutoAdminLogin
                $TempKey1->{$DefaultUserNameKey} = &read_setting ($step_to_check, $Auto_Admin_Login_User_name);         #Restore original User Name
                $TempKey1->{$DefaultDomainNameKey} = &read_setting ($step_to_check, $Auto_Admin_Login_Domain_name);     #Restore original Domain Name
        }
}

# Enables or disables registry key that launches the script at boot
sub AutoRunOnBootEnable {
        my $enable = $_[0];
        my $step_to_check=      $setttings_section_name;
        my $RunKeyValue = &read_setting($step_to_check, $run_key_value_name);
        my $RunKeyPath = 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run\\';
        my $RunKey = '\\BootScript';
        my $TempKey1;
  
        if ($enable)
        { 
                &log_out("Checking registry option to continue after reboot");
                if (!($Registry->{$RunKeyPath . $RunKey}))
                {	
                        &log_out("Setting registry option to continue after reboot");
                        $TempKey1 = $Registry->{$RunKeyPath};
                        $TempKey1->{$RunKey}= $RunKeyValue;
                        &log_out ("Succesfully created Auto-Run registry key");
                }            
        }
        else
        {
                if (($Registry->{$RunKeyPath . $RunKey}))
                {
                        $TempKey1= delete $Registry->{$RunKeyPath . $RunKey};
                        &log_out ("Deleted Auto-Run registry key");
                }
        }        
        
}
