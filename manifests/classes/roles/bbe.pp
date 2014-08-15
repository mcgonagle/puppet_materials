# Class: role::bbe
#
# This module manages role::bbe
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
class role::bbe {

  class { 'httpd': }
  include php
  include php::billing
  include gearman
  #the following three modules can be simple package definitions in this
  #class, there is no configuration or services for these packages
  include zlib
  include curl
  include ssh2

  #  This will need to be updated to be something appropriate
  cron{"remove billing logs":
     command => 'find /var/log/html -type f -mtime 7 -exec rm {} \;', 
     user => root,
     hour => [ '0-23' ], }

  #will need to double check this and make sure it is how we want to do it
  #going forward 
  file { "/usr/local/${product}/cron/hostchecker.pl":
    source => "puppet:///modules/cron/${product}_tools/tools/hostchecker.pl",
    owner => "root", group => "root", mode => "0755", }

  service { cups: 
    ensure => stopped,
    enable => false,
    hasrestart => true,
    hasstatus => true, }
  
  service { "nfs":
    ensure => stopped,
    enable => false,
    hasrestart => true,
    hasstatus => true, }
  
}#end of role::bbe
