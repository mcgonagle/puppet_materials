# Class: yumrepos
#
# Installs and manages yum_repos.
# Include it to install and run yum_repos with default settings
#
# Parameters:
# Usage:
# Actions:
# Requires:
#
# Sample Usage:
#  include yumrepos
#

##import the defines and classes subdirectories
import "defines/*.pp"
import "classes/*.pp"

class yumrepos {
 #yumrepo{"remi":
	#name => "remi",
	#baseurl => "http://${servername}:80/cobbler/repo_mirror/remi",
	#enabled => "1",
	#gpgcheck => "0",
	#priority => "10",
	#metadata_expire => "1", }

 yumrepo{"core-0":
	name => "core-0",
	baseurl => "http://${servername}:80/cobbler/ks_mirror/CentOS-5.5-x86_64",
	enabled => "1",
	gpgcheck => "0",
	priority => "20",
	metadata_expire => "1", }

 yumrepo{"CentOS5-update":
	name => "CentOS5-update",
	baseurl => "http://${servername}:80/cobbler/repo_mirror/CentOS5-update",
	enabled => "1",
	priority => "20",
	gpgcheck => "0",
	metadata_expire => "1", }

 yumrepo{"epel":
	name => "epel",
	baseurl => "http://${servername}:80/cobbler/repo_mirror/epel",
	enabled => "1",
	priority => "30",
	gpgcheck => "0",
	metadata_expire => "1", }

 yumrepo{"epel-testing":
	name => "epel-testing",
	baseurl => "http://${servername}:80/cobbler/repo_mirror/epel-testing",
	enabled => "1",
	priority => "99",
	gpgcheck => "0",
	metadata_expire => "1", }

 yumrepo{"rpmforge":
	name => "rpmforge",
	baseurl => "http://${servername}:80/cobbler/repo_mirror/rpmforge",
	enabled => "1",
	priority => "30",
	gpgcheck => "0",
	metadata_expire => "1", }

 yumrepo{"manhunt":
	name => "manhunt",
	baseurl => "http://${servername}:80/cobbler/repo_mirror/manhunt",
	enabled => "1",
	priority => "40",
	gpgcheck => "0",
	metadata_expire => "1", }


 yumrepo{"scribe":
	name => "scribe",
	baseurl => "http://${servername}:80/cobbler/repo_mirror/scribe",
	enabled => "0",
	priority => "99",
	gpgcheck => "0",
	metadata_expire => "1", }

}#end of class yum_repos
