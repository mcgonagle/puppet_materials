class sudo{
  # move the file to host
  File{
    owner  => 'root',
    group  => 'root',
    mode   => '640',
  }
  file{'/etc/sudoers.check':
    source => 'puppet:///modules/sudo/sudoers',
  }
  # copy it to the tmp location if its ok
  exec{'cp-sudo':
    path        => '/bin,/usr/sbin',
    require    => File['/etc/sudoers.check'],
    #subscribe   => File['/etc/sudoers.check'],
    #refreshonly => true,
    logoutput   => on_failure,
    onlyif      => 'visudo -c -f /etc/sudoers.check && diff /etc/sudoers.check /etc/sudoers',
    command     => 'cp /etc/sudoers.check /etc/sudoers'
  }
  # if a local user changes sudoers.tmp, then this will break
  file{'/etc/sudoers':
    require => Exec['cp-sudo'],
    mode    => '400',
  }
}
