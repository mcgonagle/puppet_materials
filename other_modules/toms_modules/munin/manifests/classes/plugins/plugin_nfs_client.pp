class munin::plugin::nfs_client inherits munin::plugin {
  file {"/etc/munin/plugins/nfs_client":
          ensure => link,
          target => "/usr/share/munin/plugins/nfs_client",
	  notify => Service["munin-node"], 
	  require => Package["munin-node"], }

}#end of class munin::plugin::apache
