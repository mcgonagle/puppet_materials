#!/usr/bin/perl 
################################################################################
# Filename: email_checker.pl
#
# Description: 1)This script reads a list of email addresses 
#              and sorts them into two files good email addresses
#              and bad email addresses
#              it takes several arguments
#              - a file of email addresses
#              - a file to contain good addresses
#              - a file to contain bad addresses that don't pass the chkaddr.pl
#                script for being valid
#              - a file containing a list of email addresses to exclude culled
#                from the /var/mail/root mail file as being User Unknown
#              
# Returns: 0 on success, 1 on failure, 2 on fatal error
#               
# Usage: email_checker.pl -f <address_file> -b bad_email_file 
#                         -g good_email_file [-e <exclude_list_file>]
#                         [-v level] [-h] 
# Where:
#       -f <address_file>
#       -b <bad_email_file>
#       -g <good_email_file>
#       -e <exclude_list_file>, optional
#       -v verbose level, optional if not defined silent is assumed \n";
#                         if no value is given 0 is assumed\n\n";
#       -h help
#
#!WHO          DATE        DESCRIPTION
# pmccann      04/04/07    (v1.0) Created
# pmccann      04/26/07    (v1.1) Added exclude file 
#
################################################################################
sub usage
{
 print "usage: email_checker.pl -f <address_file> -g <good_email_file> -b <bad_email_file> [-e exclude_file] [-v level] [-h] ";
 print "Where:\n";
 print "      -f address_file\n";
 print "      -b bad_email_file\n";
 print "      -g good_email_file\n";
 print "      -e exclude_file, optional\n";
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
my $exclude_file="none";
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
if ( ! $opts{b} ) {
  &error("Command line option \"-b bad_email_file\" is required\n\n");
  &usage();
}
if ( ! $opts{g} ) {
  &error("Command line option \"-g good_email_file\" is required\n\n");
  &usage();
}

foreach $flag (keys(%opts)) {          # Loop thru the entered keys.
       if ( $flag eq "b" ) {
         $bad_email_file=$opts{$flag};
         #Check to see if the -b flag is followed by an argument
           if ( ! $bad_email_file || $bad_email_file =~ m!^[-]!) {
             &error("Option -b requires a parameter\n");
             &usage;
           }
        }

       if ( $flag eq "e" ) {
         $exclude_file=$opts{$flag};
         #Check to see if the -e flag is followed by an argument
           if ( ! $exclude_file || $exclude_file =~ m!^[-]!) {
             &error("Option -e requires a parameter\n");
             &usage;
           }
        }

       if ( $flag eq "f" ) {
         $address_file=$opts{$flag};
         #Check to see if the -f flag is followed by an argument
           if ( ! $address_file || $address_file =~ m!^[-]!) {
             &error("Option -f requires a parameter\n");
             &usage;
           }
        }

       if ( $flag eq "g" ) {
         $good_email_file=$opts{$flag};
         #Check to see if the -f flag is followed by an argument
           if ( ! $good_email_file || $good_email_file =~ m!^[-]!) {
             &error("Option -g requires a parameter\n");
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

return($verbosity,$address_file,$good_email_file,$bad_email_file,$exclude_file);
}

##################
# do_main: This function is the main logic block, 
# Calling Profile: do_main();
# Returns:  
##################
sub do_main
{
my ($verbosity,$address_file,$good_email_file,$bad_email_file,$exclude_file) = @_;
my $bad_count="";
my $checksum="";
my $cmd="";
my $exit_code="";
my $email;
my $exclude_count=0;
my $from="manhuntmailbot\@manhunt.net";
my $good_count=0;
my $membername;
my $hostname="";
my $line="";
my $newline="";
my $percent_bad="";
my $percent_excluded="";
my $percent_good="";
my $status=0;
my $script_status=0;
my $thedate="";
my $thetime="";
my $total_count=0;
my $valid="";
my $wordcount="";

&set_debug($verbosity);
$hostname=&hostname;

$thedate=&time::timestamp(yyyymmdd);
&debug(1,"**********************************************************\n");
$thetime=&time::timestamp(mesg,"Processing Starting at:");
&debug(1,"$thetime\n");

 if ( $exclude_file ne "none" ) {
   if (!open (EXCLUDE_FILE_FH, "< $exclude_file")) {
       &fatal_error("Couldn't open $exclude_file for reading\n");
   } else {
       #shlep the whole thing in, sort it, then put it in a hash
       #for faster searching later on.
       @exclude_emails=<EXCLUDE_FILE_FH>;
       close (EXCLUDE_FILE_FH);
       @sorted_excludes=sort bystring @exclude_emails;

       #this all might be over kill if we are running on 64 bit processers
       #but what the heck

       foreach $email (@sorted_excludes) {
          chop $email;
          if (!$EXCLUDE_EMAIL_HASH{$email}) {
           #&debug(2,"putting $email in the hash\n");
           $EXCLUDE_EMAIL_HASH{$email}="$email";
          }
       }
   }
 }

 if (!open (GOOD_EMAIL_FH, "> $good_email_file")) {
       &fatal_error("Couldn't open $good_email_file for writing: $!\n");
 }
 if (!open (BAD_EMAIL_FH, "> $bad_email_file")) {
       &fatal_error("Couldn't open $bad_email_file for writing: $!\n");
 }

 if (!open (ADDRESS_FH, "< $address_file")) {
       &fatal_error("Couldn't open address file: $address_file $!\n");
  } else {

     while (<ADDRESS_FH>) {
        chop;             # By default these 3 lines operate on $_ which is
                          # the name of the input line, thus until i set
                          # line=$_ I can use it as an implied variable.
        next if (/^#/);           # skip lines that begin with comments
        next if (/^\/\*/);        # skip lines that begin with /*
        next if (/^\*/);          # skip lines that begin with *
        next unless (/\S/);       # skip Blank Lines
        $line=$_;                 # Here I define line to $_
        $line=~ s/\s*$//;         # strip trailing whitespace
        $line=~ s/^\s*//;         # strip leading whitespace
        $line=~ s/\s+/ /g;        # strip multiple "\s" spaces replace w/1sp
        $line=~ s/\'//g;          # strip single quotes
        $total_count++;
        $email=$line;


        #Reject it if it has more then 0 spaces in it
        #This may save a few micro seconds of processing
        $wordcount= ($email =~ tr/\ //); #Check for spaces
        if ($wordcount > 0) {
          &debug(2,"Space check failed for :$email\n"); 
          print BAD_EMAIL_FH "Space check failed for :$email\n";
          $bad_count++;
          next;
        }
      
        #Skip it if it's in the exclude list
        if ($EXCLUDE_EMAIL_HASH{$email}) {
          &debug(3,"Excluding $email\n");
          print BAD_EMAIL_FH "Excluding :$email\n";
          $exclude_count++;
          next;
        }

        $valid = Email::Valid->address($email,
                                       -mxcheck =>1 );
        if ( ! $valid ) {
            &debug(2,"$Email::Valid::Details check failed for:$email\n"); 
            print BAD_EMAIL_FH "$Email::Valid::Details check failed for:$email \n";
            $bad_count++;
        } else {
            debug(2,"Address valid: $valid\n");
            print GOOD_EMAIL_FH "$line\n";
            $good_count++;
        }

        #$cmd="/usr/local/manhunt/bin/chkaddr.pl -a $email -d";
        #$cmd="/home/pmccann/manhunt/bin/chkaddr.pl -a $email -d";
        #  &debug(2,"Executing $cmd\n");
        #($status,$std_out_ref,$std_err_ref)=&system::execute("$cmd");
        #@stdout= @$std_out_ref;
        #@stderr= @$std_err_ref;
        #if ($status eq "0" ) { #good address
        #  print GOOD_EMAIL_FH "$line\n";
        #  &debug(3,"stdout: @stdout\n");
        #  &debug(3,"stderr: @stderr\n");
        #  $good_count++;
        #} else { #bad address
        #  print BAD_EMAIL_FH "$line\n";
        #  print BAD_EMAIL_FH "@stdout\n";
        #  print BAD_EMAIL_FH "------\n";
        #  $bad_count++;
        #}
    }
  }
close(GOOD_EMAIL_FH);
close(BAD_EMAIL_FH);
close(ADDRESS_FH);

$percent_good= ($good_count / $total_count) * 100;
$percent_bad=  ($bad_count / $total_count) * 100;
$percent_excluded=($exclude_count / $total_count) * 100;

$percent_good = sprintf("%2.0f",$percent_good);
$percent_bad = sprintf("%2.0f",$percent_bad);
$percent_excluded = sprintf("%2.0f",$percent_excluded);

printf "%-10s %-11s %-11s %-11s\n",Total,Bad,Excluded,Good;
print "----------------------------------------------------\n";

printf "%-6.d %6.d(%2.d%%) %6.d(%2.d%%) %6.d(%2.d%%)\n", $total_count,$bad_count,$percent_bad,$exclude_count,$percent_excluded,$good_count,$percent_good;

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
use MIME::Lite;
use Mail::Address;
use Email::Valid;
use Net::DNS;
### libraries by pete ###
use sort;
use time;
use system;
use file_utils;
require ("message.pl");
require ("log.pl");

#Main variables
my $address_file="";
my $good_email_file="";
my $bad_email_file="";
my $exclude_file="";
my $verbosity="";

# Make sure that STDOUT and STDERR are unbuffered.
select((select(STDOUT), $| = 1)[0]);
select((select(STDERR), $| = 1)[0]);

$SIG{'INT'} = 'INT_handler';

#CONSTANTS (ALL CAPS)
$SCRIPT_NAME="email_checker.pl";

&getopts("b:e:f:g:v:h",\%opts);

($verbosity,$address_file,$good_email_file,$bad_email_file,$exclude_file)=&validate_input();
&do_main($verbosity,$address_file,$good_email_file,$bad_email_file,$exclude_file);

