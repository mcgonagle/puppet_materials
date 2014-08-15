#
# configures the puppetmaster
#
class puppet::server inherits puppet {
 File { owner => 'root', group => 'root', mode => '644' }
 Exec ["rebuild-pconf"] { notify +> Service['puppetmaster'] }
 file {
  "${puppet::confd}/conf.d/server": content => template('puppet/server.erb'), notify => Exec['rebuild-pconf'];
  '/etc/init.d/puppetmaster': mode => '755', source => 'puppet:///puppet/puppetmaster.init';
 } 
 service {"puppetmaster": enable => true, ensure => running, require => File['/etc/init.d/puppetmaster'],}
}
