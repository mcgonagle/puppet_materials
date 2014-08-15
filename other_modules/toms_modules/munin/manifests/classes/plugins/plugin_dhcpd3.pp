class munin::plugin::dhcpd inherits munin::plugin {

  file {"/etc/munin/plugin-conf.d/dhcpd":
    content => inline_template("[dhcpd3]
user root
env.leasefile /var/lib/dhcp3/dhcpd.leases
env.configfile /etc/dhcp3/dhcpd.conf
env.filter  ^10\.140\.
env.critical 0.95
env.warning 0.9"),
    owner => "root", group => "root", mode => "0644",
    require => File["/etc/munin/plugins/bind9"],
    notify => Service["munin-node"], }

  file {"/etc/munin/plugins/dhcpd3":
          ensure => link,
          target => "/usr/share/munin/plugins/dhcpd3",
	  notify => Service["munin-node"], 
	  require => Package["munin-node"], }

}#end of class munin::plugin::apache
