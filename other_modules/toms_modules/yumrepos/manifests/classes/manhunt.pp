# Class: yumrepos::manhunt
#
# Installs and manages the local manhunt yum repository
# Usage:
# include  yumrepos::manhunt


class yumrepos::manhunt inherits yumrepos {
	yumrepos::yumrepo_define{ "manhunt": 
  		description => "manhunt",
        	url => "http://${servername}:80/cobbler/repo_mirror/manhunt",
	}#end of yumrepo_definition

}#end of class yumrepos::manhunt
