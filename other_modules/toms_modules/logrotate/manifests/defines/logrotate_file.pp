define logrotate::file( $log, $options, $postrotate = "NONE" ) {

        file { "/etc/logrotate.d/${name}":
                owner => "root", group => "root", mode => "0644",
                content => template("logrotate/logrotate.erb"),
                require => File["/etc/logrotate.d"], }

}#end of logrotate::file
