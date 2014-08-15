class ssh{
  package{
    'openssh-clients': ensure => latest;
    'openssh-server': ensure => absent;
  }
  file{'/etc/ssh/ssh_config':
    owner   => root,
    group   => root,
    mode    => 0664,
    ensure  => file,
    require => Package['openssh-clients']
  }
  # Collecting all the know host keys from stored configs.
  Sshkey <<||>>
  resources { sshkey: purge => true }
}
