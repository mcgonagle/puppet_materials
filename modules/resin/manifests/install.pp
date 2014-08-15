# Class: resin::install
#
# This module manages resin
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
class resin::install {
	require java
 	common::unarchive::tar-gz{"${resin::params::packagename}":
        	file => "${resin::params::packagename}",
        	untared_file => "${resin::params::untared_packagename}",
        	module_url => "${resin::params::file_url}",
        	destination => "${resin::params::file_destination}", }

        file {"/opt/resin":
                ensure => link,
                target => "/opt/${resin::params::untared_packagename}",
                require => Common::Unarchive::Tar-gz["${resin::params::packagename}"], }

}#end of resin::install
