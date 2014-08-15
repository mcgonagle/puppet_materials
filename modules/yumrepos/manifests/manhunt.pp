# Class: yumrepos::manhunt
#
# This module manages yumrepos::manhunt
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
class yumrepos::manhunt {
  yumrepo {"manhunt":
    name => "manhunt",
    descr => "manhunt",
    baseurl => "http://${servername}/cobbler/repo_mirror/manhunt",
    enabled => 1,
    priority => 99,
    gpgcheck => 0,
    metadata_expire => 1, }
}#end of class
