# Class: glassfish::config
#
# This module manages glassfish::config
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
class glassfish::config {

  file{"/opt/glassfish3/glassfish/domains/domain1/lib/ext/mysql-connector-java-5.1.16-bin.jar":
    source => "puppet:///modules/glassfish/mysql-connector/mysql-connector-java-5.1.16-bin.jar",
    owner => "root", group => "root", mode => "0755", 
    require => Class["glassfish::install"], }

  file{"/opt/glassfish3/glassfish/domains/domain1/config/domain.xml":
    source => "puppet:///modules/glassfish/domain.xml",
    owner => "root", group => "root", mode => "0600", 
    require => Class["glassfish::install"], }



}
