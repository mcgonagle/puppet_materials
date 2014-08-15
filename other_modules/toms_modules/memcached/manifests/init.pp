# Class: memcached
#
# Manages apache memcached system
# Include it to install and run memcached with default settings
#
# Usage:
# include memcached


import "defines/*.pp"
#import "classes/*.pp"

class memcached {
  package { "memcached": ensure => latest, }
  package { "perl-Cache-Memcached": ensure => latest, }
  
  file { "/etc/init.d/memcached":
    ensure => absent,
    require => Package["memcached"],
  }
  
  #new memcached_instance define. Would like to get this pushed out during the next release.
  #memcached::memcached_instance {"Null":
  #	instance_name => "null",
  #	instance_port => "11211", }

  #memcached::memcached_instance {"ENT":
  #	instance_name => "ent",
  #	instance_port => "11213", }

  #memcached::memcached_instance {"GEN":
  #	instance_name => "gen",
  #	cache_size => "5116",
  #	instance_port => "11215", }

  #memcached::memcached_instance {"SESS":
  #	instance_name => "sess",
  #	instance_port => "11217", }

  #memcached::memcached_instance {"CHAT":
  #	instance_name => "chat",
  #	instance_port => "11219", }

  #memcached::memcached_instance {"ADS":
  #	instance_name => "ads",
  #	instance_port => "11221", }

  #memcached::memcached_instance {"IMG":
  #	instance_name => "img",
  #	cache_size => "2048",
  #	instance_port => "11231", }

  ###                                 NULL     ENT      SESS     CHAT     ADS     
  memcached::memcached_service_def {['11211', '11213', '11217', '11219', '11221']:
    require => Package["memcached"],
  }


  ###                                 IMG
  memcached::memcached_service_def {['11231']:
    cache_size => 2048,
    require => Package["memcached"],
  }

  ###                                 GEN
  memcached::memcached_service_def {['11215']:
    cache_size => 5116,
    require => Package["memcached"],
  }

  #include memcached monitoring
@@nagios_service { "check_memcached_procs ${hostname}":
  ensure => present,
  use => "generic-service",
  host_name => "${hostname}",
  check_command => "check_nrpe!check_memcached_procs",
  name => "check_memcached_procs ${hostname}",
  service_description => "check_memcached_procs",
  target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
  require => File["/etc/nagios/services"],
  notify => Service["nagios"], }
}

