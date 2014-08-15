# Class: java
#
# Manages java J2EE server.
# Include it to install and run java with default settings
#
# Usage:
# include java

import "classes/*.pp"
class java {
    package{"jdk":
        ensure => "latest",
        before => File['java.sh'], }
    
    file {"/etc/profile.d/java.sh":
        source => "puppet:///modules/java/java.sh.sun",
        ensure => present,
        alias  => "java.sh", }
}
