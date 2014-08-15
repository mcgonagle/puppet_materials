# Class: icinga::config
#
# This module manages icinga::config
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
class icinga::config {

  file { "/etc/icinga/htpasswd.users":
    source => "puppet:///modules/icinga/htpasswd.users",
    owner => "icinga", group => "icinga", mode => "0660", }

  file { "/etc/icinga/resource.cfg":
    source => "puppet:///modules/icinga/resource.cfg",
    owner => "icinga", group => "icinga", mode => "0660", }

  file { "/etc/icinga/icinga.cfg":
    source => "puppet:///modules/icinga/icinga.cfg",
    owner => "icinga", group => "icinga", mode => "0660", }

  file { "/etc/icinga/hosts":
    ensure => directory,
    owner => "icinga", group => "icinga", mode => "0755", }

  file { "/etc/icinga/services":
    ensure => directory,
    owner => "icinga", group => "icinga", mode => "0755", }

}
