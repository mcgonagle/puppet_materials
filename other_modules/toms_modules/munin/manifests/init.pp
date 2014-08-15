# Class: munin
#
# Manages munin software 
# Include it to install and run munin with default settings
#
# Usage:
# include munin


import "classes/*.pp"
#import "defines/*.pp"

class munin {
    include munin::plugin::yum
    package{"sysstat": ensure => latest, before => Package["munin-node"] }
    package{"munin-node": ensure => latest }

    @@file {"/etc/munin/conf.d/${fqdn}.conf":
    #content => template("munin/node.conf.erb"),
      content => inline_template("[${fqdn}] 
address ${ipaddress}"),
      owner => "root", group => "root", mode => "0644", 
      tag => "munin_file", }

    file {"/etc/munin/munin-node.conf":
      content => template("munin/munin-node.conf.erb"),
      owner => "root", group => "root", mode => "0644",
      require => Package["munin-node"], }

    #munin plugins we dont' use get removed here
    file {"/etc/munin/plugins/lpstat":
	      ensure => absent,
        require => Package["munin-node"], }

    file {"/etc/munin/plugins/exim_mailqueue":
	      ensure => absent,
        require => Package["munin-node"], }
  
  nagmon::service{"munin-node":
      ensure => running,
      enable => true,
      pid_file => "/var/run/munin/munin-node.pid",
      init_script => "/etc/init.d/munin-node", 
      warn => "1:",
      critical => "1:",
      nrpe_parameter => "-C munin-node",
      require => [ File["/etc/munin/plugins/lpstat"],
                   File["/etc/munin/plugins/exim_mailqueue"]],
      subscribe => File["/etc/munin/munin-node.conf"], }
   
      

}#end of class munin
