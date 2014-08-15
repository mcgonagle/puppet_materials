# Class: activemq::config
#
# This module manages activemq::config
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
class activemq::config {

      file {"/etc/activemq/activemq.xml":
        source => ["puppet:///modules/activemq/activemq.xml.${hostname}",
                   "puppet:///modules/activemq/activemq.xml.${role}",
                   "puppet:///modules/activemq/activemq.xml" ],
        owner => "root", group => "root", mode => "0744", 
        require => Class["activemq::install"],}

    file {"/etc/activemq/activemq-wrapper.xml":
        source => "puppet:///modules/activemq/activemq-wrapper.xml",
        owner => "root", group => "root", mode => "0744", 
        require => Class["activemq::install"],}

}
