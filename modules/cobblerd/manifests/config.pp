# Class: cobblerd::config
#
# This module manages cobblerd::config
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
class cobblerd::config {
	file{"/etc/cobbler/modules.conf":
	  ensure => present,
	  source => "puppet:///modules/cobblerd/modules.conf",
	  owner => "root", group => "root", mode => "0644",
	  notify => Class["cobblerd::service"], }

	file{"/etc/cobbler/settings":
	  ensure => present,
	  source => "puppet:///modules/cobblerd/settings",
	  owner => "root", group => "root", mode => "0644",
	  notify => Class["cobblerd::service"], }

	augeas {"tftp xinetd.d disable no":
	  context => "/files/etc/xinetd.d/tftp/service",
	  changes => ["set disable no"],
	  onlyif => "match other_value size > 0", 
	  notify => Class["cobblerd::service"], }
	
	augeas {"rsync xinetd.d disable no":
	  context => "/files/etc/xinetd.d/rsync/service",
	  changes => ["set disable no"],
	  onlyif => "match other_value size > 0", 
	  notify => Class["cobblerd::service"], }

}#end of cobblerd::config
