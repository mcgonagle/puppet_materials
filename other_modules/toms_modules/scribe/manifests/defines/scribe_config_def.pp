define scribe::scribe_config_template($template_name = "scribed.conf.erb",
                              $scribe_categories = ["default:scribevip.athenahealth.com"],
                              $file_path = "/var/log/scribe",
                              $rotate_period = "hourly") {


                file { "/etc/scribed/scribed.conf":
                        content => template ("scribe/${template_name}"),
                        owner   => "root",
                        group   => "root",
                        mode    =>  0644,
                        notify  => Service["scribed"],
                }#end of /etc/scribed/scribed.conf file statement

                file { "${file_path}":
                        ensure  => directory,
                        owner   => "root",
                        group   => "root",
                        mode    => 0644,
                        before  => File["/etc/scribed/scribed.conf"],
                }#end of filepath file statement


 }#end of definition
