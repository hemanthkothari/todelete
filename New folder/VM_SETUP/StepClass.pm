
#--------------
#class Step
#--------------
package Step;
{
        use strict;
        use warnings;
        use Time::localtime;    #Time and date

        #-------------------------------------------
        #Constructor
        #-------------------------------------------

        sub new {
            my ($class,$name) = @_;
            my $self = {
                _name  => $name,                #Name of the step
                _type  => $class,               #Type of the step (class)
                _enabled => 0,                  #Whether the step will run or not
                _always_run =>0                 #True if the step will not disable itself after running
            };
            bless $self, $class;
            return $self;
        }

        #-------------------------------------------
        #Accesor Methods
        #-------------------------------------------

        #accessor method for step's enabled status
        sub enabled {
            my ( $self, $enabled ) = @_;
            $self->{_enabled} = $enabled if defined($enabled);
            return $self->{_enabled};
        }

        #accessor method for step's name
        sub name {
            my ( $self, $name ) = @_;
            $self->{_name} = $name if defined($name);
            return $self->{_name};
        }

        #accessor method for step's type
        sub type {
            my ( $self) = @_;
            return $self->{_type};
        }

        #accessor method for step's always_run flag
        sub always_run {
            my ( $self, $always_run ) = @_;
            $self->{_name} = $always_run if defined($always_run);
            return $self->{_always_run};
        }

        #-------------------------------------------
        #Member methods
        #-------------------------------------------

        #Member function to enable the step
        sub enable {
        my ( $self) = @_;
        $self->enabled(1);
        }

        #Member function to disable the step
        sub disable {
        my ($self) = @_;
        $self->enabled(0);
        }

        #Member function to print the step's type. Should be overridden
        sub print_type {
        my ($self) = @_;
        return $self->{_type};
        }

        #Member function to execute the step. Should be overridden
        sub execute {
        #Do nothing for now. Log generic info here in the future
        return;
        }

        #Member function to fill the rest of the parameters of the step
        sub fill_parameters {
                my ($self, %parameter_map)=@_;
                my @keys = keys %parameter_map;
                foreach my $key(@keys)
                {
                       my $modified_key="_" . $key;
                       if (!(exists $self->{$modified_key}))
                       {
                            print "Error =  Parameter " . $key .  " not found in type " . type($self) . "\n";
                       return 0;
                       }
                       else
                       {
                            $self->{$modified_key} = %parameter_map->{$key};
                       }
                }
                return 1;
        }

        #Member function to check that all parameters are defined
        sub check_parameters {
            my ($self)=@_;
            my @keys = keys %{$self};
            foreach my $key(@keys)
                {
                    if (!(defined $self->{$key}))
                    {
                        print "Error = " . $key . " is undefined\n";
                        return 1;
                    }
                }
                return 0;
        }

        #Member function to print all of the object's parameters
        sub print_settings {
            my ($self)=@_;
            my @keys = keys %{$self};
            print "These are the settings for step " . name($self) . ":\n";
            print @keys;
            print "\n";
                    foreach my $key(@keys)
                    {
                        if (defined $self->{$key})
                        {
                            print $key . "=" . $self->{$key} . "\n";
                        }
                        else
                        {
                            print $key . "=Undefined\n";
                        }
                    }
        }

        #-------------------------------------------
        #Class Globals
        #-------------------------------------------


        $Step::log_file = undef;
        $Step::simulation_mode = 0;
        $Step::rebooting=0;

        #-------------------------------------------
        #Class Methods. Can be called without an object
        #-------------------------------------------

        #Initialize Step Class
        sub initialize_step_class {
            my ($log_file, $simulation_mode) = @_;
            $Step::log_file = $log_file if defined ($log_file);
            $Step::simulation_mode = $simulation_mode if defined ($simulation_mode);;
            }

            #Log message out to file or STDOUT
            sub log_out {
            my $log_line = "*| " . ctime() . " | " . $_[0]  . " |*" . "\n";
            print $log_line;
            if (defined $Step::log_file)
            {
                    print $Step::log_file $log_line;
            }
        }

        sub rebooting_flag {
            return $Step::rebooting;
        }

        #Wrapper that allows clients to dynamically create a step, or Step sub-class object, by providing the class name
        sub new_step {
            my ($step_class,$name) = @_;

            format_class_name($step_class);
            if ($step_class->can('new'))
            {
                my $dynamically_created_step = $step_class->new ($name);
                if ($dynamically_created_step->isa('Step'))
                        {
                            #print "Dynamically created step of type: " . $dynamically_created_step->print_type() . "\n";
                            return $dynamically_created_step;
                        }
                        else
                        {
                            #print "Error creating step " . $name . ". '" . $step_class . "' is not a valid name for a Step class\n";
                            return 0;
                        }
            }
            else
            {
                #print "Error creating step " . $name . ". '" . $step_class . "' is not a valid name for a Step class\n";
                return 0;
            }
        }

        #This function will take the string and operate on it to assure that it
        #conforms to the naming conventions of the classes that inheret from Step
        sub format_class_name {
            my ($string) = @_;
            my $original_length = length($string);          #remember the original length for future sanity check
            my @words = split (/_/,$string);                #split into string subsets, words, separated by underscores
            for my $word (@words)                           #for each of the words in the string
                    {
                            $word=ucfirst(lc($word));       #make everything lower-case, then uppercase the first letter in it
                    }
            $string = join ('_',@words);                    #then put all the words back together, joined by underscores
            $_[0]=$string;                                  #then replace the value directly in the reference that was passed in
            if (length ($string) == $original_length)
                    {
                    return 1;
                    }
                    return 0;
            }
}


#--------------
# class Reboot, inherits from class Step
#--------------
package Reboot;
{
        use strict;
        our @ISA = qw(Step);    # inherits from Step

        #-------------------------------------------
        #Constructor
        #-------------------------------------------

        sub new {
        my ($class,$name) = @_;

        #call the constructor of the parent class, Step
        my $self = $class->SUPER::new($name);
        bless $self, $class;
        return $self;
        }

        #-------------------------------------------
        #Member methods
        #-------------------------------------------


        #-------------------------------------------
        # Execute. Member function to execute the step. Overrides parent's
        # execute ();
        #-------------------------------------------
        #
        sub execute {
            my ($self) = @_;
            if ($self->check_parameters())
            {
                Step::log_out ("Step " . $self->{_name} . " has undefined parameters, check INI file.");
                return 1;
            }
            else
            {
                if ($self->enabled())
                {
                    return (rebootself());
                }
                else
                {
                    Step::log_out ("BUG! tried to execute a step that was marked as disabled. Step's name: " . $self->name());
                    return 1;
                }
            }
        }

        sub rebootself{
                my $command = 'shutdown -r -t 30 -c "Rebooting System.Type \'shutdown -a\' on the shell to abort"';
                my $ret_val = 0;
                if (!($Step::simulation_mode))          #if not in simulation mode
                {
                    $ret_val =(system ($command))/256;
                }
                if ($ret_val)
                {
                        Step::log_out ("Return value: ". $ret_val);
                }
                $Step::rebooting =1;
                return $ret_val;
        }
}

#--------------
# class Email, inherits from class Step
#--------------
package Email;
{
        use strict;
        our @ISA = qw(Step);    # inherits from Step

        #-------------------------------------------
        #Constructor
        #-------------------------------------------

        sub new {
        my ($class,$name) = @_;

        #call the constructor of the parent class, Step
        my $self = $class->SUPER::new($name);
        bless $self, $class;
        return $self;
        }
}

#--------------
# class Command, inherits from class Step
#--------------
package Command;
{
        use strict;
        our @ISA = qw(Step);    # inherits from Step
        #-------------------------------------------
        #constructor
        #-------------------------------------------

        sub new {
        my ($class,$name) = @_;


        #call the constructor of the parent class, Step.
        my $self = $class->SUPER::new($name);
        $self->{_path}                  = undef;        #executable's path
        $self->{_command}               = undef;        #executable's name
        $self->{_flags}                 = undef;        #executable's flags
        $self->{_sleep_until_reboot}    = undef;        #Whether we wait for someone else to reboot the machine or keep going
        bless ($self, $class);
        return $self;
        }

        #-------------------------------------------
        #Accessor methods
        #-------------------------------------------

        #Accessor method for Command's command name
        sub command {
            my ($self) = @_;
            return $self->{_command};
        }

        #Accessor method for Command's flags
        sub flags {
            my ($self,$flags) = @_;
            $self->{_flags} = $flags if defined($flags);
            return $self->{_flags};
        }

            sub sleep_until_reboot {
            my ($self) = @_;
            return $self->{_sleep_until_reboot};
        }

        #Accessor method for Command's path
        sub path {
            my ($self,$path) = @_;
            $self->{_path} = $path if defined($path);
            return $self->{_path};
        }

        #-------------------------------------------
        #Member methods
        #-------------------------------------------


        #-------------------------------------------
        # Execute. Member function to execute the step. Overrides parent's
        # execute ();
        #-------------------------------------------
        #
        sub execute {
            my ($self) = @_;
            if ($self->check_parameters())
            {
                Step::log_out ("Step " . $self->{_name} . " has undefined parameters, check INI file.");
                return 1;
            }
            else
            {

                if ($self->enabled())
                {
                    if ($self->sleep_until_reboot())                   #if this step will reboot the system
                    {
                         $Step::rebooting =1;                          #Set the global flag for an inminent reboot
                    }
                    return ($self->build_and_run_command());           #call helper function to assemble the command and run it
                }
                else
                {
                    Step::log_out ("BUG! tried to execute a step that was marked as disabled. Step's name: " . $self->name());
                    return 1;
                }
            }
        }

        #-------------------------------------------
        # Build & Execute Command
        #-------------------------------------------

        sub build_and_run_command {
                my ($self) = @_;
                my $command = '';
                if ($self->path())
                {
                        $command = '"' . $self->path() . $self->command() . '" ' . $self->flags();
                }
                else
                {
                        $command = $self->command() . ' ' . $self->flags();
                }
                &execute_command($command);
        }

        #-------------------------------------------
        # Execute Command
        # execute_command(command);
        #-------------------------------------------

        sub execute_command {
                my ($command) = @_;
                my $ret_val = 0;

                Step::log_out ("Executing:". $command);

                if (!($Step::simulation_mode))          #if not in simulation mode
                {
                    $ret_val =(system ($command))/256;
                }
                if ($ret_val)
                        {
                        Step::log_out ("Return value: ". $ret_val);
                        }
                return $ret_val;
        }

}

#-------------------------------------------
# class Scripted_Copy, inherits from class Command
#-------------------------------------------
package Scripted_Copy;
{
        use strict;
        our @ISA = qw(Command);    # inherits from Command

        #constructor
        sub new {
        my ($class,$name) = @_;

        #call the constructor of the parent class, Command.
        my $self = $class->SUPER::new($name);

        $self->{script_from_path_name}       = 'script_from_path';   #Naming convetion for the parameter names
        $self->{script_to_path_name}         = 'script_to_path';     #Naming convetion for the parameter names
        $self->{_script_from_path}              = ();                #Origin paths array
        $self->{_script_to_path}                = ();                #Destination paths array

        bless $self, $class;
        return $self;
        }

        #-------------------------------------------
        #Accessor methods
        #-------------------------------------------

        #Accessor method to add a FROM path to the list
        sub push_from_path {
            my ($self,$new_from_path) = @_;
            push (@{$self->{'_' . $self->{script_from_path_name}}},$new_from_path);
            return;
        }

        #Accessor method to add a TO path to the list
        sub push_to_path {
            my ($self,$new_to_path) = @_;
            push (@{$self->{'_' . $self->{script_to_path_name}}},$new_to_path);
            return;
        }

        #-------------------------------------------
        #Member methods
        #-------------------------------------------

        #-------------------------------------------
        # Execute. Member function to execute the step. Overrides parent's
        # execute ();
        #$command = $command . $blankspace . $double_quote . $from_path . $double_quote . $blankspace . $double_quote . $to_path . $double_quote . $blankspace . $flags;
        #-------------------------------------------
        #
        sub execute {
            my ($self) = @_;
            my $original_flags= $self->flags();
            my $counter=0;

            foreach my $from_path (@{$self->{_script_from_path}})
            {
                $self->flags($original_flags . ' "' . $from_path . '"  "' . (@{$self->{_script_to_path}}[$counter]). '"');
                $self->SUPER::execute();
                $counter++;
            }
            return; #TODO: ADD SOME RETURN CODE HERE
        }

        #-------------------------------------------
        #Member function to fill the rest of the parameters of the step# we override the parent's call to intercept some special parameters
        #-------------------------------------------

        sub fill_parameters {
                my ($self, %parameter_map)=@_;
                my $iterator=1;

                while (                                                                         #  Loop for each pair of FROM-TO paths IF:
                (exists %parameter_map->{$self->{script_from_path_name} . '_' . $iterator}      # FROM path key exists
                &&                                                                              # AND
                (exists %parameter_map->{$self->{script_to_path_name} . '_' . $iterator}))      # TO path key exists
                &&                                                                              # AND
                ($self->{script_to_path_name})                                                  # FROM path has a value
                &&                                                                              # AND
                ($self->{script_to_path_name})                                                  # TO path has a value
                )
                {
                    #print  $self->{script_from_path_name} . '_' . $iterator . " : " . (%parameter_map->{$self->{script_from_path_name} . '_' . $iterator}) . "\n";
                    #print  $self->{script_to_path_name} . '_' . $iterator . " : " . (%parameter_map->{$self->{script_to_path_name} . '_' . $iterator}) . "\n";

                    $self->push_from_path(%parameter_map->{$self->{script_from_path_name} . '_' . $iterator});
                    $self->push_to_path(%parameter_map->{$self->{script_to_path_name} . '_' . $iterator});

                    delete $parameter_map{$self->{script_from_path_name} . '_' . $iterator};
                    delete $parameter_map{$self->{script_to_path_name} . '_' . $iterator};

                    $iterator++;
                }
                $self->SUPER::fill_parameters(%parameter_map);

                return 1;
        }
}




#-------------------------------------------
# class Installer, inherits from class Command
#-------------------------------------------
package Installer;
{
        use strict;
        our @ISA = qw(Command);    # inherits from Command

        #constructor
        sub new {
        my ($class,$name) = @_;

        #call the constructor of the parent class, Command.
        my $self = $class->SUPER::new($name);
        bless $self, $class;
        return $self;
        }
}


#-------------------------------------------
# class Latest_Installer, inherits from class Installer
#-------------------------------------------
package Latest_Installer;
{
        use strict;
        our @ISA = qw(Installer);    # inherits from Installer

        #constructor
        sub new {
            my ($class,$name) = @_;

            #call the constructor of the parent class, Installer.
            my $self = $class->SUPER::new($name);
            $self->{_find_latest}           = undef;        #Whether finding the latest installer folder is enabled or not
            $self->{_path_suffix}           = undef;        #Additional path string to append once the latest folder has been found
            bless $self, $class;
            return $self;
        }

        #-------------------------------------------
        #Accessor methods
        #-------------------------------------------

        #Accessor method for Latest_Installer's find_latest flag
        sub find_latest {
            my ($self) = @_;
            return $self->{_find_latest};
        }

        #Accessor method for Latest_Installer's find_latest flag
        sub path_suffix {
            my ($self) = @_;
            return $self->{_path_suffix};
        }

        #-------------------------------------------
        #Member methods
        #-------------------------------------------

        #-------------------------------------------
        # Execute. Member function to execute the step. Overrides parent's
        # execute ();
        #-------------------------------------------
        #
        sub execute {
            my ($self) = @_;
            if ($self->find_latest())
            {
                Step::log_out ("Trying to find the latest installer folder. Starting from: " . $self->path());
                my $latest = $self->latest_path ($self->path());
                Step::log_out ("Latest installer folder detected is: " . $latest);
                my $built_path = ($self->path() . $latest . ($self->path_suffix()));
                $self->path($built_path);
            }

            # TODO: Move this into a common private method of command later on.
            if ($self->sleep_until_reboot())                           #if this step will reboot the system
                    {
                         $Step::rebooting =1;                          #Set the global flag for an inminent reboot
                    }

            $self->build_and_run_command();
        }


        #--------------------------------------------------------
        # Find latest installer folder
        #--------------------------------------------------------

        sub latest_path {
                my ($self,$base_path) = @_;
                my @dir_contents;
                opendir(DNAME, $base_path) || die "Unable to access directory...Sorry";
                @dir_contents = grep (!/^\.\.?$/ && (/\d/) && (-d "$base_path/$_"), readdir(DNAME)); #find directories that:
                                                                                         #are not "." or ".." AND
                                                                                         #contain digits in their name AND
                                                                                         #are directories.
                                                                                         #The digit condition rules out much of the
                                                                                         #crap people tend to create alongside the daily folders,
                                                                                         #such as a latest folder, etc.
                my %directories;
                #Fill the hash with {Folder}->{Creation time} but...
                #Creation time does not exist on POSIX file systems. Windows will return the creation time instead of change time, so we'll go with that
                foreach ( @dir_contents ) {
                      %directories->{$_} = (stat ($base_path. "\\" . $_))[10]; #Ouch. 10 is the index of ctime, which Windows happens to use as creation time but it does not mean creation time on POSIX file systems
                 }
                my @latest = sort { $directories{$b} <=> $directories{$a} } keys %directories; #Sort by timestamp value (high to low) using an in-line function
                closedir(DNAME);
                return $latest[0];
                }
}

#-------------------------------------------
# class Latest_Stable_Installer, inherits from class Installer
#-------------------------------------------
package Latest_Stable_Installer;
{
        use strict;
        our @ISA = qw(Installer);    # inherits from Installer

        #constructor
        sub new {
            my ($class,$name) = @_;

            #call the constructor of the parent class, Installer.
            my $self = $class->SUPER::new($name);
            $self->{_perforce_client}       = undef;
            $self->{_perforce_port}       = undef;
            bless $self, $class;
            return $self;
        }

        #-------------------------------------------
        #Accessor methods
        #-------------------------------------------

        sub find_p4client {
            my ($self) = @_;
            return $self->{_perforce_client};
        }

        sub find_p4port {
            my ($self) = @_;
            return $self->{_perforce_port};
        }

        #-------------------------------------------
        #Member methods
        #-------------------------------------------

        #-------------------------------------------
        # Execute. Member function to execute the step. Overrides parent's
        # execute ();
        #-------------------------------------------
        #
        sub execute {
            my ($self) = @_;
            Step::log_out ("Trying to find the latest stable installer from: " . $self->path());
            my $latest = $self->latest_path ($self->path());
            Step::log_out ("Latest stable installer detected is: " . $latest);
            $self->path($latest);

            # TODO: Move this into a common private method of command later on.
            if ($self->sleep_until_reboot())                           #if this step will reboot the system
                    {
                         $Step::rebooting =1;                          #Set the global flag for an inminent reboot
                    }

            $self->build_and_run_command();
        }


        #--------------------------------------------------------
        # Find latest stable installer path
        #--------------------------------------------------------

        sub latest_path {
                use XML::Simple;

                my ($self,$base_path) = @_;
                my $command = "p4 -p " . $self->find_p4port() . " -c " . $self->find_p4client() . " sync -f " . $base_path . "#head";
                Step::log_out ("Running p4 command to sync files: " . $command);
                my $ret_val = readpipe($command);
                Step::log_out ("Output from syncing files: " . $ret_val);
                $ret_val =~ m/.*(added as|updating|refreshing)\s*(.*)\s*/;
                Step::log_out ("Distribution locator is: " . $2);
                my $xmlFile = XMLin($2) || die "Unable to access $2...Sorry";
                my $latest = $xmlFile->{'Distribution'}->{'Volume'}->{'InputRoot'} || die "Unable to find the node stored latest stable installer in $2...Sorry";
                $latest =~ s/^\s+|\s+$//g;
                $latest =~ s/(.*?)\\*$/$1\\/;
                return $latest;
                }
}

package Latest_Stable_Feed_Installer;
{
        use strict;
        our @ISA = qw(Installer);    # inherits from Installer

        #constructor
        sub new {
            my ($class,$name) = @_;

            #call the constructor of the parent class, Installer.
            my $self = $class->SUPER::new($name);
            $self->{_perforce_client}       = undef;
            $self->{_perforce_port}       = undef;
            $self->{_flags}       = undef;
            bless $self, $class;
            return $self;
        }

        #-------------------------------------------
        #Accessor methods
        #-------------------------------------------

        sub find_p4client {
            my ($self) = @_;
            return $self->{_perforce_client};
        }

        sub find_p4port {
            my ($self) = @_;
            return $self->{_perforce_port};
        }

        sub find_flags {
            my ($self) = @_;
            return $self->{_flags};
        }
        #-------------------------------------------
        #Member methods
        #-------------------------------------------

        #-------------------------------------------
        # Execute. Member function to execute the step. Overrides parent's
        # execute ();
        #-------------------------------------------
        #
        sub execute {
            my ($self) = @_;
            Step::log_out ("Trying to find the latest stable installer from: " . $self->path());
            my $latest = $self->latest_path ($self->path());
            Step::log_out ("GetLatestInstaller: " . $latest);
            $self->flags($self->find_flags() . " " . $latest);
            $self->path("");

            # TODO: Move this into a common private method of command later on.
            if ($self->sleep_until_reboot())                           #if this step will reboot the system
                    {
                         $Step::rebooting =1;                          #Set the global flag for an inminent reboot
                    }

            $self->build_and_run_command();
        }


        #--------------------------------------------------------
        # Find latest stable installer path
        #--------------------------------------------------------

        sub latest_path {
            use XML::Simple;

            my ($self,$base_path) = @_;

            my $command = "p4 -p " . $self->find_p4port() . " -c " . $self->find_p4client() . " files -e " . $base_path . "/.../verified";
            Step::log_out ("command: " . $command);

            # in the command_output array, each element is something like:
            # "//AST/PackageManagement/locators/feed/nipkg/ni-c/ni-compactrio/19.0.0/19.0.0.183-0+d183/verified#1 - add change 31980609 (text)"
            my @command_output = `$command`;

            my %ver_phases_map = (
                d => '.1.',
                a => '.2.',
                b => '.3.',
                f => '.4.',
            );
            my $ver_chars = join '', keys %ver_phases_map;

            sub by_versionstr {
                # a sort subroutine, expect $a and $b

                # $a is something like "//AST/PackageManagement/locators/feed/nipkg/ni-c/ni-compactrio/19.0.0/19.0.0.183-0+d183/verified#1 - ..."
                # split $a using /, the last but one element is the version string "19.0.0.183-0+d183"
                my ($A) = (split (/\//, $a))[-2];

                # remove "-0+", so we get "19.0.0.183d183"
                $A =~ s/\-0\+//g;

                # replace version phase 'd', we get "19.0.0.183.1.183"
                $A =~ s/([$ver_chars])/$ver_phases_map{$1}/g;
                # split into array
                my @AA = split (/\./, $A);

                # do the same for $b
                my ($B) = (split (/\//, $b))[-2];
                $B =~ s/\-0\+//g;
                $B =~ s/([$ver_chars])/$ver_phases_map{$1}/g;
                my @BB = split (/\./, $B);

                for my $i (0 .. $#BB)
                {
                    if ( $BB[$i] ne $AA[$i] )
                    {
                        # descending order
                        return $BB[$i] <=> $AA[$i];
                    }
                }

                return 0;
            }

            # sort the command_output using the by_versionstr subroutine
            # get the largest (the first) of the sorted array
            my ($largest)  = sort by_versionstr @command_output;

            # remove the "/verified#1 - add change xxxxx (text)" part
            $largest =~ s@/([^/]+)$@@g;

            my $xml_path = $largest . "/feedLocator.xml";
            Step::log_out ("The latest feedLocator is: " . $xml_path);

            $command = "p4 -p " . $self->find_p4port() . " -c " . $self->find_p4client() . " sync -f " . $xml_path . "#head";
            Step::log_out ("Running p4 command to sync files: " . $command);
            my $ret_val = readpipe($command);
            $ret_val =~ m/.*(added as|updating|refreshing)\s*(.*)\s*/;
            Step::log_out ("Feed locator is: " . $2);

            my $xmlFile = XMLin($2) || die "Unable to access $2...Sorry";
            my $latest = $xmlFile->{'path'} || die "Unable to find the node stored latest stable installer in $2...Sorry";
            $latest =~ s/^\s+|\s+$//g;
            $latest =~ s/(.*?)\\*$/$1\\/;

            return $latest;
        }
}

package Swstack_Installer;
{
        use strict;
        our @ISA = qw(Installer);    # inherits from Installer

        #constructor
        sub new {
            my ($class,$name) = @_;

            #call the constructor of the parent class, Installer.
            my $self = $class->SUPER::new($name);
            $self->{_flags}       = undef;
            $self->{_component_id}       = undef;
            $self->{_rating}       = undef;
            bless $self, $class;
            return $self;
        }

        #-------------------------------------------
        #Accessor methods
        #-------------------------------------------
        sub find_flags {
            my ($self) = @_;
            return $self->{_flags};
        }

        sub find_component {
            my ($self) = @_;
            return $self->{_component_id};
        }

        sub find_rating {
            my ($self) = @_;
            return $self->{_rating};
        }
        #-------------------------------------------
        #Member methods
        #-------------------------------------------

        #-------------------------------------------
        # Execute. Member function to execute the step. Overrides parent's
        # execute ();
        #-------------------------------------------
        #
        sub execute {
            my ($self) = @_;

            my $cid = $self->find_component();
            my $rate = $self->find_rating();

            Step::log_out ("Trying to find latest stable installer for component from swstack (ID=" . $cid . ", rating>=" . $rate . ")");

            my $latest = readpipe("ParseStableInstaller.py -i $cid -r $rate");
            Step::log_out ("GetLatestInstaller: " . $latest);

            chomp($latest);
            $self->path($latest . "\\offline\\uncompressed\\");

            # TODO: Move this into a common private method of command later on.
            if ($self->sleep_until_reboot())                            #if this step will reboot the system
                    {
                         $Step::rebooting = 1;                          #Set the global flag for an inminent reboot
                    }

            $self->build_and_run_command();
        }


}

package StepClassTest;
{
        $test_result = 1;
        $test_counter = 0;
        my @failed_tests=();
        #print "overall result: " . $StepClassTest::test_result . "\n";

        #Function to keep track of the test overall test results
        sub result {
            my ($new_result)=@_;
            if (!$new_result)
            {
                push (@failed_tests,$StepClassTest::test_counter);
            }
            $StepClassTest::test_counter++;
            $StepClassTest::test_result = $StepClassTest::test_result && $new_result;
        #print "new result: " . $new_result . "\n";
        #print "overall result: " . $StepClassTest::test_result . "\n";
        }

        sub failed_tests {
               return @failed_tests;
        }

        #------------
        #Tests
        #------------
        sub step_class_autotest {

            #Static creation tests
            my @steps = ();
            result($steps[@steps]=new Step('step1'));
            result($steps[@steps]=new Step('step2'));
            result($steps[@steps]=new Command('MyCommand step'));
            result($steps[@steps]=new Reboot('MyReboot'));
            result($steps[@steps]=new Installer('MyInstaller'));
            result($steps[@steps]=new Scripted_Copy('MyScriptedCopy'));
            result($steps[@steps]=new Latest_Installer('MyLatestInstaller'));

            # Test dynamic creation, e.g. when we don't know the type ahead of time
            my $step_class = 'Command';
            my $dynamically_created_step;

            #Try the case where things are ok
            result ($dynamically_created_step = Step::new_step($step_class,'My First Dynamic step'));

            #Try the case where the class name is invalid
            $step_class = 'TheCommand';
            result (!($dynamically_created_step = Step::new_step($step_class,'My-should-have-failed-step')));

             #Try the case where the name is correct but the case is incorrect (we want to be case-insensitive)
            $step_class = 'lAtest_iNSTaller';
            result ($dynamically_created_step = Step::new_step($step_class,'My First Dynamic step'));

            return result(1);
        }
}

sub DESTROY {
}

1;
__END__

