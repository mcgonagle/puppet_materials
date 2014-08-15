#!/usr/bin/perl -w
#
# Script for checking status of a job, based on some statusfile data
#
# $Id: check_log_completion.pl,v 1.4 2010/06/25 15:10:10 wflynn Exp $
#
# wflynn 6/10
#
# This checker works on the idea that a script that we want to monitor will write a status log
# each time it is run.  That log will contain a single digit, 0, 1, 2, or 3, depending on the exit status
# of the script: 0 is a clean run, 1 is a run with a condition that should be warned on, 2 is a run with
# with a critical error, and 3 is a run resulting in some unknown status.
#
# Shell Variables for these values have been added to source.sh.tpl, elsewhere.
#
# This script is passed a log file name and a maximum accepted file age in seconds for critical and/or warning levels.
# If the statusfile to be checked is older than the specified file age, this script returns with the appropriate failure.
#
# If the statusfile is of acceptable age, this script returns the exit status of the relevant job,
# as found in the statusfile.
#
# Some Helpful values for seconds:
# 15 Minutes: 900
# Half Hour:  1800
# Hourly:     3600
# Daily:      86400
# Weekly:     604800
# Monthly:    2629744
# Yearly:     31556926
#

use strict;
use Time::Local;

my $version_string = ' $Id: check_log_completion.pl,v 1.4 2010/06/25 15:10:10 wflynn Exp $ ';
my $usage_string = "$0 --statusfile <status file> --warning <status file age in seconds> --critical <status file age in seconds>";

# NAGIOS plugin compliant return codes:
our ($OK, $WARNING, $CRITICAL, $UNKNOWN) = (0 .. 3);
our @STATUS = ('OK', 'WARNING', 'CRITICAL', 'UNKNOWN');

# http://perldoc.perl.org/Getopt/Long.html
use Getopt::Long qw(:config no_ignore_case bundling);

## These options are reserved by NAGIOS plugin specification.
our (
     $opt_version,
     $opt_help,
     $opt_timeout,
     $opt_warning,
     $opt_critical,
     $opt_hostname,
     $opt_verbose,
    );

## These options are reserved by NAGIOS plugin conventional usage.
our (
     $opt_community,
     $opt_authentication,
     $opt_logname,
     $opt_port,
     $opt_url,
    );

## Our options
our (
     $opt_statusfile,
    );

my  $result = GetOptions (
			  # REQUIRED:
			  "version|V" => sub { print "Version: $version_string\n"; },
			  "help|h"  => sub { print "Usage: $usage_string\n"; },
			  "timeout|t=i",
			  "warning|w=i",
			  "critical|c=i",
			  "hostname|H=s",
			  "verbose|v+",
			  # CONVENTIONAL:
			  "community|C=s",
			  "authentication|a=s",
			  "logname|l=s",
			  "port|p=i",
			  "url|u=s",
			  # OURS:
			  "statusfile=s",
			 );

($opt_statusfile and ($opt_critical or $opt_warning)) or ( print "Usage: $usage_string\n" and exit ($UNKNOWN));

# NAGIOS plugin guidelines recommend an enforced timeout.
$SIG{ALRM} = \&alarm_handler;
my $timeout = 10;
if ($opt_timeout) {
  $timeout=$opt_timeout;
}
alarm($timeout);

if (-f $opt_statusfile) {
  my $file_age_status = &get_file_age_status();
  if ($file_age_status != $OK) {
    print "$opt_statusfile AGE: $STATUS[$file_age_status]\n" and exit($file_age_status);
  } else {
    my $file_exit_status = &get_file_exit_status();
    print "$opt_statusfile STATUS: $STATUS[$file_exit_status]\n" and exit($file_exit_status);
  }
} else {
  print "$opt_statusfile NOT FOUND\n" and exit($UNKNOWN);
}

#  IF we fall off here, some weird shit happened, so exit UNKNOWN
print "$opt_statusfile UNEXPECTED ERROR: $0\n" and exit($UNKNOWN);

sub get_file_age_status {
  # All these are in epoch seconds, local time, since that's what stat() uses.
  # Return OK, WARNING, or CRITICAL, based on whether or not the file's modification
  # time is older than the passed-in expected age.
  my $status = $OK;
  my $file_mtime = (stat($opt_statusfile))[9];
  my $current_time = timelocal(localtime());
  my $file_age = ($current_time - $file_mtime);
  if ($file_age > $opt_warning) {
    $status = $WARNING;
  }
  if ($file_age > $opt_critical) {
    $status = $CRITICAL;
  }
  return($status);
}

sub get_file_exit_status {
  # Expecting the status log to contain one character, a 0, 1, 2, or 3
  # Get it, make sure its an expected value, and return it, failing otherwise
  open(STATUSFILE, "<$opt_statusfile") or print "Couldn't open $opt_statusfile $!" and exit($UNKNOWN);
  my $status=getc(STATUSFILE);
  close(STATUSFILE);
  if ($status =~ m/[$OK|$WARNING|$CRITICAL|$UNKNOWN]/) {
    return($status);
  } else {
    print "$opt_statusfile STATUS: $status UNDEFINED\n" and exit($UNKNOWN);
  }
}

sub alarm_handler {
  # Trap the above-set SIGALRM here if we timeout.
  my $sig=shift;
  print "$0 timed out on $opt_statusfile after $timeout seconds. (Trapped SIG$sig)\n" and exit($UNKNOWN);
}
