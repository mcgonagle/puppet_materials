# Class: jdk::config
#
# This module manages jdk
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
class jdk::config {

    file {"/etc/profile.d/java.sh":
        source => "puppet:///modules/jdk/java.sh",
        ensure => present,
        require => Package["$jdk::params::version"], }

}#end of class jdk::config
