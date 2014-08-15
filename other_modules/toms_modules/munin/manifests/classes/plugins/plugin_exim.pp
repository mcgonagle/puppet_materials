class munin::plugin::exim inherits munin::plugin {
  file {"/etc/munin/plugins/exim_mailqueue":
          ensure => absent,
	  notify => Service["munin-node"],
	  require => Package["munin-node"], }

}#end of class munin::plugin::nfsd
