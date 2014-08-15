class mysql{
  package {
    'mysql':
      ensure => installed;
    'mysql-server':
      ensure => absent;
      #require => Service['mysqld']
  }
  service {'mysqld':
    ensure    => stopped,
    enable    => false,
    # why was this false?
    hasstatus => true,
    before    => Package['mysql-server'],
  }
}

class mysql::server inherits mysql{
  Package['mysql-server']{
    ensure => installed,
  }
  Service['mysqld'] {
    ensure    => running,
    enable    => true,
    hasstatus => true,
    before    => undef,
    require   => Package['mysql-server'],
  }
}

include mysql::server
