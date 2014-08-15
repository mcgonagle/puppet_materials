#!/usr/bin/perl
################################################################################
# Filename: cmp_sums_files.pl
#
# Description: This script simply compares two sums files, that is two files
#              that contain checksums of directory structures
#              it helps if the files are sorted , but it is not necessary
#
#              To generate a sums file, go to your host system, and subdir
#              then execute the following command
#                    find . -type f -exec cksum {} \; > /tmp/<filename>
#              Then go to your second host then go to the same subdir and
#              execute the above command.
#
#              -OR-
#              use the script find_files.pl to generate your list.
# 
# Usage: cmp_sums_files.pl -f <file> -s <file2> 
# Where: 
#
# Example: 
#   
#!WHO          DATE        DESCRIPTION
# pmccann      03/09/07    (v1.0) Created
#
################################################################################
sub usage 
{
   print "usage: comparesums.pl -f <file> -s <file>\n\n";
   print "where:\n";
   print "-f <first_file>  required\n";
   print "-s <second_file> required \n";
   print "-h help, this message\n";
   print "\n";
}

##################
# validate_input: Does what it says
# Calls: read_projects
# Returns: app, env, root host, type of release, incremental flag
##################
sub validate_input
{
my $app;
my $flag;
my $found;
my $host;
my $project;
my $release_type;
my $rel_type;
my $env,$slc;
my $user;
my $version;
my $cmpversion;

if ( $opts{h} ) {  #help
  &usage;
  exit 1;
}

if ( ! $opts{f} ) { 
  print "Command line option \"-f <file> \" is required\n\n";
  &usage();
  #&fatal_error ("Command line option \"-a app \" is required\n \t\t--run comparesums.pl -h for usage \n");
} 
if ( ! $opts{s} ) { 
  print "Command line option \"-s <file> \" is required\n\n";
  &usage();
  #&fatal_error ("Command line option \"-a app \" is required\n \t\t--run comparesums.pl -h for usage \n");

}

foreach $flag (keys(%opts)) {          # Loop thru the entered keys. 

      if ( $flag eq "f" ) {
         $first_file=$opts{$flag};
         #Check to see if the -f flag is followed by an argument
         if ( ! $first_file || $first_file =~ m!^[-]!) {
            &usage;
            #&fatal_error("Option -t requires one of: @reltype_list \n");
            print "Option -t requires a file name\n";
         }
      }
          
       if ( $flag eq "s" ) {
           $second_file=$opts{$flag};
           if ( ! $second_file || $second_file =~ m!^[-]!) {
             &usage;
            # &fatal_error("Option -s requires a user name\n");
            print "Option -s requires a file name\n";
           }
       }

} # for each opts

  return($first_file,$second_file);

}
##################
# INT_handler: This function captures ctrl-c's and will flush the buffers
#              and close the logfile before exiting
#              To use this you must put the "calling profile syntax in
#              main section of code after require statments
# Calling profile: $SIG{'INT'} = 'INT_handler'
# Returns:
##################
sub INT_handler {
    # send error message to log file.
    #&error("Captured CTRL-C, cleaning up, and closing log file\n");
    # close all files.
    #&close_logfile("$LOGFILE");
    print "Captured CTRL-C, cleaning up \n";
    exit 1;
}


##################
# compare_files: generates arrays of added, deleted & changed config files
# Calling Profile: compare_files($sumsfile,$prevsums);
# Returns:
##################
sub compare_files 
{
my ($sumsfile,$prevsums) =@_;
my $cksum;
my $i_cksum;
my $c_cksum;
my $file;
my $added=0;
my $deleted=0;
my $changed=0;
my $line;
my $und;

  if (!open (INSTALL_FP, "< $sumsfile")) {
       #&error("compare_files: Couldn't open $sumsfile $!\n");
       #&fatal_error("compare_files: Couldn't open $sumsfile $!\n");
       print "compare_files: couldn't open first file: $sumsfile\n";
  }
  else {
     while (<INSTALL_FP>) {
        chop;             # By default these 3 lines operate on $_ which is
                          # the name of the input line, thus until i set
                          # line=$_ I can use it as an implied variable.
        next if (/^#/);           # skip lines that begin with comments
        next unless (/\S/);       # skip Blank Lines
        $line=$_;                 # Here I define line to $_
        $line=~ s/(\S*)\s*$/\1/o; #strip trailing whitespace
        $line=~ s/^\s*//;; #strip leading whitespace

        $line=~ s/\s+/!/g;   #strip multiple \s spaces and replace with !
        ($cksum,$und,$file) = split /!/,$line,3;
        if (!$INSTALL_LIST{$file}) {
                $INSTALL_LIST{$file}="$cksum";
        }
      } #while
  }   #else
close (INSTALL_FP);

# read the compare file
  if (!open (COMPARE_FP, "< $prevsums")) {
       #&error("compare_files: Couldn't open $prevsums $!\n");
       #&fatal_error("compare_files: Couldn't open $prevsums $!\n");
       print "compare_files: couldn't open second file:$prevsums\n";
  }
  else {
     while (<COMPARE_FP>) {
        chop;             # By default these 3 lines operate on $_ which is
                          # the name of the input line, thus until i set
                          # line=$_ I can use it as an implied variable.
        next if (/^#/);           # skip lines that begin with comments
        next unless (/\S/);       # skip Blank Lines
        $line=$_;                 # Here I define line to $_
        $line=~ s/(\S*)\s*$/\1/o; #strip trailing whitespace
        $line=~ s/^\s*//;; #strip leading whitespace

        $line=~ s/\s+/!/g;   #strip multiple \s spaces and replace with !
        ($cksum,$und,$file) = split /!/,$line,3;
        if (!$COMPARE_LIST{$file}) {
                $COMPARE_LIST{$file}="$cksum";
        }
      } #while
  }   #else
close(COMPARE_FP);

   foreach $file (keys(%INSTALL_LIST)) {
          if (!$COMPARE_LIST{$file}) {
            $added++;
            if (!$added_list{$file}) {
                $added_list{$file}="$file";
            }
          }
   }
   foreach $file (keys(%COMPARE_LIST)) {
          if (!$INSTALL_LIST{$file}) {
            $deleted++;
            if (!$deleted_list{$file}) {
                $deleted_list{$file}="$file";
            }
          }
   }
   foreach $file (keys(%INSTALL_LIST)) {
          if ($COMPARE_LIST{$file}) {
             $i_cksum=$INSTALL_LIST{$file};
             $c_cksum=$COMPARE_LIST{$file};
             if ( "$i_cksum" ne "$c_cksum" ) {
               $changed++;
               if (!$change_list{$file}) {
                   $change_list{$file}="$file";
               }
             }
          }
   }

return($deleted,$added,$changed);

}
##################
# print_report: generates the report of added, deleted & changed config files
# Calling Profile:print_report($num_deleted,$num_added,$num_changed);
# Returns:
##################
sub print_report
{

my ($num_deleted,$num_added,$num_changed,$targ_host)=@_;
my $fullname;
#my $sums_rpt_file="$REPORT_DIR/change_summary_rpt";

print "NUMBER OF CHANGED FILES: $num_changed \n";
#&log("NUMBER OF CHANGED FILES:$num_changed \n");
#&log("The following files were Changed\n");
print "The following files were Changed\n";

foreach  $fullname (keys(%change_list)) {
   #&log("$fullname\n");
   print"$fullname\n";
}

print "NUMBER OF ADDED FILES: $num_added\n";
#&log("\nNUMBER OF ADDED FILES:$num_added\n");
#&log("The following files were added\n");
print "The following files were added\n";
foreach  $fullname (keys(%added_list)) {
   #&log("$fullname\n");
   print"$fullname\n";
}

print "NUMBER OF DELETED FILES: $num_deleted\n";
#&log("\nNUMBER OF DELETED FILES:$num_deleted\n");
#&log("The following files were deleted\n");
print"The following files were deleted\n";
foreach  $fullname (keys(%deleted_list)) {
   #&log("$fullname\n");
   print "$fullname\n";
}


#&log("\n\n<B> Summary Report for $targ_host\n");
#&log("=============================\n");
#&log("NUMBER OF CHANGED FILES:$num_changed \n");
#&log("NUMBER OF ADDED FILES:$num_added\n");
#&log("NUMBER OF DELETED FILES:$num_deleted\n");
#&log("=============================</B>\n\n");

#if  (!open (COMPARE_SUMS_FP, ">>$sums_rpt_file")) {
#  &error("print_report: Unable to open $sums_rpt_file\n");
#} else {
#  print COMPARE_SUMS_FP "\n\nSummary Report for $targ_host\n";
#  print COMPARE_SUMS_FP "=============================\n";
#  print COMPARE_SUMS_FP "NUMBER OF CHANGED FILES:$num_changed \n";
#  print COMPARE_SUMS_FP "NUMBER OF ADDED FILES:$num_added\n";
#  print COMPARE_SUMS_FP "NUMBER OF DELETED FILES:$num_deleted\n";
#  print COMPARE_SUMS_FP "=============================\n\n";
#}
#close (COMPARE_SUMS_FP);

}



##################
# do_main: This function is the main logic block
# Calling Profile: do_main();
# Returns:  
##################
sub do_main
{
my $basename,$basepath,$tail;
my $cmd;
my $found=0;
my $hostname;
my $status;
my $source;
my $destination;
my $dr_file;
my $sumsfile, $sumsdir;
my $previous_version, $prevdir;
my $targ_host;
my $thetime;
my $und;
my $flag=0;
my $num_changed=0;
my $num_added=0;
my $num_deleted=0;
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);
my $version_dir;
local (@mystdout);
local (@mystderr);

($num_deleted,$num_added,$num_changed)=&compare_files($FIRST_FILE,$SECOND_FILE);
&print_report($num_deleted,$num_added,$num_changed);

}

#==============================================================================
# MAIN 
$exe_dir = $0;                         #get execution command
$exe_dir =~ s/\.pl$//;                 #strip off .pl
$exe_dir =~ s/(.*)[\\\/].+/$1/;        #strip off executable name
                                       #add directory to path
$ENV{'PATH'} = "$exe_dir:$ENV{'PATH'}" if $exe_dir; 
push (@INC, "$exe_dir") if $exe_dir;    #add directory to includes

#required

use Cwd;
use Env;
use Env qw(HOME);
use Sys::Hostname;
use Getopt::Std;

# Make sure that STDOUT and STDERR are unbuffered.
select((select(STDOUT), $| = 1)[0]);
select((select(STDERR), $| = 1)[0]);

$SIG{'INT'} = 'INT_handler';


#CONSTANTS (ALL CAPS)
$SCRIPT_NAME="cmp_sums_files.pl";

#Globals

&getopts("f:s:",\%opts);
($FIRST_FILE,$SECOND_FILE)=&validate_input();
&do_main();
