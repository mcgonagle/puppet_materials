# Class: httpd::modules::pagespeed
#
# This module manages httpd::modules::pagespeed
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
class httpd::modules::pagespeed () {
  package {"mod-pagespeed-beta": ensure => installed }

}
