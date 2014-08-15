# Class: resin::dev
#
# This module manages resin::dev
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
class resin::dev  {
  #made a copy of resin-pro-3.1.10 for mnuss and lvaldez by hand
  #made a symbolic link by hand too 


  file {"/opt/resin-lvaldez/conf/resin.conf":
          content => template("resin/lvaldez-resin.conf.erb"),
          owner => "root", group => "root", mode => 0644,
          ensure => present, 
          require => Class["resin::install"], }

  file {"/opt/resin-mnuss/conf/resin.conf":
          content => template("resin/mnuss-resin.conf.erb"),
          owner => "root", group => "root", mode => 0644,
          ensure => present, 
          require => Class["resin::install"], }

  #dlist deploy directories
  file {"/usr/local/stage/mnuss":
    ensure => directory,
    owner => "root", group => "root", mode => "0755", 
    require => Class["resin::config"], }

  file {"/usr/local/stage/lvaldez":
    ensure => directory,
    owner => "root", group => "root", mode => "0755", 
    require => Class["resin::config"], }

 #startup scripts for resin
 file {"/etc/init.d/resin-mnuss":
   source => "puppet:///modules/resin/resin-mnuss",
   owner => "root", group => "root", mode => 0755,
   ensure => present, 
   require => Class["resin::install"], }

 file {"/etc/init.d/resin-lvaldez":
   source => "puppet:///modules/resin/resin-lvaldez",
   owner => "root", group => "root", mode => 0755,
   ensure => present, 
   require => Class["resin::install"], }
  	
}
