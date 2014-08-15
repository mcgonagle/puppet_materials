# Class: php
#
# This module manages php
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
class php (
    $php_version = $php::params::php_version,
    $php_cli_version = $php::params::php_cli_version,
    $php_common_version = $php::params::php_common_version,
    $php_devel_version = $php::params::php_devel_version,
    $php_gd_version = $php::params::php_gd_version,
    $php_mbstring_version = $php::params::php_mbstring_version,
    $php_mcrypt_version = $php::params::php_mcrypt_version,
    $php_mysql_version = $php::params::php_mysql_version,
    $php_pdo_version = $php::params::php_pdo_version,
    $php_pear_cache_lite_version = $php::params::php_pear_cache_lite_version,
    $php_pear_version = $php::params::php_pear_version,
    $php_pecl_apc_version = $php::params::php_pecl_apc_version,
    $php_pecl_imagick_version = $php::params::php_pecl_imagick_version,
    $php_pecl_json_version = $php::params::php_pecl_json_version,
    $php_pecl_memcache_version = $php::params::php_pecl_memcache_version,
    $php_xml_version = $php::params::php_xml_version,
    $php_pear_xml_rpc2_version = $php::params::php_pear_xml_rpc2_version,
    $symfony_version = $php::params::symfony_version
) inherits php::params {
  require yumrepos
  include php::install, php::config

}#end of php class
