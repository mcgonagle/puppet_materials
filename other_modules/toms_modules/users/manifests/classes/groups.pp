# users::groups.pp
# content taken directly from basegroups from ovulator01 on
# 10/18/10
class users::groups inherits users{

require users::purge_users
group { "wheel":
  ensure => present,
  gid => 10,
  allowdupe => "false"
}

group { "named":
  ensure => present,
  gid =>  25, 
  allowdupe => "false"
}

group { "svn":
  ensure => present,
  gid => 504,
  allowdupe => "false"
}
group { "release":
  ensure => present,
  gid => 529,
  allowdupe => "false"
}
group { "bacula":
  ensure => present,
  gid => 531,
  allowdupe => "false"
}
group { "build-devel":
  ensure => present,
  gid => 532,
  allowdupe => "false"
}

group { "nagcmd":
  ensure => present,
  gid => 533,
  allowdupe => "false"
}
group { "puppetmaster":
  ensure => present,
  gid => 535,
  allowdupe => "false"
}
group { "sysadmin":
  ensure => present,
  gid => 536,
  allowdupe => "false"
}

group { "dba":
  ensure => present,
  gid => 537,
  allowdupe => "false"
}

group { "oinstall":
  ensure => present,
  gid => 538,
  allowdupe => "false"
}

group { "dclk":
  ensure => present,
  gid => 539,
  allowdupe => "false"
}

group { "sales":
  ensure => present,
  gid => 540,
  allowdupe => "false"
}

group { "qa":
  ensure => present,
  gid => 541,
  allowdupe => "false"
}

group { "mysql":
  ensure => present,
  gid => 542,
  allowdupe => "false"
}

group { "creative-editors":
  ensure => present,
  gid => 544,
  allowdupe => "false"
}

group { "activemq":
  ensure => present,
  gid => 545,
  allowdupe => "false"
}

group { "ids":
  ensure => present,
  gid => 546,
  allowdupe => "false"
}

group { "dkim-milt":
  ensure => present,
  gid => 547,
  allowdupe => "false"
}

group { "haclient":
  ensure => present,
  gid => 548,
  allowdupe => "false"
}

group { "loadrunner":
  ensure => present,
  gid => 549,
  allowdupe => "false"
}

group { "memcached":
  ensure => present,
  gid => 550,
  allowdupe => "false"
}


}#end of users::groups

