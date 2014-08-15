# Class: cron::install
#
# This module manages cron::install
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
class cron::install {
	package {"vixie-cron": ensure => latest }
}
