# Class: yumrepos::epel
#
# This module manages yumrepos::epel
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
class yumrepos::epel {
  yumrepo {"epel":
    name => "epel",
    descr => "epel",
    baseurl => "http://${servername}/cobbler/repo_mirror/epel",
    enabled => 1,
    priority => 99,
    gpgcheck => 0,
    metadata_expire => 1, }
}#end of class
