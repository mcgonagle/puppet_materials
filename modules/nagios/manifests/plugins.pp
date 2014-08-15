# Class: nagios::plugins
#
# This module manages nagios::plugins
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
class nagios::plugins {
    package{"nagios-plugins-all": ensure => latest }

}
