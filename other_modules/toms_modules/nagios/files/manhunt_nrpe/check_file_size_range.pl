#!/usr/bin/perl

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; 
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# contact the author directly for more information at: shahidiqq@homail.com                             
#################################################################################
# keep Check on any file in any directory
# This plugin requires basic perl plugin on the system.

## Modified by Jason Joy to suit business needs and to be sane.

use strict;                                                    
use warnings;

my $exit=0;
my $check_myfilesize = -s "$ARGV[0]";


########################### Usage of the plugin
# Usage: check_myfilesize.pl filename min_size in bytes max_size in bytes
# e.g check_myfilesize.pl test.txt 20 100000

if ( !$ARGV[1] || !$ARGV[2]) {
    print "Usage: check_file_size_range.pl Filename minsize maxsize\n";
    exit 0;                                    
}                                                                        

if ($check_myfilesize > $ARGV[1] && $check_myfilesize < $ARGV[2]) {
    print "OK: Current size is ".$check_myfilesize." bytes\n";     
    exit 0;                                                   
} else {   
    print "Critical:  Current size is ".$check_myfilesize." bytes\n";
    exit 2;                                                          
}          

sub usage {
   print "Required arguments not given!\n\n";
   print "Nagios plugin to check file size , V1.00\n";
   print "Copyright (c) 2008 Shahid Iqbal \n\n";
}                                                     
