class dhcpd {
 package{"dhcp": ensure => latest }
 monit::monitd{"dhcpd":
        pid_file => "/var/run/dhcpd.pid",
        init_script => "/etc/init.d/dhcpd", }

}
