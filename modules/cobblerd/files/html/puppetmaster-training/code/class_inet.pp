class inet {
  $basedir = '/tmp'
  file {"${basedir}/inetd.d":
    ensure  => directory,
    purge   => true,
    recurse => true,
  }
  exec { 'rebuild-inetd':
    command     => "/bin/cat ${basedir}/inetd.d/* > ${basedir}/inetd.conf",
    refreshonly => true,
    subscribe   => File["${basedir}/inetd.d"],
  }
  file {"${basedir}/inetd.conf":
    mode    => '0644',
    require => Exec['rebuild-inetd'],
  }
}
