# Class: maxmind
#
# Manages maxmind software 
# Include it to install and run maxmind with default settings
#
# Usage:
# include maxmind
class maxmind {
    $geoip_dir = "/usr/local/share/GeoIP" 

   file {"${geoip_dir}":
     ensure => directory,
     owner => "root", group => "root", mode => "0755", }

   file { "${geoip_dir}/GeoLiteCity.dat":
    source => "puppet:///modules/maxmind/GeoLiteCity.dat",
    owner => "root", group => "root", mode => "0755",
    require => File["${geoip_dir}"], }

}#end of class maximind
