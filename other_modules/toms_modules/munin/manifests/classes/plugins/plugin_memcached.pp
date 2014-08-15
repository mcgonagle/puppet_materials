class munin::plugin::memcached inherits munin::plugin {

  file {"/etc/munin/plugins/memcached_bytes":
          ensure => link,
          target => "/usr/share/munin/plugins/memcached_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/memcached_counters":
          ensure => link,
          target => "/usr/share/munin/plugins/memcached_",
          notify => Service["munin-node"],
          require => Package["munin-node"]; 
        "/etc/munin/plugins/memcached_rates":
          ensure => link,
          target => "/usr/share/munin/plugins/memcached_",
          notify => Service["munin-node"],
          require => Package["munin-node"]; }


}#end of class munin::plugin::apache
