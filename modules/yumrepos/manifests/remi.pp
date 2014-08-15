# Class: yumrepos::remi
#
# This module manages yumrepos::remi
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
class yumrepos::remi {
  yumrepo {"remi":
    name => "remi",
    descr => "remi",
    baseurl => "http://${servername}/cobbler/repo_mirror/remi",
    enabled => 1,
    priority => 99,
    gpgcheck => 0,
    metadata_expire => 1, }

}#end of class 
