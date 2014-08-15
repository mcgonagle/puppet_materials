# Class: php::billing
#
# This module manages php::billing specific packages
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
class php::billing (
  $php_pecl_http_version = $php::params::php_pecl_http_version,
  $php_pecl_xdebug_version = $php::params::php_pecl_xdebug_version,
  $php_pecl_ssh2_version = $php::params::php_pecl_ssh2_version
) inherits php::params {

  package { "php-pecl-http": ensure => "${php_pecl_http_version}", }
  package { "php-pecl-xdebug": ensure => "${php_pecl_xdebug_version}", }
  package { "php-pecl-ssh2": ensure => "${php_pecl_ssh2_version}", }

  #the next two file stanzas push down a 
  #gearman.so and gearman.ini file
  file {"/usr/lib64/php/modules/gearman.so":
    ensure => present,
    source => "puppet:///modules/php/gearman.so",
    owner => "root", group => "root", mode => "0755", }
  
  file {"/etc/php.d/gearman.ini":
    content => "extension=gearman.so\n",
    owner => "root", group => "root", mode => "0644",
    require => File["/usr/lib64/php/modules/gearman.so"], }

}#end of php::billing
