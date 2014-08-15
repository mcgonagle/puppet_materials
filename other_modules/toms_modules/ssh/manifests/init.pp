# Class: ssh
#
# Manages ssh client and server
# Include it to install and run ssh with default settings
#
# Usage:
# include ssh

class ssh {
    package{ "openssh-clients": ensure => latest }
    package{ "openssh-server": ensure => latest }

   file{"/etc/ssh/ssh_config":
     owner => "root", group => "root", mode => "0600",
     require => [ Package["openssh-clients"], Package["openssh-server"] ],
     notify => Service["sshd"], }

   file {"/etc/ssh/sshd_config":
     content => template("ssh/sshd_config.erb"),
     owner => "root", group => "root", mode => "0644",
     require => [ Package["openssh-clients"], Package["openssh-server"] ], 
     notify => Service["sshd"], }

   nagmon::service {'sshd':
     enable => true,
     ensure => running,
     init_script => "/etc/init.d/sshd",
     pid_file => "/var/run/sshd.pid",
     warn => "1:",
     critical => "1:",
     nrpe_parameter => "-C sshd",  
     require => [Package['openssh-server'],
                 File["/etc/ssh/sshd_config"]], }

} #end of class ssh
