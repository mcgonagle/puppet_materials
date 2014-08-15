#!/usr/bin/perl

use strict;
use warnings;

my $config_file = "/usr/local/src/manhunt/lib/net/manhunt/billing/vindicia/Const.php";
my $magic_line  = qq(define("VIN_SOAP_PROD_PASSWORD", "Your Production Password HERE"));

my $default_report = "BILLING OK: Production unlocked.";

if (`grep '$magic_line' $config_file`) {
    $default_report = "BILLING CRITICAL: Production is still locked.";
    }
    
print "$default_report\n";

    