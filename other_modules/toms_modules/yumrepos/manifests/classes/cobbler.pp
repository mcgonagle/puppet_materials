# Class: yumrepos::cobbler
#
# Installs and manages the local manhunt yum repository
# Usage:
# include  yumrepos::cobbler


class yumrepos::cobbler inherits yumrepos {
	yumrepos::yumrepo_define{ "scribe": 
  		description => "cobbler",
        	url => "file://etc/puppet/environments/cobbler/rpms",
	}#end of yumrepo_definition

}#end of class yumrepos::manhunt
