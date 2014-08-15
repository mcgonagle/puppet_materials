#!/usr/bin/perl -w
#
# $Id: hostchecker.pl,v 1.3 2010/07/27 18:30:57 wflynn Exp $
#
# Script for getting a list of up webhosts
#
# wflynn 07/10
#

# http://perldoc.perl.org/strict.html
use strict;

# http://perldoc.perl.org/Getopt/Long.html
use Getopt::Long qw(:config no_ignore_case);

# http://perldoc.perl.org/Net/Ping.html
use Net::Ping;

# NAGIOS plugin compliant return codes:
our ( $OK, $WARNING, $CRITICAL, $UNKNOWN ) = ( 0 .. 3 );
our @STATUS = ( 'OK', 'WARNING', 'CRITICAL', 'UNKNOWN' );
my $STATUS = $OK;

#  Pulls a hostname out of the AXFR dump
my $HOSTNAMERX = qr/^(.+?)\.\s.*$/;

## Start parsing options
our ( $opt_version, $opt_help, $opt_domains, $opt_hostconts );

my $hc_root      = $ENV{'HOME'};
my $hostlistfile = "www_hosts.txt";
my $pingport     = "80";
my $dnsserver    = 'idns04.svc.waltham.manhunt.net';
my @domains      = ( 'v4.waltham.manhunt.net', 'waltham.manhunt.net' );
my @hostconts    = ( 'www', );

my $version_string =
  ' $Id: hostchecker.pl,v 1.3 2010/07/27 18:30:57 wflynn Exp $ ';
my $usage_string = <<EOF;
$0 <options> (These defaults are probably fine):
 --hc_root            <directory> - Directory in which to store hostlistfile: $hc_root
 --hostlistfile       <filename>  - File in which to store list of up hosts: $hostlistfile
 --dnsserver          <hostname>  - DNS Server against which to run AXFR when pulling hostnames: $dnsserver
 --domain             <domain>    - Domain(s) in which to search for hosts 
                                        (multiple --domain args supported): @domains
 --hostname_contains  <string>    - Strings(s) which will be found in hostnames (in --domains) to 
                                        sync to (multiple --hostname_contains args supported): @hostconts
 --pingport           <integer>   - Port to ping check to verify host is up: $pingport
EOF

my $result = GetOptions(
    "version|V" => sub { print "Version: $version_string\n" and exit($OK); },
    "help|h"    => sub { print "Usage: $usage_string\n"     and exit($OK); },
    "hc_root=s"            => \$hc_root,
    "hostlistfile=s"       => \$hostlistfile,
    "dnsserver=s"          => \$dnsserver,
    "domain=s@"            => \$opt_domains,
    "hostname_contains=s@" => \$opt_hostconts,
    "pingport=s"           => \$pingport,
);

my $Hostlist_File = "$hc_root/$hostlistfile";

if ($opt_domains) {
    @domains = ( @{$opt_domains} );
}

if ($opt_hostconts) {
    @hostconts = ( @{$opt_hostconts} );
}

## Build our regex for parsing out the hosts we want
my $hostconts = join( '|', @hostconts );
my $HOSTLISTRX = qr/^.*?($hostconts).+$/;

## Done with Options

## Make sure we have a place to work
if ( not -d $hc_root ) {
    warn "Can't work in $hc_root: $!"
      and exit($CRITICAL);
}

## Start doing the work...
open( HLF, ">$Hostlist_File" )
  or ( warn "can't open $Hostlist_File: $!" and exit($CRITICAL) );
foreach my $host (
    @{
        &ping_upcheck( &get_hosts( $HOSTLISTRX, $dnsserver, @domains ),
            $pingport )
    }
  )
{
    print HLF "$host\n";
}
close(HLF) or ( warn "can't close $Hostlist_File: $!" and exit($CRITICAL) );
## We're done!
## STATUS==OK here, unless it got changed en-route.
exit($STATUS);

sub get_hosts() {
    my $hostrx  = shift;
    my $dns     = shift;
    my @domains = @_;
    my %hosthash;
    foreach my $domain (@domains) {
        open( AXFR, "dig \@$dns $domain axfr |" )
          or ( warn "can't fork: $!" and exit($CRITICAL) );
        while (<AXFR>) {
            chomp;
            if ( ( $_ =~ m/$hostrx/ ) and ( $_ =~ m/$HOSTNAMERX/ ) ) {
                $hosthash{$1}++;
            }
        }
        close(AXFR) or ( warn "can't close: $!" and exit($CRITICAL) );
    }
    my @retary = sort keys %hosthash;
    return \@retary;
}

sub ping_upcheck() {
    my $hostref = shift;
    my $port    = shift;
    my $pinger  = Net::Ping->new( "tcp", 2 );
    my %hostuphash;

# Try connecting to the named port instead of the echo port
# This new interface doesn't work on older machines: $pinger->port_number($port);
    $pinger->{port_num} = $port;

    foreach my $host ( @{$hostref} ) {
        if ( $pinger->ping($host) ) {
            $hostuphash{$host}++;
        }
    }
    undef($pinger);
    my @retary = sort keys %hostuphash;
    return \@retary;
}

