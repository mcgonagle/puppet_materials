class munin::plugin::nfsd inherits munin::plugin {
  file {"/etc/munin/plugins/nfsd":
          ensure => link,
          target => "/usr/share/munin/plugins/nfsd",
	  notify => Service["munin-node"], 
	  require => Package["munin-node"], }

}#end of class munin::plugin::nfsd
