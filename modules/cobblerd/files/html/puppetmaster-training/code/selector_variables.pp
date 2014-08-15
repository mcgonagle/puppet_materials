$sshpkgname = $operatingsystem ? {
  'Ubuntu' => 'ssh',
  default  => 'openssh',
}
package { 'ssh':
  name   => $sshpkgname,
  ensure => present,
}
