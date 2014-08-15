# Class: role::mail
#
# This module manages role::mail
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
class role::mail {
  class { "postfix": }
  postfix::config::maincf { "${hostname}":
    myhostname => "mailitpd01.cam.dlist.com", 
    mydomain => "dlist.com",
    relay_domains => "online-buddies.com",
    require => Class["postfix"], }

 package { "perl-DBI": ensure => present, }
 package { "perl-DBD-MySQL": ensure => present, }

}#end of role::mail
