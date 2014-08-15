# Class: yumrepos::manhunt
#
# Installs and manages the local manhunt yum repository
# Usage:
# include  yumrepos::manhunt

class yumrepos::scribe inherits yumrepos {
	yumrepos::yumrepo_define{"scribe": 
  		description => "scribe",
        	url => "http://${servername}:80/cobbler/repo_mirror/scribe",
	}#end of yumrepo_definition

}#end of class yumrepos::scribe
