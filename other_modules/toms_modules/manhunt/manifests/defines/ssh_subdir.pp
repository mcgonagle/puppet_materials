define manhunt::ssh_subdir ( ) {
  file { "/home/$name/.ssh":
    ensure => directory,
    mode => 700, owner => $name, group => root,
    require => User[ $name ],
  }
}
