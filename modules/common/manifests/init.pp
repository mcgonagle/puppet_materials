import "defines/*.pp"
# Class: common
#
# This module manages common
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
class common () inherits common::params {
	include common::install, common::config


}
