# Class: yumrepos::rpmforge
#
# This module manages yumrepos::rpmforge
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
class yumrepos::rpmforge {
  yumrepo {"rpmforge":
    name => "rpmforge",
    descr => "rpmforge",
    baseurl => "http://${servername}/cobbler/repo_mirror/rpmforge",
    enabled => 1,
    priority => 99,
    gpgcheck => 0,
    metadata_expire => 1, }
}
