# Class: php
#
# Installs Php module for Apache
# Check out php::module, php::pecl, and php::pear defines to install 
# specific php modules and pear software
#
# Usage:
# include php

##import the defines and classes subdirectories
import "defines/*.pp"
import "classes/*.pp"
class php  {
  include httpd
  $php_version = extlookup("${product}::php::version", "latest")
  $php_cli_version = extlookup("${product}::php-cli::version", "latest")
  $php_common_version = extlookup("${product}::php-common::version", "latest")
  $php_devel_version =   extlookup("${product}::php-devel::version", "latest")
  $php_gd_version = extlookup("${product}::php-gd::version", "latest")
  $php_mbstring_version =  extlookup("${product}::php-mbstring::version", "latest")
  $php_mcrypt_version = extlookup("${product}::php-mcrypt::version", "latest")
  $php_mysql_version =   extlookup("${product}::php-mysql::version", "latest")
  $php_pdo_version =  extlookup("${product}::php-pdo::version", "latest")
  $php_pear_cache_lite_version =  extlookup("${product}::php-pear-Cache-Lite::version", "latest")
  $php_pear_version =   extlookup("${product}::php-pear::version", "latest")
  $php_pecl_apc_version =  extlookup("${product}::php-pecl-apc::version", "latest")
  $php_pecl_imagick_version =  extlookup("${product}::php-pecl-imagick::version", "latest")
  $php_pecl_memcache_version =  extlookup("${product}::php-pecl-memcache::version", "latest")
  $php_xml_version = extlookup("${product}::php-xml::version", "latest")

  package { "php": ensure => "${php_version}", }
  package { "php-cli": ensure => "${php_cli_version}", }
  package { "php-common": ensure => "${php_common_version}", }
  package { "php-gd": ensure => "${php_gd_version}", }
  package { "php-mcrypt": ensure => "${php_mcrypt_version}", }       
  package { "php-xml": ensure => "${php_xml_version}", }       

  include pear::archive_tar
  include pear::cache_lite
  include pear::structures_graph
  include pear::xml_rpc2
  include pear::pdo
  include pear::pdo_mysql
  include pear::mbstring
  include pear::imagick
  include pear::symfony
  if  $role =~ /www/ {
    include pecl::apc
  }
  include pecl::memcache
  #the remi repo automatically removes this json class, not sure if it is needed or not
  #include php::pecl::json

    php::php_ini{"$fqdn":
      php_ini_file => "/etc/php.ini",
      auto_prepend_file => "",
      error_reporting => "E_ALL & ~E_NOTICE",
      extension_dir => "/usr/lib64/php/modules",
      include_path => ".:/php/includes:/var/www/manhunt/phplib",
      magic_quotes_gpc =>"Off",
      max_execution_time =>"30",
      post_max_size => "8M",
      php_extensions => [],
      register_argc_argv => "On",
      register_globals => "Off",
      sendmail_path => "/usr/sbin/sendmail -t -i -f manmailbot@manhunt.net",
      session_gc_maxlifetime => "1440",
      session_save_path => "/dev/shm",
      session_use_only_cookies => "1",
      variables_order => "EGPCS",
    }
}#end of class php
