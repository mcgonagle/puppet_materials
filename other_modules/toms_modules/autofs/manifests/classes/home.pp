# Class: autofs::home
#
# Manages autofs software 
# Include it to install and run autofs with default settings
#
# Usage:
# include autofs::home

class autofs::home inherits autofs {
    $nfs_home_server = extlookup("nfs_home_server")
    $nfs_home_path = extlookup("nfs_home_path")
    
    common::line{"autofs_home":
      ensure => present, 
      file => "/etc/auto.master",
      line => "/home   /etc/auto.home",
      require => Package["autofs"],
      before => Service["autofs"], }

    file { "/etc/auto.home":
      content => inline_template("*          -fstype=nfs,rw,nosuid,soft     <%= nfs_home_server %>:<%= nfs_home_path %>/&"),
      owner => "root", group => "root", mode => "0644", 
      require => [ Package["autofs"], 
		   Package["portmap"], 
                   Common::Line["autofs_home"]],
      before => [Service["autofs"],Service["portmap"]],
      notify => Service["autofs"],}

}#end of class autofs
