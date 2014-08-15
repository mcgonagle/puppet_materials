class munin::plugin::varnish inherits munin::plugin {

  file {"/etc/munin/plugins/varnish_backend_traffic":
          ensure => link,
          target => "/usr/share/munin/plugins/varnish_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/varnish_expunge":
          ensure => link,
          target => "/usr/share/munin/plugins/varnish_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/varnish_hit_rate":
          ensure => link,
          target => "/usr/share/munin/plugins/varnish_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/varnish_memory_usage":
          ensure => link,
          target => "/usr/share/munin/plugins/varnish_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/varnish_objects":
          ensure => link,
          target => "/usr/share/munin/plugins/varnish_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/varnish_request_rate":
          ensure => link,
          target => "/usr/share/munin/plugins/varnish_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/varnish_threads":
          ensure => link,
          target => "/usr/share/munin/plugins/varnish_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/varnish_transfer_rates":
          ensure => link,
          target => "/usr/share/munin/plugins/varnish_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/varnish_uptime":
          ensure => link,
          target => "/usr/share/munin/plugins/varnish_",
          notify => Service["munin-node"],
          require => Package["munin-node"]; }


}#end of class munin::plugin::apache
