# Class: mcollective::install
#
# This module manages mcollective::install
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
class mcollective::install {
	package { 'mcollective': ensure => '1.0.1-1.el5' }


}
