# Class: memcached::config::ent
#
# This module manages memcached::config::ent
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
class memcached::config::ent (
	$memcached_instance = "ent",
	$memcached_port = "11213",
	$memcached_maxconn = "10240",
	$memcached_cachesize = "1024",
	$memcached_options = ""
) {

	file { "/etc/init.d/memcached-${memcached_instance}":
		content => template("memcached/memcached.erb"),
		owner => "root", group => "root", mode => "0755",
		notify => Service["memcached-${memcached_instance}"], }

	file { "/etc/sysconfig/memcached-${memcached_instance}":
		content => template("memcached/sysconfig-memcached.erb"),
		owner => "root", group => "root", mode => "0644",
		notify => Service["memcached-${memcached_instance}"], }
	
	service {"memcached-${memcached_instance}":
		enable => false,
		ensure => stopped,
		hasstatus => true,
		hasrestart => true, }



}
