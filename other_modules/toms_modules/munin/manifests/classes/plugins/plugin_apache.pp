class munin::plugin::apache inherits munin::plugin {
  file {"/etc/munin/plugin-conf.d/apache":
    content => inline_template("[apache_*]
env.url   http://<%= fqdn %>:%d/server-status?auto
env.ports 80"),
    owner => "root", group => "root", mode => "0644",
    require => File["/etc/munin/plugins/apache_accesses"],
    notify => Service["munin-node"], }

  file {"/etc/munin/plugins/apache_accesses":
          ensure => link,
          target => "/usr/share/munin/plugins/apache_accesses",
	  notify => Service["munin-node"],
	  require => Package["munin-node"];
        "/etc/munin/plugins/apache_processes":
          ensure => link,
          target => "/usr/share/munin/plugins/apache_processes",
	  notify => Service["munin-node"],
	  require => Package["munin-node"];
        "/etc/munin/plugins/apache_volume":
          ensure => link,
          target => "/usr/share/munin/plugins/apache_volume",
	  notify => Service["munin-node"],
	  require => Package["munin-node"]; }

}#end of class munin::plugin::apache
