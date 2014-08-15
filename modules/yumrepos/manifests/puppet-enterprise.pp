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
class yumrepos::puppet-enterprise {
  yumrepo {"puppet-enterprise":
    name => "puppet-enterprise",
    descr => "puppet-enterprise",
    baseurl => "http://${servername}/cobbler/repo_mirror/puppet-enterprise",
    enabled => 1,
    priority => 99,
    gpgcheck => 0,
    metadata_expire => 1, }

}
