define memcached::memcached_service_def (
  $cache_size=1024
  ) {
  $memcached_instance = "${name}"
  file { "/etc/init.d/memcached-${memcached_instance}":
    content => template ("memcached/memcached.erb"),
    owner => "root", group => "root", mode => 0755,
  }
  service {"memcached-${memcached_instance}":
    enable => true,
    ensure => running,
  }

 @@nagios_service { "check_memcached_instance ${memcached_instance} ${hostname}":
  ensure => present,
  use => "generic-service",
  host_name => "${hostname}",
  check_command => "check_memcached_instance!${memcached_instance}",
  name => "check_memcached_instance ${memcached_instance} ${hostname}",
  service_description => "check_memcached_instance ${memcached_instance}",
  target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
  require => File["/etc/nagios/services"],
  notify => Service["nagios"], }

 monit::monitd{"memcached-${memcached_instance}":
    pid_file => "/var/run/memcached-${memcached_instance}.pid",
    init_script => "/etc/init.d/memcached-${memcached_instance}", }

 #file{"/usr/share/munin/plugins

}#end of memcached::memcached_service_def
