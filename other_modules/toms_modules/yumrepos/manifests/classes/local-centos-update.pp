# Class: yumrepos::local-centos-update
#
# Installs and manages the local-centos-update yum repository
#
# Usage:
# include  yumrepos::local-centos-update


class yumrepos::local-centos-update inherits yumrepos {
  yumrepos::yumrepo_define{ "${lsbdistid}${lsbmajdistrelease}-update": 
         description => "${lsbdistid}${lsbmajdistrelease}-update",
         url => "http://${servername}:80/cobbler/repo_mirror/${lsbdistid}${lsbmajdistrelease}-update",
        }#end of yumrepo_definition
}#end of class yumrepos::local-epel
