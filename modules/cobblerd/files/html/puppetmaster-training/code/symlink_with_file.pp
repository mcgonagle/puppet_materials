file { '/etc/openldap/ldap.conf':
  source => '/etc/puppet/files/ldap.conf',
}

file { '/etc/ldap.conf':
  ensure => symlink,
  target => '/etc/openldap/ldap.conf',
}
