# Class: java::config
#
# This module manages java
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
class java::config {

    file {"/etc/profile.d/java.sh":
        source => "puppet:///modules/java/java.sh",
        ensure => present,
        require => Package["$java::params::version"], }

}#end of class java::config
