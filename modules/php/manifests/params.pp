# Class: php::params
#
# This module manages php::params
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
class php::params {

  $php_version = extlookup("${product}::php::version", "latest")
  $php_cli_version = extlookup("${product}::php-cli::version", "latest")
  $php_common_version = extlookup("${product}::php-common::version", "latest")
  $php_devel_version =   extlookup("${product}::php-devel::version", "latest")
  $php_gd_version = extlookup("${product}::php-gd::version", "latest")
  $php_mbstring_version =  extlookup("${product}::php-mbstring::version", "latest")
  $php_mcrypt_version = extlookup("${product}::php-mcrypt::version", "latest")
  $php_xml_version = extlookup("${product}::php-xml::version", "latest")
  $php_pear_version =   extlookup("${product}::php-pear::version", "latest")
  $php_pdo_version =  extlookup("${product}::php-pdo::version", "latest")
  $php_mysql_version =   extlookup("${product}::php-mysql::version", "latest")
  $php_pecl_imagick_version =  extlookup("${product}::php-pecl-imagick::version", "latest")
  $php_pecl_json_version =  extlookup("${product}::php-pecl-json::version", "latest")
  $php_pear_cache_lite_version =  extlookup("${product}::php-pear-Cache-Lite::version", "latest")
  $php_pecl_memcache_version =  extlookup("${product}::php-pecl-memcache::version", "latest")
  $php_pecl_apc_version =  extlookup("${product}::php-pecl-apc::version", "latest")
  $php_pear_xml_rpc2_version =  extlookup("${product}::php-pear-xml-rpc2::version", "latest")
  #symfony package
  $symfony_version = extlookup("${product}::symfony::version","latest")
  $swift_version = extlookup("${product}::php-swift-Swift::version","latest")
  #billing packages
  $php_pecl_http_version = extlookup("${product}::php-pecl-http::version","latest")
  $php_pecl_xdebug_version = extlookup("${product}::php-pecl-xdebug::version","latest")
  $php_pecl_ssh2_version = extlookup("${product}::php-pecl-ssh2::version","latest")

}
