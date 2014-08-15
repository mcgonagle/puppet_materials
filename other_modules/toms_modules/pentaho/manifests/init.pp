class pentaho {

  file { "/etc/init.d/biserver":
    source => "puppet:///modules/pentaho/ctlscript.sh",
    owner => "root", group => "root", mode => "0755",
  }

  #Service
  service { biserver:
    ensure    => running,
    enable    => true,
    require   => File ["/etc/init.d/biserver"],
  }
  
}
