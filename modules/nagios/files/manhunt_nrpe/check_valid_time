#!/usr/bin/perl  -w
# $Id: check_valid_time.pl,v 1.2 2009/05/13 18:37:43 rbraun Exp $

$ntpdc='/usr/sbin/ntpdc';
$awk='/bin/awk';

$warn_thresh=.75;
$crit_thresh=100;

$ok_exit=0;
$warning_exit=1;
$critical_exit=2;
$unknown_exit=3;
$fields='$1,$7';


my $cmd = "$ntpdc -p | $awk '/*/ {print $fields}'" ;
($auth_server,$offset)=split(' ',`$cmd`);

if ($auth_server =~ m/LOCAL/) {
print "$auth_server server untrusted for NTP check, offset $offset\n";
exit $critical_exit;
}

if ($auth_server eq "") {
print "No auth server exists\n";
exit $critical_exit;
}

$offset=abs($offset);

if ($offset =~ m/[A-Z]/ ) {
print "$offset from $auth_server could not be evaluated.\n";
exit $unknown_exit;
}
elsif ($offset =~ m/[a-d]/ ) {
print "$offset from $auth_server could not be evaluated.\n";
exit $unknown_exit;
}
elsif ($offset =~ m/[f-z]/ ) {
print "$offset from $auth_server could not be evaluated.\n";
exit $unknown_exit;
}
elsif ($offset >= $crit_thresh) {
print "$offset seconds from $auth_server.\n";
exit $critical_exit;
}
elsif ($offset >= $warn_thresh) {
print "$offset seconds from $auth_server.\n";
exit $warning_exit;
}
elsif ($offset >= $crit_thresh) {
print "$offset seconds from $auth_server.\n";
exit $critical_exit;
}
elsif ($offset >= 0) {
print "$offset seconds from $auth_server.\n";
exit $ok_exit;
}
else {
print "Something's wrong, offset=$offset, auth_server=$auth_server\n";
exit $unknown_exit;
}
