# Class: yumrepos::epel-testing
#
# This module manages yumrepos::epel-testing
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
class yumrepos::epel-testing {
  yumrepo {"epel-testing":
    name => "epel-testing",
    descr => "epel-testing",
    baseurl => "http://${servername}/cobbler/repo_mirror/epel-testing",
    enabled => 1,
    priority => 99,
    gpgcheck => 0,
    metadata_expire => 1, }

}
