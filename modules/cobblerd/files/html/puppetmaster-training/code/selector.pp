package { 'ssh':
  name   => $operatingsystem ? {
    'Ubuntu' => 'ssh',
    default  => 'openssh',
  },
  ensure => present,
}
