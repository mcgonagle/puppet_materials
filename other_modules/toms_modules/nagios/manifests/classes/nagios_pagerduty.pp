class nagios::pagerduty inherits nagios {
 package{"perl-libwww-perl": ensure => latest }
 package{"perl-Crypt-SSLeay": ensure => latest }

 file{"/usr/local/bin/pagerduty_nagios.pl":
    source => "puppet:///modules/nagios/pagerduty_nagios.pl",
    owner => "root", group => "root", mode => "0755", }

 file{"/etc/nagios/pagerduty_nagios.cfg":
    content => template("nagios/pagerduty_nagios.cfg.erb"),
    owner => "root", group => "root", mode => "0644",
    require => File["/usr/local/bin/pagerduty_nagios.pl"], }
 
 cron {"pagerduty_nagios.pl flush":
    user => "nagios",
    command => "/usr/local/bin/pagerduty_nagios.pl flush", } 

}
