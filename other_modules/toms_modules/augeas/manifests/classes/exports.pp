class augeas::exports inherits augeas {
 augeas{ "export bar":
  context => "/files/etc/exports",
	changes => [
		"set dir[last()+1] /bar",
		"set dir[last()]/client weeble",
		"set dir[last()]/client/option[1] ro",
		"set dir[last()]/client/option[2] all_squash",
		],
    onlyif => "match dir[. = '/bar'] size == 0",
	}#end of augeas export bar

 augeas{ "export home":
  context => "/files/etc/exports",
	changes => [
		"set dir[last()+1] /home",
		"set dir[last()]/client 192.168.200.0/24",
		"set dir[last()]/client/option[1] rw",
		"set dir[last()]/client/option[2] sync",
		"set dir[last()]/client/option[2] root_squash",
		],
    onlyif => "match dir[. = '/home'] size == 0",
	}#end of augeas export bar

  #augeas {"export foo2":
    #context => "/files/etc/exports",
    #changes => [
      #"set dir[. = '/foo2' ] /foo2",
      #"set dir[. = '/foo2' ] /client weeble2",
      #"set dir[. = '/foo2' ] /client/option[1] ro",
      #"set dir[. = '/foo2' ] /client/option[2] all_squash",
    #],
  #}#end of augeas
  #augeas {"export home":
    #context => "/files/etc/exports",
    #changes => [
      #"set dir[. = '/home' ] /home",
      #"set dir[. = '/foo2' ] /client 192.168.200.0/24",
      #"set dir[. = '/foo2' ] /client/option[1] rw",
      #"set dir[. = '/foo2' ] /client/option[2] sync",
      #"set dir[. = '/foo2' ] /client/option[3] root_squash",
    #],
  #}#end of augeas
}#end of augeas::exports 
