class bind {
 package{"bind": ensure => latest }
 
 #include munin::plugin::named
 #include munin::plugin::named

  monit::monitd{"named":
        pid_file => "/var/run/named.pid",
        init_script => "/etc/init.d/named", }
}
