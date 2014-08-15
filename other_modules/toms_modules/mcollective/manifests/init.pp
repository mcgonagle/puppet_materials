# Class: mcollective
#
# Manages mcollective software 
# Include it to install and run mcollective with default settings
#
# Usage:
# include mcollective

import "classes/*.pp"

class mcollective {
    package{"rubygem-stomp":ensure => latest }
    package{"mcollective-client": ensure => latest }
    package{"mcollective": ensure => latest }
  
    include mcollective::plugin 
    include gems

   file{"/etc/mcollective/client.cfg":
    content => template("mcollective/client.cfg.erb"),
    owner => "root", group => "root", mode => "0640",
    require => Package["mcollective-client"], }

   file{"/etc/mcollective/server.cfg":
    content => template("mcollective/server.cfg.erb"),
    owner => "root", group => "root", mode => "0640",
    require => [Package["mcollective"], File["/etc/mcollective/client.cfg"]],
    notify => Service["mcollective"], }

   nagmon::service {"mcollective":
    enable => true,
    ensure => running,
    pid_file => "/var/run/mcollectived.pid",
    init_script => "/etc/init.d/mcollective", 
    warn => "1:1",
    critical => "1:1",
    nrpe_parameter => "-C mcollectived",
    require =>  [Package["mcollective"], 
                File["/etc/mcollective/server.cfg"]],}

}#end of class mcollective
