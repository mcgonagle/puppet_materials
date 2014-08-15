# Class: maxmind::dlist
#
# This module manages maxmind::dlist
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
class maxmind::dlist {
  common::unarchive::gunzip{"GeoIPCity.dat.gz":
    file => "GeoIPCity.dat.gz",
    unzipped_file => "GeoIPCity.dat",
    destination => "/usr/local/etc",
    module_url => "puppet:///modules/maxmind", }

 file{"/usr/local/etc/GeoLiteCity.dat":
  ensure => link,
  target => "/usr/local/etc/GeoIPCity.dat",
  require => Common::Unarchive::Gunzip["GeoIPCity.dat.gz"], }

  
}
