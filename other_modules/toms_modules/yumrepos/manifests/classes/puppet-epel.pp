# Class: yumrepos::puppet-epel
#
# Installs and manages the puppet-epel yum repository
#
# Usage:
# include  yumrepos::local-epel


class yumrepos::puppet-epel inherits yumrepos {
	yumrepos::yumrepo_define{ "puppet-epel": 
  		description => "puppet-epel",
        	url => "http://${servername}:80/cobbler/repo_mirror/puppet-epel",
	}#end of yumrepo_definition


}#end of class yumrepos::puppet-epel
