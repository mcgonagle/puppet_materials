# configures puppet clients
class puppet {
  $confd = '/etc/puppet' 
  exec { 'rebuild-pconf':
    command => "/bin/cat ${puppet::confd}/conf.d/* > ${puppet::confd}/puppet.conf",
    refreshonly => true,
    subscribe => File["${puppet::confd}/conf.d"],
    notify => Service['puppet']
  }
  file {
   "${confd}/conf.d": ensure => directory, recurse => true, purge => true;
   '/etc/init.d/puppet': source => 'puppet:///puppet/puppet.init';
   "${confd}/puppet.conf": mode => '644', require => Exec[rebuild-pconf]; 
  }
  file { "${confd}/conf.d/client":
     content => template('puppet/client.erb'),
     mode => '644',
     owner => 'root',
     group => 'root',
     notify => Exec['rebuild-pconf'],
  }
  service { 'puppet':
    enable => true,
    ensure => running,
    require => File['/etc/init.d/puppet'],
    hasstatus => true,
  }
}
