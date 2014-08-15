# Class: maxmind::install
#
# This module manages maxmind::install
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
class maxmind::install {
   file {"${geoip_dir}":
    ensure => directory,
    owner => "root", group => "root", mode => "0755", }

   file { "${geoip_dir}/GeoLiteCity.dat":
    source => "puppet:///modules/maxmind/GeoLiteCity.dat",
    owner => "root", group => "root", mode => "0755", 
    require => File["${geoip_dir}"], }
  
}
