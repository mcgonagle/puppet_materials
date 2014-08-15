# Class: yumrepos::centos
#
# This module manages yumrepos::centos
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
class yumrepos::centos {
	$centos_version = "${operatingsystem}-${operatingsystemrelease}-${architecture}"
	yumrepo {"cobbler-config":
	 	name => "core-0",
	 	descr => "core-0",
		baseurl => "http://${servername}/cobbler/ks_mirror/${centos_version}",
		enabled => 1,
		priority => 99,
		gpgcheck => 0,
		metadata_expire => 1, }
}#end of class
