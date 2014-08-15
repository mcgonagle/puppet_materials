class munin::plugin::named inherits munin::plugin {
  file {"/etc/munin/plugins/named":
          ensure => link,
          target => "/usr/share/munin/plugins/named",
	  notify => Service["munin-node"],
	  require => Package["munin-node"], }

}#end of class munin::plugin::nfsd
