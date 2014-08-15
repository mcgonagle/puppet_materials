# Class: mysql::install
#
# This module manages mysql::install
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
class mysql::install {
    package{"${server_package}":
        ensure => "present",
        require => Class["yumrepos::mysql-enterprise"], }

    package{"${client_package}":
        ensure => "present",
        require => [ Class["yumrepos::mysql-enterprise"],
                     Package["${server_package}"]] }


}
