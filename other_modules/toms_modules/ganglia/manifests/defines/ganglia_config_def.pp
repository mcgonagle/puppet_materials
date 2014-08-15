define ganglia_config_def($template_name, $cluster_name = $clustername, $multicast_address = $multicastaddress,
                                $host_dmax = $hostdmax) {
        file { "/etc/ganglia/${template_name}":
                content => template ("ganglia/${template_name}.erb"),
                owner   => "root",
                group   => "root",
                mode    =>  0644,
                require => File["/etc/ganglia"],
        }#end of file
 }#end of definition
