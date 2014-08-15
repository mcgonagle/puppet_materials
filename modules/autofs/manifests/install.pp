# Class: autofs::install
#
# This module manages autofs
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
class autofs::install {
    package { "autofs": ensure => latest }
    package { "nfs-utils": ensure => latest }
    package { "portmap": ensure => latest }
}
