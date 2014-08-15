# Class: java::openjdk
#
# Manages open jdk java J2EE server.
# Include it to install and run java with default settings
#
# Usage:
# include java::openjdk

class java::openjdk inherits java {
   $openjdk_packagename = extlookup("java::openjdk::packagename","java-1.6.0-openjdk")
    package {"jdk": ensure => absent }
    package{"${openjdk_packagename}":
	ensure => latest,
        before => File['java.sh'], }
    
    file {"/etc/profile.d/java.sh":
	source => "puppet:///modules/java/java.sh.openjdk",
	ensure => present,
	alias  => "java.sh", }
}#end of java::openjdk
