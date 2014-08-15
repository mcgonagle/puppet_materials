# Class: yumrepos::mysql-enterprise
#
# This module manages yumrepos::mysql-enterprise
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
class yumrepos::mysql-enterprise {
  yumrepo { "mysql-enterprise":
    name => "mysql-enterprise",
    descr => "mysql-enterprise",
    baseurl => "http://${servername}/cobbler/repo_mirror/mysql-enterprise",
    enabled => 0,
    priority => 99,
    gpgcheck => 0,
    metadata_expire => 1,}

}#end of class
