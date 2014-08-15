# Class: java
#
# This module manages java
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
# Using parameterized classes by inheriting the java class from the 
# java::params class idea comes from the following puppet documentation.
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
class java( $packages = $java::params::packages) inherits java::params {
	include java::install, java::config

}#end of class java
