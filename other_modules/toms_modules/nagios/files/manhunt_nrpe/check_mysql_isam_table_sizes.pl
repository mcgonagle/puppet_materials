#!/usr/bin/perl -w
use strict;
use DBI;
use Getopt::Long;

my $options;
$options->{'host'} = 'server';
$options->{'user'} = 'user';
$options->{'pass'} = 'password';
$options->{'warn'} = 50;
$options->{'crit'} = 80;
$options->{'debug'} = 0;
$options->{'port'} = 3306;
my $result = GetOptions ($options, 'host=s', 'user=s', 'pass=s', 'warn=i', 'crit=i', 'debug=i', 'port=i', 'help');

my $dsn = sprintf "DBI:mysql:host=%s;port=%s", $options->{'host'}, $options->{'port'};


sub debug {
	my ($debug, $message) = @_;
	return unless (defined($options->{'debug'}) && ($options->{'debug'} =~ /^\d+$/));
	return unless (defined($debug) && ($debug =~ /^\d+$/));
	return unless $debug <= $options->{'debug'};
	warn unless defined $message;
	my $caller = (caller(1))[3];
	printf "%s: %s\n", $caller || "Main", $message;
}

sub db_connect {
	debug(5, "Using $dsn");
	my $dbh = DBI->connect($dsn, $options->{'user'}, $options->{'pass'}, {RaiseError => 1});
	if (not $dbh) {
		printf "Unable to connect to DB host %s:%s", $options->{'host'}, $options->{'port'};
		exit 3;
	}
	debug(3, sprintf "Connected to DB host %s:%s", $options->{'host'}, $options->{'port'});
	return $dbh;
}

sub get_table_sizes {
	my $dbh = shift;
	my $db = shift;
	my $sql = sprintf "show table status from %s", $db;
	debug(6, "$sql");
	my $sth = $dbh->prepare($sql);
	my $res = $sth->execute;
	my $sizes;
	while (my $ref = $sth->fetchrow_hashref) {
		debug(5, "Working on " . $ref->{Name});
		if ($ref->{'Engine'} ne "MyISAM") {
			debug(5, "Skipping non MyISAM table");
			next;
		} 
		debug(7, join(', ', keys(%{$ref})));
		$sizes->{$ref->{'Name'}}->{'max'} = $ref->{'Max_data_length'};
		$sizes->{$ref->{'Name'}}->{'cur'} = $ref->{'Data_length'};
		debug(6, sprintf "Looking at %s, size is %d, max is %.0f", $ref->{'Name'}, $ref->{'Data_length'}, $ref->{'Max_data_length'});
		$sizes->{$ref->{'Name'}}->{'pct'} = ($sizes->{$ref->{'Name'}}->{'cur'} / $sizes->{$ref->{'Name'}}->{'max'}) * 100;
	}

	my $exit_code = 0;
	my $exit_message;
	foreach (keys %{$sizes}) {
		if ($sizes->{$_}->{'pct'} >= $options->{'crit'} ) {
			$exit_message.= sprintf "%s:%s:  %2.2f%%! ", $db, $_, $sizes->{$_}->{'pct'};
			$exit_code = 2;
		} elsif ($sizes->{$_}->{'pct'}  >= $options->{'warn'} ) {
			$exit_message.= sprintf "%s:%s:  %2.2f%%. ", $db, $_, $sizes->{$_}->{'pct'};
			$exit_code = 1 if $exit_code < 1;
		} else {
			# say nothing.
			debug(5, sprintf "%s: %2.8f%%", $_, $sizes->{$_}->{'pct'});
		}
	}
	return $exit_code, $exit_message;
}


sub get_databases {
	my $dbh = shift;
	my $sql = "show databases";
	my $sth = $dbh->prepare($sql);
	my $res = $sth->execute;
	my $exit_message;
	my $exit_code = 0;
	while (my $ref = $sth->fetchrow_hashref) {
		debug(4, "Found database " . $ref->{Database});
		my ($new_code, $new_message) = get_table_sizes($dbh, $ref->{Database});
		$exit_message .= $new_message if $new_message;
		$exit_code = $new_code if $new_code > $exit_code;
	}
	if ($exit_message) {
		print $exit_message . "\n";
		exit $exit_code;
	} 
	print "OK\n";
	exit $exit_code;
}

sub help {
	my $name = $0;
	print <<FOO;
$name [ --help ] [ --port <n> ] [ --host <name> ] [ --user <name> ] [ --pass <pass> ] 
    [ --warn <i> ] [ --crit <i> ] [ --debug <i> ]

Checks for MyISAM tables in MySQL, and sees how 'full' they are based upon the maximum 
current table space and the number of rows currently there. It is essentially a SQL query 
of "show table status like <name>", acorss all tables in all databases.


	--port <n>	Port number of MySQL to connect to
	--user <name>	MySQL account to use
	--pass <pass>	MySQL password for the user
	--warn <i>	Percentage to consider a warning level, 0..100
	--crit <i>	Percentage to consider critical level, 0..100, higher than warn!
	--debug <i> 	Debug level, the higher the more rubbish we print out

(c) Fotango 2004
James E Bromberger, jbromberger\@fotango.com

FOO
}

if (defined $options->{help}) {
	help();
	exit;
	}
my $dbh = db_connect();
get_databases($dbh);
$dbh->disconnect();
