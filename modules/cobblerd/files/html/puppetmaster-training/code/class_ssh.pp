class ssh {
  package { "openssh-server":
    ensure => present,
  } # package

  File { owner => "root", group => "root", mode => "0644"}

  file {
    "/etc/ssh":
      ensure => directory;
    "/etc/ssh/ssh_known_hosts":
      ensure => present;
    "/etc/ssh/ssh_config":
      ensure => present,
      source => "puppet:///modules/ssh/ssh_config";
  } # file

  service { "sshd":
    enable  => false,
    ensure  => stopped,
    require => Package["openssh-server"],
  } # service
} # class ssh
