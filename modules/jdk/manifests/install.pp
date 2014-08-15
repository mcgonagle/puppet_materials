# Class: jdk::install
#
# This module manages jdk
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
class jdk::install {
    #yumrepo {"sun-java":
    #  name => "sun-java",
    #  descr => "sun-java",
    #  baseurl => "http://${servername}/cobbler/repo_mirror/sun-java",
    #  enabled => 1,
    #  priority => 99,
    #  gpgcheck => 0, }

    package{"${packages}":
        ensure => "present",
        require => Class["yumrepos::sun-java"], }
        #require => Yumrepo["sun-java"], }

}#end of class jdk::install
