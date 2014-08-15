#!/usr//bin/perl
################################################################################
# Filename: find_files
#
# Description: This script simply generates a sorted list of files and their
#              checksums. This is script is used in conjunction with 
#              cmp_sums_files.pl to find the difference between to sums_files
# 
# Usage: 
# Where: 
#
# Example: 
#   
#!WHO          DATE        DESCRIPTION
# pmccann      03/12/07    (v1.0) Created
#
################################################################################
##################
# execute: Executes a system command
# Calls:
# Called by:
# Returns: StdOut Array, StdErr Array and success.
##################

sub execute
{

local ($cmd, *cmdout, *cmderr) = @_;

local($StdOut) = "/tmp/standard.out_$$";
local($StdErr) = "/tmp/standard.err_$$";
local($err_code);

unlink($StdOut);
unlink($StdErr);

select((select(STDOUT), $| = 1)[0]);
select((select(STDERR), $| = 1)[0]);


$err_code = system ("$cmd > $StdOut 2> $StdErr");

open ( cmdout, "< $StdOut") || die "execute: Could not open file $StdOut : $!\n" ;
@cmdout = <cmdout>;
close ( cmdout );


open ( cmderr, "< $StdErr") || die "execute: Could not open file $StdErr : $!\n" ;
@cmderr = <cmderr>;
close ( cmderr );

unlink($StdOut);
unlink($StdErr);

return $err_code;

}

##################
# usage: This function will print the usage and help
# Calling profile: usage();
# Called by: Main
# Returns: none
##################
sub usage
{
   print "Usage: find_files.pl -p path -o outfile \n\n";
   print "Example:   find_files.pl -p /home/build/branches/www -o monkey-www \n";
   print "\n";
}

##################
# validate_input: Does what it says
# Returns:
##################
sub validate_input
{
  my $flag;
  my $path;
  my $datafile;

if ( $opts{h} ) {  #help
  &usage;
  exit 0;
}


#if ( ! %opts{} ) {
#  &usage;
#  exit 0;
#}

  foreach $flag (keys(%opts))            # Loop thru the entered keys.
     {
        if ($flag eq "h") {  #help
           &usage;
           exit 0;
        }

     if ( ! $opts{p} ) {
           print("Command line option \"-p path\" is required\n \t\n");
           &usage;
           exit 1;
     }

     if ( $flag eq "p" ) {  # -p path
       $path=$opts{$flag};
       if ( ! $path || $path =~ m!^[-]!) {
           print("Option -p requires a path\n");
           &usage;
           exit 1;
       }
     }
     if ( $flag eq "o" ) {  # -o outputfile
       $datafile=$opts{$flag};
        if ( ! $datafile || $datafile =~ m!^[-]!) {
            print("Option -o requires a value\n");
            &usage;
            exit 1;
        }
     }
   }
 return ($path,$datafile);
}

##################
# traverse: Walks down a directory path looking for file types;
#           After it finds one it puts the path to it in an array.
#          -By the way this function is recursive.
# Calls:
# Called by: Main
# Returns: list of cfg, ini, and .dat files
##################

sub traverse {
    local($dir)=@_;
    local($path);
    my $checksum;
    
    my($found)=0;
   unless (opendir(DIR, $dir)) {
        print "***Error: Can't open $dir\n";
        closedir(DIR);
        return;
    }

    foreach (readdir(DIR)) {
#       last if ($found) ;
        next if (&skipdirs($_) );
        next if ( $path =~ /\.pre$/ );
        $path = "$dir/$_";
       if (-d $path) {                         # a directory keep looking
            &traverse($path);
       }
       elsif ( -z $path ) {
                print "Zero length $path skipping\n";
                
       } else {
                   $checksum=&get_checksum("$path");
                   push ( @unsorted_list, $checksum);
       }
    }
    closedir(DIR);
}
##################
# skipdirs: Tests to see if directory should be skipped
# Calls: none
# Called by: transfer
##################
sub skipdirs
{
   my ($dir) =@_;
   my ($skip) = 0;

   if ($dir eq '.' || $dir eq '..' ) {
      $skip++;
   }
   if ($dir eq '.svn' ) {
      $skip++;
   }
   if ($dir eq 'banners' ) {
      $skip++;
   }

   return $skip;
}

##################
# get_checksum: This function returns the checksum of the file passed to it
# Calling Profile: get_checksum($filename)
# $checksum=&get_checksum("$latest_tar");
# notes for later
# $checksum=~ s/\s+/!/g;   #strip multiple \s spaces and replace with !
# $checksum=~ s/:/!/g;     #strip : and replace with !
# ($checksum,$und,$und) = split /!/,$checksum,3;
# Returns:  checksum
##################
sub get_checksum
{
my ($filename) = @_;
my $exit_code;
my $checksum;
my $cksum_cmd="/usr/bin/cksum";

local (@mystdout);
local (@mystderr);

    #&debug (2,"--===Entering get_checksum===--\n\n");
    #&log("getting checksum for $filename\n");
    $exit_code= &execute("$cksum_cmd \"$filename\" ", *mystdout, *mystderr);
    if ( $exit_code != 0 )
    {
    #  &error("$chsum_cmd failed - @mystderr \n");
       print "$cksum_cmd failed @mystderr\n";
    }
    else {
     # &log("Successfully ran checksum\n - @mystdout\n");
      ($checksum)=@mystdout;
     #print "checksum $checksum\n";
    }
return ($checksum);
}

##################
# numerically: sort elements of passed in array by number
# Calling Profile:  @sorted_list = sort numerically @unsorted_list;
# Returns: an acending sorted array
##################
sub numerically { $a <=> $b; }

##################
# do_main: This function is the main logic block
# Calling Profile: do_main();
# Returns:
##################
sub do_main
{
my ($path,$datafile) = @_;
my $status;
my $host;
my $cwd;

local (@mystdout);
local (@mystderr);

print "Called with options: -p: $path -o $datafile\n";
 if ( !chdir $path ) {
   print "***Error: Unable to change to $path\n";
   exit 0;
 } else {
   $cwd = Cwd::cwd();
   $path=".";
 }
&traverse($path);
@sorted_list= sort numerically @unsorted_list;

if (!open (DATA_FP, "> $datafile")) {
   print "Unable to open $datafile for writing\n";
} else {
  foreach $file (@sorted_list) {
   print DATA_FP $file
  }
}

}

#==============================================================================
# MAIN
$exe_dir = $0;                         #get execution command
$exe_dir =~ s/\.pl$//;                 #strip off .pl
$exe_dir =~ s/(.*)[\\\/].+/$1/;        #strip off executable name
                                       #add directory to path
$ENV{'PATH'} = "$exe_dir:$ENV{'PATH'}" if $exe_dir;
push (@INC, "$exe_dir") if $exe_dir;    #add directory to includes

use Cwd ();
use File::Path;
use File::Find;
use File::Basename;
use Getopt::Std;

# Make sure that STDOUT and STDERR are unbuffered.
select((select(STDOUT), $| = 1)[0]);
select((select(STDERR), $| = 1)[0]);

#CONSTANTS (ALL CAPS)
$VERSION="find_file.pl Release v1.0";

#Globals

&getopts("p:o:h",\%opts);
my ($PATH,$DATAFILE)=&validate_input();

&do_main($PATH,$DATAFILE);

