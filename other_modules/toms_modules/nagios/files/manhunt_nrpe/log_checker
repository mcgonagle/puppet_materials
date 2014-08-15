#!/usr/bin/perl

use strict;
use warnings;

my $start_date = `date +%Y.%m.%d.%H -d "1 hour ago"`;
chomp $start_date;

my $path = "/mnt/manhunt";
my $key  = $ARGV[0];
my @servers = `ls -1d $path/$key*`;

my @error_categories = ("www","memcache","deadlock","mysql","Mailman");

my $warning_message = "";
my $critical_message = "";

my $warning_factor  = 2;
my $critical_factor = 3;

my $flat_value_factor = 100;

#print "My categories are:\n";

#foreach (@error_categories) {
#    print "  $_\n";
#}

my %global_errors;

## Collect All Data.
LOG_SCAN: foreach my $server_log_path (@servers) {
    chomp $server_log_path;
#    print "$server_log_path\n";
    
    my $server_name = $server_log_path;
    $server_name =~ s/^.*\/(.*)\_.*$/$1/;
#    print "$server_name\n";
    ## there may be a EDT/EST error here.  Please be aware of it.
    my $www_error_file = "$server_log_path/httpd/www_error.$start_date.EST.log";

    foreach my $error_check (@error_categories) {
    
       if ( ! -e $www_error_file) {
           $global_errors{$server_name}{$error_check} = "";
       } else {
            my $error_collection = `grep -ic $error_check $www_error_file`;
            chomp $error_collection;
            $global_errors{$server_name}{$error_check} = $error_collection;
       }
    }
}

my @list_servers = sort(keys(%global_errors));

foreach my $current_category (@error_categories) {
    my $error_count = 0;
    my $elements = 0;
    foreach my $current_server (@list_servers) {
        if ($global_errors{$current_server}{$current_category} ne "") {
            $error_count += $global_errors{$current_server}{$current_category};
            $elements++;
        }
    }
#    print "\n$ current_category average:  ";
    my $error_average = $error_count/$elements;
#    print "$error_average\n";
    
    ERROR_REPORT: foreach my $check_current_server (@list_servers) {
        my $error_value = $global_errors{$check_current_server}{$current_category};
        if ($error_value eq "") {
            $warning_message .= "  $check_current_server $current_category WARNING (NO REPORT), ";
            next ERROR_REPORT;
        }
        if (($error_value > $critical_factor * $error_average) && ($error_value > $flat_value_factor)) {
            $critical_message .= "  $check_current_server $current_category CRITICAL ($error_value occurances), ";
            next ERROR_REPORT;
        } elsif (($error_value > $warning_factor * $error_average) && ($error_value > $flat_value_factor)) {
            $warning_message  .= "  $check_current_server $current_category WARNING ($error_value occurances), ";
            next ERROR_REPORT;
        }
     }
}    

#foreach(@list_servers) {
#    my $read_server = $_;
#    print "$_\n";
#    foreach(@error_categories) {
#        print "  $_: $global_errors{$read_server}{$_}\n";
#    }
#}

if ($critical_message ne "") {
    print "Critical:  $critical_message\n";
    exit(2);
} elsif ($warning_message ne "") {
    print "Warning:  $warning_message\n";
    exit(1);
}

print "OK: Nothing to report. Narf.\n";

