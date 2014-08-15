# Class: puppet::server
#
# This module manages puppet
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
class puppet::server {
	include puppet::server::install
  selboolean { "httpd_disable_trans":
    persistent => "true",
    value => "off", }

}
