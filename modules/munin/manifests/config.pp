# Class: munin::config
#
# This module manages munin::config
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
class munin::config {
     @@file {"/etc/munin/conf.d/${fqdn}.conf":
      #content => template("munin/node.conf.erb"),
      content => inline_template("[${fqdn}] \naddress ${ipaddress}"),
      owner => "root", group => "root", mode => "0644", 
      tag => "munin_file",
      require => Class["munin::install"], }

    file {"/etc/munin/munin-node.conf":
      content => template("munin/munin-node.conf.erb"),
      owner => "root", group => "root", mode => "0644",
      require => [ Package["munin-node"], Class["munin::install"]], }

    #munin plugins we dont' use get removed here
    file {"/etc/munin/plugins/lpstat":
      ensure => absent,
      require => [ Package["munin-node"], Class["munin::install"]], }

    file {"/etc/munin/plugins/exim_mailqueue":
      ensure => absent,
      require => [ Package["munin-node"], Class["munin::install"]], }


}
