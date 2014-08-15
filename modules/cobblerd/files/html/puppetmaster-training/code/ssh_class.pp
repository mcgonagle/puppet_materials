# /etc/puppet/modules/ssh/manifests/init.pp

class ssh {
  package  { "openssh-clients":
    ensure => present,
  } # package

  file { "/etc/ssh/ssh_config":
    owner   => "root",
    group   => "root",
    mode    => "644",
    require => Package["openssh-clients"],
    source  => "puppet:///modules/ssh/ssh_config",
  } # file

  service { "sshd":
    ensure => stopped,
    enable => false,
  } # service
} # class ssh
