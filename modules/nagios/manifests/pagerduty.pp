# Class: nagios::pagerduty
#
# This module manages nagios::pagerduty
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class nagios::pagerduty {
 package{"perl-libwww-perl": ensure => latest }
 package{"perl-Crypt-SSLeay": ensure => latest }

 file{"/usr/local/bin/pagerduty_nagios.pl":
    source => "puppet:///modules/nagios/pagerduty_nagios.pl",
    owner => "nagios", group => "nagios", mode => "0755", }

 file{"/etc/nagios/pagerduty_nagios.cfg":
    content => template("nagios/pagerduty_nagios.cfg.erb"),
    owner => "nagios", group => "nagios", mode => "0644", 
    require => File["/usr/local/bin/pagerduty_nagios.pl"], }
 
 cron {"pagerduty_nagios.pl flush": 
    user => "nagios",
    command => "/usr/local/bin/pagerduty_nagios.pl flush", } 

}
