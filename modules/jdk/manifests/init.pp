# Class: jdk
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
# Using parameterized classes by inheriting the java class from the 
# java::params class idea comes from the following puppet documentation.
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
class jdk( $packages = $jdk::params::packages) inherits jdk::params {
	include jdk::install, jdk::config

}#end of class jdk
