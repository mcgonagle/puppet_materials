#!/usr/bin/perl
#
# addrcheck - mail address checker
# by tchrist@perl.com
# Copyright 1997 Tom Christiansen
# version 1.001 Fri Feb 14 15:20:02 MST 1997

####################################
# this program takes an email address as its argument
# and decides whether you're being spoofed or not.
# it exists 0 if it likes the address, and 1 if it doesn't.
# 
# can be tested interactively.  if not interactive, it will
# use syslog.
#
# should be rewritten instead of just growing via hacks.
####################################
use Getopt::Std;
&getopts("a:dh",\%opts);

$LOGGER   = '/usr/bin/logger';  # or /usr/ucb?
$NSLOOKUP = '/usr/bin/nslookup';  # or /usr/ucb?

#$DEBUG = -t STDIN && -t STDOUT;
#$address = shift || die "usage: $0 address\n";

if ( $opts{h} ){  #help
  &usage;
  exit 0;
}
if ( ! $opts{a} ) {
  print "***Error: Command line option \"-a email_address file\" is required\n\n";
  &usage();
}
foreach $flag (keys(%opts)) {

       if ( $flag eq "d" ) {
         $DEBUG=1;
        }
       
       if ( $flag eq "a" ) {
         $address=$opts{$flag};
         #Check to see if the -s flag is followed by an argument
           if ( ! $address || $address =~ m!^[-]!) {
             print "***Error: Option -a requires an email address\n";
             &usage;
           }
        }
}

#if ($#ARGV < 0 ) {
#        print "usage $0 [-d] -a address\n";
#}
#for ($i = $[; $i <= $#ARGV; $i++) {
#    if ($ARGV[$i] =~ m!^-d$!i ) {
#        $DEBUG=1;
#    } elsif ($ARGV[$i] =~ m!^-a$!i )  {
#        $address = $ARGV[++$i];
#    } else {
#        print "usage $0 [-d] -a address\n";
#    }
#}

for ($address) {
    s/^-+//;
    tr/A-Z/a-z/;
}

($user, $host) = split /\@/, $address;

# we check in this order because of speed;
# this way it will fail more quickly.

check_passwd($user);	# picky

if (! $host) {
 &bad("no domain"); 
}

if ($address =~ /\@./) { 
    check_host($host);
    ck822($address);   	# inscrutable
    dns_check($host);  	# slow
}

exit 0;

####################################
sub usage
{
  print "usage $0 [-d] -a address\n";
}
####################################
 
sub bad {
    # GLOBAL $hispass and $what
    if ($DEBUG) {
	print "$what $hispass is bad: @_\n";
    } else {
	system $LOGGER,
		    "-p", "daemon.notice", 
		    "-t", "ftpucheck",
		"BOGUS \U$what\E $hispass (@_)";
    } 
    exit 1;
} 

####################################

#############

sub check_passwd {  
    local $what = 'user';
    local $hispass = shift;

#   for (@rude) {
#	bad("rude") if index($hispass, lc $_) != -1;
#    } 

#    for (@anywhere) {
#	bad("inside") if index($hispass, lc $_) != -1;
#   } 

#    for (@full) {
#	bad("full") if $hispass eq lc $_;
#    } 

#    for (@start) {
#	bad("start") if index($hispass, lc $_) == 0;
#    } 

    # single char
    bad("single") if length($hispass) == 1;

    study $hispass;

#    bad("dup letters") if $hispass =~ /(\w)\1{3,}/;
    bad("dup letters") if $hispass =~ /(\w)\1{4,}/;

    bad("white") if $hispass =~ /\s/;

    bad("junk") if $hispass =~ /[;,\/#^*]/;

    $V = 'aeiouy';
    if ($hispass =~ /netscape/ || $hispass =~ /^m[$V]*[sz]+[$V]*l+[$V]*\W*$/) {
	bad("mozilla");
    } 

    if ($hispass =~ /xyz+y/) {
	bad("xyzzy");
    } 

    # all same letter
    bad("dup letters") if $hispass =~ /^(.)\1+$/;

    # want letters
    bad("ugly") unless $hispass =~ /[a-z]/;

    bad("backspace") if $hispass =~ /[\010\177]/;

    $letters = "qwertyuiopasdfghjklzxcvbnmmnbvcxzlkjhgfrdsapoiuytrewq";

    # consecutive
    bad("consecutive") if 
	    length($hispass) > 2 &&
		( index($letters, $hispass) != -1
		    ||
		  ($hispass =~ /^(\w+)\1$/ && length($1) > 2
		    && index($letters, $1) != -1)
		);

    print "$what: $hispass is good\n" if $DEBUG;

}


#############

sub check_host {
    local $what = 'host';
    local $hispass = shift;

    bad("dotless") unless index($hispass, '.') >= 0;

   # for (@rude) {
#	bad("rude") if index($hispass, lc $_) != -1;
#    } 

#    for (@full) {
#	bad("full") if $hispass eq lc $_;
#    } 

    # single char
    bad("single") if length($hispass) == 1;

    study $hispass;

    bad("white") if $hispass =~ /\s/;

    bad("junk") if $hispass =~ /[;,\/#^*]/;

    # want letters, darnit;  this will cause 127.1 to fail though
    bad("ugly") unless $hispass =~ /[a-z]/;

    bad("backspace") if $hispass =~ /[\010\177]/;

    $letters = "qwertyuiopasdfghjklzxcvbnmmnbvcxzlkjhgfrdsapoiuytrewq";

    # consecutive
    bad("consecutive") if 
	    length($hispass) > 2 &&
		( index($letters, $hispass) != -1
		    ||
		  ($hispass =~ /^(\w+)\1$/ && length($1) > 2
		    && index($letters, $1) != -1)
		);

    print "$what: $hispass is good\n" if $DEBUG;

}

sub dns_check {
    # first try an MX record, then an A rec (for badly configged hosts)

    my $host = shift;
    local $/ = undef;
    local $what = "DNS record";
    local $hispass = $host;


    # the following is comment out for security reasons:
    #	if ( `nslookup -query=mx $host` =~ /mail exchanger/
    # otherwise there could be naughty bits in $host
    # we'll bypass system() and get right at execvp()

    if (open(NS, "-|")) {
	if (<NS> =~ /mail exchanger/) {
	    print "$what MX: $hispass is good\n" if $DEBUG;
	    close NS;
	    return;
	}
    } else {
	open(SE, ">&STDERR");
	open(STDERR, ">/dev/null");
	exec $NSLOOKUP, '-query=mx', $host;
	open(STDERR, ">&SE");
	die "can't exec nslookup: $!";
    } 

    if (open(NS, "-|")) {
	$_ = <NS>;
	if (/answer:.*Address/s) {
	    print "$what A: $hispass is good\n" if $DEBUG;
	    close NS;
	    return;
	}
	if (/Name:.*$host.*Address:/si) {
	    print "$what A: $hispass is good\n" if $DEBUG;
	    close NS;
	    return;
	}
    } else {
	open(SE, ">&STDERR");
	open(STDERR, ">/dev/null");
	exec $NSLOOKUP, '-query=a', $host;
	open(STDERR, ">&SE");
	die "can't exec nslookup: $!";
    } 

    bad("No DNS");
} 


sub ck822 { 

    # ck822 -- check whether address is valid rfc 822 address
    # tchrist@perl.com
    #
    # pattern developed in program by jfriedl; 
    # see "Mastering Regular Expressions" from ORA for details

    # this will error on something like "ftp.perl.com." because
    # even though dns wants it, rfc822 hates it.  shucks.

    local $what = 'address';

    local $hispass = shift;
    local $_;

    $is_a_valid_rfc_822_addr = '';

    while (<DATA>) {
	chomp;
	$is_a_valid_rfc_822_addr .= $_;
    } 


    bad("rfc822 failure") unless $hispass =~ /^${is_a_valid_rfc_822_addr}$/o;
    print "$what: $hispass is good\n" if $DEBUG;
}

##############################
# initializations
##############################

BEGIN {

    @full = qw{

	admin
	anon
	anonymous
	bar
	big-liar
	bin
	bizarre
	bla
	blah
	bogus
	cache
	collect
	compuserve
	cool
	crud
	DeleGateMaster
	devnull
	dialup
	dork
	dummy
	employee
	first1
	foo
	friendly
	ftpsearch-collect
	fu
	god
	guest
	gunk
	gw
	harvest
	here
	hi
	ident
	ident
	ie30user
	info
	internet
	junk
	liar
	login
	lycos
	maxima
	me
	mirror
	mosaic
	nobody
	none
	none-known
	nouser
	ntcon
	ok
	outbound
	postmaster
	president
	public
	Put_Your_Email_Address
	report_abuse
	root
	satan
	socks
	spanky
	src
	sticky
	system
	there
	Unknown_Netscape_User
	Unregistered
	unverified
	user
	UserName
	vice-president
	vividnet
	whoever
	wow
	xyz
	xyz

    };

    @start = qw{

	aaa
	abc
	account
	anon
	anon
	asquid
	daemon 
	delegate
	ftp
	gopher
	gotch
	oracle
	otthttp
	pass
	satan
	squid
	student
	test
	web
	xx

    };

    @anywhere = qw{

	adresse
	asdf
	asfd
	cache
	firewall
	-gw
	http
	mail
	mirror
	mother
	name
	nobody
	proxy
	sadf
	system
	user
	www

    }; 

    @rude = qw{

	asshole
	crap
	cunt
	damn
	fuck
	piss
	shit
	suck
	tits
	upyour

    };

}

# don't touch this stuff down here or you'll break the rfc822 matcher.
__END__
(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n
\015()]|\\[^\x80-\xff])*\))*\))*(?:(?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\
xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff])|"(?:[^\\\x80-\xff\n\015"
]|\\[^\x80-\xff])*")(?:(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xf
f]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*\.(?:[\040\t]|\((?:[
^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\
xff])*\))*\))*(?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;
:".\\\[\]\000-\037\x80-\xff])|"(?:[^\\\x80-\xff\n\015"]|\\[^\x80-\xff])*"))
*(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\
n\015()]|\\[^\x80-\xff])*\))*\))*@(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\
\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*(?:[^(\04
0)<>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-
\xff])|\[(?:[^\\\x80-\xff\n\015\[\]]|\\[^\x80-\xff])*\])(?:(?:[\040\t]|\((?
:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80
-\xff])*\))*\))*\.(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\(
(?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*(?:[^(\040)<>@,;:".\\\[\]
\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff])|\[(?:[^\\
\x80-\xff\n\015\[\]]|\\[^\x80-\xff])*\]))*|(?:[^(\040)<>@,;:".\\\[\]\000-\0
37\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff])|"(?:[^\\\x80-\xf
f\n\015"]|\\[^\x80-\xff])*")(?:[^()<>@,;:".\\\[\]\x80-\xff\000-\010\012-\03
7]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\
\[^\x80-\xff])*\))*\)|"(?:[^\\\x80-\xff\n\015"]|\\[^\x80-\xff])*")*<(?:[\04
0\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]
|\\[^\x80-\xff])*\))*\))*(?:@(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x
80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*(?:[^(\040)<>@
,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]
)|\[(?:[^\\\x80-\xff\n\015\[\]]|\\[^\x80-\xff])*\])(?:(?:[\040\t]|\((?:[^\\
\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff
])*\))*\))*\.(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^
\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*(?:[^(\040)<>@,;:".\\\[\]\000-
\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\x80-
\xff\n\015\[\]]|\\[^\x80-\xff])*\]))*(?:(?:[\040\t]|\((?:[^\\\x80-\xff\n\01
5()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*,(?
:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\0
15()]|\\[^\x80-\xff])*\))*\))*@(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^
\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*(?:[^(\040)<
>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xf
f])|\[(?:[^\\\x80-\xff\n\015\[\]]|\\[^\x80-\xff])*\])(?:(?:[\040\t]|\((?:[^
\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\x
ff])*\))*\))*\.(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:
[^\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*(?:[^(\040)<>@,;:".\\\[\]\00
0-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\x8
0-\xff\n\015\[\]]|\\[^\x80-\xff])*\]))*)*:(?:[\040\t]|\((?:[^\\\x80-\xff\n\
015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*)
?(?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000
-\037\x80-\xff])|"(?:[^\\\x80-\xff\n\015"]|\\[^\x80-\xff])*")(?:(?:[\040\t]
|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[
^\x80-\xff])*\))*\))*\.(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xf
f]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*(?:[^(\040)<>@,;:".\
\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff])|"(?:
[^\\\x80-\xff\n\015"]|\\[^\x80-\xff])*"))*(?:[\040\t]|\((?:[^\\\x80-\xff\n\
015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*@
(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n
\015()]|\\[^\x80-\xff])*\))*\))*(?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff
]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\x80-\xff\n\015\[\
]]|\\[^\x80-\xff])*\])(?:(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\
xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*\.(?:[\040\t]|\((?
:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80
-\xff])*\))*\))*(?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@
,;:".\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\x80-\xff\n\015\[\]]|\\[^\x80-\xff
])*\]))*(?:[\040\t]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff]|\((?:[^\\\x8
0-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*>)(?:[\040\t]|\((?:[^\\\x80-\xff\n\
015()]|\\[^\x80-\xff]|\((?:[^\\\x80-\xff\n\015()]|\\[^\x80-\xff])*\))*\))*

