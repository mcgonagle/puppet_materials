# Class: cron
#
# This module manages cron
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
class cron () inherits cron::params {
	include cron::install, cron::config
}
