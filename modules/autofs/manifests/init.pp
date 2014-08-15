# Class: autofs
#
# This module manages autofs
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
class autofs () inherits autofs::params {
	include autofs::install, autofs::config, autofs::service
	include autofs::home

}
