#!/usr/bin/perl

use strict;
use warnings;

use DBI;

my $mysql_host     = "192.168.218.111";
my $mysql_user     = "cacti13";
my $mysql_password = "cacti13";
my $mysql_database = "business_data";
my $mysql_table    = "bounce_email";

my $last_checkpoint;
my $sleep_cycle = 3;

my $domain = "dlist";

my $dbh = database_connect($mysql_database,$mysql_host,$mysql_user,$mysql_password);

my $last_time_check = time_now();
my $report_URL  = "http://mnuss.manhunt.local/maintenance.do?ac=emailBounced&email";
my $report_USER = "itmaintain";
my $report_PASS = "pppppp"; 
my $report_TIMEOUT = "2"; 

while(1) {
    print "Cycle Start.\n";
    my $time_now = time_now();
    print "$last_time_check = $time_now\n";
    my $bad_email_query = "SELECT email,last_bounce,last_error FROM $mysql_table WHERE last_bounce >= '$last_time_check' AND domain = '$domain'";
    my @bad_accounts = database_query($dbh,$bad_email_query);
    foreach(@bad_accounts) {
        my %account_entry = %$_;
        next if $account_entry{email} =~ m/\@dlist\.com$/;
        print "$account_entry{last_bounce} -- $account_entry{email} ($account_entry{last_error}).\n";

        system("/usr/bin/wget",
               "$report_URL=$account_entry{email}",
               "--http-user=$report_USER",
               "--http-password=$report_PASS",
               "--timeout=$report_TIMEOUT",
               "--auth-no-challenge",
               );

    }
    $last_time_check = $time_now;
    sleep($sleep_cycle);

}

sub database_connect {
    my ($mysql_database,$mysql_host,$mysql_user,$mysql_password) = @_;
    my $new_dbh = DBI->connect("DBI:mysql:$mysql_database;host=$mysql_host", "$mysql_user", "$mysql_password",
        { RaiseError => 1 }
    );
    return $new_dbh;
}
                     
sub database_query {
    my ($q_dbh,$query) = @_;
    
    my @result_stack;
    
    my $sth = $q_dbh->prepare($query);
    $sth->execute();
    while (my $result = $sth->fetchrow_hashref()) {
        push(@result_stack,$result);
    }
    
    return @result_stack;
}  

sub time_now {
    my @time_array = database_query($dbh,"SELECT NOW() as now_time");
    return $time_array[0]{now_time};
}
