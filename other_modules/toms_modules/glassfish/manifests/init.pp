# Module: glassfish
#
# Class: glassfish
#
# Description:
#       This class installs the glassfish java servlet container
#
# Defines:
#
# Variables:
#
# Facts:
#       None
# Usagge:
# include glassfish
#
#   
class glassfish {
 require sun-java
 require glassfish::params

 common::unarchive::unzip{"$glassfish::params::package_version":
	  file => "$glassfish::params::package_version",
	  unzipped_file => "glassfish3",
	  module_url => "puppet:///modules/glassfish/",
	  destination => "/opt", }

  file {"/etc/init.d/glassfish":
    source => "puppet:///modules/glassfish/glassfish",
    owner => "root", group => "root", mode => 0755, 
    require => Common::Unarchive::Unzip["$glassfish::params::package_version"], }

  service {"glassfish":
    enable => false,
    ensure => stopped,
    hasstatus => false,
    hasrestart => true,
    pattern => "java -cp /usr/local/glassfishv3/glassfish/modules/glassfish.jar",
    require => File["/etc/init.d/glassfish"], }

}#end of glassfish
