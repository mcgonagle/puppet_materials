# Module: sun-java
#
# Class: sun-java
#
# Description:
#       This class installs the sun/oracle java jdk
#
# Defines:
#
# Variables:
#       None
#
# Facts:
#       None
#
class sun-java {
    #require sun-java::params

    yumrepo {"sun-java":
      name => "sun-java",
      baseurl => "http://${servername}/cobbler/repo_mirror/sun-java",
      enabled => 1,
      priority => 99,
      gpgcheck => 0, }
    
    package{"jdk-1.6.0_25-fcs":
        ensure => "latest",
        require => Yumrepo["sun-java"], }
    
    file {"/etc/profile.d/java.sh":
        source => "puppet:///modules/java/java.sh",
        ensure => present,
        require => Package["jdk-1.6.0_25-fcs"], }
}#end of sun-java class
