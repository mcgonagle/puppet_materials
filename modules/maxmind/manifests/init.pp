# Class: maxmind 
#
# This module manages maxmind 
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
class maxmind (
  $geoip_dir = $maxmind::params::geoip_dir
) inherits maxmind::params {
  include maxmind::install
  
}
