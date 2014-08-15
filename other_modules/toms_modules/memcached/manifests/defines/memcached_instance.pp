define memcached::memcached_instance (
  $instance_name,
  $instance_port,
  $cache_size = "1024") {

  $memcached_instance = "${instance_name}"

  file { "/etc/init.d/memcached-${memcached_instance}":
    content => template ("memcached/memcached_startup.erb"),
    owner => "root", group => "root", mode => "0755", }

  service {"memcached-${memcached_instance}":
    enable => true,
    ensure => running, }

 @@nagios_service { "check_memcached_instance ${memcached_instance} ${hostname}":
  ensure => present,
  use => "generic-service",
  host_name => "${hostname}",
  check_command => "check_memcached_instance!${instance_port}",
  name => "check_memcached_instance ${memcached_instance} ${hostname}",
  service_description => "check_memcached_instance ${memcached_instance}",
  target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
  require => File["/etc/nagios/services"],
  notify => Service["nagios"], }

 monit::monitd{"memcached-${memcached_instance}":
    pid_file => "/var/run/memcached-${instance_port}.pid",
    init_script => "/etc/init.d/memcached-${memcached_instance}", }

 file{"/usr/share/munin/plugins/${memcached_instance}_memcached_":
	content => template("memcached/munin/memcached_"),
	owner => "root", group => "root", mode => "0755", }

  file {"/etc/munin/plugins/${memcached_instance}_memcached_bytes":
          ensure => link,
          target => "/usr/share/munin/plugins/${memcached_instance}_memcached_",
          notify => Service["munin-node"],
          require => [ Package["munin-node"], File["/usr/share/munin/plugins/${memcached_instance}_memcached_"]];
        "/etc/munin/plugins/${memcached_instance}_memcached_counters":
          ensure => link,
          target => "/usr/share/munin/plugins/${memcached_instance}_memcached_",
          notify => Service["munin-node"],
          require => [ Package["munin-node"], File["/usr/share/munin/plugins/${memcached_instance}_memcached_"]];
        "/etc/munin/plugins/${memcached_instance}_memcached_rates":
          ensure => link,
          target => "/usr/share/munin/plugins/${memcached_instance}_memcached_",
          notify => Service["munin-node"],
          require => [ Package["munin-node"], File["/usr/share/munin/plugins/${memcached_instance}_memcached_"]]; }


}#end of memcached::memcached_service_def
