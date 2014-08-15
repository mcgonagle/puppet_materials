define vhost($port, $path = '/etc/httpd/conf.d') {
  file {"${path}/${name}.conf":
    ensure  => present,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0644',
    # assume that $port is used inside template
    content => template('/etc/puppet/templates/vhost.erb'),
  }
}
