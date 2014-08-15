class sshd{
  package{'sshd':
    name   => 'openssh-server',
    ensure => installed,
  }
  service{'sshd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  #  this works too 
  #  subscribe => File['/etc/ssh/sshd_config'],
  }
  file{'/etc/ssh/sshd_config':
    source  => 'puppet:///modules/sshd/sshd_config',
    owner   => 'root',
    group   => 'root',
    mode    => '640',
    notify  => Service['sshd'],
    require => Package['sshd'],
  }
}
