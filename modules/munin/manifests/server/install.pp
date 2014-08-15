# Class: munin::server::install
#
# This module manages munin::server::install
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
class munin::server::install {
	package {"munin": ensure => latest }

}
