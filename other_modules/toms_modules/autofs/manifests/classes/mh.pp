# Class: autofs::mh
#
# Manages autofs software 
# Include it to install and run autofs with default settings
#
# Usage:
# include autofs::mh

class autofs::mh inherits autofs {
    common::line{"autofs_mh":
      ensure => present, 
      file => "/etc/auto.master",
      line => "/var/www/html   /etc/auto.mh",
      require => Package["autofs"], }

    file { "/etc/auto.mh":
      content => inline_template("mh          -fstype=nfs,rw,nosuid,soft     <%= servername %>:/var/www/html/mh"),
      owner => "root", group => "root", mode => "0644", 
      require => [ Package["autofs"], 
	           Package["portmap"], 
                   Common::Line["autofs_mh"] ],
      before => [Service["autofs"], Service["portmap"]],
      notify => Service["autofs"], }

}#end of class autofs
