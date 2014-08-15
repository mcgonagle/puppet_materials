class xinetd {
 package { "xinetd": ensure => latest }
 service { "xinetd":
 enable => true,
 ensure => running,
 require => Package["xinetd"],
 }

}#end of xinetd
