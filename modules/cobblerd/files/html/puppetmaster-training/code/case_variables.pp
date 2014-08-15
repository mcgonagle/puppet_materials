case $operatingsystem {
  'ubuntu': {
    $ssh_pkg = 'ssh'
  }
  'solaris': {
    $ssh_pkg = [ 'SUNWsshcu', 'SUNWsshdr', 'SUNWsshdu', 'SUNWsshr', 'SUNWsshu' ]
  }
  # default assumes CentOS, RedHat
  default: {
    $ssh_pkg = ['openssh', 'openssh-clients', 'openssh-server']
  }
}

package { $ssh_pkg:
  ensure => present,
}
