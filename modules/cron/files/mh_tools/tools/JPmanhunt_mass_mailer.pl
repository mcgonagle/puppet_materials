#!/usr/bin/perl 
################################################################################
# Filename: manhunt_mass_mailer.pl
#
# Description: 1)This script reads a list of email addresses 
#              and sends them a spam message from manhunt
#              it takes several arguments 
#              - file of email addresses
#              - file to the message content  
#              - file to the subject line
#              - a delay in seconds between each send
#              
# Returns: 0 on success, 1 on failure, 2 on fatal error
#               
# Usage: manhunt_mass_mailer.pl -f <address_file> -m <message_file> 
#                               -s<subject_file> -d <delay> [-v level] [-h] 
# Where:
#       -f address_file
#       -m message_file
#       -s subject_file
#       -d "delay in seconds"
#       -v verbose level, optional if not defined silent is assumed \n";
#                         if no value is given 0 is assumed\n\n";
#       -h help
#
#!WHO          DATE        DESCRIPTION
# pmccann      04/04/07    (v1.0) Created
#
################################################################################
sub usage
{
 print "usage: manhunt_mass_mailer.pl -f <file> -m <message_file> -s <subject_file>  [-v level] [-h] ";
 print "Where:\n";
 print "      -f address_file\n";
 print "      -m message_file\n";
 print "      -s subject_file \n";
 print "      -d delay \n";
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
my $message_file="";
my $verbosity=0;
my $delay=0;
my $flags="";

if ( $opts{h} ){  #help
  &usage;
  exit 0;
}
if ( ! $opts{f} ) {
  &error("Command line option \"-f email_address file\" is required\n\n");
  &usage();
}
if ( ! $opts{m} ) {
  &error("Command line option \"-m message file\" is required\n\n");
  &usage();
}
if ( ! $opts{s} ) {
  &error("Command line option \"-s subject file\" is required\n\n");
  &usage();
}

foreach $flag (keys(%opts)) {          # Loop thru the entered keys.

       if ( $flag eq "f" ) {
         $address_file=$opts{$flag};
         #Check to see if the -f flag is followed by an argument
           if ( ! $address_file || $address_file =~ m!^[-]!) {
             &error("Option -f requires a parameter containing a list of email addresses\n");
             &usage;
           }
        }

       if ( $flag eq "m" ) {
         $message_file=$opts{$flag};
         #Check to see if the -m flag is followed by an argument
           if ( ! $message_file || $message_file =~ m!^[-]!) {
             &error("Option -m requires a message name\n");
             &usage;
           }
        }
       if ( $flag eq "s" ) {
         $subject=$opts{$flag};
         #Check to see if the -s flag is followed by an argument
           if ( ! $subject || $subject =~ m!^[-]!) {
             &error("Option -s requires a remote file name\n");
             &usage;
           }
        }

       if ( $flag eq "d" ) {
         $delay=$opts{$flag};
         #Check to see if the -d flag is followed by an argument
           if ( ! $delay || $delay =~ m!^[-]!) {
              $delay=0;
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

return($verbosity,$address_file,$message_file,$subject,$delay);
}


##################
# send_mail: This function sends mail
# Calling Profile: &send_mail($from,$to,$subject,$message_ref);
#                  where $message_ref is a reference to an array 
#                        containing the message to send
# Returns: none 
##################

sub send_mail {
 my ($from,$to,$subject,$message_ref)= @_;
 my $msg;
 my @message=@$message_ref;

    $msg = MIME::Lite->new(
           From    => $from,
           To      => $to,
           Subject => $subject,
           Type    => 'text/plain; charset=shift_JIS',
           Data    => \@message ); 

   $msg->send(  );

}


##################
# do_main: This function is the main logic block, 
# Calling Profile: do_main();
# Returns:  
##################
sub do_main
{
my ($verbosity,$address_file,$message_file,$subject,$delay) = @_;
my $checksum="";
my $cmd="";
my $exit_code="";
my $email;
my $from="support\@manhunt.jp";
my $membername;
my $message_body;
my $subject_body;
my $hostname="";
my $line="";
my $newline="";
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

 if (!open (SUBJECT_FH, "< $subject")) {
       &fatal_error("Couldn't open subject file: $subject $!\n");
 } else {
     while (<SUBJECT_FH>) {
        chop;             # By default these 3 lines operate on $_ which is
                          # the name of the input line, thus until i set
                          # line=$_ I can use it as an implied variable.
        next if (/^#/);           # skip lines that begin with comments
        next if (/^\/\*/);        # skip lines that begin with /*
        next unless (/\S/);       # skip Blank Lines
        $line=$_;                 # Here I define line to $_
        $line=~ s/\s*$//;         # strip trailing whitespace
        $line=~ s/^\s*//;         # strip leading whitespace
        $line=~ s/\s+/ /g;        # strip multiple "\s" spaces replace w/1sp
        $subject=$line;           # hopefully what's left is the subject
     }
       close (SUBJECT_FH);
 }

 if (!open (MESSAGE_FH, "< $message_file")) {
       &fatal_error("Couldn't open message file: $message_file $!\n");
 } else {
       #shlep the whole thing in for now
       @message_body=<MESSAGE_FH>;
       close (MESSAGE_FH);
#  print "@message_body\n";
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
        next unless (/\S/);       # skip Blank Lines
        $line=$_;                 # Here I define line to $_
        $line=~ s/\s*$//;         # strip trailing whitespace
        $line=~ s/^\s*//;         # strip leading whitespace
        $line=~ s/\s+/ /g;        # strip multiple "\s" spaces replace w/1sp
        $line=~ s/\'//g;          # strip single quotes
        $email=$line; 
       # ($membername,$email) = split /,/,$line,2;
               
       #  $cmd="chkaddr.pl -a $email";
       # ($status,$std_out_ref,$std_err_ref)=&system::execute("$cmd");
       # @stdout= @$std_out_ref;
       # @stderr= @$std_err_ref;

       # if ($status eq "0" ) { #good address
       #   push (@good_email, $line);
       # } else { #bad address
       #   push (@bad_email, $line);
       # }

        sleep $delay;
        if (!open (LAST_MAIL_SENT_FH, "> last_mail_sent")) {
            &error("Couldn't last_mail_sent for writing $!\n");
         } else {
            print LAST_MAIL_SENT_FH "$email\n";
            close(LAST_MAIL_SENT_FH);
         }
        &send_mail($from,$email,$subject,\@message_body);
        # print "email:$email,membername:$membername\n";
    }
  }

close (ADDRESS_FH);
#foreach $email (@good_email) {
#        ($membername,$email) = split /,/,$email,2;
#        foreach  $line (@message_body) {
#           if ($line =~ /_MEMBERNAME_/ ) {
#            #do really cool stuff
#            ($newline = $line) =~ s/_MEMBERNAME_/$membername/;
#            push(@new_message_body,$newline);
#           } else {
#            push(@new_message_body,$line);
#           }
#        }
#        &send_mail($from,$email,$subject,\@new_message_body);
#}
#foreach $email (@bad_email) {
#        print "bad email: $email\n";
#}

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
### libraries by pete ###
use time;
use system;
use file_utils;
require ("message.pl");
require ("log.pl");

#Main variables
my $address_file="";
my $subject="";
my $verbosity="";
my $delay="";
my $message_file="";

# Make sure that STDOUT and STDERR are unbuffered.
select((select(STDOUT), $| = 1)[0]);
select((select(STDERR), $| = 1)[0]);

$SIG{'INT'} = 'INT_handler';

#CONSTANTS (ALL CAPS)
$SCRIPT_NAME="manhunt_mass_mailer.pl";

&getopts("f:m:s:d:v:h",\%opts);

($verbosity,$address_file,$message_file,$subject,$delay)=&validate_input();
&do_main($verbosity,$address_file,$message_file,$subject,$delay);

