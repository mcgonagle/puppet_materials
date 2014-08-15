# /etc/puppet/modules/ssh/manifests/server.pp

class ssh::server inherits ssh {
  package { "openssh-server":
    ensure => latest,
  } # package

  file { "/etc/ssh/sshd_config":
    owner   => "root",
    group   => "root",
    mode    => "644",
    source  => "puppet:///modules/ssh/sshd_config",
    require => Package["openssh-server"],
  } # file

  Service["sshd"] {
    enable    => true,
    ensure    => running,
    subscribe => File["/etc/ssh/sshd_config"],
    require   => Package["openssh-server"],
  } # Service
} # class ssh::server
