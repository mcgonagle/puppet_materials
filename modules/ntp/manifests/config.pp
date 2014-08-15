# Class: ntp::config
#
# This module manages ntp
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
class ntp::config {
    file { "/etc/ntp.conf":
      content => template("ntp/ntp.conf.erb"),
      owner => "root", group => "root", mode => "0644",
      require => Class["ntp::install"], }

}
