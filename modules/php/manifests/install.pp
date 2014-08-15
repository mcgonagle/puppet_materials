# Class: php::install
#
# This module manages php::install
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
class php::install {
  package { "php": ensure => "${php_version}", }
  package { "php-devel": ensure => "${php_devel_version}", }
  package { "php-cli": ensure => "${php_cli_version}", }
  package { "php-common": ensure => "${php_common_version}", }
  package { "php-gd": ensure => "${php_gd_version}", }
  package { "php-mcrypt": ensure => "${php_mcrypt_version}", }
  package { "php-xml": ensure => "${php_xml_version}", }
  package { "php-pear": ensure => "${php_pear_version}", }

  package { "php-pear-Cache-Lite": ensure => "${php_pear_cache_lite_version}", }
  package { "php-pecl-imagick": ensure => "${php_pecl_imagick_version}", }
  #obsoleted php-pecl-json
  #package { "php-pecl-json": ensure => "${php_pecl_json_version}" }
  package { "php-pecl-apc": ensure => "${php_pecl_apc_version}" }
  package { "php-mbstring": ensure => "${php_mbstring_version}" }
  package { "php-pecl-memcache": ensure => "${php_pecl_memcache_version}", }
  package { "php-pdo": ensure => "${php_pdo_version}", }
  package { "php-mysql": ensure => "${php_mysql_version}", }
  package { "php-pear-XML-RPC2": ensure => "${php_pear_xml_rpc2_version}", }

  package { "php-symfony-symfony": ensure => "${symfony_version}", }
  package { "php-swift-Swift": ensure => "${swift_version}", }

}#end of php::install
