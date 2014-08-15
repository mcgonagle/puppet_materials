class sshd::packages() {

  package { [ 
    "openssh-server",
    "openssh-clients" ]:
      ensure => present,
  } # package
} # class sshd::packages
