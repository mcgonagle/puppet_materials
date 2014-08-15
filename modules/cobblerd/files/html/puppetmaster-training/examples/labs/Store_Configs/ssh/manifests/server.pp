class ssh::server inherits ssh {
  file {'/etc/ssh/sshd_config':
    #0.24.x 
    # source => 'puppet:///ssh/sshd_config'
    # 0.25.x
    source => 'puppet:///modules/ssh/sshd_config',
    owner => 'root',
    group => 'root',
    mode => '644'
  } 
  Package['openssh-server'] {
    ensure => latest, 
    require => Package['openssh-clients'],
  }  
  service {'sshd':
    ensure => running,
    enable => true,
    hasstatus  => true,
    hasrestart => true,
    require => Package['openssh-server'],
    subscribe => File['/etc/ssh/sshd_config'],
  }
  @@sshkey { "$fqdn": type => rsa, key => $sshrsakey }
}
