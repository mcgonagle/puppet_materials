# Class: yumrepos::centosplus
#
# This module manages yumrepos::centosplus
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
class yumrepos::centosplus {
	yumrepo {"centosplus":
		name => "centosplus",
		descr => "centosplus",
		baseurl => "http://${servername}/cobbler/repo_mirror/centosplus",
		enabled => 1,
		priority => 99,
		gpgcheck => 0,
		metadata_expire => 1, }
}#end of class
