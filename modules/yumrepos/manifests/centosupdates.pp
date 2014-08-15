# Class: yumrepos::centosupdates
#
# This module manages yumrepos::centosupdates
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
class yumrepos::centosupdates {
  yumrepo {"centosupdates":
    name => "centosupdates",
    descr => "centosupdates",
    baseurl => "http://${servername}/cobbler/repo_mirror/centosupdates",
    enabled => 1,
    priority => 99,
    gpgcheck => 0,
    metadata_expire => 1,}

}#end of class
