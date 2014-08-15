# Class: sudoers
#
# Manages apache sudoers system
# Include it to install and run sudoers with default settings
#
# Usage:
# include sudoers

import "defines/*.pp"
##import "classes/*.pp"

class sudoers {


  File{ owner  => 'root', group  => 'root', mode   => '640', }

  file {"/etc/sudoers.d":
    ensure => directory,
    owner => "root", group => "root", mode => "0755",
  }

  sudoers::sudoers_file{'/etc/sudoers':
    dir=>'/etc',
    sudoers_conf_file=>'sudoers',
  }

  sudoers::sudoers_file{"/etc/sudoers.d/sudoers_${zone}":
    dir=>'/etc/sudoers.d',
    sudoers_conf_file=>"sudoers_${zone}",
    require => File["/etc/sudoers.d"],
  }

  sudoers::visudo_file{'/etc/sudoers':
    before => File ['/etc/sudoers']
  }
  
  # if a local user changes sudoers.tmp, then this will break
  file {'/etc/sudoers':
    mode    => '0440',
  }

}

