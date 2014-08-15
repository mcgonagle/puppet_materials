# Class: munin::server::config
#
# This module manages munin::server::config
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
class munin::server::config {

	file {"/etc/munin/munin.conf":
    		content => template("munin/munin.conf.erb"),
    		owner => "root", group => "root", mode => "0644", 
    		require => Class["munin::server::install"], }

  File <<| tag == "munin_file" |>>

}
