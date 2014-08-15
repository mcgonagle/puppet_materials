# Class: cobblerd
#
# This module manages cobblerd
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
class cobblerd () inherits cobblerd::params {
	include cobblerd::install, cobblerd::config, cobblerd::service

}#end of cobblerd
