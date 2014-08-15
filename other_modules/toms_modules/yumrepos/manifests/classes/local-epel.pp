# Class: yumrepos::local-epel
#
# Installs and manages the local-epel yum repository
#
# Usage:
# include  yumrepos::local-epel


class yumrepos::local-epel inherits yumrepos {
	yumrepos::yumrepo_define{ "local-epel": 
  		description => "local-epel",
        	url => "http://${servername}:80/cobbler/repo_mirror/local-epel",
	}#end of yumrepo_definition

}#end of class yumrepos::local-epel
