# Class: resin::params
#
# This module manages resin
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
class resin::params {
	$untared_packagename =  "resin-pro-3.1.10"
	$packagename = "${untared_packagename}.tar.gz"
	$file_url = "puppet:///modules/resin/"
	$file_destination = "/opt"
	$c3p0_file = "c3p0-0.9.1.2.jar"
	$mysql_connector_file = "mysql-connector-java-5.1.12-bin.jar"
	$primrose_file = "primrose.jar"

  $jdbc_url_master = extlookup("${zone}::jdbc_url_master")
  $jdbc_url_slave = extlookup("${zone}::jdbc_url_slave")
  $jdbc_url_admin = extlookup("${zone}::jdbc_url_admin")

  $main_domain = extlookup("${zone}::main_domain")	
  #main_domain_root_directory is set to "/home" in the
  #ovulator code
  $main_domain_root_directory = "."
  $host_alias = [ "$fqdn", "$hostname", "www.dlist.com" ]
  $redirect_files = [ ]
  $media_domain = extlookup("${zone}::media_domain")
  $connector_domain = extlookup("${zone}::connector_domain")

  $redirect_host_alias = "dlist.com"
  $redirect_type = "moved-permanently"
  $redirect_regexp = [ "^/robots.txt", ]
  $redirect_target = "http://${fqdn}"

}#end of resin::params
