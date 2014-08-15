class yum::conf inherits yum {
  file { "/etc/yum.conf":
    source => [	 "puppet:///modules/yum/yum.conf.${hostname}",	
		  "puppet:///modules/yum/yum.conf.${role}",
		  "puppet:///modules/yum/yum.conf.${zone}",
	 	  "puppet:///modules/yum/yum.conf" ],
      owner => "root", group => "root", mode => "0644", }
}#end of yum::conf
