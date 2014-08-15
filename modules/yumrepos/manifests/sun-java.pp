# Class: yumrepos::sun-java
#
# This module manages yumrepos::sun-java
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
class yumrepos::sun-java {
  yumrepo {"sun-java":
    name => "sun-java",
    descr => "sun-java",
    baseurl => "http://${servername}/cobbler/repo_mirror/sun-java",
    enabled => 1,
    priority => 99,
    gpgcheck => 0,
    metadata_expire => 1,}
}#end of class
