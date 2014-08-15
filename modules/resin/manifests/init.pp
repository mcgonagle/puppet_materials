# Class: resin
#
# This module manages resin
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
class resin inherits resin::params {
	include resin::install, resin::config, resin::service
}
