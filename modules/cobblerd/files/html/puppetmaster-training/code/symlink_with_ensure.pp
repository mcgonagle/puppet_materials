file { '/etc/ldap.conf':
  ensure => symlink,
  target => '/etc/openldap/ldap.conf',
}
