# Class: yumrepos::puppet-enterprise
#
# This module manages yumrepos::puppet-enterprise
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
class yumrepos::puppet-prosvc {
  yumrepo {"puppet-prosvc":
    name => "puppet-prosvc",
    descr => "puppet-prosvc",
    baseurl => "http://${servername}/cobbler/repo_mirror/puppet-prosvc",
    enabled => 1,
    priority => 10,
    gpgcheck => 0,
    metadata_expire => 1, }

}
