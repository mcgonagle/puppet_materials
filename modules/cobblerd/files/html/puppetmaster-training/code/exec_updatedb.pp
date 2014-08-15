exec { 'updatedb':
  path    => '/usr/bin',
  creates => '/var/lib/mlocate/mlocate.db'
}
