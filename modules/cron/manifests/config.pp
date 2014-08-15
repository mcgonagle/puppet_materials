# Class: cron::config
#
# This module manages cron::config
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
class cron::config {
 require cron::install

 file {"/etc/manhunt":
  ensure => directory,
  owner => "root", group => "root", mode => "0755", }
  
 file {"/etc/manhunt/source.sh":
  source => "puppet:///modules/cron/mh_tools/source.sh", 
  owner => "root", group => "root", mode => "0755",
  require => File["/etc/manhunt"], }

 file {"/usr/local/${product}":
  ensure => directory,
  owner => "root", group => "root", mode => "0755", }

 file {"/usr/local/${product}/cron":
  source => "puppet:///modules/cron/mh_cron_scripts",
  recurse => true,
  owner => "root", group => "root", mode => "0755",
  require => File["/usr/local/${product}"], }

}
