class ssh::server inherits ssh {

  file { "/etc/ssh/sshd_config":
    ensure => present,
    source => "puppet:///modules/ssh/sshd_config"
  } # file

  Service["sshd"] {
    enable => true,
    ensure => running,
  } # Service

} # class ssh::server
