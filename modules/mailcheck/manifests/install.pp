# Class: mailcheck
#
# This module manages mailcheck
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
class mailcheck::install {
  file { "/usr/local/manhunt/cron":
    ensure => directory,
  }
 
  file { "/usr/local/manhunt/cron/smtp_watcher.pl":
    ensure => absent,
    source => "puppet://modules/mailcheck/files/smtp_watcher.pl",
    owner  => root, mode => 644, group => root,
  }

  file { "/usr/local/manhunt/cron/smtp_db_reporter.pl":
    ensure => absent,
    source => "puppet://modules/mailcheck/files/smtp_db_reporter.pl",
    owner  => root, mode => 644, group => root,

  }

  file { "/etc/init.d/smtp_watcher":
    ensure => absent,
    source => "puppet://modules/mailcheck/files/init.d/smtp_watcher_init.sh",
    owner  => root, mode => 644, group => root,
  }

  file { "/etc/init.d/smtp_db_watcher":
    ensure => absent,
    source => "puppet://modules/mailcheck/files/init.d/smtp_db_watcher_init.sh",
    owner  => root, mode => 644, group => root,
  }

  file { "/var/run/smtp_watcher":
    ensure => directory,
    owner  => root, mode => 644, group => root,
  }

  file { "/var/run/smtp_db_watcher":
    ensure => directory,
    owner  => root, mode => 644, group => root,
  }


  

}
