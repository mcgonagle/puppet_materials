# Class: autofs
#
# This module manages autofs
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class autofs::home {

    $nfs_home_server = extlookup("nfs_home_server")
    $nfs_home_path = extlookup("nfs_home_path")
    
    common::line{"autofs_home":
      ensure => present, 
      file => "/etc/auto.master",
      line => "/home   /etc/auto.home",
      require => Class["autofs::install"],
      before => Class["autofs::service"], }

    file { "/etc/auto.home":
      content => inline_template("*          -fstype=nfs,rw,nosuid,soft     <%= nfs_home_server %>:<%= nfs_home_path %>/&\n"),
      owner => "root", group => "root", mode => "0644", 
      require => [ Class["autofs::install"], 
                   Common::Line["autofs_home"]],
      before => Class["autofs::service"],
      notify => Class["autofs::service"],}

}
