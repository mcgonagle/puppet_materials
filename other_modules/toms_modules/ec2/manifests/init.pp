# Class: ec2 
#
# Manages ec2 module
#
# Usage:
# include ec2 


import "defines/*.pp"
import "classes/*.pp"

class ec2 {
    
    require ec2::params

    #file {"${ec2::params::ec2_root}": ensure => directory, }

    file {"${ec2::params::ec2_root}/pk-JY2P4QYJ4KQKCO4ISAKN5E3H6YOIR5ZY.pem":
	source => "puppet:///ec2/pk-JY2P4QYJ4KQKCO4ISAKN5E3H6YOIR5ZY.pem", 
        owner => "root", group => "root", mode => 0755, }

    file {"${ec2::params::ec2_root}/cert-JY2P4QYJ4KQKCO4ISAKN5E3H6YOIR5ZY.pem":
	source => "puppet:///ec2/cert-JY2P4QYJ4KQKCO4ISAKN5E3H6YOIR5ZY.pem", 
        owner => "root", group => "root", mode => 0755, }

    file {"${ec2::params::ec2_root}/set_namemedia_ec2":
	source => "puppet:///ec2/set_namemedia_ec2", 
        owner => "root", group => "root", mode => 0755, }


   common::unarchive::unzip{"${ec2::params::ec2_api_tools_zipped}":
    file => "${ec2::params::ec2_api_tools_zipped}",
    unzipped_file => "${ec2::params::ec2_api_tools}",
    module_url => "${ec2::params::file_url}",
    destination => "${ec2::params::file_destination}",
    require => File["${ec2::params::ec2_root}"],
   }

   common::unarchive::unzip{"${ec2::params::packagename}":
    file => "${ec2::params::packagename}",
    unzipped_file => "${ec2::params::unzipped_packagename}",
    module_url => "${ec2::params::file_url}",
    destination => "${ec2::params::file_destination}",
    require => File["${ec2::params::ec2_root}"],
   }
	

}#end of ec2
