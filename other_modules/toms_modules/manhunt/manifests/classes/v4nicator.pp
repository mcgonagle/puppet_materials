# v4nicator.pp
#
# $Id: v4nicator.pp,v 1.15 2010/10/20 17:46:22 wflynn Exp $
#
# Created 5/09 by wflynn
#
# Class Definition for v4 installation scripts

class manhunt::v4nicator inherits manhunt {
  include manhunt::stagingtools

  package{"dos2unix": ensure => latest }

  file { "/tmp/v4nicator.sh":
    source => "puppet:///modules/manhunt/tools/v4nicator.sh",
    owner => "root", group => "root", mode => "0700",
  }
  
  file { "/tmp/v4nicator2.sh":
    ensure => absent,
  }
  
  file { "/tmp/cleanerator.sh":
    source => "puppet:///modules/manhunt/tools/cleanerator.sh",
    owner => "root", group => "root", mode => "0700",
  }

  file { "/tmp/Community_symfony.txt":
    content =>  "<?php\n\$sf_symfony_lib_dir='/usr/share/pear/symfony';\n\$sf_symfony_data_dir='/usr/share/pear/data/symfony';\n",
    owner => "root", group => "root", mode => "0644",
  }

  file { "/tmp/Platform_symfony.txt":
    content =>  "<?php\n\$sf_symfony_lib_dir='/usr/share/pear/symfony';\n\$sf_symfony_data_dir='/usr/share/pear/data/symfony';\n",
    owner => "root", group => "root", mode => "0644",
  }
}
