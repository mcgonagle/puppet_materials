# Class: glassfish::install
#
# This module manages glassfish::install
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
class glassfish::install {
  common::unarchive::unzip{"glassfish":
    file => "glassfish-3.1.zip",
    unzipped_file => "glassfish3",
    destination => "/opt",
    module_url => "puppet:///modules/glassfish", }

  file {"/etc/init.d/glassfish":
    source => "puppet:///modules/glassfish/init/glassfish",
    owner => "root", group => "root", mode => 0755, 
    require => Common::Unarchive::Unzip["glassfish"], }


}
