# Class: common::install
#
# This module manages common configuration files to all hosts
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
class common::install {
  package { "man": ensure => latest }
  package { "which": ensure => latest }
  package { "sysstat": ensure => latest }
  package { "bind-utils": ensure => latest }
  package { "mlocate": ensure => latest }
  package { "joe": ensure => latest }
  package { "telnet": ensure => latest }
  package { "rsyslog": ensure => latest }
  package { "tree": ensure => latest }
  package { "zsh": ensure => latest }
  package { "tcsh": ensure => latest }
  package { "unzip": ensure => latest }
  package { "yum-priorities": ensure => latest }

}#end of common::install
