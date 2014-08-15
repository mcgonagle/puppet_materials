class munin::plugin::bind inherits munin::plugin {

  file {"/etc/munin/plugin-conf.d/bind":
    content => inline_template("[bind9]
env.logfile   /var/log/bind9/query.log"),
    owner => "root", group => "root", mode => "0644",
    require => File["/etc/munin/plugins/bind9"],
    notify => Service["munin-node"], }

  file {"/etc/munin/plugins/bind9":
          ensure => link,
          target => "/usr/share/munin/plugins/bind9",
	  notify => Service["munin-node"],
	  require => Package["munin-node"], }

}#end of class munin::plugin::apache
