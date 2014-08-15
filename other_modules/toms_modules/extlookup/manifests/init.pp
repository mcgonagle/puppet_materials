class extlookup {
    file {"/tmp/file":
	content => template("extlookup/file.erb"),
        ensure => present,
	}

}#end of extlookup
