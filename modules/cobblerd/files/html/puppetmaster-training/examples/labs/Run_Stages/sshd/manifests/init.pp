class sshd {

  file { "/etc/ssh/sshd_config":
    source => "puppet:///modules/sshd/sshd_config",
    mode   => 600,
    owner  => root,
    group  => root,
  } # file

  service { "sshd":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => File["/etc/ssh/sshd_config"],
  } # service
} # class sshd
