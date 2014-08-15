#!/usr/bin/perl 
################################################################################
# Filename: transfer_file.pl
#
# Description: 1)This script picks up the passed in file
#              then copies it to the specified target directory.
#              on a remote server. It does a cksum both before and after
#              transfer to verify the validity of the transfer
#              
# Returns: 0 on success, 1 on failure, 2 on fatal error
#               
# Usage: transfer_file.pl -a [put|get] -f <local_file> -s <server> -t <target_dir> [-v level] [-h] 
# Where:
#       -a action [put, get]
#       -f full path to local file
#       -t target dir
#       -r target file name
#       -s target server
#       -v verbose level, optional if not defined silent is assumed \n";
#                         if no value is given 0 is assumed\n\n";
#       -h help
#
#!WHO          DATE        DESCRIPTION
# pmccann      03/29/07    (v1.0) Created (was originally stage_target)
#
################################################################################
sub usage
{
 print "usage: transfer_file.pl -a [put|get] -f <local_file> -s <server> -t <target_dir> [-v level] [-h] ";
 print "Where:\n";
 print "      -a action [put, get]\n";
 print "      -f full path to local file\n";
 print "      -t target dir\n";
 print "      -r target file name\n";
 print "      -s target server\n";
 print "      -v verbose level, optional if not defined silent is assumed \n";
 print "                        if no value is given 0 is assumed\n\n";
 print "      -h help \n";
 exit 0; 

}
##################
# validate_input: Does what it says
# Calling profile: validate_input();
# Returns: 
##################
sub validate_input
{

my $action="";
my $local_file="";
my $target_dir="";
my $target_file="";
my $target_server="";
my $verbosity=0;
my $flags="";

if ( $opts{h} ){  #help
  &usage;
  exit 0;
}
if ( ! $opts{a} ) {
  &error("Command line option \"-a action\" is required\n\n");
  &usage();
}
if ( ! $opts{f} ) {
  &error("Command line option \"-f local file\" is required\n\n");
  &usage();
}
if ( ! $opts{r} ) {
  &error("Command line option \"-r remote file name\" is required\n\n");
  &usage();
}
if ( ! $opts{t} ) {
  &error("Command line option \"-t target_dir\" is required\n\n");
  &usage();
}
if ( ! $opts{s} ) {
  &error("Command line option \"-s server\" is required\n\n");
  &usage();
}

foreach $flag (keys(%opts)) {          # Loop thru the entered keys.

       if ( $flag eq "a" ) {
         $action=$opts{$flag};
         #Check to see if the -a flag is followed by an argument
           if ( ! $action || $action =~ m!^[-]!) {
             &error("Option -a requires parameter \n");
             &usage;
           } 
           if (( $action ne "put" ) && ($action ne "get")) {
             &error("Option -a requires either [put, get]\n");
             &usage;
           } 
        }

       if ( $flag eq "f" ) {
         $local_file=$opts{$flag};
         #Check to see if the -f flag is followed by an argument
           if ( ! $local_file || $local_file =~ m!^[-]!) {
             &error("Option -f requires a parameter\n");
             &usage;
           }
        }

       if ( $flag eq "r" ) {
         $target_file=$opts{$flag};
         #Check to see if the -s flag is followed by an argument
           if ( ! $target_file || $target_file =~ m!^[-]!) {
             &error("Option -r requires a remote file name\n");
             &usage;
           }
        }

       if ( $flag eq "s" ) {
         $target_server=$opts{$flag};
         #Check to see if the -s flag is followed by an argument
           if ( ! $target_server || $target_server =~ m!^[-]!) {
             &error("Option -s requires a servername\n");
             &usage;
           }
        }

       if ( $flag eq "t" ) {
         $target_dir=$opts{$flag};
         #Check to see if the -t flag is followed by an argument
           if ( ! $target_dir || $target_dir =~ m!^[-]!) {
             &error("Option -t requires a servername\n");
             &usage;
           }
        }

       if ( $flag eq "v" ) {
         $verbosity=$opts{$flag};
         #Check to see if the -v flag is followed by an argument
         #if not set it to 0
           if ( ! $verbosity || $verbosity =~ m!^[-]!) {
              $verbosity=0;
           }
        }
}

return($verbosity,$action,$local_file,$target_dir,$target_file,$target_server);
}

##################
# do_main: This function is the main logic block, 
# Calling Profile: do_main();
# Returns:  
##################
sub do_main
{
my ($verbosity,$action,$local_file,$target_dir,$target_file,$target_server) = @_;
my $checksum="";
my $cmd="";
my $exit_code="";
my $hostname="";
my $local_dir="";
my $result="";
my $copy_status=1;
my $status=0;
my $script_status=0;
my $thedate="";
my $thetime="";
my $tail="";
my $query="";
my $und="";     #undefined

&set_debug($verbosity);

$hostname=&hostname;

$thedate=&time::timestamp(yyyymmdd);
&debug(1,"**********************************************************\n");
$thetime=&time::timestamp(mesg,"Processing Starting at:");
&debug(1,"$thetime\n");

#break out the local file to its parts
($local_file,$local_dir,$tail)=&fileparse($local_file);

$checksum=&file_utils::get_checksum("$local_dir/$local_file");
&debug(2,"checksum: $checksum\n");

    &debug(1,"Copying $local_file to $target_dir on $target_server\n");
    #if we are copying to this system use copy instead
    if ($target_server eq $hostname) { 
       #file copy returns 1 on success 0 on failure
       $copy_status=&File::Copy::copy($local_file,"$target_dir/$target_file");
    } else {
       ($status,$std_out_ref,$std_err_ref)=&system::scp_file($target_server,$action,$local_dir,$local_file,$target_dir,$target_file);
    }

    @stdout= @$std_out_ref; 
    @stderr= @$std_err_ref; 

    if (( $copy_status eq "0" ) || ( $status ne "0" )) {
       $script_status=1; 
    }

    if ( $status ne "0" ) {
     &error("Failed to transfer $local_dir/$local_file to $target_dir/$target_file\n");
     &debug(2,"exit_code:$status\n");
     &debug(2,"std_err:@stderr \n");
     &debug(2,"std_out:@stdout \n");

    } elsif ( $copy_status ne "1" ) {
     &error("Failed to copy $local_dir/$local_file $target_dir/$target_file\n");
     &debug(2,"exit_code:$copy_status\n");

    }else {
     &debug(2,"Successfully copied $local_dir/$local_file to $target_server \n@mystdout\n");
     &debug(2,"Checking correct transfer of archive to $target_server\n");

     $cmd="$config::CKSUM_CMD $target_dir/$target_file";
     &debug(2,"Executing $cmd on $target_server\n");

    if ($target_server eq $hostname) {

      ($status,$std_out_ref,$std_err_ref)=&system::execute("$cmd");
      @stdout= @$std_out_ref; 
      #@stderr= @$std_err_ref; 
      $result=@stdout[0];
    } else {

     ($status,$std_out_ref,$std_err_ref)=&system::execute_ssh_cmd($target_server,"$cmd");
      @stdout= @$std_out_ref; 
      #@stderr= @$std_err_ref; 
      $result=@stdout[0];
    }

    if ($status eq "0" ) {
      $result=~ s/\s+/!/g;   #strip multiple \s spaces and replace with !
      ($result,$und,$und) = split /!/,$result,3;
      &debug(2,"Remote Checksum: $result\n
                std_out:@stdout\n");
    } else {
      &error("Failed to get remote checksum\n"); 
      &debug(2,"exit_code:$status\n");
      &debug(2,"std_err:@stderr \n");
      &debug(2,"std_out:@stdout \n");
      $script_status=1;
    }

    if ( $checksum == $result ) {
       &debug(1,"Checksums match\n");
    } else {
       &error("Checksums do not match\n");
       $script_status=1;
    }

    } #end of else successful copy

$thetime=&time::timestamp(mesg,"Processing Completed at:");
&debug(1,"$thetime\n\n");
&debug(1,"**********************************************************\n");
#$status=&gen_report("$logfile",$USER);
exit $script_status;
}


#==============================================================================
# MAIN 
use FindBin qw($Bin);
use lib "$Bin/../lib";

use File::Basename;
use File::Copy;
use File::Path;
use Env;
use Sys::Hostname;
use Getopt::Std;
### libraries by pete ###
use config;
use time;
use system;
use file_utils;
require ("message.pl");

#Main variables
my $action="";
my $local_file="";
my $verbosity="";
my $target_dir="";
my $target_file="";
my $target_server="";

# Make sure that STDOUT and STDERR are unbuffered.
select((select(STDOUT), $| = 1)[0]);
select((select(STDERR), $| = 1)[0]);

$SIG{'INT'} = 'INT_handler';

#CONSTANTS (ALL CAPS)
$SCRIPT_NAME="transfer_file.pl";

&getopts("a:f:r:s:t:v:h",\%opts);

($verbosity,$action,$local_file,$target_dir,$target_file,$target_server)=&validate_input();
&do_main($verbosity,$action,$local_file,$target_dir,$target_file,$target_server);

