# Class: yumrepos::elff
#
# This module manages yumrepos::elff
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
class yumrepos::elff {
  yumrepo {"elff":
    name => "elff",
    descr => "elff",
    baseurl => "http://${servername}/cobbler/repo_mirror/elff",
    enabled => 1,
    priority => 99,
    gpgcheck => 0,
    metadata_expire => 1, }

}
