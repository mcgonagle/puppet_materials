#!/usr/bin/perl 
################################################################################
# Filename: prep_email_lists.pl
#
# Description: This script takes a file containing email addresses
#              -It sorts them using the unix command sort with
#                  the -u (unique) flag. This avoids reading very large files
#                  into memory and processing them a line at a time.
#              -It then determines the number of lines in the file
#                 and divides it by 8, then calls the Unix command 
#                 split -l <numlines> -a 1 -d filename www13
#              -This will split it into 8 files named www130 ... www137
#              -Then for completeness we just copy www130 to www138
#              -If the output_dir exists then we fail fataly
#              
#              
# Returns: 0 on success, 1 on failure, 2 on fatal error
#               
# Usage: prep_email_lists.pl -f <address_file> -o <output_dir> [-v level] [-h] 
# Where:
#       -f <address_file>
#       -o <output_dir>
#       -v verbose level, optional if not defined silent is assumed \n";
#                         if no value is given 0 is assumed\n\n";
#       -h help
#
#!WHO          DATE        DESCRIPTION
# pmccann      04/25/07    (v1.0) Created
#
################################################################################
sub usage
{
 print "usage: prep_email_lists.pl -f <address_file> -o <output_dir> [-v level] [-h] ";
 print "Where:\n";
 print "      -f <address_file>\n";
 print "      -o <output_dir>\n";
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
my $address_file="";
my $good_email_file="";
my $bad_email_file="";
my $verbosity=0;
my $flags="";

if ( $opts{h} ){  #help
  &usage;
  exit 0;
}
if ( ! $opts{f} ) {
  &error("Command line option \"-f address_file\" is required\n\n");
  &usage();
}
if ( ! $opts{o} ) {
  &error("Command line option \"-o output_dir\" is required\n\n");
  &usage();
}

foreach $flag (keys(%opts)) {          # Loop thru the entered keys.

       if ( $flag eq "f" ) {
         $address_file=$opts{$flag};
         #Check to see if the -f flag is followed by an argument
           if ( ! $address_file || $address_file =~ m!^[-]!) {
             &error("Option -f requires a parameter\n");
             &usage;
           }
        }
       if ( $flag eq "o" ) {
         $output_dir=$opts{$flag};
         #Check to see if the -b flag is followed by an argument
           if ( ! $output_dir || $output_dir =~ m!^[-]!) {
             &error("Option -o requires a parameter\n");
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

return($verbosity,$address_file,$output_dir);
}

##################
# do_main: This function is the main logic block, 
# Calling Profile: do_main();
# Returns:  
##################
sub do_main
{
my ($verbosity,$address_file,$output_dir) = @_;
my $checksum="";
my $cmd="";
my $email;
my $hostname="";
my $line="";
my $numlines="";
my $status=0;
my $script_status=0;
my $thedate="";
my $thetime="";

&set_debug($verbosity);
$hostname=&hostname;

$thedate=&time::timestamp(yyyymmdd);
&debug(1,"**********************************************************\n");
$thetime=&time::timestamp(mesg,"Processing Starting at:");
&debug(1,"$thetime\n");

if ( ! -d $output_dir ) { #if the output dir doesn't exist create it
  &debug(2,"$output_dir doesn't exist, attempting to create it \n");
  &File::Path::mkpath($output_dir,0,0775);
  if ( -d $output_dir ) {
    &debug(2,"Successfully created $output_dir\n");
  } else {
    &fatal_error("Unable to create $output_dir\n");
  }
   
} else {
  &fatal_error("$output_dir already exists, you may want to cleanup or\n choose another directory \n");
  
}

 if ( ! -e  $address_file) {
   &fatal_error("Couldn't locate address file: $address_file $!\n");
 } else {
   $cmd="sort -u $address_file";
   ($status,$std_out_ref,$std_err_ref)=&system::execute("$cmd");
   @stdout= @$std_out_ref;
   @stderr= @$std_err_ref;
   if ($status ne "0" ) {
      &error("Failed to execute $cmd\n");
      &debug(2,"exit_code:$status\n");
      &debug(2,"std_err:@stderr \n");
      &debug(2,"std_out:@stdout \n");
      $script_status=1;
      &fatal_error("Unable to sort file $address_file\n ...all processing stopped $!\n");
   } else {
      &debug(2,"Successfully Sorted list\n");
      &debug(3,"sorted list:std_out:\n@stdout\n");
       if (!open (SORTED_FILE_FH, "> $output_dir/$address_file.sort")) {
         &fatal_error("Couldn't open $address_file.sort for writing: $!\n");
       } else {
         print SORTED_FILE_FH "@stdout";
       }
         close (SORTED_FILE_FH);

   }

   $cmd="cat $output_dir/$address_file.sort | wc -l ";
   ($status,$std_out_ref,$std_err_ref)=&system::execute("$cmd");
   @stdout= @$std_out_ref;
   @stderr= @$std_err_ref;
   if ($status ne "0" ) {
      &error("Failed to execute $cmd\n");
      &debug(2,"exit_code:$status\n");
      &debug(2,"std_err:@stderr \n");
      &debug(2,"std_out:@stdout \n");
      $script_status=1;
      &fatal_error("Unable to run $cmd ...all processing stopped $!\n");
   } else {
      &debug(2,"Successfully determined the number of lines:std_out:@stdout\n");
      $num_lines=@stdout[0];
   }
    &debug(2,"numlines in the sorted file:$num_lines\n");
    $modulus= $num_lines % 8;       #get the remainder 
    &debug(2,"modulus: $modulus\n");
    $diff= 8 - $modulus;            #subtract the remainder from 8
    $num_lines= $num_lines + $diff; #add the remainder to the number of lines
                                    #so it is evenly divisible by 8
    $num_lines= $num_lines / 8;
    &debug(2,"numlines for each server after division by 8: $num_lines\n");
   if ( ! chdir $output_dir ) {
    &fatal_error("Unable to chdir to $output_dir to split the sorted email file\n");
   } else {
     $cmd="split -l $num_lines -a 1 -d $address_file.sort www13";
     ($status,$std_out_ref,$std_err_ref)=&system::execute("$cmd");
     @stdout= @$std_out_ref;
     @stderr= @$std_err_ref;
     if ($status ne "0" ) {
        &error("Failed to execute $cmd\n");
        &debug(2,"exit_code:$status\n");
        &debug(2,"std_err:@stderr \n");
        &debug(2,"std_out:@stdout \n");
        $script_status=1;
        &fatal_error("Unable to run $cmd ...all processing stopped $!\n");
     } else {
        &debug(2,"Successfully split the file\n std_out:@stdout\n");
        &File::Copy::move(www130,www138);
     }
   }

 }

$thetime=&time::timestamp(mesg,"Processing Completed at:");
&debug(1,"$thetime\n\n");
&debug(1,"**********************************************************\n");
exit $script_status;
}


#==============================================================================
# MAIN 

use FindBin qw($Bin);
use lib "$Bin/../lib";

use Sys::Hostname;
use Getopt::Std;
use File::Path;
use File::Copy;
### libraries by pete ###
use time;
use system;
use file_utils;
require ("message.pl");
require ("log.pl");

#Main variables
my $address_file="";
my $good_email_file="";
my $bad_email_file="";
my $subject="";
my $verbosity="";
my $message_file="";

# Make sure that STDOUT and STDERR are unbuffered.
select((select(STDOUT), $| = 1)[0]);
select((select(STDERR), $| = 1)[0]);

$SIG{'INT'} = 'INT_handler';

#CONSTANTS (ALL CAPS)
$SCRIPT_NAME="prep_email_lists.pl";

&getopts("f:o:v:h",\%opts);

($verbosity,$address_file,$output_dir)=&validate_input();
&do_main($verbosity,$address_file,$output_dir);

