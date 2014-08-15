# Class: cobblerd::install
#
# This module manages cobblerd::install
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
class cobblerd::install {
	package{ "cobbler": ensure => present }
	package{ "cobbler-web": ensure => present }

}#end of cobblerd::install
