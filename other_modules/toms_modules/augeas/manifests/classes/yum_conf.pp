class augeas::yum_conf inherits augeas {
 #augeas{ "yum.conf":
 # context => "/files/etc/yum.conf",
 # changes => [ "set dir[. = '/main' ] /main",
 #	     "set dir[. = '/main' ] /metadata_expire 1",
 #	],
 #}#end of augeas 

 augeas{ "yum.conf":
  context => "/files/etc/yum.conf/main",
	changes => "set /metadata_expire 1",
	}#end of augeas 
}#end of augeas::yum_conf
