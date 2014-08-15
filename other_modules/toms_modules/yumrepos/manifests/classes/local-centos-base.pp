# Class: yumrepos::local-centos-base
#
# Installs and manages the local-epel yum repository
#
# Usage:
# include  yumrepos::local-centos-base


class yumrepos::local-centos-base inherits yumrepos {
  yumrepos::yumrepo_define{ "core-0": 
                description => "core-0",
                url => "http://${servername}:80/cobbler/ks_mirror/${lsbdistid}-${lsbdistrelease}-${hardwaremodel}",
        }#end of yumrepo_definition
}#end of class yumrepos::local-epel
