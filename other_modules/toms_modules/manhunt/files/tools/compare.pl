#!/usr/bin/perl
################################################################################
# Filename: compare.pl
#
# Description: this tool will compare two directory structures
#              and return 1)New files in the first directory
#                         2)Deleted files in the first directory
#                         3)Files changed 
# Usage:   
#    compare.pl [-h][-i<installdirpath>][-r<rollbackdirpath>]\n\n";
#    Where: 
#           h = help
#           i = path    #path to install dir
#           r = path    #path to rollback area
#
# Example: 
# compare.pl -i /www/icrpfbd/scripts -r /cc_reladm/crp/fbd/web_rollback/scripts
# compare.pl -i /www/icrpfbd/images -r  /cc_reladm/crp/fbd/web_rollback/images
# compare.pl -i /www/icrpfbd -r  /cc_reladm/crp/fbd/web_rollback
#
#
#!WHO          DATE        DESCRIPTION
# pmccann      12/20/02    (v2.0) redid the whole thing from scratch
# pmccann      09/19/02    (v1.3) Added change counts
# pmccann      07/17/02    (v1.2) Converted for use at Fleet
# pmccann      11/07/01    (v1.1) Handles New directory structure.
# pmccann      10/02/01    (v1.0) Created
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
#$err_code = system ("$cmd");

open ( cmdout, "< $StdOut") || die "execute: Could not open file $StdOut : $!\n"
;
@cmdout = <cmdout>;
close ( cmdout );


open ( cmderr, "< $StdErr") || die "execute: Could not open file $StdErr : $!\n"
;
@cmderr = <cmderr>;
close ( cmderr );

unlink($StdOut);
unlink($StdErr);

return $err_code;

}

sub wanted {
    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    &exec(0, 'cksum','{}');
}

sub exec {
    local($ok, @cmd) = @_;
    local (@mystdout);
    local (@mystderr);
    foreach $word (@cmd) {
        $word =~ s#{}#$name#g;
    }
    if ($ok) {
        local($old) = select(STDOUT);
        $| = 1;
        print "@cmd";
        select($old);
        return 0 unless <STDIN> =~ /^y/;
    }

    chdir $cwd;         # sigh
       my $adir = $dir;                          #is the fullpath to the file
       $adir =~ s/^\Q$INSTALLDIR//;              #strip installdir if there
       $adir =~ s/^\Q$COMPAREDIR//;              #strip comparedir if there
       $adir =~ s/^\///;                         #strip leading /
    if ( ! -d $name ) {                          # don't cksum directories
       $status = &execute("@cmd", *mystdout, *mystderr);
       ($checksum)=@mystdout;
       $checksum=~ s/\s+/!/g;   #strip multiple \s spaces and replace with !
       ($checksum,$und,$und) = split /!/,$checksum,3;
       if ($INSTALL) {
         if ( $adir ) {
            print INSTALL_FP "$checksum $adir/$_\n";
         } else {
            print INSTALL_FP "$checksum $_\n";
         }
       } else {
         if ( $adir ) {
            print COMPARE_FP "$checksum $adir/$_\n";
         } else {
            print COMPARE_FP "$checksum $_\n";
         }
       }
    }
    
    # system @cmd;
    chdir $dir;
    return !$?;
}

##################
# compare_files: generates the report of added, deleted & changed config files
# Calling Profile:
# Returns:
##################
sub compare_files 
{
my $cksum;
my $file;
my $added=0;
my $deleted=0;
my $changed=0;
  if (!open (INSTALL_FP, "< $TMPINSTALL")) {
       print "***Error: Couldn't open $TMPINSTALL $!\n";
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

        $line=~ s/\s+/!/g;   #strip multiple \s spaces and replace with !
        ($cksum,$file) = split /!/,$line,2;
        if (!$INSTALL_LIST{$file}) {
                $INSTALL_LIST{$file}="$cksum";
        }
      } #while
  }   #else
close (INSTALL_FP);

# read the compare file
  if (!open (COMPARE_FP, "< $TMPCOMPARE")) {
       print "***Error: Couldn't open $TMPCOMPARE $!\n";
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

        $line=~ s/\s+/!/g;   #strip multiple \s spaces and replace with !
        ($cksum,$file) = split /!/,$line,2;
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
# Calling Profile:
# Returns:
##################
sub print_report
{

my $fullname;
my ($num_deleted,$num_added,$num_changed)=@_;

   print "\n";
print "NUMBER OF CHANGED FILES: $num_changed \n";
print "The following files were Changed\n";
foreach  $fullname (keys(%change_list)) {
   print "\t$fullname\n";
}
print "\n";

print "NUMBER OF ADDED FILES: $num_added\n";
print "The following files were added to $INSTALLDIR\n";
foreach  $fullname (keys(%added_list)) {
   print "\t$fullname\n";
}
print "\n";

print "NUMBER OF DELETED FILES: $num_deleted\n";
print "The following files were deleted from $INSTALLDIR\n";
foreach  $fullname (keys(%deleted_list)) {
   print "\t$fullname\n";
}

print "\n";
print "NUMBER OF CHANGED FILES: $num_changed \n";
print "NUMBER OF ADDED FILES: $num_added\n";
print "NUMBER OF DELETED FILES: $num_deleted\n";
print "\n";

}
##################
# validate_input: Does what it says
# Calls:
# Called by: Main
# Returns:
##################
sub validate_input 
{
  my $flag;
  my $installdir;
  my $rollbackdir;


  if ( ! %opts ) {
     &usage;
     exit 0;
  }

  foreach $flag (keys(%opts))            # Loop thru the entered keys.
  {
        if ($flag eq "h") {  #help
           &usage;
           exit 0;
        }

       if ( $flag eq "i" ) { 
           $installdir=$opts{$flag};
           if ( ! $installdir || $installdir =~ m!^[-]! ) {
              print "***Error: Option -i requires a path name\n";
              &usage;
              exit 0;
           }
           else {
              print "Install Directory : $installdir\n";
           }
       }

       if ( $flag eq "r" ) { 
           $rollbackdir=$opts{$flag};
           if ( ! $rollbackdir || $rollbackdir =~ m!^[-]! ) {
              print "***Error: Option -r requires a path name\n";
              &usage;
              exit 0;
           }
           else {
              print "Compare Directory : $rollbackdir\n";
           }
       }
  }
  return($installdir,$rollbackdir);
}

##################
# usage: This function prints the usage and help 
# Calls:
# Called by: Main
# Returns:
##################
sub usage 
{
#Comand Line Options
#    h = help
#    i = path    #path to  install dir
#    r = path    #path to  rollback area
   print "\n";
print "usage: compare.pl -i<installdirpath> -r<rollbackdirpath> [-h]\n\n";
print "Example: compare.pl -i /www/icrpfbd -r /cc_reladm/crp/fbd/web_rollback\n";
print "         compare.pl -i /www/icrpfbd/images -r  /cc_reladm/crp/fbd/web_rollback/images\n";
}


##################
# do_main: This function is the main logic block, for the local system
#          Due to different daemons running on the server we need to check
#          to see if the system is up ,and if the system can take remote calls
# Calls:
# Called by: is Main
# Returns:  
##################
sub do_main
{
my $flag=0;
my $num_changed=0;
my $num_added=0;
my $num_deleted=0;

$INSTALL=1;
$TMPINSTALL="/tmp/install_$$";

($basename,$basepath,$tail)=&fileparse("$INSTALLDIR","");
if  (!open (INSTALL_FP, ">$TMPINSTALL")) {
     print "***Error: unable to open $TMPINSTALL\n";
} else {
   if ( !opendir(INSTALLDIR,$INSTALLDIR)) {
     print "***Error: Unable to open installdir: $INSTALLDIR\n";
   } else {
     @installdir_list= grep !/^\.\.?$/, readdir(INSTALLDIR);
     foreach $filename (@installdir_list) {     
        $filename="$INSTALLDIR/$filename";
        quotemeta $filename;
        &find(\&wanted,"$filename");
     }
   }
}
close (INSTALL_FP);

$INSTALL=0;
$TMPCOMPARE="/tmp/compare_$$";

($basename,$basepath,$tail)=&fileparse("$COMPAREDIR","");
if  (!open (COMPARE_FP, ">$TMPCOMPARE")) {
   print "***Error: unable to open $TMPCOMPARE\n";
} else {
   if ( !opendir(COMPAREDIR,$COMPAREDIR)) {
     print "***Error: Unable to open comparedir: $COMPAREDIR\n";
   } else {
     @rollbackdir_list= grep !/^\.\.?$/, readdir(COMPAREDIR);
     foreach $filename (@rollbackdir_list) {     
        $filename="$COMPAREDIR/$filename";
        quotemeta $filename;
        &find(\&wanted,"$filename");
     }
   }
}
close (COMPARE_FP);

($num_deleted,$num_added,$num_changed)=&compare_files();

&print_report($num_deleted,$num_added,$num_changed);

unlink($TMPINSTALL);
unlink($TMPCOMPARE);

}



#==============================================================================
# MAIN 
$exe_dir = $0;                         #get execution command
$exe_dir =~ s/\.pl$//;                 #strip off .pl
$exe_dir =~ s/(.*)[\\\/].+/$1/;        #strip off executable name
                                       #add directory to path
print LOGFILE_FP "EXEDIR: $exe_dir\n";
$ENV{'PATH'} = "$exe_dir:$ENV{'PATH'}" if $exe_dir; 
push (@INC, "$exe_dir") if $exe_dir;    #add directory to includes

use Env qw(HOME);
use Sys::Hostname;
use File::Find;
use File::Path;
use File::Compare;
use File::Basename;
use Getopt::Std;

use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

use Cwd ();
my $cwd = Cwd::cwd();


# Make sure that STDOUT and STDERR are unbuffered.
select((select(STDOUT), $| = 1)[0]);
select((select(STDERR), $| = 1)[0]);


#CONSTANTS (ALL CAPS)
$VERSION="compare.pl Release v1.1";

#Globals

getopts("i:r:h",\%opts);
($INSTALLDIR,$COMPAREDIR)=&validate_input();
&do_main();
