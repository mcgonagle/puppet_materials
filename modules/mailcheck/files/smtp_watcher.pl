#!/usr/bin/perl

use strict;
use warnings;

use DBI;

my $hostname = `hostname`;
chomp $hostname;
$hostname =~ s/^(.*?)\.(.*)$/$1/g;

my ($environment,$rest) = @ARGV;
$environment = $environment || "manhunt";

my $mysql_host     = "192.168.218.111";
my $mysql_user     = "cacti13";
my $mysql_password = "cacti13";  
my $mysql_database = "business_data";
my $mysql_table    = "bounce_email";

my $log_file = "/var/log/maillog";
my $log_file_previous = "/var/log/maillog\.1";

my $file_trigger = 0;
my $skip = 0;

my $last_position = -s "$log_file";
my $position_file = "/tmp/email_position_file";

my %dsn_major;
my %dsn_minor;

my %dsn_code_translation = ( 2 => "Success",
                             5 => "Permanent",
                             4 => "Transient",
                           );

my $dbh;
database_connect();

my $iteration = 0;
while (1) { ## Infinite Loop for Now ...
    my $file_position = -s "$log_file";
    my $last_loop_position = $last_position;
    
    $iteration++;
#    print "File Position: $file_position  -- Last Loop Position: $last_loop_position\n";
    if ($last_position < $file_position) {
        $last_position = read_file($log_file,$last_position);
        my $calced_diff = $last_position - $last_loop_position;
        $iteration = 0;
#        print "$iteration: $calced_diff\n";
    } elsif ($last_position > $file_position) {
        $last_position = read_file($log_file_previous,$last_position);
        $last_position = 0;
        $iteration = 0;
    } else {
        $iteration++;
    }
    
    sleep(3);
}

database_disconnect();

sub database_disconnect {
    $dbh->disconnect();
}

sub database_connect {
    $dbh = DBI->connect("DBI:mysql:$mysql_database;host=$mysql_host", "$mysql_user", "$mysql_password",
                       { RaiseError => 1 }
                       );
}

sub read_file {
    my ($current_log,$position) = @_;
    database_connect();
    open(my $LF_HANDLE,"$current_log") or die "Cannot open $current_log. $!\n";
    seek($LF_HANDLE,$position,0);
#    print "Starting at $position...\n";
    while(<$LF_HANDLE>) {
        chomp;
        next if ! m/@/;
        next if ! m/^(.*?) (.*?) (..:..:..)/;

        my $e_address = $_;
        my $smtp_code = $e_address;

                
        $e_address =~ s/.*<(.*@.*?)>.*/$1/g;
        next if $e_address =~ m/manhunt\.net/;

        if ($smtp_code =~ m/dsn=/) {
            $smtp_code =~ s/^.*dsn=(.....),.*$/$1/;
        } else {
            $smtp_code =~ s/^.* (.*?) <.*@.*?>.*$/$1/;
        }
        
        print "*$smtp_code*\n";
        next if ! $smtp_code =~ m/^.....$/;
        
        my $smtp_major_code = $smtp_code;
        $smtp_major_code =~ s/^(.).*$/$1/g;

        my $error_message = $_;
        if ($error_message =~ m/said:/) {
            $error_message =~ s/.*said:(.*)$/$1/;
        } else {
            $error_message = "";
        }

        if ($smtp_major_code eq "5") {
            my ($count,$bounces) = check_email($e_address,$environment);
            if ($count == 0) {
                insert_email($e_address,$environment,$error_message,$count);
            } else {
                update_email($e_address,$environment,$error_message,$count);
            }
        }
        print "($smtp_code) [$smtp_major_code] -> $e_address -- $error_message\n";
    }
    my $stop_position = tell($LF_HANDLE);
    close($LF_HANDLE);
    database_disconnect();
    return $stop_position;
}

sub check_email {
    my ($bad_email,$environment) = @_;
    my $check_query = "SELECT count(*) AS entries, bounces FROM $mysql_table WHERE domain = ? AND email = ? LIMIT 1";
    my $dbq = $dbh->prepare($check_query);
    $dbq->execute($environment,$bad_email);
    my $db_row = $dbq->fetchrow_hashref();
    return ($$db_row{entries},$$db_row{bounces});
}

sub insert_email {
    my ($bad_email,$environment,$error,$count) = @_;
    $count++;
    my $insert_query = "INSERT INTO $mysql_table (email,domain,bounces,last_bounce,last_error) values (?,?,?,NOW(),?)";
    my $dbq = $dbh->prepare($insert_query);
    $dbq->execute($bad_email,$environment,$count,$error);
}

sub update_email {
    my ($bad_email,$environment,$error,$count) = @_;
    $count++;
    my $update_query = "UPDATE $mysql_table SET bounces=?, last_bounce=NOW(), last_error=? where email=? AND domain=?";
    my $dbq = $dbh->prepare($update_query);
    $dbq->execute($count, $error, $bad_email, $environment);
}

